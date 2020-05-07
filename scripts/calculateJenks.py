#!/usr/bin/env python
#Import statements
import os
import sys
import argparse
import configparser
import jenkspy
import pandas as pd
import logging
import json

from elasticsearch import Elasticsearch
from elasticsearch_dsl import Search


'''
Script to calculate natural breaks (jenks) from DSRA Views
Can be run from the command line with mandatory arguments 
Run this script with a command like:
python3 calculateJenks.py --eqScenario="sim6p8_cr2022_rlz_1" --retrofitPrefix="r1" --dbview=social_disruption_agg_view --field=sC_DBiz_30 --bins=5
Can also be imported for use in other scripts like:
from calculateJenks import calculateJenks
'''

#Main Function
def main ():
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(levelname)s - %(message)s', 
                        handlers=[logging.FileHandler('{}.log'.format(os.path.splitext(sys.argv[0])[0])),
                                  logging.StreamHandler()])
    auth = get_config_params('config.ini')
    args = parse_args()
    view = "dsra_{eq_scenario}_{retrofit_prefix}_{dbview}".format(**{'eq_scenario':args.eqScenario, 'retrofit_prefix':args.retrofitPrefix, 'dbview':args.dbview})
    es = Elasticsearch([auth.get('es', 'es_endpoint')], http_auth=(auth.get('es', 'es_un'), auth.get('es', 'es_pw')))
    try:
        jenks = calculateJenks(auth, args, es)
    
    except Exception as error :
        logging.error(error)

    jenksJson = buildJson(args, jenks)

    settings = {
        'settings': {
            'number_of_shards': 1,
            'number_of_replicas': 0
        },
        'mappings': {
            'properties': {

            }
        }
    }

    if not es.indices.exists("dsra_break_values"):
        es.indices.create(index="dsra_break_values", body=settings, request_timeout=90)

    res = es.index(index="dsra_break_values", id=view+'_'+args.field, body=jenksJson)
    
    #return print(jenks)
    
#Support Functions
def get_config_params(args):
    """
    Parse Input/Output columns from supplied *.ini file
    """
    configParseObj = configparser.ConfigParser()
    configParseObj.read(args)
    return configParseObj

def calculateJenks(auth, args, es):
    #Build the view string from arguments
    view = "dsra_{eq_scenario}_{retrofit_prefix}_{dbview}".format(**{'eq_scenario':args.eqScenario, 'retrofit_prefix':args.retrofitPrefix, 'dbview':args.dbview})
    response = Search(using=es, index=view)
    #Create a dataframe containing the full series of values from the specified view and field
    df = pd.DataFrame([getattr(hit.properties, args.field) for hit in response.scan()], columns=[args.field])
    #Use Jenskpy to create natural breaks
    breaks = jenkspy.jenks_breaks(df[args.field], nb_class=args.bins)
    
    return breaks

def buildJson(args, jenks):
    data = {}
    data['eqScenario'] = args.eqScenario
    data['retrofitPrefix'] = args.retrofitPrefix
    data['dbview'] = args.dbview
    data['field'] = args.field
    i = 0
    for breakvalue in jenks:
        data['break_value_'+str(i)] = breakvalue
        i+=1
    return json.dumps(data)                                               
            
def parse_args():
    parser = argparse.ArgumentParser(description="Calculate Natural Breaks using the Fisher-Jenks Algorithm")
    parser.add_argument("--eqScenario", type=str, help="Earthquake scenario id")
    parser.add_argument("--retrofitPrefix", type=str, help="Retrofit Prefix. Allowable values: (b0, r1, r2)")
    parser.add_argument("--dbview", type=str, help=" Thematic Database View. Allowable values: (affectedpeople, all, buildingperformance, ci, economicsecurity mortality)")
    parser.add_argument("--field", type=str, help="Field to calculate natural breaks over")
    parser.add_argument("--bins", type=int, help="number of natural break classes (i.e. 5)")
    args = parser.parse_args()
    
    return args

if __name__ == '__main__':
    main() 
