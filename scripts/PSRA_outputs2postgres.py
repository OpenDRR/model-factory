#!/usr/bin/env python
import sqlalchemy as db
import sqlalchemy.orm as orm
import pandas as pd
import numpy as np
from io import StringIO
import pyodbc 
import csv
import glob 
import os
import sys
import argparse
import configparser

'''
Script to ingest OpenQuake outputs in csv and MS Access format to single PostGreSQL database. The Script can be run in the following form by 
changing the filepaths as appropriate
python C:\GitLab\nrcan\scenarios\scripts\PSRA_outputs2postgres.py 
--avgLossMeanDir="C:\Projects\RiskProfile_Compilation\eRisk_CA\avg_losses-mean" 
--lossCurveMeanDir="C:\Projects\RiskProfile_Compilation\eRisk_CA\loss_curve-mean" 
--physExposureCSV="C:\Projects\RiskProfile_Compilation\eRisk_CA\Canada.csv" 
--damageMDBDir="C:\Projects\RiskProfile_Compilation\eRisk_CA\cDamage_CA" 
--columnsINI="C:\GitLab\nrcan\scenarios\scripts\PSRA_Metrics_Columns.ini"
'''

def main():
    args = parse_args()
    os.system('')
    configParser = get_config_params(args)

    listScenario = list(filter(None, (x.strip() for x in configParser.get('Scenario', 'listScenario').splitlines())))
    listScenarioPrefix = list(filter(None, (x.strip() for x in configParser.get('Scenario', 'listScenarioPrefix').splitlines())))
    damageCols = list(filter(None, (x.strip() for x in configParser.get('Damage Potential', 'damagePotentialColumns').splitlines())))
    
    engine = db.create_engine('postgresql://postgres:password@localhost:5432/gisdb')

    for scenario, scenarioPrefix in zip(listScenario,listScenarioPrefix):
        #merge all of the csv tiles, name columns according to scenario prefix
        copy_average_losses_mean(args, scenario, scenarioPrefix, engine)

        #reshape and merge loss curves tiles, name columns according to scenario prefix
        pivot_copy_loss_curves_mean(args, scenario, scenarioPrefix, engine)
    
        #Parse the Damage Databases from access and copy into postgres
        copy_damage_mdb2postgres(args, scenario, scenarioPrefix, damageCols, engine)
        
    copy_exposure_model(args, engine)
    
    return

def copy_average_losses_mean(args, scenario, scenarioPrefix, engine):
    os.chdir(os.path.join(args.avgLossMeanDir,scenario))
    print('Merging all tiled csv files in: '+os.path.join(args.avgLossMeanDir,scenario))
    dfOut = pd.concat([pd.read_csv(csvFile, usecols=['id','structural','nonstructural','contents','occupants']) for csvFile in glob.glob('avg_losses-mean_???.csv')])
    #Add a scenario prefix to each column
    dfOut = dfOut.add_prefix(scenarioPrefix)   
    #except for 'id', back to original name
    dfOut = dfOut.rename(columns={scenarioPrefix+'id' : 'id'})

    return dfOut.to_sql('average_losses_mean_'+scenario, engine, if_exists='replace', method=psql_insert_copy)


def pivot_copy_loss_curves_mean(args, scenario, scenarioPrefix, engine):
    os.chdir(os.path.join(args.lossCurveMeanDir,scenario))
    print('Merging all tiled csv files in: '+os.path.join(args.lossCurveMeanDir,scenario))
    firstTile = True
    for csvFile in glob.glob('loss_curves-mean_???.csv'):
        df_loss_curve = pd.read_csv(csvFile, skiprows=1)
        df_loss_curve['loss'] = df_loss_curve['loss'].astype(float)
        
        df_structural = df_loss_curve.loc[df_loss_curve['loss_type'] == 'structural'].pivot(index='asset', columns='period', values='loss')
        df_nonstructural = df_loss_curve.loc[df_loss_curve['loss_type'] == 'nonstructural'].pivot(index='asset', columns='period', values='loss')
        df_contents = df_loss_curve.loc[df_loss_curve['loss_type'] == 'contents'].pivot(index='asset', columns='period', values='loss')
        df_pml = df_structural.add(df_nonstructural).add(df_contents)
        df_pml.columns = ['PML_50','PML_100','PML_500','PML_1000','PML_2500']
        df_pml = df_pml.add_prefix(scenarioPrefix) 

        df_occupants = df_loss_curve.loc[df_loss_curve['loss_type'] == 'occupants'].pivot(index='asset', columns='period', values='loss')
        df_occupants.columns = ['OCC_50','OCC_100','OCC_500','OCC_1000','OCC_2500']
        df_occupants = df_occupants.add_prefix(scenarioPrefix)
        dfOut = pd.merge(df_pml, df_occupants, on='asset', how='inner')

        if firstTile is False:
            dfOut.to_sql('loss_curves_mean_'+scenario, engine, if_exists='append', method=psql_insert_copy)
        else :
            dfOut.to_sql('loss_curves_mean_'+scenario, engine, if_exists='replace', method=psql_insert_copy)
            firstTile = False
    
    return True


def copy_damage_mdb2postgres(args, scenario, scenarioPrefix, damageCols, engine):
    print('Converting damage databases to CSV for scenario: '+scenario)
    connString = (
        r'DRIVER={Microsoft Access Driver (*.mdb)};'
        r'DBQ='+os.path.join(args.damageMDBDir, 'cDamage_CA_'+scenarioPrefix[:-1]+'.mdb')
        )
    conn = pyodbc.connect(connString)
    #update next line to check the tables in the database in case naming is inconsistent
    SQL_Query = pd.read_sql_query('SELECT '+', '.join(damageCols)+' from cDamage_CA_'+scenarioPrefix[:-1], conn)
    dfDamage = pd.DataFrame(SQL_Query, columns=damageCols)
    dfDamage.columns = [[item[0:2]+scenarioPrefix[1:2]+item[2:] for item in damageCols]]
    dfDamage = dfDamage.rename(columns={'id'+scenarioPrefix[1:2] : 'id'})

    return dfDamage.to_sql('cdamage_ca_'+scenario, engine, if_exists='replace', method=psql_insert_copy, index=False, chunksize=100)

def copy_exposure_model(args, engine):
    dfExposure = pd.read_csv(args.physExposureCSV)
    return dfExposure.to_sql("exposure_model", engine, if_exists='replace', method=psql_insert_copy, chunksize=100)

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
    configParser = configparser.ConfigParser()
    configParser.read(args.columnsINI)
    return configParser

def parse_args():
    parser = argparse.ArgumentParser(description='Merge Average Annual Losses and Probable Maximum Loss With Physical Exposure Dataset.')
    parser.add_argument('--avgLossMeanDir', type=str, help='Path to avg-losses-mean directory', required=True)
    parser.add_argument('--lossCurveMeanDir', type=str, help='Path to loss_curves-mean directory', required=True)
    parser.add_argument('--physExposureCSV', type=str, help='Path to physical exposure file', required=True)
    parser.add_argument('--damageMDBDir', type=str, help='Path to damage database directory', required=True)
    parser.add_argument('--columnsINI', type=str, help='PSRA_Metrics_Columns.ini', required=True, default='PSRA_Metrics_Columns.ini')
    args = parser.parse_args()
    
    return args

if __name__ == '__main__':
    main() 