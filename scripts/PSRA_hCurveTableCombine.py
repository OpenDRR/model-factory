#!/usr/bin/env python

import pandas as pd
import numpy as np
import csv
import glob 
import os
import re
import sys
import argparse
import configparser
import logging

'''

'''

def main():
    args = parse_args()
    os.chdir(args.hCurveDir)

    subPT= glob.glob('*hcurves_PGA.csv')
    subPT = [elem.split('_')[1] for elem in subPT]

    hCurveFileList = glob.glob('*{}*'.format(subPT[0]))
    hCurveFileList = [filename.replace(subPT[0], '{}') for filename in hCurveFileList]

    for fileName in hCurveFileList:    
        print(subPT[0])
        print(fileName.format(subPT[0]))
        with open(fileName.format(subPT[0]), newline='') as f:
            reader = csv.reader(f)
            columns = next(reader)
    
        dfFinal = pd.DataFrame(columns=columns)

        for provTerritory in subPT:
            dfTemp = pd.read_csv(fileName.format(provTerritory))
            dfFinal = dfFinal.append(dfTemp)
        outFileName = fileName.format(subPT[0][0:2])

        if not os.path.isfile(outFileName): 
            #Check if the file already exists, it should for 
            #Provs/Territories that were process with a single 
            #Economic region
            dfFinal.to_csv(outFileName, index=False)
        else: # else it exists, do nothing
            print('File ({}) already exists renaming original file'.format(outFileName))
            os.rename(outFileName, '{}_orginal.csv'.format(os.path.splitext(outFileName)[0]))
            dfFinal.to_csv(outFileName, index=False)
    return

def get_config_params(args):
    """
    Parse Input/Output columns from supplied *.ini file
    """
    configParseObj = configparser.ConfigParser()
    configParseObj.read(args)
    return configParseObj

def parse_args():
    parser = argparse.ArgumentParser(description='Combine Hazard Curves to single Province/Territory Level')
    parser.add_argument('--hCurveDir', type=str, help='', required=True)
    args = parser.parse_args()
    
    return args

if __name__ == '__main__':
    main() 