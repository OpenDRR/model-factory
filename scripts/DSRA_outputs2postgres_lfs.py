#!/usr/bin/env python
import sqlalchemy as db
import pandas as pd
from io import StringIO
from functools import reduce
import csv
import os
import sys
import argparse
import configparser
import requests
import json
import logging

'''
Script to ingest OpenQuake outputs in csv format from GitHub to
single PostGreSQL database. The Script can be run in the following form by
changing the filepaths as appropriate
python3 DSRA_outputs2postgres_lfs.py
    --dsraRepo="OpenDRR/openquake-models"
    --columnsINI="DSRA_outputs2postgres.ini"
'''


def main():
    args = parse_args()
    if args.logging is True:
        logging.basicConfig(level=logging.INFO,
                            format='%(asctime)s - %(levelname)s - %(message)s',
                            handlers=[logging.FileHandler(f'/tmp/{os.path.splitext(sys.argv[0])[0]}.log'),
                                      logging.StreamHandler()])
    if args.logging is False:
        logging.disable(sys.maxsize)
    columnConfigParser = get_config_params(args.columnsINI)

    os.chdir(sys.path[0])
    auth = get_config_params('config.ini')
    listRetrofit = list(filter(None,
                        (x.strip() for x in columnConfigParser.get('Retrofit',
                                                                   'listRetrofit').splitlines())))
    listRetrofitPrefix = list(filter(None,
                              (x.strip() for x in columnConfigParser.get('Retrofit',
                                                                         'listRetrofitPrefix').splitlines())))
    if args.eqScenario == "All":
        listeqScenario = list(filter(None, (x.strip() for x in columnConfigParser.get('Scenario','listScenario').splitlines())))
    else:
        listeqScenario = [args.eqScenario]
    engine = db.create_engine('postgresql://{}:{}@{}'.format(auth.get('rds','postgres_un'),
                                                             auth.get('rds', 'postgres_pw'),
                                                             auth.get('rds', 'postgres_address')),
                              echo=True)

    # url = args.dsraRepo.replace('https://github.com', 'https://api.github.com/repos').replace('tree/master', 'contents')
    url = f'https://api.github.com/repos/{args.dsraRepo}/contents/FINISHED'
    dsraRepo = args.dsraRepo
    branch = args.dsraRepoBranch
    try:
        response = requests.get('{}?ref={}'.format(url, branch),
                                headers={'Authorization': 'token {}'.format(auth.get('auth',
                                                                                     'github_token'))})
        response.raise_for_status()
        repo_dict = json.loads(response.content)
        repo_list = []

        for item in repo_dict:
            if item['type'] == 'file':
                repo_list.append(item['name'])

    except requests.exceptions.RequestException as e:
        logging.error(e)
        sys.exit()

    for eqscenario in listeqScenario:

        dfsr = {}
        for retrofit, retrofitPrefix in zip(listRetrofit, listRetrofitPrefix):
            # retrofit Realization dataframe
            dfsr[retrofit] = GetDataframeForScenario(url,
                                                     dsraRepo,
                                                     branch,
                                                     repo_list,
                                                     retrofitPrefix,
                                                     eqscenario,
                                                     columnConfigParser,
                                                     auth,
                                                     args)
            # Process conditional fields for retrofit realization dataframe

        # Merge retrofit dataframes for a realization
        dfs = []
        for i in listRetrofit:
            dfs.append(dfsr[i])
        dffinal = reduce(pd.merge, dfs)

        # add in ordered output code
        dffinalout = dffinal

        # Output assembled dataframe to database
        dffinalout.to_sql("dsra_{}".format(eqscenario.lower()),
                          engine,
                          if_exists='replace',
                          method=psql_insert_copy,
                          schema='dsra')

    return


def GetDataframeForScenario(url,
                            dsraRepo,
                            branch,
                            repo_list,
                            retrofitPrefix,
                            eqscenario,
                            columnConfigParser,
                            auth,
                            args):
    # Get file names. If more than one match grab higher increment value
    consequenceFile = [s for s in repo_list if "s_consequences_{}_{}".format(eqscenario, retrofitPrefix) in s][-1]
    damageFile = [s for s in repo_list if "s_dmgbyasset_{}_{}".format(eqscenario, retrofitPrefix) in s][-1]
    lossesFile = [s for s in repo_list if "s_lossesbyasset_{}_{}".format(eqscenario, retrofitPrefix) in s][-1]

    # Create dataframes
    # Consequence DataFrame
    item_url = "{}/{}?ref={}".format(url, consequenceFile, branch)
    response = requests.get(item_url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
    item_dict = json.loads(response.content)
    response = requests.get(item_dict['download_url'],
                            headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
    consequenceFieldNames = list(filter(None, [x.strip().split(",") for x in columnConfigParser.get('Consequences', 'consequenceFieldNames').splitlines()]))
    consequenceInputFieldNames, consequenceOutputFieldNames = zip(*consequenceFieldNames)
    dfConsequence = pd.read_csv(StringIO(response.content.decode(response.encoding)),
                                sep=',',
                                index_col=False,
                                usecols=consequenceInputFieldNames,
                                low_memory=False,
                                thousands=',')
    for oldcol, newcol in zip(consequenceInputFieldNames,
                              consequenceOutputFieldNames):
        dfConsequence.rename(columns={oldcol: newcol},
                             inplace=True) 
    # print(dfConsequence.columns)
    # dfConsequence.insert(loc=2, column='BldgCostT', value=dfConsequence['value_structural'] + dfConsequence['value_nonstructural'] + dfConsequence['value_contents'])
    # dfConsequence.drop(columns=['value_structural','value_nonstructural','value_contents'], inplace=True)
    dfConsequence = dfConsequence.add_suffix("_{}".format(retrofitPrefix))
    dfConsequence.rename(columns={"AssetID_{}".format(retrofitPrefix):"AssetID"}, inplace=True)

    # Damage dataframe,
    item_url = "{}/{}?ref={}".format(url, damageFile, branch)
    response = requests.get(item_url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
    item_dict = json.loads(response.content)
    response = requests.get(item_dict['download_url'], headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
    damageFieldNames = list(filter(None, [x.strip().split(",") for x in columnConfigParser.get('Damage', 'damageFieldNames').splitlines()]))
    damageInputFieldNames, damageOutputFieldNames = zip(*damageFieldNames)
    dfDamage = pd.read_csv(StringIO(response.content.decode(response.encoding)),
                           sep=',',
                           index_col=False,
                           usecols=damageInputFieldNames,
                           low_memory=False,
                           thousands=',')
    for oldcol, newcol in zip(damageInputFieldNames, damageOutputFieldNames):
        dfDamage.rename(columns={oldcol: newcol},
                        inplace=True)
    # dfDamage.insert(loc=4, column='sauid_t', value=dfDamage['sauid_i'])
    dfDamage = dfDamage.add_suffix("_{}".format(retrofitPrefix))
    dfDamage.rename(columns={"AssetID_{}".format(retrofitPrefix): "AssetID"},
                    inplace=True)

    # Losses Dataframe
    item_url = "{}/{}?ref={}".format(url, lossesFile, branch)
    response = requests.get(item_url,
                            headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
    item_dict = json.loads(response.content)
    response = requests.get(item_dict['download_url'],
                            headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
    lossesFieldNames = list(filter(None, [x.strip().split(",") for x in columnConfigParser.get('Losses', 'lossesFieldNames').splitlines()]))
    lossesInputFieldNames, lossesOutputFieldNames = zip(*lossesFieldNames)
    dfLosses = pd.read_csv(StringIO(response.content.decode(response.encoding)),
                           sep=',',
                           index_col=False,
                           usecols=lossesInputFieldNames,
                           low_memory=False,
                           thousands=',')
    for oldcol, newcol in zip(lossesInputFieldNames, lossesOutputFieldNames):
        dfLosses.rename(columns={oldcol: newcol},inplace=True)
    dfLosses = dfLosses.add_suffix("_{}".format(retrofitPrefix))
    dfLosses.rename(columns={"AssetID_{}".format(retrofitPrefix): "AssetID"},
                    inplace=True)

    # eq_url = args.dsraRepo.replace('https://github.com', 'https://raw.githubusercontent.com').replace('contents/FINISHED', '{}/initializations/s_Hazard_{}.ini'.format(branch, eqscenario))
    eq_url = f'https://raw.githubusercontent.com/{dsraRepo}/{branch}/initializations/s_Hazard_{eqscenario}.ini'

    response = requests.get(eq_url,
                            headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))}).text
    segment = response[response.index('gsim_logic_tree_file'):]
    gmpe_model_value = segment[segment.index('LogicTree/') + 10:segment.index('.xml')]

    # Merge dataframes
    dfMerge = reduce(lambda left,
                     right: pd.merge(left, right, on='AssetID'),
                     [dfDamage, dfConsequence, dfLosses])
    dfMerge.insert(loc=0,
                   column='Rupture_Abbr',
                   value=eqscenario)
    dfMerge.insert(loc=1,
                   column='gmpe_Model',
                   value=gmpe_model_value)
    return dfMerge


def psql_insert_copy(table, conn, keys, data_iter):
    # This fuction was copied from the Pandas documentation
    # gets a DBAPI connection that can provide a cursor
    dbapi_conn = conn.connection
    with dbapi_conn.cursor() as cur:
        s_buf = StringIO()
        writer = csv.writer(s_buf)
        writer.writerows(data_iter)
        s_buf.seek(0)
        columns = ', '.join('"{}"'.format(k) for k in keys)
        if table.schema:
            table_name = '{}.{}'.format(table.schema, table.name)
        else:
            table_name = table.name
        sql = 'COPY {} ({}) FROM STDIN WITH CSV'.format(
            table_name, columns)
        cur.copy_expert(sql=sql, file=s_buf)


def get_config_params(args):
    """
    Parse Input/Output columns from supplied *.ini file
    """
    configParseObj = configparser.ConfigParser()
    configParseObj.read(args)
    return configParseObj


def str2bool(v):
    if isinstance(v, bool):
        return v
    if v.lower() in ('yes', 'true', 't', 'y', '1'):
        return True
    elif v.lower() in ('no', 'false', 'f', 'n', '0'):
        return False
    else:
        raise argparse.ArgumentTypeError('Boolean value expected.')


def parse_args():
    parser = argparse.ArgumentParser(description='''Pull DSRA Output data from
                                                 Github repository and copy
                                                 into PostGreSQL''')
    parser.add_argument('--dsraRepo',
                        type=str,
                        help='Path to DSRA Model repo',
                        required=True)
    parser.add_argument('--dsraRepoBranch',
                        type=str,
                        help='Name of the DSRA repo branch',
                        required=True)
    parser.add_argument('--columnsINI',
                        type=str,
                        help='DSRA_outputs2postgres.ini',
                        required=True,
                        default='DSRA_outputs2postgres.ini')
    parser.add_argument('--logging',
                        type=str2bool,
                        help='''True/False - Logging Enabled by Default.
                             Set to False to disble logging''',
                        default=True)
    parser.add_argument('--eqScenario',
                        type=str,
                        help='''Specify Earthquake Scenario.
                             Use "All" for all scenarios in
                             DSRA_outputs2postgres.ini''',
                        default="All")
    args = parser.parse_args()

    return args


if __name__ == '__main__':
    main()
