-- script to generate Canada exposure table

DROP TABLE IF EXISTS exposure.canada_exposure;

-- create table
CREATE TABLE exposure.canada_exposure(
    PRIMARY KEY (id),
    ---OID varchar,
    id varchar,
    lon float,
    lat float,
    taxonomy varchar,
    number float,
    structural float,
    nonstructural float,
    contents float,
    day float,
    night float,
    transit float,
    landusetyp varchar,
    GenOcc varchar,
    hzOccType varchar,
    eqOccType varchar,
    BldgGen varchar,
    hzTaxon varchar,
    EqBldgType varchar,
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
    pruid varchar,
    prname varchar,
    ername varchar

);

-- import exposure from csv
-- COPY exposure.canada_exposure (OID,id, lon, lat, taxonomy, number, structural, nonstructural, contents, day, night, transit, landusetyp, GenOcc, hzOccType, eqOccType, BldgGen, hzTaxon, EqBldgType, EqDesLev, sauid, dauid, adauid, fsauid, csduid, csdname, cduid, cdname, SAC, pruid, prname, ername)
COPY exposure.canada_exposure (id, lon, lat, taxonomy, number, structural, nonstructural, contents, day, night, transit, landusetyp, GenOcc, hzOccType, eqOccType, BldgGen, hzTaxon, EqBldgType, EqDesLev, sauid, dauid, adauid, fsauid, csduid, csdname, cduid, cdname, SAC, pruid, prname, ername)
    FROM '/usr/src/app/BldgExp_Canada.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;


-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE exposure.canada_exposure ADD COLUMN geom geometry(Point,4326);
UPDATE exposure.canada_exposure SET geom = st_setsrid(st_makepoint(lon,lat),4326);

-- create spatial index
CREATE INDEX Canada_exposure_idx
ON exposure.canada_exposure using GIST (geom);

--remove trailing space from 'manufactured ' in bldggen
UPDATE exposure.bldgexp_canada 
SET bldggen = REPLACE(bldggen,'Manufactured ','Manufactured')
WHERE bldggen = 'Manufactured '
