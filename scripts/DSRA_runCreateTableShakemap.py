#Import statements
import sys
import os
import argparse
import configparser
import psycopg2
import logging
import csv

'''
Script to run Create_table_shakemap.sql
python3 DSRA_runCreateTableShakemap.py --shakemapFile=s_shakemap_IDM6p8_Sidney_221.csv
'''

#Main Function
def main ():
    logging.basicConfig(level=logging.INFO,
                format='%(asctime)s - %(levelname)s - %(message)s', 
                handlers=[logging.FileHandler('/tmp/{}.log'.format(os.path.splitext(sys.argv[0])[0])),
                            logging.StreamHandler()])
    os.chdir(sys.path[0])
    auth = get_config_params('config.ini')
    args = parse_args()
    eqScenario='{}_{}'.format(args.shakemapFile.split('_')[2],args.shakemapFile.split('_')[3])
    with open(args.shakemapFile, "r") as f:
        reader = csv.reader(f)
        headerFields = reader.next() 

    headerFields = ','.join(headerFields)
    sqlquerystring = open('Create_table_shakemap.sql', 'r').read().format(**{
        'shakemapFile':args.shakemapFile,
        'eqScenario':eqScenario
        'headerFields':headerFields})
    try:
        connection = psycopg2.connect(user = auth.get('rds', 'postgres_un'),
                                        password = auth.get('rds', 'postgres_pw'),
                                        host = auth.get('rds', 'postgres_host'),
                                        port = auth.get('rds', 'postgres_port'),
                                        database = auth.get('rds', 'postgres_db'))
        cursor = connection.cursor()
        cursor.execute(sqlquerystring)
        #cursor.commit()
        connection.commit()
    
    except (Exception, psycopg2.Error) as error :
        logging.error(error)

    finally:
        if(connection):
            cursor.close()
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
    parser = argparse.ArgumentParser(description='''Script to create DSRA shakemap 
    table in PostGIS database from raw CSV file
    Can be run from the command line with mandatory arguments 
    Run this script with a command like:
    python3 DSRA_runCreateTableShakemap.py --shakemapFile=s_shakemap_IDM6p8_Sidney_221.csv ''')
    parser.add_argument("--shakemapFile", type=str, help="Shakemap CSV File")
    args = parser.parse_args()
    
    return args

if __name__ == '__main__':
    main() 