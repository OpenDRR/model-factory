#!/usr/bin/env python

#Import statements
import configparser
import argparse


#Main Function
def main():
    args = parse_args()
    os.system('')


#Suport Functions

def write_hazard_config(runName, runID, ruptureFile, configParser):
    hazardConfig = configparser.ConfigParser(allow_no_value=True)
    hazardConfig['general'] = {}
    hazardConfig['general']['description'] = configParser.get('General', 'description')
    hazardConfig['general']['calculation_mode'] = 'scenario'
    hazardConfig['general']['random_seed'] = configParser.get('General', 'random_seed') 
    
    hazardConfig['site_params'] = {}
    hazardConfig['site_params']['site_model_file'] = configParser.get('File Paths', 'SiteParams')
    
    hazardConfig['Rupture information'] = {}
    hazardConfig['Rupture information']['rupture_model_file'] = ruptureFile
    hazardConfig['Rupture information']['rupture_mesh_spacing'] = configParser.get('General', 'RuptureMeshSpacing')
    
    hazardConfig['Calculation parameters'] = {}
    hazardConfig['Calculation parameters']['gsim_logic_tree_file'] = configParser.get('File Paths', 'GMPE')
    hazardConfig['Calculation parameters']['truncation_level'] = '0'
    hazardConfig['Calculation parameters']['maximum_distance'] = configParser.get('General', 'maximum_distance')
    hazardConfig['Calculation parameters']['number_of_ground_motion_fields'] = '1'
    hazardConfig['Calculation parameters']['intensity_measure_types'] = configParser.get('File Paths', 'intensity_measure_types')
    
    with open('initializations/s_Hazard_%s_%s.ini' %(runID, runName), 'w') as configfile:
        configfile.write('# Generated automatically with manyFaults.py on: '+ str(datetime.now())+'\n')
        hazardConfig.write(configfile)
    return
    

def write_run_file_header(runName):
    if not os.path.exists('jobs/regions/'+runName):
        os.makedirs('jobs/regions/'+runName)
    runFile = open('jobs/regions/%s/run-%s.sh' %(runName, runName), 'w+')
    runFile.write('''#!/bin/bash
# =================================================================
# Batch routine for running scenario damage and risk models using fragility functions for shallow crustal rupture ground motions. Taxonomy lookup tables (CoV_UBC2hzTaxonTaxonLUT) are used to map UBC building taxonomy to existing fragility and vulnerability functions used in the National Canada Risk Model 
''')
    return runFile.close()

def write_run_file(runName, magnitude, strike, dip, rake):
    runFile = open('run-%s.sh' %(runName), 'a')
    runFile.write('# =================================================================\n')
    runFile.write('# %s - Magnitude: %s, Strike: %s, Dip: %s, Rake: %s\n' %(runName, magnitude, strike, dip, rake))
    runFile.write('# =================================================================\n')
    runFile.write('oq engine --run '+runName+'/sDamage_%s_M%s_S%s_D%s_R%s.ini' %(runName, magnitude, strike, dip, rake)+' &> output/%s/sDamage_%s_M%s_S%s_D%s_R%s.log;\n' %(runName, runName, magnitude, strike, dip, rake))
    runFile.write('oq export dmg_by_asset -1 -e csv -d output/%s;\n' %(runName))
    runFile.write('oq export realizations -1 -e csv -d output/%s;\n' %(runName))
    runFile.write('source ~/oqenv/bin/activate\n')
    runFile.write('python consequences-v3.7.1py -1\n')
    runFile.write('mv consequences*.csv output/%s\n'%(runName))
    runFile.write('deactivate\n')
    runFile.write('oq engine --run sRisk_%s_M%s_S%s_D%s_R%s.ini' %(runName, magnitude, strike, dip, rake)+' &> output/%s/sRisk.log;\n' %(runName))
    runFile.write('oq export losses_by_asset -1 -e csv -d output/%s;\n'%(runName))
    runFile.write('oq export realizations -1 -e csv -d output/%s;\n'%(runName))
    return runFile.close()

def get_config_params(args):
    """
    Parse Input/Output columns from supplied *.ini file
    """
    configParser = configparser.ConfigParser()
    configParser.read(args.manyFaultsINI)
    return configParser

def parse_args():
    parser = argparse.ArgumentParser(description="Create NRML ruputure file and all calibration files required to begin Open Quake model run")
    parser.add_argument("--manyFaultsINI", type=str, help="Full or relative filepath of initialization file. i.e --manyFaultsINI=C:\Python_Scripts\Many_Faults.ini")
    args = parser.parse_args()
    if args.manyFaultsINI is None:
        args.manyFaultsINI = os.path.dirname(sys.argv[0])+'/manyFaults.ini'
    return args

def updateProgressBar(progress, totalProgress):
    unitColor = "\037[5;36m\033[5;47m"
    endColor = "\037[0;0m\037[0;0m"
    incre = int(50.0 / totalProgress * progress)
    if i != count -1:
        sys.stdout.write("\r" + "|%s%s%s%s| %d%%" % (unitColor, "\033[7m" + " "*incre + " \033[27m", endColor, " "*(50-incre), 2*incre))
    else:
        sys.stdout.write("\r" + "|%s%s%s| %d%%" % (unitColor, "\033[7m" + " "*20 + "COMPLETE!" + " "*21 + " \033[27m", endColor, 100))
    sys.stdout.flush()
    sys.stdout.write("\n")


#Classes

if __name__ == "__main__":
    main() 