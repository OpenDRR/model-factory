#!/usr/bin/python3

'''
Script to run psql \\copy statements to copy PSRA datasets into PostGIS
python3 PSRA_copyTables.py
'''

import argparse
import configparser
import csv
import logging
import os
import re
import sys

# WORKDIR of the opendrr/python-env Docker image
WORKDIR = '/usr/src/app'

calculations = {
    'cHazard': [
        'hcurves_PGA',
        'hcurves_Sa0p1',
        'hcurves_Sa0p2',
        'hcurves_Sa0p3',
        'hcurves_Sa0p5',
        'hcurves_Sa0p6',
        'hcurves_Sa1p0',
        'hcurves_Sa2p0',
        'hmaps',
        'hmaps_xref',
        'uhs',
    ],
    'cDamage': [
        'dmg-mean_b0',
        'dmg-mean_r2',
    ],
    'eDamage': [
        'damages-mean_b0',
        'damages-mean_r2',
    ],
    'ebRisk': [
        'agg_curves-stats_b0',
        'agg_curves-stats_r2',
        'avg_losses-stats_b0',
        'avg_losses-stats_r2',
        'src_loss_table_b0',
        'src_loss_table_r2',
    ]
}

# expected_headers will be removed in a future version
expected_headers = {}


def populate_expected_headers():
    """Populate expected_headers to help check for changes."""
    template_headers = {
        'HCURVES_5.0': [
            'lon', 'lat', 'depth',
            'poe_0.0500000', 'poe_0.0637137', 'poe_0.0811888', 'poe_0.1034569',
            'poe_0.1318325', 'poe_0.1679909', 'poe_0.2140666', 'poe_0.2727797',
            'poe_0.3475964', 'poe_0.4429334', 'poe_0.5644189', 'poe_0.7192249',
            'poe_0.9164904', 'poe_1.1678607', 'poe_1.4881757', 'poe_1.8963451',
            'poe_2.4164651', 'poe_3.0792411', 'poe_3.9237999', 'poe_5.0000000',
        ],
        'HCURVES_9.4': [
            'lon', 'lat', 'depth',
            'poe_0.0500000', 'poe_0.0658662', 'poe_0.0867671', 'poe_0.1143003',
            'poe_0.1505706', 'poe_0.1983502', 'poe_0.2612914', 'poe_0.3442054',
            'poe_0.4534299', 'poe_0.5973140', 'poe_0.7868559', 'poe_1.0365439',
            'poe_1.3654639', 'poe_1.7987580', 'poe_2.3695466', 'poe_3.1214600',
            'poe_4.1119734', 'poe_5.4168002', 'poe_7.1356795', 'poe_9.4000000',
        ],
        'HMAPS_XREF': [
            'id', 'sauid', 'asset_lon', 'asset_lat', 'lon', 'lat', 'distance',
            'PGA_0.02', 'PGA_0.1',
            'SA(0.1)_0.02', 'SA(0.1)_0.1',
            'SA(0.2)_0.02', 'SA(0.2)_0.1',
            'SA(0.3)_0.02', 'SA(0.3)_0.1',
            'SA(0.5)_0.02', 'SA(0.5)_0.1',
            'SA(0.6)_0.02', 'SA(0.6)_0.1',
            'SA(1.0)_0.02', 'SA(1.0)_0.1',
            'SA(10.0)_0.02', 'SA(10.0)_0.1',
            'SA(2.0)_0.02', 'SA(2.0)_0.1',
            'SA(5.0)_0.02', 'SA(5.0)_0.1',
        ],
        'DMG_MEAN': [
            'asset_id',
            'BldEpoch', 'BldgType', 'EqDesLev', 'GenOcc', 'GenType', 'LandUse',
            'OccClass', 'SAC', 'SSC_Zone', 'SauidID', 'adauid', 'cdname',
            'cduid', 'csdname', 'csduid', 'dauid', 'ername', 'eruid', 'fsauid',
            'prname', 'pruid', 'sauid', 'taxonomy',
            'lon', 'lat',
            'structural_no_damage', 'structural_slight', 'structural_moderate',
            'structural_extensive', 'structural_complete',
        ],
        'AGG_CURVES_STATS': [
            'return_period', 'stat', 'loss_type', 'fsauid', 'GenOcc',
            'GenType', 'loss_value', 'loss_ratio',
            'annual_frequency_of_exceedence',
        ],
        'AVG_LOSS_STATS': [
            'asset_id',
            'BldEpoch', 'BldgType', 'EqDesLev', 'GenOcc', 'GenType', 'LandUse',
            'OccClass', 'SAC', 'SSC_Zone', 'SauidID', 'adauid', 'cdname',
            'cduid', 'csdname', 'csduid', 'dauid', 'ername', 'eruid', 'fsauid',
            'prname', 'pruid', 'sauid', 'taxonomy',
            'lon', 'lat',
            'contents', 'nonstructural', 'structural',
        ],
        'SRC_LOSS': ['source', 'loss_type', 'loss_value', 'trt', 'region'],
    }

    blah = {
        'HCURVES_5.0': [
            'hcurves_pga', 'hcurves_sa0p1', 'hcurves_sa0p2', 'hcurves_sa0p3',
            'hcurves_sa1p0', 'hcurves_sa2p0'],
        'HCURVES_9.4': ['hcurves_sa0p5', 'hcurves_sa0p6'],
        'HMAPS_XREF': ['hmaps_ref'],
        'DMG_MEAN': [
            'cd_dmg_mean_b0', 'cd_dmg_mean_r2',
            'ed_dmg_mean_b0', 'ed_dmg_mean_r2'],
        'AGG_CURVES_STATS': ['agg_curves_stats_b0', 'agg_curves_stats_r2'],
        'AVG_LOSS_STATS': ['avg_losses_stats_b0', 'avg_losses_stats_r2'],
        'SRC_LOSS': ['src_loss_b0', 'src_loss_r2']
    }

    for tmpl in blah:
        if tmpl in expected_headers:
            print('ERROR', tmpl)
        print(blah[tmpl])
        for tabl in blah[tmpl]:
            expected_headers[tabl] = template_headers[tmpl]


def check_headers():
    """Temporary function to check headers during refactoring"""
    for k in expected_headers:
        print(k)
        print()

        control = 'cd_dmg_mean_b0'
        if expected_headers[k] == expected_headers[control]:
            print(k, "and %s are identical" % control)
        else:
            print(k, "and %s are DIFFERENT" % control)
            print(expected_headers[k])
            print(expected_headers[control])
            print()

    # print(expected_headers['hcurves_pga'])


def import_csv(model, table_csv, province):
    """Import CSV files into PostGIS database"""

    model_abbrev = re.match("[a-z]+[A-Z]", model)[0]    # e.g. ebRisk -> ebR
    cvs_filename = '%s_%s_%s.csv' % (model_abbrev, province, table_csv)
    cvs_fullpath = os.path.join(WORKDIR, model, province, cvs_filename)

    table_sql = table_csv.lower().replace('-', '_')
    print('FROM', cvs_fullpath)

    # Use of utf-8-sig strips initial U+FEFF byte order mark (BOM), if any
    with open(cvs_fullpath, mode='r', encoding='utf-8-sig') as f:
        reader = csv.reader(f)
        columns = next(reader)
        if columns[0] == '#':
            print('OpenQuake comment header detected, stripping...')
            columns = next(reader)

    columns = ','.join('"{0}"'.format(w) for w in columns)
    print(columns)
    return
    columns = columns.replace('~', '_')
    columns = columns.replace('"lon"', 'lon')
    columns = columns.replace('"lat"', 'lat')

    cmd = r"""psql -h "${{POSTGRES_HOST}}"
            -U "${{POSTGRES_USER}}"
            -d "${{DB_NAME}}"
            -a
            -c '\copy psra_{prov}.psra_{prov}_uhs({columns})
                FROM /usr/src/app/cHazard/{prov}/cH_{prov}_uhs.csv
                WITH
                CSV HEADER ;'
    """.format(**{'prov': province, 'columns': columns})
    print(cmd)
    cmd = ' '.join(cmd.split())
    os.system(cmd)


# Support Functions

def get_config_params(args):
    """
    Parse Input/Output columns from supplied *.ini file
    """
    config = configparser.ConfigParser()
    config.read(args)
    return config


def parse_args():
    """Parse command-line arguments."""
    parser = argparse.ArgumentParser(
        description=r'Script to run psql \copy statements for PSRA datasets.'
    )
    parser.add_argument("--province", type=str,
                        help="Two letter province/territory identifier")

    if not parser.parse_args().province:
        print("ERROR: Must specify a province or territory with --province\n")
        parser.print_help(sys.stderr)
        sys.exit(1)

    return parser.parse_args()


def main():
    """
    Iterate through tables listed in calculations (dictionary of lists)
    for CSV import into PostGIS
    """
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[logging.FileHandler(
            '/tmp/{}.log'.format(os.path.splitext(sys.argv[0])[0])),
            logging.StreamHandler()])
    os.chdir(sys.path[0])

    check_headers()
    populate_expected_headers()

    args = parse_args()

    for model in calculations:
        for table_csv in calculations[model]:
            import_csv(model, table_csv, args.province)


if __name__ == '__main__':
    main()
