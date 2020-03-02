#Template Python Script
#!/usr/bin/env python
#Import statements
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



'''
Script to ingest OpenQuake outputs in csv format from GtHub to single PostGreSQL database. The Script can be run in the following form by 
changing the filepaths as appropriate
python DSRA_ruptures2postgres.py --dsraRuptureDir="https://github.com/OpenDRR/opendrr-data-store/tree/master/sample-datasets/scenario-risk/model-inputs" 
'''

#Main Function
def main ():
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(levelname)s - %(message)s', 
                        handlers=[logging.FileHandler('{}.log'.format(os.path.splitext(sys.argv[0])[0])),
                                  logging.StreamHandler()])
    args = parse_args()
    os.chdir(sys.path[0])
    auth = get_config_params('config.ini')

    engine = db.create_engine('postgresql://{}:{}@{}'.format(auth.get('rds', 'postgres_un'), auth.get('rds', 'postgres_pw'), auth.get('rds', 'postgres_address')), echo=False)

    url = args.dsraRuptureDir.replace('https://github.com', 'https://api.github.com/repos').replace('tree/master', 'contents')
    logging.info(url)
    try:
        response = requests.get(url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
        # logging.info(response.content)
        response.raise_for_status()
        repo_dict = json.loads(response.content)
        repo_list = []

        for item in repo_dict:
            if item['type'] == 'file' and 'rupture' in item['name']:
                repo_list.append(item['name'])
        logging.info(repo_list)
    except requests.exceptions.RequestException as e:
        logging.error(e)
        sys.exit()
    
    processRuptureXML(repo_list, engine, auth, url)

    return

#Support Functions
def get_config_params(args):
    """
    Parse Input/Output columns from supplied *.ini file
    """
    configParseObj = configparser.ConfigParser()
    configParseObj.read(args)
    return configParseObj

def parse_args():
    parser = argparse.ArgumentParser(description="'Pull Rupture input data from Github repository and copy into PostGreSQL on AWS RDS'")
    parser.add_argument("--dsraRuptureDir", type=str, help='DSRA Rupture repo directory address', required=True)
    args = parser.parse_args()
    return args

def processRuptureXML(repo_list, engine, auth, url):
    for ruptureFile in repo_list:
        logging.info("processing: {}".format(ruptureFile))
        item_url="{}/{}".format(url, ruptureFile)
        item_url = item_url.replace('api.github.com/repos', 'raw.githubusercontent.com').replace('/contents/','/master/')
        response = requests.get(item_url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
        df_cols = ["source_type", "rupture_name", "magnitude", "rake", "lon", "lat", "depth"]
        rows = []
        xroot = et.ElementTree(et.fromstring(response.content)).getroot()
        source_type = xroot[0].tag.replace('{http://openquake.org/xmlns/nrml/0.4}','')
        rupture_name = os.path.splitext(ruptureFile)[0].replace('rupture_','')
        magnitude = xroot[0].find("{http://openquake.org/xmlns/nrml/0.4}magnitude").text
        rake = xroot[0].find("{http://openquake.org/xmlns/nrml/0.4}rake").text
        lon = xroot[0].find("{http://openquake.org/xmlns/nrml/0.4}hypocenter").attrib.get('lon')
        lat = xroot[0].find("{http://openquake.org/xmlns/nrml/0.4}hypocenter").attrib.get('lat')
        depth = xroot[0].find("{http://openquake.org/xmlns/nrml/0.4}hypocenter").attrib.get('depth')
        rows.append({"source_type": source_type, "rupture_name": rupture_name, "magnitude": magnitude, "rake": rake, "lon": lon, "lat": lat, "depth": depth})
        out_df = pd.DataFrame(rows, columns = df_cols)
        out_df.to_sql("rupture_table", engine,  if_exists='append', method=psql_insert_copy, schema='ruptures') 
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
        columns = ', '.join('"{}"'.format(k) for k in keys)
        if table.schema:
            table_name = '{}.{}'.format(table.schema, table.name)
        else:
            table_name = table.name
        sql = 'COPY {} ({}) FROM STDIN WITH CSV'.format(
            table_name, columns)
        cur.copy_expert(sql=sql, file=s_buf)


#Classes

if __name__ == '__main__':
    main() 

    