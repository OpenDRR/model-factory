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
from io import StringIO

'''
Script to ingest OpenQuake outputs in csv format from GtHub to single PostGreSQL database. The Script can be run in the following form by 
changing the filepaths as appropriate
python DSRA_vsThirty2postgres.py --vs30Dir="https://github.com/OpenDRR/opendrr-data-store/tree/master/sample-datasets/scenario-risk/model-inputs" 
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
    columnConfigParser = get_config_params('{}.ini'.format(os.path.splitext(sys.argv[0])[0]))
    engine = db.create_engine('postgresql://{}:{}@{}'.format(auth.get('rds', 'postgres_un'), auth.get('rds', 'postgres_pw'), auth.get('rds', 'postgres_address')), echo=False)

    url = args.vs30Dir.replace('https://github.com', 'https://api.github.com/repos').replace('tree/master', 'contents')

    try:
        response = requests.get(url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
        # logging.info(response.content)
        response.raise_for_status()
        repo_dict = json.loads(response.content)
        repo_list = []

        for item in repo_dict:
            if item['type'] == 'file' and 'vs30' in item['name']:
                repo_list.append(item['name'])
    except requests.exceptions.RequestException as e:
        logging.error(e)
        sys.exit()
    
    processvs30(repo_list, engine, auth, url, columnConfigParser)
    return True

#Support Functions
def get_config_params(args):
    """
    Parse Input/Output columns from supplied *.ini file
    """
    configParseObj = configparser.ConfigParser()
    configParseObj.read(args)
    return configParseObj

def parse_args():
    parser = argparse.ArgumentParser(description="'Pull Site Mesh input data from Github repository and copy into PostGreSQL on AWS RDS'")
    parser.add_argument("--vs30Dir", type=str, help='DSRA Site Mesh Field repo directory address', required=True)
    args = parser.parse_args()
    return args

def processvs30(repo_list, engine, auth, url, columnConfigParser):
    for vs30File in repo_list:
        logging.info("processing: {}".format(vs30File))
        item_url="{}/{}".format(url, vs30File).replace('api.github.com/repos', 'raw.githubusercontent.com').replace('/contents/','/master/')
        response = requests.get(item_url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
        vs30FieldNames = list(filter(None, [x.strip().split(",") for x in columnConfigParser.get('VS30 Fields', 'vs30FieldNames').splitlines()]))
        vs30InputFieldNames, vs30OutputFieldNames = zip(*vs30FieldNames)
        dfvs30 = pd.read_csv(StringIO(response.content.decode(response.encoding)),
                    sep=',',
                    index_col=False,
                    usecols=vs30InputFieldNames,
                    low_memory=False,
                    thousands=',')
        [dfvs30.rename(columns={oldcol:newcol}, inplace=True) for oldcol, newcol in zip(vs30InputFieldNames, vs30OutputFieldNames)]
        dfvs30.to_sql(os.path.splitext(vs30File)[0].lower(),
                    engine,
                    if_exists='replace',
                    method=psql_insert_copy,
                    index=False,
                    schema='vs30')   
    return True

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

