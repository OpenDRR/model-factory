-- script to generate Canada  site level exposure table

DROP TABLE IF EXISTS exposure.canada_site_exposure;

-- create table
CREATE TABLE exposure.canada_site_exposure(
    PRIMARY KEY (id),
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
COPY exposure.canada_site_exposure (id,SiteID,SiteLon,SiteLat,SauidID,SauidLat,SauidLon,Sauid_km2,Sauid_ha,LandUse,taxonomy,number,structural,nonstructural,contents,business,"limit",deductible,retrofitting,day,night,transit,GenOcc,OccClass1,OccClass2,PopDU,GenType,BldgType,NumFloors,Bldg_ft2,BldYear,BldEpoch,SSC_Zone,EqDesLev,sauid,dauid,adauid,fsauid,csduid,csdname,cduid,cdname,SAC,eruid,ername,pruid,prname,ObjID)
    FROM '/usr/src/app/SiteExp_MetroVan_v2p5p3_master.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;


-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE exposure.canada_site_exposure ADD COLUMN geom_site geometry(Point,4326);
UPDATE exposure.canada_site_exposure SET geom_site = st_setsrid(st_makepoint(sitelon,sitelat),4326);

-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE exposure.canada_site_exposure ADD COLUMN geom_sauid geometry(Point,4326);
UPDATE exposure.canada_site_exposure SET geom_sauid = st_setsrid(st_makepoint(sauidlon,sauidlat),4326);

-- create spatial index
CREATE INDEX canada_site_exposure_idx
ON exposure.canada_site_exposure using GIST (geom_site,geom_sauid);