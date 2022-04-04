#Import statements
import argparse
import configparser
import csv
import logging
import os
import sys
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
    args = parse_args()

    # Copy hcurve Table PGA
    with open("/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_PGA.csv".format(
            **{'prov': args.province}), "r", encoding='UTF-8-sig') as f:
        reader = csv.reader(f)
        hcurveColumns = next(reader)
    hcurveColumns = ','.join('"{0}"'.format(w) for w in hcurveColumns)
    hcurveColumns = hcurveColumns.replace('-', '_')
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_hcurves_pga({hcurveColumns})
                    FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_PGA.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'hcurveColumns': hcurveColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy hcurve table Sa0p1
    with open("/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p1.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        hcurveColumns = next(reader)
    hcurveColumns = ','.join('"{0}"'.format(w) for w in hcurveColumns)
    hcurveColumns = hcurveColumns.replace('-', '_')
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_hcurves_Sa0p1({hcurveColumns})
                    FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p1.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'hcurveColumns': hcurveColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy hcurve table Sa0p2
    with open("/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p2.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        hcurveColumns = next(reader)
    hcurveColumns = ','.join('"{0}"'.format(w) for w in hcurveColumns)
    hcurveColumns = hcurveColumns.replace('-', '_')
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_hcurves_sa0p2({hcurveColumns})
                    FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p2.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'hcurveColumns': hcurveColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy hcurve table Sa0p3
    with open("/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p3.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        hcurveColumns = next(reader)
    hcurveColumns = ','.join('"{0}"'.format(w) for w in hcurveColumns)
    hcurveColumns = hcurveColumns.replace('-', '_')
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_hcurves_sa0p3({hcurveColumns})
                    FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p3.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'hcurveColumns': hcurveColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy hcurve table Sa0p5
    with open("/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p5.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        hcurveColumns = next(reader)
    hcurveColumns = ','.join('"{0}"'.format(w) for w in hcurveColumns)
    hcurveColumns = hcurveColumns.replace('-', '_')
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_hcurves_sa0p5({hcurveColumns})
                    FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p5.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'hcurveColumns': hcurveColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy hcurve table Sa0p6
    with open("/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p6.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        hcurveColumns = next(reader)
    hcurveColumns = ','.join('"{0}"'.format(w) for w in hcurveColumns)
    hcurveColumns = hcurveColumns.replace('-', '_')
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_hcurves_sa0p6({hcurveColumns})
                    FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p6.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'hcurveColumns': hcurveColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy hcurve table Sa1p0
    with open("/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa1p0.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        hcurveColumns = next(reader)
    hcurveColumns = ','.join('"{0}"'.format(w) for w in hcurveColumns)
    hcurveColumns = hcurveColumns.replace('-', '_')
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_hcurves_sa1p0({hcurveColumns})
                    FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa1p0.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'hcurveColumns': hcurveColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy hcurve table Sa2p0
    with open("/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa2p0.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        hcurveColumns = next(reader)
    hcurveColumns = ','.join('"{0}"'.format(w) for w in hcurveColumns)
    hcurveColumns = hcurveColumns.replace('-', '_')
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_hcurves_sa2p0({hcurveColumns})
                    FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa2p0.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'hcurveColumns': hcurveColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy hmaps table
    with open("/usr/src/app/cHazard/{prov}/cH_{prov}_hmaps.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        hmapColumns = next(reader)
    hmapColumns = ','.join('"{0}"'.format(w) for w in hmapColumns)
    hmapColumns = hmapColumns.replace('-', '_')
    hmapColumns = hmapColumns.replace('"lon"', 'lon')
    hmapColumns = hmapColumns.replace('"lat"', 'lat')

    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_hmaps({hmapColumns})
                    FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hmaps.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'hmapColumns': hmapColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy hmaps_xref table
    with open("/usr/src/app/cHazard/{prov}/cH_{prov}_hmaps_xref.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        hmapColumns = next(reader)
    hmapColumns = ','.join('"{0}"'.format(w) for w in hmapColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_hmaps_xref({hmapColumns})
                        FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hmaps_xref.csv'
                            WITH
                            CSV HEADER ;'""".format(**{
                                'prov': args.province,
                                'hmapColumns': hmapColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy uhs table
    with open("/usr/src/app/cHazard/{prov}/cH_{prov}_uhs.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        uhsColumns = next(reader)
    uhsColumns = ','.join('"{0}"'.format(w) for w in uhsColumns)
    uhsColumns = uhsColumns.replace('~', '_')
    uhsColumns = uhsColumns.replace('"lon"', 'lon')
    uhsColumns = uhsColumns.replace('"lat"', 'lat')

    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_uhs({uhsColumns})
                    FROM /usr/src/app/cHazard/{prov}/cH_{prov}_uhs.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'uhsColumns': uhsColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # # Copy dmg mean b0 table
    # with open("/usr/src/app/cDamage/{prov}/cD_{prov}_dmg-mean_b0.csv".format(
    #         **{'prov': args.province}), "r") as f:
    #     reader = csv.reader(f)
    #     dmgColumns = next(reader)
    # dmgColumns = ','.join('"{0}"'.format(w) for w in dmgColumns)
    # dmgColumns = dmgColumns.replace('~', '_')
    # systemCall = """psql -h  ${{POSTGRES_HOST}}
    #             -U  ${{POSTGRES_USER}}
    #             -d ${{DB_NAME}}
    #             -a
    #             -c '\copy psra_{prov}.psra_{prov}_cd_dmg_mean_b0({dmgColumns})
    #                 FROM /usr/src/app/cDamage/{prov}/cD_{prov}_dmg-mean_b0.csv
    #                     WITH
    #                     CSV HEADER ;'""".format(**{
    #                         'prov': args.province,
    #                         'dmgColumns': dmgColumns})
    # systemCall = ' '.join(systemCall.split())
    # os.system(systemCall)

    # # Copy dmg mean r2 table
    # with open("/usr/src/app/cDamage/{prov}/cD_{prov}_dmg-mean_r2.csv".format(
    #         **{'prov': args.province}), "r") as f:
    #     reader = csv.reader(f)
    #     dmgColumns = next(reader)
    # dmgColumns = ','.join('"{0}"'.format(w) for w in dmgColumns)
    # dmgColumns = dmgColumns.replace('~', '_')
    # systemCall = """psql -h  ${{POSTGRES_HOST}}
    #             -U  ${{POSTGRES_USER}}
    #             -d ${{DB_NAME}}
    #             -a
    #             -c '\copy psra_{prov}.psra_{prov}_cd_dmg_mean_r2({dmgColumns})
    #                 FROM /usr/src/app/cDamage/{prov}/cD_{prov}_dmg-mean_r2.csv
    #                     WITH
    #                     CSV HEADER ;'""".format(**{
    #                         'prov': args.province,
    #                         'dmgColumns': dmgColumns})
    # systemCall = ' '.join(systemCall.split())
    # os.system(systemCall)

  # Copy ed dmg q05 b0 table
    with open("/usr/src/app/eDamage/{prov}/eD_{prov}_damages-q05_b0.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        dmgColumns = next(reader)
    dmgColumns = ','.join('"{0}"'.format(w) for w in dmgColumns)
    dmgColumns = dmgColumns.replace('~', '_')
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_ed_dmg_q05_b0({dmgColumns})
                    FROM /usr/src/app/eDamage/{prov}/eD_{prov}_damages-q05_b0.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'dmgColumns': dmgColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

      # Copy ed dmg q05 r1 table
    with open("/usr/src/app/eDamage/{prov}/eD_{prov}_damages-q05_r1.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        dmgColumns = next(reader)
    dmgColumns = ','.join('"{0}"'.format(w) for w in dmgColumns)
    dmgColumns = dmgColumns.replace('~', '_')
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_ed_dmg_q05_r1({dmgColumns})
                    FROM /usr/src/app/eDamage/{prov}/eD_{prov}_damages-q05_r1.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'dmgColumns': dmgColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

      # Copy ed dmg q95 b0 table
    with open("/usr/src/app/eDamage/{prov}/eD_{prov}_damages-q95_b0.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        dmgColumns = next(reader)
    dmgColumns = ','.join('"{0}"'.format(w) for w in dmgColumns)
    dmgColumns = dmgColumns.replace('~', '_')
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_ed_dmg_q95_b0({dmgColumns})
                    FROM /usr/src/app/eDamage/{prov}/eD_{prov}_damages-q95_b0.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'dmgColumns': dmgColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

      # Copy ed dmg q95 r1 table
    with open("/usr/src/app/eDamage/{prov}/eD_{prov}_damages-q95_r1.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        dmgColumns = next(reader)
    dmgColumns = ','.join('"{0}"'.format(w) for w in dmgColumns)
    dmgColumns = dmgColumns.replace('~', '_')
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_ed_dmg_q95_r1({dmgColumns})
                    FROM /usr/src/app/eDamage/{prov}/eD_{prov}_damages-q95_r1.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'dmgColumns': dmgColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy ed dmg mean b0 table
    with open("/usr/src/app/eDamage/{prov}/eD_{prov}_damages-mean_b0.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        dmgColumns = next(reader)
    dmgColumns = ','.join('"{0}"'.format(w) for w in dmgColumns)
    dmgColumns = dmgColumns.replace('~', '_')
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_ed_dmg_mean_b0({dmgColumns})
                    FROM /usr/src/app/eDamage/{prov}/eD_{prov}_damages-mean_b0.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'dmgColumns': dmgColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy ed dmg mean r1 table
    with open("/usr/src/app/eDamage/{prov}/eD_{prov}_damages-mean_r1.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        dmgColumns = next(reader)
    dmgColumns = ','.join('"{0}"'.format(w) for w in dmgColumns)
    dmgColumns = dmgColumns.replace('~', '_')
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_ed_dmg_mean_r1({dmgColumns})
                    FROM /usr/src/app/eDamage/{prov}/eD_{prov}_damages-mean_r1.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'dmgColumns': dmgColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg curves stats b0 table
    with open("/usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-stats_b0.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_agg_curves_stats_b0({aggColumns})
                    FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-stats_b0.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg curves stats r1 table
    with open("/usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-stats_r1.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_agg_curves_stats_r1({aggColumns})
                    FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-stats_r1.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg curves q05 b0 table
    with open("/usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-q05_b0.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_agg_curves_q05_b0({aggColumns})
                        FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-q05_b0.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'prov': args.province,
                                'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg curves q05 r1 table
    with open("/usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-q05_r1.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_agg_curves_q05_r1({aggColumns})
                        FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-q05_r1.csv
                            WITH
                            CSV HEADER ;'""".format(**{'prov': args.province,
                                                       'aggColumns':aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg curves q95 b0 table
    with open("/usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-q95_b0.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_agg_curves_q95_b0({aggColumns})
                        FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-q95_b0.csv
                            WITH
                            CSV HEADER ;'""".format(**{'prov': args.province,
                                                       'aggColumns':aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg curves q95 r1 table
    with open("/usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-q95_r1.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_agg_curves_q95_r1({aggColumns})
                        FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-q95_r1.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'prov': args.province,
                                'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg losses q05 b0 table
    with open("/usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_losses-q05_b0.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_agg_losses_q05_b0({aggColumns})
                        FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_losses-q05_b0.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'prov': args.province,
                                'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg losses q05 r1 table
    with open("/usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_losses-q05_r1.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_agg_losses_q05_r1({aggColumns})
                        FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_losses-q05_r1.csv
                            WITH
                            CSV HEADER ;'""".format(**{'prov': args.province,
                                                       'aggColumns':aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg losses q95 b0 table
    with open("/usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_losses-q95_b0.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_agg_losses_q95_b0({aggColumns})
                        FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_losses-q95_b0.csv
                            WITH
                            CSV HEADER ;'""".format(**{'prov': args.province,
                                                       'aggColumns':aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg losses q95 r1 table
    with open("/usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_losses-q95_r1.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_agg_losses_q95_r1({aggColumns})
                        FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_losses-q95_r1.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'prov': args.province,
                                'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg losses stats b0 table
    with open("/usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_losses-stats_b0.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_agg_losses_stats_b0({aggColumns})
                        FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_losses-stats_b0.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'prov': args.province,
                                'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy agg losses stats r1 table
    with open("/usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_losses-stats_r1.csv".format(**{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        aggColumns = next(reader)
    aggColumns = ','.join('"{0}"'.format(w) for w in aggColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_agg_losses_stats_r1({aggColumns})
                        FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_losses-stats_r1.csv
                            WITH
                            CSV HEADER ;'""".format(**{
                                'prov': args.province,
                                'aggColumns': aggColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy avg losses b0 table
    with open("/usr/src/app/ebRisk/{prov}/ebR_{prov}_avg_losses-stats_b0.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        lossColumns = next(reader)
    lossColumns = ','.join('"{0}"'.format(w) for w in lossColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_avg_losses_stats_b0({lossColumns})
                    FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_avg_losses-stats_b0.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'lossColumns': lossColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy avg losses r1 table
    with open("/usr/src/app/ebRisk/{prov}/ebR_{prov}_avg_losses-stats_r1.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        lossColumns = next(reader)
    lossColumns = ','.join('"{0}"'.format(w) for w in lossColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_avg_losses_stats_r1({lossColumns})
                    FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_avg_losses-stats_r1.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'lossColumns': lossColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy source loss b0 table
    with open("/usr/src/app/ebRisk/{prov}/ebR_{prov}_src_loss_table_b0.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        lossColumns = next(reader)
    lossColumns = ','.join('"{0}"'.format(w) for w in lossColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_src_loss_b0({lossColumns})
                    FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_src_loss_table_b0.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'lossColumns': lossColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy source loss r1 table
    with open("/usr/src/app/ebRisk/{prov}/ebR_{prov}_src_loss_table_r1.csv".format(
            **{'prov': args.province}), "r") as f:
        reader = csv.reader(f)
        lossColumns = next(reader)
    lossColumns = ','.join('"{0}"'.format(w) for w in lossColumns)
    systemCall = """psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy psra_{prov}.psra_{prov}_src_loss_r1({lossColumns})
                    FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_src_loss_table_r1.csv
                        WITH
                        CSV HEADER ;'""".format(**{
                            'prov': args.province,
                            'lossColumns': lossColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy sourceTypes.csv into LUT schema
    with open("/usr/src/app/sourceTypes.csv") as f:
        reader = csv.reader(f)
        columns = next(reader)
    columns = ','.join('"{0}"'.format(w) for w in columns)
    columns = columns.lower()
    systemCall = """psql -h ${{POSTGRES_HOST}}
                -U ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a
                -c '\copy  lut.psra_source_types ({columns})
                        FROM /usr/src/app/sourceTypes.csv
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
    for PSRA datasets Can be run from the command line with out arguments like:
    Run this script with a command like:
    python3 PSRA_copyTables.py''')
    parser.add_argument("--province", type=str, help="Two letter province/territory identifier")
    args = parser.parse_args()

    return args

if __name__ == '__main__':
    main()