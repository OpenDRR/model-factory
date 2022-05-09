# Import statements
import sys
import os
import argparse
import configparser
import logging
import csv

'''
Script to copy Ancillary tables into PostGIS
python3 copyAncillaryTables.py
'''


# Main Function
def main():
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(levelname)s - %(message)s',
                        handlers=[logging.FileHandler('/tmp/{}.log'.format(
                            os.path.splitext(sys.argv[0])[0])),
                            logging.StreamHandler()])
    os.chdir(sys.path[0])
    # auth = get_config_params('config.ini')
    # args = parse_args()

    # Copy Canada Exposure Model
    with open("/usr/src/app/BldgExpRef_CA_master_v3p2.csv") as f:
        reader = csv.reader(f)
        columns = next(reader)
    columns = ','.join('"{0}"'.format(w) for w in columns)
    columns = columns.lower()
    systemCall = """psql -h ${{POSTGRES_HOST}}
                    -U ${{POSTGRES_USER}}
                    -d ${{DB_NAME}}
                    -a
                    -c '\copy exposure.canada_exposure ({columns})
                        FROM /usr/src/app/BldgExpRef_CA_master_v3p2.csv
                            WITH
                            CSV HEADER ;' """.format(**{
                                'columns': columns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy Site exposure model
    # with open("/usr/src/app/PhysExpRef_MetroVan_v4.csv") as f:
    #     reader = csv.reader(f)
    #     columns = next(reader)
    # columns = ','.join('"{0}"'.format(w) for w in columns)
    # columns = columns.lower()
    # systemCall = """psql -h ${{POSTGRES_HOST}}
    #             -U ${{POSTGRES_USER}}
    #             -d ${{DB_NAME}}
    #             -a
    #             -c '\copy  exposure.metrovan_site_exposure ({columns})
    #                     FROM /usr/src/app/PhysExpRef_MetroVan_v4.csv
    #                         WITH
    #                         CSV HEADER ;'""".format(**{
    #                             'columns': columns})
    # systemCall = ' '.join(systemCall.split())
    # os.system(systemCall)

    # Copy VS30 Canada Site Model
    with open("/usr/src/app/site-vgrid_CA.csv") as f:
        reader = csv.reader(f)
        columns = next(reader)
    columns = ','.join('"{0}"'.format(w) for w in columns)
    systemCall = """psql -h ${{POSTGRES_HOST}}
                -U ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy vs30.vs30_can_site_model ({columns})
                        FROM /usr/src/app/site-vgrid_CA.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'columns': columns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy VS30 Canada Site Model xref
    with open("/usr/src/app/vs30_CAN_site_model_xref.csv") as f:
        reader = csv.reader(f)
        columns = next(reader)
    columns = ','.join('"{0}"'.format(w) for w in columns)
    systemCall = """psql -h ${{POSTGRES_HOST}}
                -U ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy vs30.vs30_can_site_model_xref ({columns})
                        FROM /usr/src/app/vs30_CAN_site_model_xref.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'columns': columns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy 2016 Censuse Table
    with open("/usr/src/app/census-attributes-2016.csv") as f:
        reader = csv.reader(f)
        columns = next(reader)
    columns = ','.join('"{0}"'.format(w) for w in columns)
    columns = columns.lower()
    systemCall = """psql -h ${{POSTGRES_HOST}}
                -U ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy census.census_2016_canada ({columns})
                        FROM /usr/src/app/census-attributes-2016.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'columns': columns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy Table SOVI SAUID
    with open("/usr/src/app/sovi_sauid_nov2021.csv") as f:
        reader = csv.reader(f)
        columns = next(reader)

    columns = ','.join('"{0}"'.format(w) for w in columns)
    systemCall = """psql -h ${{POSTGRES_HOST}}
                -U ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy  sovi.sovi_sauid_nov2021 ({columns})
                        FROM /usr/src/app/sovi_sauid_nov2021.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'columns': columns})

    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy table collapse probability
    with open("/usr/src/app/collapse_probability.csv") as f:
        reader = csv.reader(f)
        columns = next(reader)
    columns = ','.join('"{0}"'.format(w) for w in columns)
    systemCall = """psql -h ${{POSTGRES_HOST}}
                -U ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy  lut.collapse_probability ({columns})
                        FROM /usr/src/app/collapse_probability.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'columns': columns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy GHSL Table
    with open("/usr/src/app/mh-intensity-ghsl.csv") as f:
        reader = csv.reader(f)
        columns = next(reader)

    columns = ','.join('"{0}"'.format(w) for w in columns)
    columns = columns.lower()
    systemCall = """psql -h ${{POSTGRES_HOST}}
                -U ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy  ghsl.ghsl_mh_intensity_ghsl ({columns})
                        FROM /usr/src/app/mh-intensity-ghsl.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'columns': columns})

    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)


    # Copy MH Intensity Table
    with open("/usr/src/app/HTi_sauid.csv") as f:
        reader = csv.reader(f)
        columns = next(reader)

    columns = ','.join('"{0}"'.format(w) for w in columns)
    columns = columns.lower()
    columns = columns.replace('e_sauid"', 'sauidt"')
    columns = columns.replace(',"e_', ',"')
    columns = columns.replace('sauidlon', 'lon')
    columns = columns.replace('sauidlat', 'lat')
    columns = columns.replace(',"hti_', ',"')
    columns = columns.replace(',"ph_', ',"')
    columns = columns.replace('svit_score', 'svlt_score')

    systemCall = """psql -h ${{POSTGRES_HOST}}
                -U ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy   mh.mh_intensity_canada({columns})
                        FROM /usr/src/app/HTi_sauid.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'columns': columns})

    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)


    # Copy MH Threshold Table
    with open("/usr/src/app/HTi_thresholds.csv") as f:
        reader = csv.reader(f)
        columns = next(reader)
    columns = ','.join('"{0}"'.format(w) for w in columns)
    systemCall = """psql -h ${{POSTGRES_HOST}}
                -U ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy   mh.mh_thresholds({columns})
                    FROM /usr/src/app/HTi_thresholds.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'columns': columns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy MH Rating Threshold Table
    with open("/usr/src/app/hazard_threat_rating_thresholds.csv") as f:
        reader = csv.reader(f)
        columns = next(reader)
    columns = ','.join('"{0}"'.format(w) for w in columns)
    systemCall = """psql -h ${{POSTGRES_HOST}}
                -U ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy   mh.mh_ratings_thresholds({columns})
                    FROM /usr/src/app/hazard_threat_rating_thresholds.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'columns': columns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)
    return


# Support Functions
def get_config_params(args):
    """
    Parse Input/Output columns from supplied *.ini file
    """
    configParseObj = configparser.ConfigParser()
    configParseObj.read(args)
    return configParseObj


def parse_args():
    parser = argparse.ArgumentParser(description='''Script to run \\copy statements
    for ancillary datasets such as Exposure models, VS30 models etc
    Can be run from the command line with out arguments like:
    Run this script with a command like:
    python3 copyAncillaryTables.py''')
    # parser.add_argument("--shakemapFile", type=str, help="Shakemap CSV File")
    args = parser.parse_args()

    return args


if __name__ == '__main__':
    main()
