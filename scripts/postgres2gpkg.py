#Template Python Script
#!/usr/bin/env python
#Import statements
import os
import sys
import argparse
import configparser
import psycopg2
import geopandas

#procedural code

#Main Function
def main ():
    os.chdir(sys.path[0])
    auth = get_config_params('config.ini')
    # args = parse_args()
    sqlquerystring = 'SELECT * from "results_idm7p1_jdf_rlz_0"."dsra_indicators_affectedpeople_idm7p1_jdf_rlz_0_b0"'
    connection = None
    try:
        connection = psycopg2.connect(user = auth.get('rds', 'postgres_un'),
                                        password = auth.get('rds', 'postgres_pw'),
                                        host = auth.get('rds', 'postgres_host'),
                                        port = auth.get('rds', 'postgres_port'),
                                        database = auth.get('rds', 'postgres_db'))
        pgdf = geopandas.GeoDataFrame.from_postgis(sqlquerystring, connection, geom_col='geom')
        pgdf.to_file('test.gpkg', driver="GPKG")

    except (Exception, psycopg2.Error) as error :
        print ("Error while connecting to PostgreSQL", error)

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
    parser.add_argument("--arg1", type=str, help="First argument")

    args = parser.parse_args()
    
    return args

#Classes

if __name__ == '__main__':
    main() 

    