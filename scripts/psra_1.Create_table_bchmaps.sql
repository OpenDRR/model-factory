-- script to generate hazard map mean
CREATE SCHEMA IF NOT EXISTS psra_bc;

DROP TABLE IF EXISTS psra_bc.psra_bc_hmaps CASCADE;

-- create table
CREATE TABLE psra_bc.psra_bc_hmaps(
lon float,
lat float,
"PGA_0.02" float,
"PGA_0.1" float,
"SA(0.1)_0.02" float,
"SA(0.1)_0.1" float,
"SA(0.2)_0.02" float,
"SA(0.2)_0.1" float,
"SA(0.3)_0.02" float,
"SA(0.3)_0.1" float,
"SA(0.5)_0.02" float,
"SA(0.5)_0.1" float,
"SA(0.6)_0.02" float,
"SA(0.6)_0.1" float,
"SA(1.0)_0.02" float,
"SA(1.0)_0.1" float,
"SA(10.0)_0.02" float,
"SA(10.0)_0.1" float,
"SA(2.0)_0.02" float,
"SA(2.0)_0.1" float,
"SA(5.0)_0.02" float,
"SA(5.0)_0.1" float
);

-- import exposure from csv
COPY psra_bc.psra_bc_hmaps(lon,lat,"PGA_0.02","PGA_0.1","SA(0.1)_0.02","SA(0.1)_0.1","SA(0.2)_0.02","SA(0.2)_0.1","SA(0.3)_0.02","SA(0.3)_0.1","SA(0.5)_0.02","SA(0.5)_0.1","SA(0.6)_0.02","SA(0.6)_0.1","SA(1.0)_0.02","SA(1.0)_0.1","SA(10.0)_0.02","SA(10.0)_0.1","SA(2.0)_0.02","SA(2.0)_0.1","SA(5.0)_0.02","SA(5.0)_0.1")
    FROM '/usr/src/app/chazard/bc/cH_BC_hmaps.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;

-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE psra_bc.psra_bc_hmaps ADD COLUMN geom geometry(Point,4326);
UPDATE psra_bc.psra_bc_hmaps SET geom = st_setsrid(st_makepoint(lon,lat),4326);

-- create spatial index
CREATE INDEX bc_hmaps_idx
ON psra_bc.psra_bc_hmaps using GIST (geom);


DROP TABLE IF EXISTS psra_bc.exposure_bc CASCADE;

CREATE TABLE psra_bc.exposure_bc AS
(
SELECT id,
sauid,
sauidlon,
sauidlat,
geom

FROM exposure.canada_exposure 
WHERE PRUID = '59'
);

-- attach assetID to hazard mean map based on closest location
DROP TABLE IF EXISTS psra_bc.psra_bc_hmaps_xref CASCADE;

CREATE TABLE psra_bc.psra_bc_hmaps_xref AS
SELECT
a.id,
a.sauid,
a.sauidlon AS "asset_lon",
a.sauidlat AS "asset_lat",
b.lon,
b.lat,
ST_Distance(a.geom,b.geom) AS "distance",
b."PGA_0.02",
b."PGA_0.1",
b."SA(0.1)_0.02",
b."SA(0.1)_0.1",
b."SA(0.2)_0.02",
b."SA(0.2)_0.1",
b."SA(0.3)_0.02",
b."SA(0.3)_0.1",
b."SA(0.5)_0.02",
b."SA(0.5)_0.1",
b."SA(0.6)_0.02",
b."SA(0.6)_0.1",
b."SA(1.0)_0.02",
b."SA(1.0)_0.1",
b."SA(10.0)_0.02",
b."SA(10.0)_0.1",
b."SA(2.0)_0.02",
b."SA(2.0)_0.1",
b."SA(5.0)_0.02",
b."SA(5.0)_0.1"

FROM psra_bc.exposure_bc a
CROSS JOIN LATERAL 
(
SELECT 
lon,
lat,
"PGA_0.02",
"PGA_0.1",
"SA(0.1)_0.02",
"SA(0.1)_0.1",
"SA(0.2)_0.02",
"SA(0.2)_0.1",
"SA(0.3)_0.02",
"SA(0.3)_0.1",
"SA(0.5)_0.02",
"SA(0.5)_0.1",
"SA(0.6)_0.02",
"SA(0.6)_0.1",
"SA(1.0)_0.02",
"SA(1.0)_0.1",
"SA(10.0)_0.02",
"SA(10.0)_0.1",
"SA(2.0)_0.02",
"SA(2.0)_0.1",
"SA(5.0)_0.02",
"SA(5.0)_0.1",
geom

FROM psra_bc.psra_bc_hmaps
ORDER BY a.geom <-> geom
LIMIT 1
) AS b;

DROP TABLE IF EXISTS psra_bc.exposure_bc;