#Import statements
import sys
import os
import argparse
import configparser
import logging

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

    # Copy Canada Exposure Model
    systemCall='''psql -h  db-opendrr
                    -U ${POSTGRES_USER}
                    -d ${DB_NAME}
                    -a 
                    -c "\copy exposure.canada_exposure (objectid,
                                                        id,
                                                        SauidLat,
                                                        SauidLon,
                                                        Sauid_km2,
                                                        Sauid_ha,
                                                        LandUse,
                                                        taxonomy,
                                                        number,
                                                        structural,
                                                        nonstructural,
                                                        contents,
                                                        retrofitting,
                                                        day,night,
                                                        transit,
                                                        GenOcc,
                                                        OccClass1,
                                                        OccClass2,
                                                        PopDU,
                                                        GenType,
                                                        BldgType,
                                                        NumFloors,
                                                        Bldg_ft2,
                                                        BldYear,
                                                        BldEpoch,
                                                        SSC_Zone,
                                                        EqDesLev,
                                                        sauid,
                                                        dauid,
                                                        adauid,
                                                        fsauid,
                                                        csduid,
                                                        csdname,
                                                        cduid,
                                                        cdname,
                                                        SAC,
                                                        eruid,
                                                        ername,
                                                        pruid,
                                                        prname)
                        FROM '/usr/src/app/BldgExpRef_CA_master_v3p1.csv'
                            WITH 
                            DELIMITER AS ','
                            CSV HEADER ;" '''
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy Site exposure model
    systemCall='''psql -h  db-opendrr
                -U  ${{POSTGRES_USER}} 
                -d ${{DB_NAME}} 
                -a 
                -c "\copy  exposure.metrovan_site_exposure (OBJECTID,
                                                            id,
                                                            SiteID,
                                                            SiteLon,
                                                            SiteLat,
                                                            SauidID,
                                                            SauidLat,
                                                            SauidLon,
                                                            Sauid_km2,
                                                            Sauid_ha,
                                                            LandUse,
                                                            taxonomy,
                                                            number,
                                                            structural,
                                                            nonstructural,
                                                            contents,
                                                            business,
                                                            "limit",
                                                            deductible,
                                                            retrofitting,
                                                            day,
                                                            night,
                                                            transit,
                                                            GenOcc,
                                                            OccClass1,
                                                            OccClass2,
                                                            PopDU,
                                                            GenType,
                                                            BldgType,
                                                            NumFloors,
                                                            Bldg_ft2,
                                                            BldYear,
                                                            BldEpoch,
                                                            SSC_Zone,
                                                            EqDesLev,
                                                            sauid,
                                                            dauid,
                                                            adauid,
                                                            fsauid,
                                                            csduid,
                                                            csdname,
                                                            cduid,
                                                            cdname,
                                                            SAC,
                                                            eruid,
                                                            ername,
                                                            pruid,
                                                            prname,
                                                            OBJECTID_1,
                                                            OBJECTID_12,
                                                            SAUIDt,
                                                            SAUIDi,
                                                            Lon,
                                                            Lat,
                                                            Area_km2,
                                                            Area_ha,
                                                            DAUIDt,
                                                            DAUIDi,
                                                            ADAUID_1,
                                                            CFSAUID,
                                                            PRUID_1,
                                                            PRNAME_1,
                                                            CSDUID_1,
                                                            CSDNAME_1,
                                                            CSDTYPE,
                                                            CDUID_1,
                                                            CDNAME_1,
                                                            CDTYPE,
                                                            CCSUID,
                                                            CCSNAME,
                                                            ERUID_1,
                                                            ERNAME_1,
                                                            SACCODE,
                                                            SACTYPE,
                                                            CMAUID,
                                                            CMAPUID,
                                                            CMANAME,
                                                            CMATYPE,
                                                            Shape_Leng,
                                                            Shape_Length,
                                                            Shape_Area)
                        FROM '/usr/src/app/PhysExpRef_MetroVan_v4.csv'
                            WITH 
                            DELIMITER AS ','
                            CSV HEADER ;'''
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy VS30 Canada Site Model
    systemCall='''psql -h  db-opendrr
                -U  ${POSTGRES_USER}
                -d ${DB_NAME}
                -a 
                -c "\copy vs30.vs30_can_site_model (objectid,
                                                    lon,
                                                    lat,
                                                    vs30,
                                                    z1pt0,
                                                    z2pt5)
                        FROM '/usr/src/app/site-vgrid_CA.csv'
                            WITH 
                            DELIMITER AS ','
                            CSV HEADER ;"'''
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy VS30 Canada Site Model xref
    systemCall='''psql -h  db-opendrr
                -U  ${POSTGRES_USER}
                -d ${DB_NAME}
                -a 
                -c "\copy vs30.vs30_can_site_model_xref (id,
                                                        asset_lon,
                                                        asset_lat,
                                                        vs30,
                                                        z1pt0,
                                                        z2pt5,
                                                        vs_lon,
                                                        vs_lat,
                                                        distance)
                        FROM '/usr/src/app/vs30_CAN_site_model_xref.csv'
                            WITH 
                            DELIMITER AS ','
                            CSV HEADER ;"'''
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy 2016 Censuse Table
    systemCall='''psql -h  db-opendrr
                -U  ${POSTGRES_USER}
                -d ${DB_NAME}
                -a 
                -c "\copy census.census_2016_canada (OBJECTID,
                                                        SAUIDt,
                                                        SAUIDi,
                                                        DAUIDt,
                                                        DAUIDi,
                                                        Fsauid,
                                                        Csdname,
                                                        Cdname,
                                                        Ername,
                                                        Prname,
                                                        Lon,
                                                        Lat,
                                                        BldgNum,
                                                        CostAsset,
                                                        CostBldg,
                                                        PopDay,
                                                        PopNight,
                                                        PopTrnst,
                                                        Concrete,
                                                        Manufactured,
                                                        Precast,
                                                        RMasonry,
                                                        Steel,
                                                        URMasonry,
                                                        Wood,
                                                        Agr,
                                                        Comm,
                                                        Ind,
                                                        Civic,
                                                        Res_HD,
                                                        Res_MD,
                                                        Res_LD,
                                                        CensusPop,
                                                        CensusBldg,
                                                        CensusDU,
                                                        CensusRESLD,
                                                        CensusResMD,
                                                        CensusRESHD,
                                                        CensusCOMM,
                                                        CensusIND,
                                                        CensusCIVIC,
                                                        CensusAGR,
                                                        Area_km2,
                                                        Area_ha,
                                                        Shape_Length,
                                                        Shape_Area,
                                                        LandUse,
                                                        PRUID,
                                                        ProvAbbr,
                                                        People_DU,
                                                        DAUID,
                                                        SACTYPE,
                                                        PopTotal,
                                                        Pop_Dens,
                                                        Pop_Ha,
                                                        Bus_Ha,
                                                        Pre_1975,
                                                        Renter,
                                                        Hshld_NSuit,
                                                        Hshld_Mntn1,
                                                        Hshld_MntnAge,
                                                        Pub_Trans,
                                                        Vis_Min,
                                                        Imm_LT5,
                                                        Indigenous,
                                                        Age_GT65,
                                                        Age_LT6,
                                                        Age_Median,
                                                        NoSec_School,
                                                        Retail_Job,
                                                        Health_Job,
                                                        Fam_GT5,
                                                        LonePar3Kids,
                                                        Live_Alone,
                                                        No_EngFr,
                                                        Moved_LT1,
                                                        NoWrkPlace,
                                                        Shltr_GT30,
                                                        Inc_Indv,
                                                        Inc_Hshld,
                                                        Inc_LowDecile,
                                                        Unemployed,
                                                        Work_Parttime,
                                                        Work_None,
                                                        Employ_Inc)
                        FROM '/usr/src/app/census-attributes-2016.csv'
                            WITH 
                            DELIMITER AS ','
                            CSV HEADER ;"'''
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy Table SOVI Index
    systemCall='''psql -h  db-opendrr
                -U  ${POSTGRES_USER}
                -d ${DB_NAME}
                -a 
                -c "\copy  sovi.sovi_index_canada (OBJECTID,
                                                    SAUIDt,
                                                    SAUIDi,
                                                    Lon,
                                                    Lat,
                                                    Area_km2,
                                                    Area_ha,
                                                    DAUIDt,
                                                    DAUIDi,
                                                    ADAUID,
                                                    CFSAUID,
                                                    PRUID,
                                                    PRNAME,
                                                    CSDUID,
                                                    CSDNAME,
                                                    CSDTYPE,
                                                    CDUID,
                                                    CDNAME,
                                                    CDTYPE,
                                                    CCSUID,
                                                    CCSNAME,
                                                    ERUID,
                                                    ERNAME,
                                                    SACCODE,
                                                    SACTYPE,
                                                    CMAUID,
                                                    CMAPUID,
                                                    CMANAME,
                                                    CMATYPE,
                                                    Shape_Length,
                                                    Shape_Area,
                                                    DAUID,
                                                    Pop_Density,
                                                    Pop_Ha,
                                                    Bus_Ha,
                                                    Pre_1975,
                                                    Renter,
                                                    Hshld_NSuit,
                                                    Hshld_Mntn1,
                                                    Hshld_MntnAge,
                                                    Pub_Trans,
                                                    Vis_Min,
                                                    Imm_LT5,
                                                    Indigenous,
                                                    Age_GT65,
                                                    Age_LT6,
                                                    Age_Median,
                                                    NoSec_School,
                                                    Retail_Job,
                                                    Health_Job,
                                                    Fam_GT5,
                                                    LonePar3Kids,
                                                    Live_Alone,
                                                    No_EngFr,
                                                    Moved_LT1,
                                                    NoWrkPlace,
                                                    Shltr_GT30,
                                                    Inc_Indv,
                                                    Inc_Hshld,
                                                    Inc_LowDecile,
                                                    Unemployed,
                                                    Work_Parttime,
                                                    Work_None,
                                                    Employ_Inc,
                                                    MH_Index)
                        FROM '/usr/src/app/social-vulnerability-index.csv'
                            WITH 
                            DELIMITER AS ','
                            CSV HEADER ;"'''
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy Table SOVI Census
    systemCall='''psql -h  db-opendrr
                -U  ${POSTGRES_USER}
                -d ${DB_NAME}
                -a 
                -c "\copy  sovi.sovi_census_canada (OBJECTID,
                                                    SAUIDt,
                                                    SAUIDi,
                                                    Lon,
                                                    Lat,
                                                    Area_km2,
                                                    Area_ha,
                                                    DAUIDt,
                                                    DAUIDi,
                                                    ADAUID,
                                                    CFSAUID,
                                                    PRUID,
                                                    PRNAME,
                                                    CSDUID,
                                                    CSDNAME,
                                                    CSDTYPE,
                                                    CDUID,
                                                    CDNAME,
                                                    CDTYPE,
                                                    CCSUID,
                                                    CCSNAME,
                                                    ERUID,
                                                    ERNAME,
                                                    SACCODE,
                                                    SACTYPE,
                                                    CMAUID,
                                                    CMAPUID,
                                                    CMANAME,
                                                    CMATYPE,
                                                    Shape_Length,
                                                    Shape_Area,
                                                    DAUID,
                                                    Pop_Dens,
                                                    Pop_Ha,
                                                    Bus_Ha,
                                                    Pre_1975,
                                                    Renter,
                                                    Hshld_NSuit,
                                                    Hshld_Mntn1,
                                                    Hshld_MntnAge,
                                                    Pub_Trans,
                                                    Vis_Min,
                                                    Imm_LT5,
                                                    Indigenous,
                                                    Age_GT65,
                                                    Age_LT6,
                                                    Age_Median,
                                                    NoSec_School,
                                                    Retail_Job,
                                                    Health_Job,
                                                    Fam_GT5,
                                                    LonePar3Kids,
                                                    Live_Alone,
                                                    No_EngFr,
                                                    Moved_LT1,
                                                    NoWrkPlace,
                                                    Shltr_GT30,
                                                    Inc_Indv,
                                                    Inc_Hshld,
                                                    Inc_LowDecile,
                                                    Unemployed,
                                                    Work_Parttime,
                                                    Work_None,
                                                    Employ_Inc)

                        FROM '/usr/src/app/social-vulnerability-census.csv'
                            WITH 
                            DELIMITER AS ','
                            CSV HEADER ;"'''
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)
    
    #Copy table collapse probability
    systemCall='''psql -h  db-opendrr
                -U  ${POSTGRES_USER}
                -d ${DB_NAME}
                -a 
                -c "\copy  lut.collapse_probability ("typology",
                                                        "eqbldgtype",
                                                        "collapse_pc")
                        FROM '/usr/src/app/collapse_probability.csv'
                            WITH 
                            DELIMITER AS ','
                            CSV HEADER ;"'''
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)
    
    #Copy Retrofit costs table
    systemCall='''psql -h  db-opendrr
                -U  ${POSTGRES_USER}
                -d ${DB_NAME}
                -a 
                -c "\copy  lut.retrofit_costs ("Eq_BldgType",
                                                        "Description",
                                                        "BldgArea_ft2",
                                                        "USD_ft2__pre1917",
                                                        "USD_ft2_1917_1975",
                                                        "USD_ft2_1975_2019",
                                                        "RetrofitCost_pc_Total",
                                                        "USD_RetrofitCost_Bldg",
                                                        "CAD_RetrofitCost_Bldg")
                        FROM '/usr/src/app/retrofit_costs.csv'
                            WITH 
                            DELIMITER AS ','
                            CSV HEADER ;"'''
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)
    
    #Copy GHSL Table
    systemCall='''psql -h  db-opendrr
                -U  ${POSTGRES_USER}
                -d ${DB_NAME}
                -a 
                -c "\copy  ghsl.ghsl_mh_intensity_ghsl (ghslID,
                                                        lon,
                                                        lat,
                                                        ghsl_km2,
                                                        ghsl_ha,
                                                        Pop_2015,
                                                        Pop_2000,
                                                        Pop_1990,
                                                        Pop_1975,
                                                        SMOD_2015,
                                                        SMOD_2000,
                                                        SMOD_1990,
                                                        SMOD_1975,
                                                        PGV,
                                                        PGA,
                                                        MMI7,
                                                        Tsunami,
                                                        Fld500,
                                                        Wildfire,
                                                        LndSus,
                                                        Cy500,
                                                        CSDUID,
                                                        CSDNAME,
                                                        CSDTYPE,
                                                        PRUID,
                                                        PRNAME,
                                                        CDUID,
                                                        CDNAME,
                                                        CDTYPE,
                                                        CCSUID,
                                                        CCSNAME,
                                                        ERUID,
                                                        ERNAME,
                                                        SACCODE,
                                                        SACTYPE,
                                                        NEAR_FID)
                        FROM '/usr/src/app/mh-intensity-ghsl.csv'
                            WITH 
                            DELIMITER AS ','
                            CSV HEADER ;"'''
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)
    
    #Copy MH Intensity Table
    systemCall='''psql -h  db-opendrr
                -U  ${POSTGRES_USER}
                -d ${DB_NAME}
                -a 
                -c "\copy  mh.mh_intensity_canada (OBJECTID,
                                                    SAUIDt,
                                                    lon,
                                                    lat,
                                                    PGV,
                                                    PGA,
                                                    Sa0p1,
                                                    Sa0p3,
                                                    Sa1p0,
                                                    Sa2p0,
                                                    Vs30,
                                                    MMI6,
                                                    MMI7,
                                                    MMI8,
                                                    Tsun_ha,
                                                    Fl200,
                                                    Fl500,
                                                    Fl1000,
                                                    Fire,
                                                    Lndsus,
                                                    Cy100,
                                                    Cy250,
                                                    Cy500,
                                                    Cy1000,
                                                    PGVn,
                                                    MMI7n,
                                                    Tsun_n,
                                                    Fl500n,
                                                    Firen,
                                                    Lndn,
                                                    Cy500n,
                                                    MHn_TPGV,
                                                    MHn_TMMI7,
                                                    MHIn_PGV,
                                                    MHIn_MMI7)
                        FROM '/usr/src/app/mh-intensity-sauid.csv'
                            WITH 
                            DELIMITER AS ','
                            CSV HEADER ;"'''
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
    for ancillary datasets such as Exposure models, VS30 models etc
    Can be run from the command line with out arguments like:
    Run this script with a command like:
    python3 copyAncillaryTables.py''')
    # parser.add_argument("--shakemapFile", type=str, help="Shakemap CSV File")
    args = parser.parse_args()

    return args

if __name__ == '__main__':
    main() 