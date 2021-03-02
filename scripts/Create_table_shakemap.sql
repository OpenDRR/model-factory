-- script to generate shakemap table
DROP TABLE IF EXISTS gmf.shakemap_{eqScenario} CASCADE;

-- create table
CREATE TABLE gmf.shakemap_{eqScenario}
(
    site_id varchar,
    gmv_PGA float,
    gmv_PGV float,
    "gmv_SA(0.1)" float,
    "gmv_SA(0.2)" float,
    "gmv_SA(0.3)" float,
    "gmv_SA(0.5)" float,
    "gmv_SA(0.6)" float,
    "gmv_SA(1.0)" float,
    "gmv_SA(2.0)" float,
    lon float,
    lat float
    
);
/*
-- import exposure from csv
COPY gmf.shakemap_{eqScenario} ({headerFields})
    FROM '/usr/src/app/{shakemapFile}'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;


-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE gmf.shakemap_{eqScenario} ADD COLUMN geom geometry(Point,4326);
UPDATE gmf.shakemap_{eqScenario} SET geom = st_setsrid(st_makepoint(lon,lat),4326);

-- create spatial index
CREATE INDEX shakemap_{eqScenario}_idx
ON gmf.shakemap_{eqScenario} using GIST (geom);
*/