# Template Python Script
# !/usr/bin/env python
# Import statements
import argparse
import configparser
import csv
import json
import logging
import os
import pandas as pd
import requests
import sqlalchemy as db
import sys
import xml.etree.ElementTree as et
from io import StringIO


"""
Script to ingest OpenQuake outputs in csv format from GtHub to single
PostGreSQL database. The Script can be run in the following form by
changing the filepaths as appropriate
python DSRA_ruptures2postgres.py --dsraRuptureRepo="OpenDRR/DSRA-processing" \
                                 --dsraRuptureBranch=${DSRA_BRANCH}
"""


# Main Function
def main():
    logFileName = f"{os.path.splitext(sys.argv[0])[0]}.log"
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s - %(levelname)s - %(message)s",
        handlers=[logging.FileHandler(logFileName), logging.StreamHandler()],
    )
    args = parse_args()
    os.chdir(sys.path[0])
    auth = get_config_params("config.ini")

    engine = db.create_engine(
        "postgresql://{}:{}@{}".format(
            auth.get("rds", "postgres_un"),
            auth.get("rds", "postgres_pw"),
            auth.get("rds", "postgres_address"),
        ),
        echo=False,
    )

    url = (
        f"https://api.github.com/repos/{args.dsraRuptureRepo}/"
        f"contents/ruptures?ref={args.dsraRuptureBranch}"
    )
    logging.info(url)
    try:
        ghToken = auth.get("auth", "github_token")
        response = requests.get(url, headers={"Authorization": f"token {ghToken}"})
        # logging.info(response.content)
        response.raise_for_status()
        repo_dict = json.loads(response.content)

        for item in repo_dict:
            logging.info(item["name"])
    except requests.exceptions.RequestException as e:
        logging.error(e)
        sys.exit()

    processRuptureXML(repo_dict, engine, auth)

    return


# Support Functions
def get_config_params(args):
    """
    Parse Input/Output columns from supplied *.ini file
    """
    configParseObj = configparser.ConfigParser()
    configParseObj.read(args)
    return configParseObj


def parse_args():
    parser = argparse.ArgumentParser(
        description=(
            "Pull Rupture data from " "Github repository and " "copy into PostGreSQL"
        )
    )
    parser.add_argument(
        "--dsraRuptureRepo",
        type=str,
        help="DSRA Rupture repo directory address",
        required=True,
    )
    parser.add_argument(
        "--dsraRuptureBranch", type=str, help="DSRA Rupture branch name", required=True
    )
    args = parser.parse_args()
    return args


def processRuptureXML(repo_dict, engine, auth):
    for ruptureFile in repo_dict:
        logging.info("processing: {}".format(ruptureFile["name"]))
        item_url = ruptureFile["download_url"]
        ghToken = auth.get("auth", "github_token")
        response = requests.get(item_url, headers={"Authorization": f"token {ghToken}"})
        df_cols = [
            "source_type",
            "rupture_name",
            "magnitude",
            "rake",
            "lon",
            "lat",
            "depth",
        ]
        rows = []
        xroot = et.ElementTree(et.fromstring(response.content)).getroot()
        xmlns = "{http://openquake.org/xmlns/nrml/0.4}"
        source_type = xroot[0].tag.replace(f"{xmlns}", "")
        rupture_name = os.path.splitext(ruptureFile["name"])[0].replace("rupture_", "")
        magnitude = float(xroot[0].find(f"{xmlns}magnitude").text)
        rake = xroot[0].find(f"{xmlns}rake").text
        lon = xroot[0].find(f"{xmlns}hypocenter").attrib.get("lon")
        lat = xroot[0].find(f"{xmlns}hypocenter").attrib.get("lat")
        depth = xroot[0].find(f"{xmlns}hypocenter").attrib.get("depth")
        rows.append(
            {
                "source_type": source_type,
                "rupture_name": rupture_name,
                "magnitude": magnitude,
                "rake": rake,
                "lon": lon,
                "lat": lat,
                "depth": depth,
            }
        )
        out_df = pd.DataFrame(rows, columns=df_cols)
        out_df.to_sql(
            "rupture_table",
            engine,
            if_exists="append",
            method=psql_insert_copy,
            schema="ruptures",
        )
    return


def psql_insert_copy(table, conn, keys, data_iter):
    # This fuction was copied from the Pandas documentation
    # gets a DBAPI connection that can provide a cursor
    dbapi_conn = conn.connection
    with dbapi_conn.cursor() as cur:
        s_buf = StringIO()
        writer = csv.writer(s_buf)
        writer.writerows(data_iter)
        s_buf.seek(0)
        columns = ", ".join('"{}"'.format(k) for k in keys)
        if table.schema:
            table_name = "{}.{}".format(table.schema, table.name)
        else:
            table_name = table.name
        sql = "COPY {} ({}) FROM STDIN WITH CSV".format(table_name, columns)
        cur.copy_expert(sql=sql, file=s_buf)


if __name__ == "__main__":
    main()
