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
python script to merge source loss tables for Provinces and territories
where PSRA runs have een split up by economic region or sub regions
can be run from the command line with mandatory arguments like:
python3 PSRA_combineSrcLossTable.py --srcLossDir=/usr/src/app/ebRisk/AB/
'''


def main():
    args = parse_args()
    os.chdir(args.srcLossDir)

    for retrofit in 'b0', 'r1':
        erFileList = glob.glob('*src_loss_table_{}.csv'.format(retrofit))
        erFileList.sort()

        with open(erFileList[0], newline='') as f:
            reader = csv.reader(f)
            columns = next(reader)

        columns.append('region')

        dfFinal = pd.DataFrame(columns=columns)

        for erFile in erFileList:
            dfTemp = pd.read_csv(erFile)
            # er = erFile.split('_')[1]
            # Remove the split econmic region identifiers
            # handle subregions and combined regions differently
            # For example 'QC2445-55' should remain the same
            # NB1330 should remain the same
            # BC5920A2 should be changed to BC5920
            er = erFile.split('ebR_')[1].split('_src_loss_table_{}.csv'.format(retrofit))[0]
            # 2021-11-08 Updated, er will now be any of the text which the OpenQuake Analyst
            # chooses to put in the filename between 'ebR_' and '_agg_curves-stats_{}.csv
            # if len(re.split('(\d+)', er)) == 1 or re.split('(\d+)', er)[2] == '-':
            #     er = ''.join(re.split('(\d+)',er)[0:4])
            # else:
            #     er = ''.join(re.split('(\d+)',er)[0:2])

            dfTemp['region'] = er
            dfFinal = dfFinal.append(dfTemp)
        outFileName = 'ebR_{er}_src_loss_table_{retrofit}.csv'.format(**{
            'er': er[0:2],
            'retrofit': retrofit})

        if not os.path.isfile(outFileName):
            # Check if the file already exists, it should for
            # Provs/Territories that were process with a single
            # Economic region
            dfFinal.to_csv(outFileName, index=False)
        else:
            # else it exists, do nothing
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
    parser = argparse.ArgumentParser(description='Combine Source Loss Tables across Economic Regions')
    parser.add_argument('--srcLossDir', type=str, help='', required=True)
    args = parser.parse_args()

    return args


if __name__ == '__main__':
    main()
