#!/usr/bin/env python

import pandas as pd
import csv
import glob
import os
import re
import argparse


'''
python script to add economic region or subregion to new column in csv file
where PSRA runs have een split up by economic region or sub regions
can be run from the command line with mandatory arguments like:
python3 PSRA_combineAggLossesStats.py --aggLossDir=/usr/src/app/ebRisk/AB/
'''


def main():
    args = parse_args()
    os.chdir(args.aggLossDir)

    for retrofit in 'b0', 'r1':
        erFileList = glob.glob('*agg_losses-stats_{}.csv'.format(retrofit))
        erFileList.sort()

        with open(erFileList[0], newline='') as f:
            reader = csv.reader(f)
            columns = next(reader)

        columns.append('region')

        dfFinal = pd.DataFrame(columns=columns)

        for erFile in erFileList:
            dfFinal = pd.read_csv(erFile)
            # er = erFile.split('_')[1]
            # Remove the split econmic region identifiers
            # handle subregions and combined regions differently
            # For example 'QC2445-55' should remain the same
            # NB1330 should remain the same
            # BC5920A2 should be changed to BC5920
            er = erFile.split('ebR_')[1].split('_agg_losses-stats_{}.csv'.format(retrofit))[0]
            # 2021-11-08 Updated, er will now be any of the text which the OpenQuake Analyst
            # chooses to put in the filename between 'ebR_' and '_agg_curves-stats_{}.csv
            # if len(re.split('(\d+)', er)) == 1 or re.split('(\d+)', er)[2] == '-':
            #     er = ''.join(re.split('(\d+)', er)[0:4])
            # else:
            #     er = ''.join(re.split('(\d+)', er)[0:2])

            dfFinal['region'] = er
            os.rename(erFile, '{}_orginal.csv'.format(os.path.splitext(erFile)[0]))
            dfFinal.to_csv(erFile, index=False)
    return


def parse_args():
    parser = argparse.ArgumentParser(
        description='Add Economic Regions field to agg loss tables')
    parser.add_argument('--aggLossDir', type=str, help='', required=True)
    args = parser.parse_args()

    return args


if __name__ == '__main__':
    main()
