#Import statements
import sys
import os
import argparse
import configparser
import psycopg2
import logging

'''
Script to run Create_table_sitemesh_update 
python3 DSRA_sitemesh_gmf_xref.py --eqScenario=idm7p1_jdf
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
    sqlquerystring = open('Create_table_s_sitemesh_update.sql', 'r').read().format(**{'eqScenario':args.eqScenario})
    try:
        connection = psycopg2.connect(user = auth.get('rds', 'postgres_un'),
                                        password = auth.get('rds', 'postgres_pw'),
                                        host = auth.get('rds', 'postgres_host'),
                                        port = auth.get('rds', 'postgres_port'),
                                        database = auth.get('rds', 'postgres_db'))
        cursor = connection.cursor()
        cursor.execute(sqlquerystring)
        cursor.commit()
    
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
    parser = argparse.ArgumentParser(description='''Script to create DSRA indicator views 
    Can be run from the command line with mandatory arguments 
    Run this script with a command like:
    python3 DSRA_sitemesh_gmf_xref.py --eqScenario=idm7p1_jdf ''')
    parser.add_argument("--eqScenario", type=str, help="Earthquake scenario id")
    
    args = parser.parse_args()
    
    return args

if __name__ == '__main__':
    main() 
