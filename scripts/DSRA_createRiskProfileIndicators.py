#Import statements
import sys
import os
import argparse
import configparser
import psycopg2
import logging

'''
Script to create DSRA indicator views 
Can be run from the command line with mandatory arguments 
Run this script with a command like:
python Create_DSRA_risk_profile_indicators.py --eqScenario="idm7p1_jdf" --realization=rlz_1
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
    sqlquerystring = open('Create_scenario_risk_building_indicators_ALL.sql', 'r').read().format(**{'eq_scenario':args.eqScenario, 'realization':args.realization})
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
    python Create_DSRA_risk_profile_indicators.py --eqScenario="idm7p1_jdf_rlz_0" --realization="rlz_1"''')
    parser.add_argument("--eqScenario", type=str, help="Earthquake scenario id")
    parser.add_argument("--realization", type=str, help="Realization Number formatted like: rlz_1,rlz_2 etc.")

    args = parser.parse_args()
    
    return args

if __name__ == '__main__':
    main() 
