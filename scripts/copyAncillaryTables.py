#Import statements
import sys
import os
import argparse
import configparser
import psycopg2
import logging
import csv

'''
Script to copy Ancillary tables into PostGIS 
python3 
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


    systemCall='''psql -h  db-opendrr
                    -U ${POSTGRES_USER}
                    -d ${DB_NAME}
                    -a 
                    -c "\copy exposure.canada_exposure (objectid,
                                                        id,
                                                        SauidLat,
                                                        SauidLon,
                                                        Sauid_km2,
                                                        Sauid_ha,
                                                        LandUse,
                                                        taxonomy,
                                                        number,
                                                        structural,
                                                        nonstructural,
                                                        contents,
                                                        retrofitting,
                                                        day,night,
                                                        transit,
                                                        GenOcc,
                                                        OccClass1,
                                                        OccClass2,
                                                        PopDU,
                                                        GenType,
                                                        BldgType,
                                                        NumFloors,
                                                        Bldg_ft2,
                                                        BldYear,
                                                        BldEpoch,
                                                        SSC_Zone,
                                                        EqDesLev,
                                                        sauid,
                                                        dauid,
                                                        adauid,
                                                        fsauid,
                                                        csduid,
                                                        csdname,
                                                        cduid,
                                                        cdname,
                                                        SAC,
                                                        eruid,
                                                        ername,
                                                        pruid,
                                                        prname)
                        FROM '/usr/src/app/BldgExpRef_CA_master_v3p1.csv'
                            WITH 
                            DELIMITER AS ','
                            CSV HEADER ;" '''
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # systemCall='''psql -h  db-opendrr
    #             -U  ${{POSTGRES_USER}} 
    #             -d ${{DB_NAME}} 
    #             -a 
    #             -c "\copy gmf.shakemap_{eqScenario} ({headerFields}) 
    #                     FROM '/usr/src/app/{shakemapFile}' 
    #                         WITH 
    #                             DELIMITER AS ',' 
    #                             CSV HEADER ;"'''.format(**{
    #                                 'shakemapFile':args.shakemapFile,
    #                                 'eqScenario':eqScenario,
    #                                 'headerFields':headerFields})
    # systemCall = ' '.join(systemCall.split())
    # systemCall = systemCall.replace('PGA,"gmv', r'PGA,\"gmv')
    # systemCall = systemCall.replace(')","gmv', r')\",\"gmv')
    # systemCall = systemCall.replace(')",lon', r')\",lon')
    # os.system(systemCall)
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
    parser = argparse.ArgumentParser(description='''Script to run 
    Can be run from the command line with mandatory arguments 
    Run this script with a command like:
    python3  ''')
    # parser.add_argument("--shakemapFile", type=str, help="Shakemap CSV File")
    args = parser.parse_args()

    return args

if __name__ == '__main__':
    main() 