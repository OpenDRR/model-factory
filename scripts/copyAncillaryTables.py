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
    systemCall='''psql -h ${POSTGRES_HOST}
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
                                                        day,
                                                        night,
                                                        transit,
                                                        GenOcc,
                                                        OccType,
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
                                                        SS_Region,
                                                        nation)
                        FROM '/usr/src/app/BldgExpRef_CA_master_v3p2.csv'
                            WITH
                            DELIMITER AS ','
                            CSV HEADER ;" '''
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    # Copy Site exposure model
    systemCall="""psql -h ${POSTGRES_HOST}
                -U ${POSTGRES_USER} 
                -d ${DB_NAME}
                -a 
                -c '\copy  exposure.metrovan_site_exposure (OBJECTID,
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
                        FROM /usr/src/app/PhysExpRef_MetroVan_v4.csv
                            WITH 
                            CSV HEADER ;'"""
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy VS30 Canada Site Model
    systemCall='''psql -h ${POSTGRES_HOST}
                -U ${POSTGRES_USER}
                -d ${DB_NAME}
                -a
                -c "\copy vs30.vs30_can_site_model (lon,
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
    systemCall='''psql -h ${POSTGRES_HOST}
                -U ${POSTGRES_USER}
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
    systemCall='''psql -h ${POSTGRES_HOST}
                -U ${POSTGRES_USER}
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
    systemCall='''psql -h ${POSTGRES_HOST}
                -U ${POSTGRES_USER}
                -d ${DB_NAME}
                -a 
                -c "\copy  sovi.sovi_index_canada (sauidt,
                                                    sauidi,
                                                    dauidt,
                                                    dauidi,
                                                    fsauid,
                                                    csdname,
                                                    cdname,
                                                    ername,
                                                    prname,
                                                    lon,
                                                    lat,
                                                    bldgnum,
                                                    costasset,
                                                    costbldg,
                                                    popday,
                                                    popnight,
                                                    poptrnst,
                                                    censuspop,
                                                    censusbldg,
                                                    censusdu,
                                                    area_km2,
                                                    area_ha,
                                                    shape_length,
                                                    shape_area,
                                                    sauid_pc,
                                                    landuse,
                                                    dauid_i,
                                                    dauid_lon,
                                                    dauid_lat,
                                                    adauid,
                                                    ctuid,
                                                    ctname,
                                                    cfsauid,
                                                    csduid,
                                                    csdtype,
                                                    saccode,
                                                    sactype,
                                                    cduid,
                                                    cdtype,
                                                    ccsuid,
                                                    ccsname,
                                                    cmauid,
                                                    cmapuid,
                                                    cmaname,
                                                    cmatype,
                                                    eruid,
                                                    pruid,
                                                    sauid_km2,
                                                    age_gt65,
                                                    age_lt6,
                                                    age_median,
                                                    health_job,
                                                    indigenous,
                                                    no_engfr,
                                                    nosec_school,
                                                    vis_min,
                                                    pub_trans,
                                                    inc_hshld,
                                                    inc_indv,
                                                    inc_lowdecile,
                                                    retail_job,
                                                    shltr_gt30,
                                                    unemployed,
                                                    work_none,
                                                    work_parttime,
                                                    employ_inc,
                                                    fam_gt5,
                                                    imm_lt5,
                                                    live_alone,
                                                    lonepar3kids,
                                                    moved_lt1,
                                                    nowrkplace,
                                                    bus_ha,
                                                    hshld_mntn1,
                                                    hshld_mntnage,
                                                    hshld_nsuit,
                                                    pop_ha,
                                                    pre_1975,
                                                    renter,
                                                    dauid_text)
                        FROM '/usr/src/app/social-vulnerability-index.csv'
                            WITH 
                            DELIMITER AS ','
                            CSV HEADER ;"'''
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy Table SOVI Census
    systemCall='''psql -h ${POSTGRES_HOST}
                -U ${POSTGRES_USER}
                -d ${DB_NAME}
                -a 
                -c "\copy  sovi.sovi_census_canada (sauidt,
                                                    sauidi,
                                                    dauidt,
                                                    dauidi,
                                                    fsauid,
                                                    csdname,
                                                    cdname,
                                                    ername,
                                                    prname,
                                                    lon,
                                                    lat,
                                                    bldgnum,
                                                    costasset,
                                                    costbldg,
                                                    popday,
                                                    popnight,
                                                    poptrnst,
                                                    censuspop,
                                                    censusbldg,
                                                    censusdu,
                                                    area_km2,
                                                    area_ha,
                                                    shape_length,
                                                    shape_area,
                                                    sauid_pc,
                                                    landuse,
                                                    dauidt_1,
                                                    dauid_i,
                                                    dauid_lon,
                                                    dauid_lat,
                                                    adauid,
                                                    ctuid,
                                                    ctname,
                                                    cfsauid,
                                                    csduid,
                                                    csdtype,
                                                    saccode,
                                                    sactype,
                                                    cduid,
                                                    cdtype,
                                                    ccsuid,
                                                    ccsname,
                                                    cmauid,
                                                    cmapuid,
                                                    cmaname,
                                                    cmatype,
                                                    eruid,
                                                    pruid,
                                                    sauid_km2,
                                                    age_gt65,
                                                    age_lt6,
                                                    age_median,
                                                    health_job,
                                                    indigenous,
                                                    no_engfr,
                                                    nosec_school,
                                                    vis_min,
                                                    pub_trans,
                                                    inc_hshld,
                                                    inc_indv,
                                                    inc_lowdecile,
                                                    retail_job,
                                                    shltr_gt30,
                                                    unemployed,
                                                    work_none,
                                                    work_parttime,
                                                    employ_inc,
                                                    fam_gt5,
                                                    imm_lt5,
                                                    live_alone,
                                                    lonepar3kids,
                                                    moved_lt1,
                                                    nowrkplace,
                                                    bus_ha,
                                                    hshld_mntn1,
                                                    hshld_mntnage,
                                                    hshld_nsuit,
                                                    pop_ha,
                                                    pre_1975,
                                                    renter,
                                                    dauid_text)
                        FROM '/usr/src/app/social-vulnerability-census.csv'
                            WITH 
                            DELIMITER AS ','
                            CSV HEADER ;"'''
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy Table SOVI Threshold
    systemCall='''psql -h ${POSTGRES_HOST}
                -U ${POSTGRES_USER}
                -d ${DB_NAME}
                -a 
                -c "\copy  sovi.sovi_thresholds (sactype,
                                                    pop_ha_t,
                                                    bus_ha_t,
                                                    pre_1975_t,
                                                    hshld_nsuit_t,
                                                    hshld_mntnage_t,
                                                    hshld_mntn1_t,
                                                    renter_t,
                                                    live_alone_t,
                                                    lonepar3kids_t,
                                                    fam_gt5_t,
                                                    moved_lt1_t,
                                                    imm_lt5_t,
                                                    nowrkplace_t,
                                                    no_engfr_t,
                                                    nosec_school_t,
                                                    age_gt65_t,
                                                    age_lt6_t,
                                                    indigenous_t,
                                                    vis_min_t,
                                                    shltr_gt30_t,
                                                    inc_lowdecile_t,
                                                    unemployed_t,
                                                    work_none_t,
                                                    work_parttime_t,
                                                    employ_inc_t,
                                                    inc_indv_t,
                                                    inc_hshld_t,
                                                    agemedian_t,
                                                    health_t,
                                                    pubtrans_t,
                                                    retail_t)
                        FROM '/usr/src/app/sovi_thresholds_2021.csv'
                            WITH 
                            DELIMITER AS ','
                            CSV HEADER ;"'''
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy table collapse probability
    systemCall='''psql -h ${POSTGRES_HOST}
                -U ${POSTGRES_USER}
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
    # Retrofit costs depricated
    # systemCall="""psql -h ${POSTGRES_HOST}
    #             -U ${POSTGRES_USER}
    #             -d ${DB_NAME}
    #             -a 
    #             -c '\copy  lut.retrofit_costs ("Eq_BldgType",
    #                                             "Description",
    #                                             "BldgArea_ft2",
    #                                             "USD_ft2__pre1917",
    #                                             "USD_ft2_1917_1975",
    #                                             "USD_ft2_1975_2019",
    #                                             "RetrofitCost_pc_Total",
    #                                             "USD_RetrofitCost_Bldg",
    #                                             "CAD_RetrofitCost_Bldg")
    #                     FROM /usr/src/app/retrofit_costs.csv
    #                         WITH
    #                         CSV HEADER ;'"""
    # systemCall = ' '.join(systemCall.split())
    # os.system(systemCall)

    #Copy GHSL Table
    systemCall='''psql -h ${POSTGRES_HOST}
                -U ${POSTGRES_USER}
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
    systemCall='''psql -h ${POSTGRES_HOST}
                -U ${POSTGRES_USER}
                -d ${DB_NAME}
                -a 
                -c "\copy   mh.mh_intensity_canada(sauidt,
                                                    sauidi,
                                                    lon,
                                                    lat,
                                                    pgv2500,
                                                    pgv500,
                                                    pga2500,
                                                    pga500,
                                                    vs30,
                                                    mmi6,
                                                    mmi7,
                                                    mmi8,
                                                    tsun500,
                                                    fld50_jrc,
                                                    fld100_jrc,
                                                    fld200_jrc,
                                                    fld500_jrc,
                                                    fld200_unep,
                                                    fld500_unep,
                                                    fld1000_unep,
                                                    wildfire,
                                                    wui_type,
                                                    lndsus,
                                                    cy100,
                                                    cy250,
                                                    cy500,
                                                    cy1000,
                                                    svlt_score)
                        FROM '/usr/src/app/HTi_sauid.csv'
                            WITH 
                            DELIMITER AS ','
                            CSV HEADER ;"'''
    systemCall = ' '.join(systemCall.split())
    os.system(systemCall)

    #Copy MH Threshold Table
    systemCall='''psql -h ${POSTGRES_HOST}
                -U ${POSTGRES_USER}
                -d ${DB_NAME}
                -a 
                -c "\copy   mh.mh_thresholds(threat,
                                                htt_exposure,
                                                hti_pgv500,
                                                hti_pga500,
                                                hti_tsun500,
                                                hti_fld500,
                                                hti_wildfire,
                                                hti_lndsus,
                                                hti_cy500)
                    FROM '/usr/src/app/HTi_thresholds.csv'
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