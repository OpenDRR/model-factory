-- script to generate Canada  site level exposure table

DROP TABLE IF EXISTS exposure.metrovan_site_exposure CASCADE;

-- create table
CREATE TABLE exposure.metrovan_site_exposure(
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
OBJECTID_1 varchar,
OBJECTID_12 varchar,
SAUIDt varchar,
SAUIDi varchar,
Lon varchar,
Lat varchar,
Area_km2 varchar,
Area_ha varchar,
DAUIDt varchar,
DAUIDi varchar,
ADAUID_1 varchar,
CFSAUID varchar,
PRUID_1 varchar,
PRNAME_1 varchar,
CSDUID_1 varchar,
CSDNAME_1 varchar,
CSDTYPE varchar,
CDUID_1 varchar,
CDNAME_1 varchar,
CDTYPE varchar,
CCSUID varchar,
CCSNAME varchar,
ERUID_1 varchar,
ERNAME_1 varchar,
SACCODE varchar,
SACTYPE varchar,
CMAUID varchar,
CMAPUID varchar,
CMANAME varchar,
CMATYPE varchar,
Shape_Leng varchar,
Shape_Length varchar,
Shape_Area varchar

);

-- import exposure from csv
COPY exposure.metrovan_site_exposure (OBJECTID,id,SiteID,SiteLon,SiteLat,SauidID,SauidLat,SauidLon,Sauid_km2,Sauid_ha,LandUse,taxonomy,number,structural,nonstructural,contents,business,"limit",deductible,retrofitting,day,night,transit,GenOcc,OccClass1,OccClass2,PopDU,GenType,BldgType,NumFloors,Bldg_ft2,BldYear,BldEpoch,SSC_Zone,EqDesLev,sauid,dauid,adauid,fsauid,csduid,csdname,cduid,cdname,SAC,eruid,ername,pruid,prname,OBJECTID_1,OBJECTID_12,SAUIDt,SAUIDi,Lon,Lat,Area_km2,Area_ha,DAUIDt,DAUIDi,ADAUID_1,CFSAUID,PRUID_1,PRNAME_1,CSDUID_1,CSDNAME_1,CSDTYPE,CDUID_1,CDNAME_1,CDTYPE,CCSUID,CCSNAME,ERUID_1,ERNAME_1,SACCODE,SACTYPE,CMAUID,CMAPUID,CMANAME,CMATYPE,Shape_Leng,Shape_Length,Shape_Area)
    FROM '/usr/src/app/PhysExpRef_MetroVan_v4.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;

-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE exposure.metrovan_site_exposure ADD COLUMN geom_site geometry(Point,4326);
UPDATE exposure.metrovan_site_exposure SET geom_site = st_setsrid(st_makepoint(sitelon,sitelat),4326);

-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE exposure.metrovan_site_exposure ADD COLUMN geom_sauid geometry(Point,4326);
UPDATE exposure.metrovan_site_exposure SET geom_sauid = st_setsrid(st_makepoint(sauidlon,sauidlat),4326);

-- create spatial index
CREATE INDEX metrovan_site_exposure_idx
ON exposure.metrovan_site_exposure using GIST (geom_site,geom_sauid);

-- drop columns that are not needed
ALTER TABLE exposure.metrovan_site_exposure
DROP COLUMN objectid_1,
DROP COLUMN objectid_12,
DROP COLUMN sauidt,
DROP COLUMN sauidi,
DROP COLUMN lon,
DROP COLUMN lat,
DROP COLUMN area_km2,
DROP COLUMN area_ha,
DROP COLUMN dauidt,
DROP COLUMN dauidi,
DROP COLUMN adauid_1,
DROP COLUMN cfsauid,
DROP COLUMN pruid_1,
DROP COLUMN prname_1,
DROP COLUMN csduid_1,
DROP COLUMN csdname_1,
DROP COLUMN csdtype,
DROP COLUMN cduid_1,
DROP COLUMN cdname_1,
DROP COLUMN cdtype,
DROP COLUMN ccsuid,
DROP COLUMN ccsname,
DROP COLUMN eruid_1,
DROP COLUMN ername_1,
DROP COLUMN saccode,
DROP COLUMN sactype,
DROP COLUMN cmauid,
DROP COLUMN cmapuid,
DROP COLUMN cmaname,
DROP COLUMN cmatype,
DROP COLUMN shape_leng,
DROP COLUMN shape_length,
DROP COLUMN shape_area;