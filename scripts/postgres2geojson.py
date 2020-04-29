#!/usr/bin/env python
#Import statements
import os
import sys
import argparse
import configparser
import psycopg2
import geopandas
import logging

'''
Script to convert DSRA indicator views to GeoJSON
Can be run from the command line with mandatory arguments 
Run this script with a command like:
python postgres2geojson.py --eqScenario="idm7p1_jdf_rlz_0" --retrofitPrefix="b0" --dbview=affectedpeople
'''

#Main Function
def main ():
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(levelname)s - %(message)s', 
                        handlers=[logging.FileHandler('{}.log'.format(os.path.splitext(sys.argv[0])[0])),
                                  logging.StreamHandler()])
    os.chdir(sys.path[0])
    auth = get_config_params('config.ini')
    args = parse_args()
    view = "dsra_{eq_scenario}_{retrofit_prefix}_{dbview}".format(**{'eq_scenario':args.eqScenario, 'retrofit_prefix':args.retrofitPrefix, 'dbview':args.dbview})
    sqlquerystring = 'SELECT * from "results"."{}"'.format(view)
    connection = None
    try:
        connection = psycopg2.connect(user = auth.get('rds', 'postgres_un'),
                                        password = auth.get('rds', 'postgres_pw'),
                                        host = auth.get('rds', 'postgres_host'),
                                        port = auth.get('rds', 'postgres_port'),
                                        database = auth.get('rds', 'postgres_db'))
        pgdf = geopandas.GeoDataFrame.from_postgis(sqlquerystring, connection, geom_col='geom_poly')
        pgdf.to_file(view+'.json', driver="GeoJSON")

    except (Exception, psycopg2.Error) as error :
        logging.error(error)

    finally:
        if(connection):
            # cursor.close()
            connection.close()

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
 
    parser = argparse.ArgumentParser(description="script description")
    parser.add_argument("--eqScenario", type=str, help="Earthquake scenario id")
    parser.add_argument("--retrofitPrefix", type=str, help="Retrofit Prefix. Allowable values: (b0, r1, r2)")
    parser.add_argument("--dbview", type=str, help=" Thematic Database View. Allowable values: (affectedpeople, all, buildingperformance, ci, economicsecurity mortality)")
    args = parser.parse_args()
    
    return args

#Classes

if __name__ == '__main__':
    main() 

    