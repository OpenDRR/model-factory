
DROP TABLE IF EXISTS sovi.sovi_census_canada CASCADE;

-- create table
CREATE TABLE sovi.sovi_census_canada(
    PRIMARY KEY(SAUIDt),
    OBJECTID varchar,
    SAUIDt varchar,
    SAUIDi integer,
    Lon float,
    Lat float,
    Area_km2 float,
    Area_ha float,
    DAUIDt varchar,
    DAUIDi integer,
    ADAUID varchar,
    CFSAUID varchar,
    PRUID varchar,
    PRNAME varchar,
    CSDUID varchar,
    CSDNAME varchar,
    CSDTYPE varchar,
    CDUID varchar,
    CDNAME varchar,
    CDTYPE varchar,
    CCSUID varchar,
    CCSNAME varchar,
    ERUID varchar,
    ERNAME varchar,
    SACCODE varchar,
    SACTYPE varchar,
    CMAUID varchar,
    CMAPUID varchar,
    CMANAME varchar,
    CMATYPE varchar,
    Shape_Length float,
    Shape_Area float,
    DAUID varchar,
    Pop_Dens float,
    Pop_Ha float,
    Bus_Ha float,
    Pre_1975 float,
    Renter float,
    Hshld_NSuit float,
    Hshld_Mntn1 float,
    Hshld_MntnAge float,
    Pub_Trans float,
    Vis_Min float,
    Imm_LT5 float,
    Indigenous float,
    Age_GT65 float,
    Age_LT6 float,
    Age_Median float,
    NoSec_School float,
    Retail_Job float,
    Health_Job float,
    Fam_GT5 float,
    LonePar3Kids float,
    Live_Alone float,
    No_EngFr float,
    Moved_LT1 float,
    NoWrkPlace float,
    Shltr_GT30 float,
    Inc_Indv float,
    Inc_Hshld float,
    Inc_LowDecile float,
    Unemployed float,
    Work_Parttime float,
    Work_None float,
    Employ_Inc float

);

-- import exposure from csv
COPY sovi.sovi_census_canada (OBJECTID, SAUIDt, SAUIDi, Lon, Lat, Area_km2, Area_ha, DAUIDt, DAUIDi, ADAUID, CFSAUID, PRUID, PRNAME, CSDUID, CSDNAME, CSDTYPE, CDUID, CDNAME, CDTYPE, CCSUID, CCSNAME, ERUID, ERNAME, SACCODE, SACTYPE, CMAUID, CMAPUID, CMANAME, CMATYPE, Shape_Length, Shape_Area, DAUID, Pop_Dens, Pop_Ha, Bus_Ha, Pre_1975, Renter, Hshld_NSuit, Hshld_Mntn1, Hshld_MntnAge, Pub_Trans, Vis_Min, Imm_LT5, Indigenous, Age_GT65, Age_LT6, Age_Median, NoSec_School, Retail_Job, Health_Job, Fam_GT5, LonePar3Kids, Live_Alone, No_EngFr, Moved_LT1, NoWrkPlace, Shltr_GT30, Inc_Indv, Inc_Hshld, Inc_LowDecile, Unemployed, Work_Parttime, Work_None, Employ_Inc)

    FROM '/usr/src/app/social-vulnerability-census.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;