#!/usr/bin/env python
import sqlalchemy as db
import sqlalchemy.orm as orm
import pandas as pd
import numpy as np
from io import StringIO
import csv
import glob 
import os
import sys
import argparse
import configparser
import requests
import json
import logging

'''
Script to ingest OpenQuake outputs in csv format from GtHub to single PostGreSQL database. The Script can be run in the following form by 
changing the filepaths as appropriate
python PSRA_outputs2postgres.py --avgLossMeanDir="https://github.com/OpenDRR/earthquake-risk-probabilistic/tree/master/eb-risk/${SCENARIO}/average-annual-loss"  --lossCurveMeanDir="https://github.com/OpenDRR/earthquake-risk-probabilistic/tree/master/eb-risk/${SCENARIO}/probable-maximum-loss" --damageDir="https://github.com/OpenDRR/earthquake-risk-probabilistic/tree/master/c-damage/${SCENARIO}" --columnsINI="C:\github\OpenDRR\model-factory\scripts\PSRA_Metrics_Columns.ini"
'''

def main():
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(levelname)s - %(message)s', 
                        handlers=[logging.FileHandler('{}.log'.format(os.path.splitext(sys.argv[0])[0])),
                                  logging.StreamHandler()])
    args = parse_args()
    os.system('')
    os.chdir(sys.path[0])
    columnConfigParser = get_config_params(args.columnsINI)

    auth = get_config_params('config.ini')

    listScenario = list(filter(None, (x.strip() for x in columnConfigParser.get('Scenario', 'listScenario').splitlines())))
    listScenarioPrefix = list(filter(None, (x.strip() for x in columnConfigParser.get('Scenario', 'listScenarioPrefix').splitlines())))
    damageCols = list(filter(None, (x.strip() for x in columnConfigParser.get('Damage Potential', 'damagePotentialColumns').splitlines())))
    
    engine = db.create_engine('postgresql://{}:{}@{}'.format(auth.get('rds', 'postgres_un'), auth.get('rds', 'postgres_pw'), auth.get('rds', 'postgres_address')), echo=True)

    for scenario, scenarioPrefix in zip(listScenario,listScenarioPrefix):
        #merge all of the csv tiles, name columns according to scenario prefix
        copy_average_losses_mean(args, scenario, scenarioPrefix, engine, auth)

        #reshape and merge loss curves tiles, name columns according to scenario prefix
        #pivot_copy_loss_curves_mean(args, scenario, scenarioPrefix, engine, auth)
    
        #Parse the Damage Databases from access and copy into postgres
        copy_damage(args, scenario, scenarioPrefix, damageCols, engine, auth)
        
    return

def copy_average_losses_mean(args, scenario, scenarioPrefix, engine, auth):
    url = args.avgLossMeanDir.replace('https://github.com', 'https://api.github.com/repos').replace('tree/master', 'contents').replace('${SCENARIO}', scenario)
    response = requests.get(url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
    # we could add some exception handling here for bad responses
    repo_dict = json.loads(response.content)
    repo_list = []
    
    for item in repo_dict:
        if item['type'] == 'file' and os.path.splitext(item['name'])[1] == '.csv':
            repo_list.append(item['name'])

    firstTile = True
    base_url = url.replace('api.github.com/repos', 'raw.githubusercontent.com').replace('/contents/','/master/')
    for item in repo_list:
        
        item_url="{}/{}".format(base_url, item)
        
        response = requests.get(item_url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
        
        dfOut = pd.read_csv(StringIO(response.content.decode(response.encoding))) #usecols=[columns passed from config] to 
        #Add a scenario prefix to each column if desired
        # dfOut = dfOut.add_prefix(scenarioPrefix)   
        #except for 'id', back to original name
        # dfOut = dfOut.rename(columns={scenarioPrefix+'id' : 'id'})
        if firstTile is False:
            dfOut.to_sql('avg_losses_mean_'+scenario, engine, if_exists='append', method=psql_insert_copy)
        else :
            dfOut.to_sql('avg_losses_mean_'+scenario, engine, if_exists='replace', method=psql_insert_copy)
            firstTile = False
    
    return 


def pivot_copy_loss_curves_mean(args, scenario, scenarioPrefix, engine, auth):
    url = args.lossCurveMeanDir.replace('https://github.com', 'https://api.github.com/repos').replace('tree/master', 'contents').replace('${SCENARIO}', scenario)
    response = requests.get(url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
    repo_dict = json.loads(response.content)
    repo_list = []

    for item in repo_dict:
        if item['type'] == 'file' and os.path.splitext(item['name'])[1] == '.csv':
            repo_list.append(item['name'])

    
    firstTile = True
    base_url = url.replace('api.github.com/repos', 'raw.githubusercontent.com').replace('/contents/','/master/')
    for item in repo_list:
        item_url="{}/{}".format(base_url, item)
        print(item)
        response = requests.get(item_url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
        print(response)
        df_loss_curve = pd.read_csv(StringIO(response.content.decode(response.encoding)), skiprows=1)
        
        df_structural = df_loss_curve.loc[df_loss_curve['loss_type'] == 'structural'].pivot(index='csdname', columns='return_period', values='loss_value')
        df_nonstructural = df_loss_curve.loc[df_loss_curve['loss_type'] == 'nonstructural'].pivot(index='csdname', columns='return_period', values='loss_value')
        df_contents = df_loss_curve.loc[df_loss_curve['loss_type'] == 'contents'].pivot(index='csdname', columns='return_period', values='loss_value')
        df_pml = df_structural.add(df_nonstructural).add(df_contents)
        print(df_pml.columns)
        df_pml.columns = ['PML_50','PML_100','PML_500','PML_1000','PML_2500']
        # df_pml = df_pml.add_prefix(scenarioPrefix) 

        df_occupants = df_loss_curve.loc[df_loss_curve['loss_type'] == 'occupants'].pivot(index='csdname', columns='return_period', values='loss_value')
        print(df_occupants.columns)
        df_occupants.columns = ['OCC_50','OCC_100','OCC_500','OCC_1000','OCC_2500']
        # df_occupants = df_occupants.add_prefix(scenarioPrefix)
        dfOut = pd.merge(df_pml, df_occupants, on='csdname', how='inner')

        if firstTile is False:
            dfOut.to_sql('agg_loss_curves_mean_'+scenario, engine, if_exists='append', method=psql_insert_copy)
        else :
            dfOut.to_sql('agg_loss_curves_mean_'+scenario, engine, if_exists='replace', method=psql_insert_copy)
            firstTile = False
    
    return


def copy_damage(args, scenario, scenarioPrefix, damageCols, engine, auth):
    url = args.damageDir.replace('https://github.com', 'https://api.github.com/repos').replace('tree/master', 'contents').replace('${SCENARIO}', scenario)
    response = requests.get(url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
    # we could add some exception handling here for bad responses
    repo_dict = json.loads(response.content)
    repo_list = []
    
    for item in repo_dict:
        if item['type'] == 'file' and os.path.splitext(item['name'])[1] == '.csv':
            repo_list.append(item['name'])

    firstTile = True
    base_url = url.replace('api.github.com/repos', 'raw.githubusercontent.com').replace('/contents/','/master/')
    for item in repo_list:
        
        item_url="{}/{}".format(base_url, item)
        
        response = requests.get(item_url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
        
        dfOut = pd.read_csv(StringIO(response.content.decode(response.encoding))) #usecols=[columns passed from config] to 
        #Add a scenario prefix to each column if desired
        # dfOut = dfOut.add_prefix(scenarioPrefix)   
        #except for 'id', back to original name
        # dfOut = dfOut.rename(columns={scenarioPrefix+'id' : 'id'})
        if firstTile is False:
            dfOut.to_sql('damages_structural_mean_'+scenario, engine, if_exists='append', method=psql_insert_copy)
        else :
            dfOut.to_sql('damages_structural_mean_'+scenario, engine, if_exists='replace', method=psql_insert_copy)
            firstTile = False
    
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


def get_config_params(args):
    """
    Parse Input/Output columns from supplied *.ini file
    """
    configParseObj = configparser.ConfigParser()
    configParseObj.read(args)
    return configParseObj

def parse_args():
    parser = argparse.ArgumentParser(description='Pull PSRA Output data from Github repository and copy into PostGreSQL on AWS RDS')
    parser.add_argument('--avgLossMeanDir', type=str, help='Path to avg-losses-mean repo', required=True)
    parser.add_argument('--lossCurveMeanDir', type=str, help='Path to loss_curves-mean repo', required=True)
    parser.add_argument('--damageDir', type=str, help='Path to damage database repo', required=True)
    parser.add_argument('--columnsINI', type=str, help='PSRA_Metrics_Columns.ini', required=True, default='PSRA_Metrics_Columns.ini')
    args = parser.parse_args()
    
    return args

if __name__ == '__main__':
    main() 