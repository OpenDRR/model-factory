
-- version 3 replaces previous version, methodology and data changes.  Name kept the same to keep scripts from running.
DROP TABLE IF EXISTS mh.mh_intensity_canada CASCADE;

-- create table
CREATE TABLE mh.mh_intensity_canada(
    PRIMARY KEY(sauidt),
    sauidt varchar,
    lon float,
    lat float,
    pgv2500 float,
    pgv500 float,
    pga2500 float,
    pga500 float,
    vs30 float,
    mmi6 float,
    mmi7 float,
    mmi8 float,
    tsun500 float,
    fld200 float,
    fld500 float,
    fld1000 float,
    wildfire float,
    lndsus float,
    cy100 float,
    cy250 float,
    cy500 float,
    cy1000 float
);

/*
-- import exposure from csv
COPY mh.mh_intensity_canada(sauidt,lon,lat,pgv2500,pgv500,pga2500,pga500,vs30,mmi6,mmi7,mmi8,tsun500,fld200,fld500,fld1000,wildfire,lndsus,cy100,cy250,cy500,cy1000)
    FROM 'D:\Workspace\data\source datasets\mh\hazard-intensity_sauid.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;

-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE mh.mh_intensity_canada ADD COLUMN geom geometry(Point,4326);
UPDATE mh.mh_intensity_canada SET geom = st_setsrid(st_makepoint(lon,lat),4326);

-- create index
CREATE INDEX IF NOT EXISTS mh_intensity_canada_idx ON mh.mh_intensity_canada using GIST(geom);
CREATE INDEX IF NOT EXISTS mh_intensity_canada_sauid_idx ON mh.mh_intensity_canada(sauidt);
*/