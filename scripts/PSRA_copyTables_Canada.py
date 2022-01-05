# Import statements
import argparse
import configparser
import csv
import logging
import os
import sys
'''
Script to copy Canada PSRA tables into PostGIS
python3 PSRA_copyTables_Canada.py
'''


# Main Function
def main():
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(levelname)s - %(message)s',
                        handlers=[logging.FileHandler('/tmp/{}.log'.format(
                            os.path.splitext(sys.argv[0])[0])),
                            logging.StreamHandler()])
    os.chdir(sys.path[0])
    args = parse_args()

    # Copy agg curves stats b0 table
    with open("/usr/src/app/ebRisk/Canada/ebR_Canada_agg_curves-stats_b0.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_canada.psra_canada_agg_curves_stats_b0({aggColumns})
                    FROM /usr/src/app/ebRisk/Canada/ebR_Canada_agg_curves-stats_b0.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg curves stats r1 table
    with open("/usr/src/app/ebRisk/Canada/ebR_Canada_agg_curves-stats_r1.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_canada.psra_canada_agg_curves_stats_r1({aggColumns})
                    FROM /usr/src/app/ebRisk/Canada/ebR_Canada_agg_curves-stats_r1.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg curves q05 b0 table
    with open("/usr/src/app/ebRisk/Canada/ebR_Canada_agg_curves-q05_b0.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_canada.psra_canada_agg_curves_q05_b0({aggColumns})
                        FROM /usr/src/app/ebRisk/Canada/ebR_Canada_agg_curves-q05_b0.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'prov': args.province,
                                'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg curves q05 r1 table
    with open("/usr/src/app/ebRisk/Canada/ebR_Canada_agg_curves-q05_r1.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_canada.psra_canada_agg_curves_q05_r1({aggColumns})
                        FROM /usr/src/app/ebRisk/Canada/ebR_Canada_agg_curves-q05_r1.csv
                            WITH
                            CSV HEADER ;'""".format(**{'prov': args.province,
                                                       'aggColumns':aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg curves q95 b0 table
    with open("/usr/src/app/ebRisk/Canada/ebR_Canada_agg_curves-q95_b0.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_canada.psra_canada_agg_curves_q95_b0({aggColumns})
                        FROM /usr/src/app/ebRisk/Canada/ebR_Canada_agg_curves-q95_b0.csv
                            WITH
                            CSV HEADER ;'""".format(**{'prov': args.province,
                                                       'aggColumns':aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg curves q95 r1 table
    with open("/usr/src/app/ebRisk/Canada/ebR_Canada_agg_curves-q95_r1.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_canada.psra_canada_agg_curves_q95_r1({aggColumns})
                        FROM /usr/src/app/ebRisk/Canada/ebR_Canada_agg_curves-q95_r1.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'prov': args.province,
                                'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg losses q05 b0 table
    with open("/usr/src/app/ebRisk/Canada/ebR_Canada_agg_losses-q05_b0.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_canada.psra_canada_agg_losses_q05_b0({aggColumns})
                        FROM /usr/src/app/ebRisk/Canada/ebR_Canada_agg_losses-q05_b0.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'prov': args.province,
                                'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg losses q05 r1 table
    with open("/usr/src/app/ebRisk/Canada/ebR_Canada_agg_losses-q05_r1.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_canada.psra_canada_agg_losses_q05_r1({aggColumns})
                        FROM /usr/src/app/ebRisk/Canada/ebR_Canada_agg_losses-q05_r1.csv
                            WITH
                            CSV HEADER ;'""".format(**{'prov': args.province,
                                                       'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg losses q95 b0 table
    with open("/usr/src/app/ebRisk/Canada/ebR_Canada_agg_losses-q95_b0.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_canada.psra_canada_agg_losses_q95_b0({aggColumns})
                        FROM /usr/src/app/ebRisk/Canada/ebR_Canada_agg_losses-q95_b0.csv
                            WITH
                            CSV HEADER ;'""".format(**{'prov': args.province,
                                                       'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg losses q95 r1 table
    with open("/usr/src/app/ebRisk/Canada/ebR_Canada_agg_losses-q95_r1.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_canada.psra_canada_agg_losses_q95_r1({aggColumns})
                        FROM /usr/src/app/ebRisk/Canada/ebR_Canada_agg_losses-q95_r1.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'prov': args.province,
                                'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg losses stats b0 table
    with open("/usr/src/app/ebRisk/Canada/ebR_Canada_agg_losses-stats_b0.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_canada.psra_canada_agg_losses_stats_b0({aggColumns})
                        FROM /usr/src/app/ebRisk/Canada/ebR_Canada_agg_losses-stats_b0.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'prov': args.province,
                                'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg losses stats r1 table
    with open("/usr/src/app/ebRisk/Canada/ebR_Canada_agg_losses-stats_r1.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_canada.psra_canada_agg_losses_stats_r1({aggColumns})
                        FROM /usr/src/app/ebRisk/Canada/ebR_Canada_agg_losses-stats_r1.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'prov': args.province,
                                'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy source loss b0 table
    with open("/usr/src/app/ebRisk/Canada/ebR_Canada_src_loss_table_b0.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        lossColumns = next(reader)
    lossColumns = ','.join('"{0}"'.format(w) for w in lossColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_canada.psra_canada_src_loss_b0({lossColumns})
                    FROM /usr/src/app/ebRisk/Canada/ebR_Canada_src_loss_table_b0.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'lossColumns': lossColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy source loss r1 table
    with open("/usr/src/app/ebRisk/Canada/ebR_Canada_src_loss_table_r1.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        lossColumns = next(reader)
    lossColumns = ','.join('"{0}"'.format(w) for w in lossColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_canada.psra_canada_src_loss_r1({lossColumns})
                    FROM /usr/src/app/ebRisk/Canada/ebR_Canada_src_loss_table_r1.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'lossColumns': lossColumns})
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
    for PSRA datasets Can be run from the command line with out arguments like:
    Run this script with a command like:
    python3 PSRA_copyTables.py''')
    parser.add_argument("--province", type=str, help="Two letter province/territory identifier")
    args = parser.parse_args()

    return args


if __name__ == '__main__':
    main()
