#Import statements
import sys
import os
import argparse
import configparser
import psycopg2
import logging
import csv

'''

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
    
    with open("/usr/src/app/cHazard/{prov}/cH_{prov}_hmaps.csv".format(**{'prov':args.province}), "r") as f:
        reader = csv.reader(f)
        hmapColumns = next(reader)
    hmapColumns = ','.join('"{0}"'.format(w) for w in hmapColumns)
    hmapColumns = hmapColumns.replace('-','_')
    hmapColumns = hmapColumns.replace('"lon"','lon')
    hmapColumns = hmapColumns.replace('"lat"','lat')
    hmapColumns = hmapColumns.replace('"PGA_0.02"','PGA_0.02')
    hmapColumns = hmapColumns.replace('"PGA_0.1"','PGA_0.02')

    with open("/usr/src/app/cHazard/{prov}/cH_{prov}_uhs.csv".format(**{'prov':args.province}), "r") as f:
        reader = csv.reader(f)
        uhsColumns = next(reader)
    uhsColumns = ','.join('"{0}"'.format(w) for w in hmapColumns)
    uhsColumns = uhsColumns.replace('~','_')
    uhsColumns = uhsColumns.replace('"lon"','lon')
    uhsColumns = uhsColumns.replace('"lat"','lat')
    hmapColumns = hmapColumns.replace('"0.2_PGA"','0.2_PGA')

    sqlquerystring = open(args.sqlScript, 'r').read().format(**{
        'prov':args.province, 
        'hmapColumns':hmapColumns,
        'uhsColumns':uhsColumns})
    

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
    parser = argparse.ArgumentParser(description='''''')
    parser.add_argument("--province", type=str, help="Two letter province/territory identifier")
    parser.add_argument("--sqlScript", type=str, help="PSRA SQL Script to Run")
    args = parser.parse_args()

    return args

if __name__ == '__main__':
    main() 