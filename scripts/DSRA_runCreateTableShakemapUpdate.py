#Import statements
import sys
import os
import argparse
import configparser
import psycopg2
import logging

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
    if args.exposureAgg == 'b':
        sqlquerystring = open('Create_table_shakemap_update.sql', 'r').read().format(**{'eqScenario':args.eqScenario})
    elif args.exposureAgg == 's':
        sqlquerystring = open('Create_table_shakemap_update_ste.sql', 'r').read().format(**{'eqScenario':args.eqScenario})
    else:
        logging.error("Exposure Model Aggregation not recognized - Bad input")
        exit()  
      
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
    parser.add_argument("--eqScenario", type=str, help="Earthquake Scenario Name")
    parser.add_argument("--exposureAgg", type=str, help="Exposure Model Aggregatio (b or s)")
    args = parser.parse_args()
    
    return args

if __name__ == '__main__':
    main() 