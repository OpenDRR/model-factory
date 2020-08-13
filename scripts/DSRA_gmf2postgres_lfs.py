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
python3 DSRA_gmf2postgres_lfs.py --gmfDir="https://github.com/OpenDRR/openquake-models/tree/master/deterministic/outputs"  --eqScenario=AFM7p3_GSM
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
    #columnConfigParser = get_config_params('{}.ini'.format(os.path.splitext(sys.argv[0])[0]))
    columnConfigParser = get_config_params('DSRA_gmf2postgres.ini')
    engine = db.create_engine('postgresql://{}:{}@{}'.format(auth.get('rds', 'postgres_un'), auth.get('rds', 'postgres_pw'), auth.get('rds', 'postgres_address')), echo=False)

    url = args.gmfDir.replace('https://github.com', 'https://api.github.com/repos').replace('tree/master', 'contents')

    try:
        response = requests.get(url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
        # logging.info(response.content)
        response.raise_for_status()
        repo_dict = json.loads(response.content)
        repo_list = []

        for item in repo_dict:
            if item['type'] == 'file' and 'gmfdata' in item['name'] and args.eqScenario in      item['name']:
                repo_list.append(item['name'])
    except requests.exceptions.RequestException as e:
        logging.error(e)
        sys.exit()
    
    processGMF(repo_list, engine, auth, url, columnConfigParser, args)
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
    parser = argparse.ArgumentParser(description="'Pull GMF input data from Github repository and copy into PostGreSQL on AWS RDS'")
    parser.add_argument("--gmfDir", type=str, help='DSRA Ground Motion Field repo directory address', required=True)
    parser.add_argument("--eqScenario", type=str, help='Earthquake Scenario Name i.e. (sim6p8_cr2022)', required=True)
    args = parser.parse_args()
    return args

def processGMF(repo_list, engine, auth, url, columnConfigParser, args):
    for gmfFile in repo_list:
        logging.info("processing: {}".format(gmfFile))
        #item_url="{}/{}".format(url, gmfFile).replace('api.github.com/repos', 'raw.githubusercontent.com').replace('/contents/','/master/')
        item_url="{}/{}".format(url, gmfFile)
        response = requests.get(item_url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
        item_dict = json.loads(response.content)
        response = requests.get(item_dict['download_url'], headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
        gmfFieldNames = list(filter(None, [x.strip().split(",") for x in columnConfigParser.get('Ground Motion Fields', 'gmfFieldNames').splitlines()]))
        gmfInputFieldNames, gmfOutputFieldNames = zip(*gmfFieldNames)
        dfGmf = pd.read_csv(StringIO(response.content.decode(response.encoding)),
                            sep=',',
                            index_col=False,
                            usecols=gmfInputFieldNames,
                            low_memory=False,
                            thousands=',')
        [dfGmf.rename(columns={oldcol:newcol}, inplace=True) for oldcol, newcol in zip(gmfInputFieldNames, gmfOutputFieldNames)]
        dfGmf.to_sql('s_gmfdata_{}'.format(args.eqScenario).lower(),
                            engine,
                            if_exists='replace',
                            method=psql_insert_copy,
                            schema='gmf')
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


