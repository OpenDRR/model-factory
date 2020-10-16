-- script to generate Canada exposure table

DROP TABLE IF EXISTS exposure.canada_exposure CASCADE;

-- create table
CREATE TABLE exposure.canada_exposure(
    PRIMARY KEY (id),
    OBJECTID varchar,
    id varchar,
    SiteID varchar,
    SiteLon float,
    SiteLat float,
    SauidID varchar,
    SauidLat float,
    SauidLon float,
    Sauid_km2 float,
    Sauid_ha float,
    LandUse varchar,
    taxonomy varchar,
    number float,
    structural float,
    nonstructural float,
    contents float,
    business float,
    "limit" float,
    deductible float,
    retrofitting float,
    day float,
    night float,
    transit float,
    GenOcc varchar,
     OccClass1 varchar,
    OccClass2 varchar,
    PopDU float,
    GenType varchar,
    BldgType varchar,
    NumFloors float,
    Bldg_ft2 float,
    BldYear float,
    BldEpoch varchar,
    SSC_Zone varchar,
    EqDesLev varchar,
    sauid varchar,
    dauid varchar,
    adauid varchar,
    fsauid varchar,
    csduid varchar,
    csdname varchar,
    cduid varchar,
    cdname varchar,
    SAC varchar,
    eruid varchar,
    ername varchar,
    pruid varchar,
    prname varchar,
    ObjID varchar

);

-- import exposure from csv
COPY exposure.canada_exposure (OBJECTID,id,SiteID,SiteLon,SiteLat,SauidID,SauidLat,SauidLon,Sauid_km2,Sauid_ha,LandUse,taxonomy,number,structural,nonstructural,contents,business,"limit",deductible,retrofitting,day,night,transit,GenOcc,OccClass1,OccClass2,PopDU,GenType,BldgType,NumFloors,Bldg_ft2,BldYear,BldEpoch,SSC_Zone,EqDesLev,sauid,dauid,adauid,fsauid,csduid,csdname,cduid,cdname,SAC,eruid,ername,pruid,prname,ObjID)
    FROM '/usr/src/app/BldgExp_CA_v2p5p3_master.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;


-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE exposure.canada_exposure ADD COLUMN geom geometry(Point,4326);
UPDATE exposure.canada_exposure SET geom = st_setsrid(st_makepoint(SauidLon,SauidLat),4326);

-- create spatial index
CREATE INDEX canada_exposure_idx
ON exposure.canada_exposure using GIST (geom);

--remove trailing space from 'manufactured ' in gentype
UPDATE exposure.canada_exposure 
SET gentype = REPLACE(gentype,'Manufactured ','Manufactured')
WHERE gentype = 'Manufactured '