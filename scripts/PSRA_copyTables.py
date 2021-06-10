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

#Main Function
def main ():
    logging.basicConfig(level=logging.INFO,
                format='%(asctime)s - %(levelname)s - %(message)s',
                handlers=[logging.FileHandler('/tmp/{}.log'.format(os.path.splitext(sys.argv[0])[0])),
                            logging.StreamHandler()])
    os.chdir(sys.path[0])
    auth = get_config_params('config.ini')
    args = parse_args()

    #Copy hcurve Table PGA
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_hcurves_pga(lon,
                                                                lat,
                                                                depth,
                                                                "poe_0.0500000",
                                                                "poe_0.0637137",
                                                                "poe_0.0811888",
                                                                "poe_0.1034569",
                                                                "poe_0.1318325",
                                                                "poe_0.1679909",
                                                                "poe_0.2140666",
                                                                "poe_0.2727797",
                                                                "poe_0.3475964",
                                                                "poe_0.4429334",
                                                                "poe_0.5644189",
                                                                "poe_0.7192249",
                                                                "poe_0.9164904",
                                                                "poe_1.1678607",
                                                                "poe_1.4881757",
                                                                "poe_1.8963451",
                                                                "poe_2.4164651",
                                                                "poe_3.0792411",
                                                                "poe_3.9237999",
                                                                "poe_5.0000000")
                    FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_PGA.csv
                        WITH 
                        CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)
    
    #Copy hcurve table Sa0p1
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_hcurves_Sa0p1(lon,
                                                                lat,
                                                                depth,
                                                                "poe_0.0500000",
                                                                "poe_0.0637137",
                                                                "poe_0.0811888",
                                                                "poe_0.1034569",
                                                                "poe_0.1318325",
                                                                "poe_0.1679909",
                                                                "poe_0.2140666",
                                                                "poe_0.2727797",
                                                                "poe_0.3475964",
                                                                "poe_0.4429334",
                                                                "poe_0.5644189",
                                                                "poe_0.7192249",
                                                                "poe_0.9164904",
                                                                "poe_1.1678607",
                                                                "poe_1.4881757",
                                                                "poe_1.8963451",
                                                                "poe_2.4164651",
                                                                "poe_3.0792411",
                                                                "poe_3.9237999",
                                                                "poe_5.0000000" )
                    FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p1.csv
                        WITH 
                        CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy hcurve table Sa0p2
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_hcurves_sa0p2(lon,
                                                                lat,
                                                                depth,
                                                                "poe_0.0500000" ,
                                                                "poe_0.0637137" ,
                                                                "poe_0.0811888" ,
                                                                "poe_0.1034569" ,
                                                                "poe_0.1318325" ,
                                                                "poe_0.1679909" ,
                                                                "poe_0.2140666" ,
                                                                "poe_0.2727797" ,
                                                                "poe_0.3475964" ,
                                                                "poe_0.4429334" ,
                                                                "poe_0.5644189" ,
                                                                "poe_0.7192249" ,
                                                                "poe_0.9164904",
                                                                "poe_1.1678607" ,
                                                                "poe_1.4881757" ,
                                                                "poe_1.8963451" ,
                                                                "poe_2.4164651" ,
                                                                "poe_3.0792411" ,
                                                                "poe_3.9237999" ,
                                                                "poe_5.0000000" )
                    FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p2.csv
                        WITH 
                        CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy hcurve table Sa0p3
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_hcurves_sa0p3(lon,
                                                                lat,
                                                                depth,
                                                                "poe_0.0500000" ,
                                                                "poe_0.0637137" ,
                                                                "poe_0.0811888" ,
                                                                "poe_0.1034569" ,
                                                                "poe_0.1318325" ,
                                                                "poe_0.1679909" ,
                                                                "poe_0.2140666" ,
                                                                "poe_0.2727797" ,
                                                                "poe_0.3475964" ,
                                                                "poe_0.4429334" ,
                                                                "poe_0.5644189" ,
                                                                "poe_0.7192249" ,
                                                                "poe_0.9164904",
                                                                "poe_1.1678607" ,
                                                                "poe_1.4881757" ,
                                                                "poe_1.8963451" ,
                                                                "poe_2.4164651" ,
                                                                "poe_3.0792411" ,
                                                                "poe_3.9237999" ,
                                                                "poe_5.0000000" )
                    FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p3.csv
                        WITH 
                        CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy hcurve table Sa0p5
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_hcurves_sa0p5(lon,
                                                                lat,
                                                                depth,
                                                                "poe_0.0500000",
                                                                "poe_0.0658662",
                                                                "poe_0.0867671",
                                                                "poe_0.1143003",
                                                                "poe_0.1505706",
                                                                "poe_0.1983502",
                                                                "poe_0.2612914",
                                                                "poe_0.3442054",
                                                                "poe_0.4534299",
                                                                "poe_0.5973140",
                                                                "poe_0.7868559",
                                                                "poe_1.0365439",
                                                                "poe_1.3654639",
                                                                "poe_1.7987580",
                                                                "poe_2.3695466",
                                                                "poe_3.1214600",
                                                                "poe_4.1119734",
                                                                "poe_5.4168002",
                                                                "poe_7.1356795",
                                                                "poe_9.4000000" )
                        FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p5.csv
                            WITH 
                            CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)
    
    #Copy hcurve table Sa0p6
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_hcurves_sa0p6(lon,
                                                                lat,
                                                                depth,
                                                                "poe_0.0500000",
                                                                "poe_0.0658662",
                                                                "poe_0.0867671",
                                                                "poe_0.1143003",
                                                                "poe_0.1505706",
                                                                "poe_0.1983502",
                                                                "poe_0.2612914",
                                                                "poe_0.3442054",
                                                                "poe_0.4534299",
                                                                "poe_0.5973140",
                                                                "poe_0.7868559",
                                                                "poe_1.0365439",
                                                                "poe_1.3654639",
                                                                "poe_1.7987580",
                                                                "poe_2.3695466",
                                                                "poe_3.1214600",
                                                                "poe_4.1119734",
                                                                "poe_5.4168002",
                                                                "poe_7.1356795",
                                                                "poe_9.4000000" )
                        FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p6.csv
                            WITH 
                            CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)
    
    #Copy hcurve table Sa1p0
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_hcurves_sa1p0(lon,
                                                                lat,
                                                                depth,
                                                                "poe_0.0500000" ,
                                                                "poe_0.0637137" ,
                                                                "poe_0.0811888" ,
                                                                "poe_0.1034569" ,
                                                                "poe_0.1318325" ,
                                                                "poe_0.1679909" ,
                                                                "poe_0.2140666" ,
                                                                "poe_0.2727797" ,
                                                                "poe_0.3475964" ,
                                                                "poe_0.4429334" ,
                                                                "poe_0.5644189" ,
                                                                "poe_0.7192249" ,
                                                                "poe_0.9164904",
                                                                "poe_1.1678607" ,
                                                                "poe_1.4881757" ,
                                                                "poe_1.8963451" ,
                                                                "poe_2.4164651" ,
                                                                "poe_3.0792411" ,
                                                                "poe_3.9237999" ,
                                                                "poe_5.0000000" )
                        FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa1p0.csv
                            WITH 
                            CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)
    
    #Copy hcurve table Sa2p0
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_hcurves_sa2p0(lon,
                                                                lat,
                                                                depth,
                                                                "poe_0.0500000" ,
                                                                "poe_0.0637137" ,
                                                                "poe_0.0811888" ,
                                                                "poe_0.1034569" ,
                                                                "poe_0.1318325" ,
                                                                "poe_0.1679909" ,
                                                                "poe_0.2140666" ,
                                                                "poe_0.2727797" ,
                                                                "poe_0.3475964" ,
                                                                "poe_0.4429334" ,
                                                                "poe_0.5644189" ,
                                                                "poe_0.7192249" ,
                                                                "poe_0.9164904",
                                                                "poe_1.1678607" ,
                                                                "poe_1.4881757" ,
                                                                "poe_1.8963451" ,
                                                                "poe_2.4164651" ,
                                                                "poe_3.0792411" ,
                                                                "poe_3.9237999" ,
                                                                "poe_5.0000000" )
                        FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa2p0.csv
                            WITH 
                            CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)
    
    #Copy hmaps table
    with open("/usr/src/app/cHazard/{prov}/cH_{prov}_hmaps.csv".format(**{'prov':args.province}), "r") as f:
        reader = csv.reader(f)
        hmapColumns = next(reader)
    hmapColumns = ','.join('"{0}"'.format(w) for w in hmapColumns)
    hmapColumns = hmapColumns.replace('-','_')
    hmapColumns = hmapColumns.replace('"lon"','lon')
    hmapColumns = hmapColumns.replace('"lat"','lat')

    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_hmaps({hmapColumns})
                        FROM /usr/src/app/cHazard/{prov}/cH_{prov}_hmaps.csv
                            WITH 
                            CSV HEADER ;'""".format(**{'prov':args.province, 'hmapColumns':hmapColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy hmaps_xref table
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_hmaps_xref(id,
                                                             sauid,
                                                             asset_lon,
                                                             asset_lat,
                                                             lon,
                                                             lat,
                                                             distance,
                                                             "PGA_0.02",
                                                             "PGA_0.1",
                                                             "SA(0.1)_0.02",
                                                             "SA(0.1)_0.1",
                                                             "SA(0.2)_0.02",
                                                             "SA(0.2)_0.1",
                                                             "SA(0.3)_0.02",
                                                             "SA(0.3)_0.1",
                                                             "SA(0.5)_0.02",
                                                             "SA(0.5)_0.1",
                                                             "SA(0.6)_0.02",
                                                             "SA(0.6)_0.1",
                                                             "SA(1.0)_0.02",
                                                             "SA(1.0)_0.1",
                                                             "SA(10.0)_0.02",
                                                             "SA(10.0)_0.1",
                                                             "SA(2.0)_0.02",
                                                             "SA(2.0)_0.1",
                                                             "SA(5.0)_0.02",
                                                             "SA(5.0)_0.1")
                        FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hmaps_xref.csv'
                            WITH 
                            CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy uhs table
    with open("/usr/src/app/cHazard/{prov}/cH_{prov}_uhs.csv".format(**{'prov':args.province}), "r") as f:
        reader = csv.reader(f)
        uhsColumns = next(reader)
    uhsColumns = ','.join('"{0}"'.format(w) for w in uhsColumns)
    uhsColumns = uhsColumns.replace('~','_')
    uhsColumns = uhsColumns.replace('"lon"','lon')
    uhsColumns = uhsColumns.replace('"lat"','lat')

    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_uhs({uhsColumns})
                        FROM /usr/src/app/cHazard/{prov}/cH_{prov}_uhs.csv
                            WITH 
                            CSV HEADER ;'""".format(**{'prov':args.province, 'uhsColumns':uhsColumns})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy dmg mean b0 table
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_cd_dmg_mean_b0(asset_id,
                                                                    "BldEpoch",
                                                                    "BldgType",
                                                                    "EqDesLev",
                                                                    "GenOcc",
                                                                    "GenType",
                                                                    "LandUse",
                                                                    "OccClass",
                                                                    "SAC",
                                                                    "SSC_Zone",
                                                                    "SauidID",
                                                                    adauid,
                                                                    cdname,
                                                                    cduid,
                                                                    csdname,
                                                                    csduid,
                                                                    dauid,
                                                                    ername,
                                                                    eruid,
                                                                    fsauid,
                                                                    prname,
                                                                    pruid,
                                                                    sauid,
                                                                    taxonomy,
                                                                    lon,
                                                                    lat,
                                                                    structural_no_damage,
                                                                    structural_slight,
                                                                    structural_moderate,
                                                                    structural_extensive,
                                                                    structural_complete)
                        FROM /usr/src/app/cDamage/{prov}/cD_{prov}_dmg-mean_b0.csv
                            WITH 
                            CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy dmg mean r2 table
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_cd_dmg_mean_r2(asset_id,
                                                                    "BldEpoch",
                                                                    "BldgType",
                                                                    "EqDesLev",
                                                                    "GenOcc",
                                                                    "GenType",
                                                                    "LandUse",
                                                                    "OccClass",
                                                                    "SAC",
                                                                    "SSC_Zone",
                                                                    "SauidID",
                                                                    adauid,
                                                                    cdname,
                                                                    cduid,
                                                                    csdname,
                                                                    csduid,
                                                                    dauid,
                                                                    ername,
                                                                    eruid,
                                                                    fsauid,
                                                                    prname,
                                                                    pruid,
                                                                    sauid,
                                                                    taxonomy,
                                                                    lon,
                                                                    lat,
                                                                    structural_no_damage,
                                                                    structural_slight,
                                                                    structural_moderate,
                                                                    structural_extensive,
                                                                    structural_complete)
                        FROM /usr/src/app/cDamage/{prov}/cD_{prov}_dmg-mean_r2.csv
                            WITH 
                            CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy ed dmg mean b0 table 
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_ed_dmg_mean_b0(asset_id,
                                                                    "BldEpoch",
                                                                    "BldgType",
                                                                    "EqDesLev",
                                                                    "GenOcc",
                                                                    "GenType",
                                                                    "LandUse",
                                                                    "OccClass",
                                                                    "SAC",
                                                                    "SSC_Zone",
                                                                    "SauidID",
                                                                    adauid,
                                                                    cdname,
                                                                    cduid,
                                                                    csdname,
                                                                    csduid,
                                                                    dauid,
                                                                    ername,
                                                                    eruid,
                                                                    fsauid,
                                                                    prname,
                                                                    pruid,
                                                                    sauid,
                                                                    taxonomy,
                                                                    lon,
                                                                    lat,
                                                                    structural_no_damage,
                                                                    structural_slight,
                                                                    structural_moderate,
                                                                    structural_extensive,
                                                                    structural_complete)
                        FROM /usr/src/app/eDamage/{prov}/eD_{prov}_damages-mean_b0.csv
                            WITH 
                            CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy ed dmg mean r2 table
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_ed_dmg_mean_r2(asset_id,
                                                                    "BldEpoch",
                                                                    "BldgType",
                                                                    "EqDesLev",
                                                                    "GenOcc",
                                                                    "GenType",
                                                                    "LandUse",
                                                                    "OccClass",
                                                                    "SAC",
                                                                    "SSC_Zone",
                                                                    "SauidID",
                                                                    adauid,
                                                                    cdname,
                                                                    cduid,
                                                                    csdname,
                                                                    csduid,
                                                                    dauid,
                                                                    ername,
                                                                    eruid,
                                                                    fsauid,
                                                                    prname,
                                                                    pruid,
                                                                    sauid,
                                                                    taxonomy,
                                                                    lon,
                                                                    lat,
                                                                    structural_no_damage,
                                                                    structural_slight,
                                                                    structural_moderate,
                                                                    structural_extensive,
                                                                    structural_complete)
                        FROM /usr/src/app/eDamage/{prov}/eD_{prov}_damages-mean_r2.csv
                            WITH 
                            CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy agg curves stats b0 table
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_agg_curves_stats_b0(return_period,
                                                                        stat,
                                                                        loss_type,
                                                                        fsauid,
                                                                        "GenOcc",
                                                                        "GenType",
                                                                        loss_value,
                                                                        loss_ratio,
                                                                        annual_frequency_of_exceedence)
                        FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-stats_b0.csv
                            WITH 
                            CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)
    
    #Copy agg curves stats r2 table
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_agg_curves_stats_r2(return_period,
                                                                        stat,
                                                                        loss_type,
                                                                        fsauid,
                                                                        "GenOcc",
                                                                        "GenType",
                                                                        loss_value,
                                                                        loss_ratio,
                                                                        annual_frequency_of_exceedence)
                        FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-stats_r2.csv
                            WITH 
                            CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)
    
    #Copy avg losses b0 table
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_avg_losses_stats_b0(asset_id,
                                                                        "BldEpoch",
                                                                        "BldgType",
                                                                        "EqDesLev",
                                                                        "GenOcc",
                                                                        "GenType",
                                                                        "LandUse",
                                                                        "OccClass",
                                                                        "SAC",
                                                                        "SSC_Zone",
                                                                        "SauidID",
                                                                        adauid,
                                                                        cdname,
                                                                        cduid,
                                                                        csdname,
                                                                        csduid,
                                                                        dauid,
                                                                        ername,
                                                                        eruid,
                                                                        fsauid,
                                                                        prname,
                                                                        pruid,
                                                                        sauid,
                                                                        taxonomy,
                                                                        lon,
                                                                        lat,
                                                                        contents,
                                                                        nonstructural,
                                                                        structural)
                        FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_avg_losses-stats_b0.csv
                            WITH 
                            CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)
    
    #Copy avg losses r2 table
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_avg_losses_stats_r2(asset_id,
                                                                        "BldEpoch",
                                                                        "BldgType",
                                                                        "EqDesLev",
                                                                        "GenOcc",
                                                                        "GenType",
                                                                        "LandUse",
                                                                        "OccClass",
                                                                        "SAC",
                                                                        "SSC_Zone",
                                                                        "SauidID",
                                                                        adauid,
                                                                        cdname,
                                                                        cduid,
                                                                        csdname,
                                                                        csduid,
                                                                        dauid,
                                                                        ername,
                                                                        eruid,
                                                                        fsauid,
                                                                        prname,
                                                                        pruid,
                                                                        sauid,
                                                                        taxonomy,
                                                                        lon,
                                                                        lat,
                                                                        contents,
                                                                        nonstructural,
                                                                        structural)
                        FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_avg_losses-stats_r2.csv
                            WITH 
                            CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)
    
    #Copy source loss b0 table
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_src_loss_b0(source,
                                                                loss_type,
                                                                loss_value,
                                                                trt,
                                                                region)
                        FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_src_loss_table_b0.csv
                            WITH 
                            CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)
    
    #Copy source loss r2 table
    systemCall="""psql -h  ${{POSTGRES_HOST}}
                -U  ${{POSTGRES_USER}}
                -d ${{DB_NAME}}
                -a 
                -c '\copy psra_{prov}.psra_{prov}_src_loss_r2(source,
                                                                loss_type,
                                                                loss_value,
                                                                trt,
                                                                region)
                        FROM /usr/src/app/ebRisk/{prov}/ebR_{prov}_src_loss_table_r2.csv
                            WITH 
                            CSV HEADER ;'""".format(**{'prov':args.province})
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

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
    parser = argparse.ArgumentParser(description='''Script to run \\copy statements 
    for PSRA datasets Can be run from the command line with out arguments like:
    Run this script with a command like:
    python3 PSRA_copyTables.py''')
    parser.add_argument("--province", type=str, help="Two letter province/territory identifier")
    args = parser.parse_args()

    return args

if __name__ == '__main__':
    main()