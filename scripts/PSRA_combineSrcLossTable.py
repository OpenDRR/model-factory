#!/usr/bin/env python
import sqlalchemy as db
import sqlalchemy.orm as orm
import pandas as pd
import numpy as np
from io import StringIO
import csv
import glob 
import os
import sys
import argparse
import configparser
import requests
import json
import logging

'''
python 
'''

def main():
    args = parse_args()
    os.chdir(args.srcLossDir)
    erFileList = glob.glob('*src_loss_table_*.csv')
dfFinal = pd.read_csv(erFileList[0], usecols = ['source', 'loss_type', 'trt'])
aggregateLossList=[]

for erFile in erFileList:
    dfTemp = pd.read_csv(erFile)
    er = erFile.split('_')[1]
    retrofit = erFile.split('_')[-1].split('.')[0]
    dfTemp = dfTemp.rename(columns={"loss_value": "loss_value_{er}_{retrofit}".format(**{'er':er,
                                                                                            'retrofit':retrofit})})
    aggregateLossList.append("loss_value_{er}_{retrofit}".format(**{'er':er,
                                                                    'retrofit':retrofit}))
    dfFinal = pd.merge(dfFinal,
                        dfTemp,
                        how='left',
                        left_on=['source', 'loss_type', 'trt'],
                        right_on=['source', 'loss_type', 'trt'])

dfFinal['loss_value'] = dfFinal[aggregateLossList].sum(axis=1)
dfFinal.to_csv('test.csv', index_col=False)
    return






def get_config_params(args):
    """
    Parse Input/Output columns from supplied *.ini file
    """
    configParseObj = configparser.ConfigParser()
    configParseObj.read(args)
    return configParseObj

def parse_args():
    parser = argparse.ArgumentParser(description='Combine Source Loss Tables across Economic Regions')
    parser.add_argument('--srcLossDir', type=str, help='', required=True)
    args = parser.parse_args()
    
    return args

if __name__ == '__main__':
    main() 