-- script to generate hazard map mean
CREATE SCHEMA IF NOT EXISTS psra_{prov};

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_hcurves_pga CASCADE;

-- create table
CREATE TABLE psra_{prov}.psra_{prov}_hcurves_pga(
lon float,
lat float,
depth float,
"poe_0.0500000" float,
"poe_0.0637137" float,
"poe_0.0811888" float,
"poe_0.1034569" float,
"poe_0.1318325" float,
"poe_0.1679909" float,
"poe_0.2140666" float,
"poe_0.2727797" float,
"poe_0.3475964" float,
"poe_0.4429334" float,
"poe_0.5644189" float,
"poe_0.7192249" float,
"poe_0.9164904" float,
"poe_1.1678607" float,
"poe_1.4881757" float,
"poe_1.8963451" float,
"poe_2.4164651" float,
"poe_3.0792411" float,
"poe_3.9237999" float,
"poe_5.0000000" float

);

-- import exposure from csv
COPY psra_{prov}.psra_{prov}_hcurves_pga(lon,lat,depth,"poe_0.0500000" ,"poe_0.0637137" ,"poe_0.0811888" ,"poe_0.1034569" ,"poe_0.1318325" ,"poe_0.1679909" ,
"poe_0.2140666" ,"poe_0.2727797" ,"poe_0.3475964" ,"poe_0.4429334" ,"poe_0.5644189" ,"poe_0.7192249" ,"poe_0.9164904","poe_1.1678607" ,
"poe_1.4881757" ,"poe_1.8963451" ,"poe_2.4164651" ,"poe_3.0792411" ,"poe_3.9237999" ,"poe_5.0000000" )
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_pga.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;



-- script to generate hazard map mean
CREATE SCHEMA IF NOT EXISTS psra_{prov};

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_hcurves_sa0p1 CASCADE;

-- create table
CREATE TABLE psra_{prov}.psra_{prov}_hcurves_sa0p1(
lon float,
lat float,
depth float,
"poe_0.0500000" float,
"poe_0.0637137" float,
"poe_0.0811888" float,
"poe_0.1034569" float,
"poe_0.1318325" float,
"poe_0.1679909" float,
"poe_0.2140666" float,
"poe_0.2727797" float,
"poe_0.3475964" float,
"poe_0.4429334" float,
"poe_0.5644189" float,
"poe_0.7192249" float,
"poe_0.9164904" float,
"poe_1.1678607" float,
"poe_1.4881757" float,
"poe_1.8963451" float,
"poe_2.4164651" float,
"poe_3.0792411" float,
"poe_3.9237999" float,
"poe_5.0000000" float

);

-- import exposure from csv
COPY psra_{prov}.psra_{prov}_hcurves_Sa0p1(lon,lat,depth,"poe_0.0500000" ,"poe_0.0637137" ,"poe_0.0811888" ,"poe_0.1034569" ,"poe_0.1318325" ,"poe_0.1679909" ,
"poe_0.2140666" ,"poe_0.2727797" ,"poe_0.3475964" ,"poe_0.4429334" ,"poe_0.5644189" ,"poe_0.7192249" ,"poe_0.9164904","poe_1.1678607" ,
"poe_1.4881757" ,"poe_1.8963451" ,"poe_2.4164651" ,"poe_3.0792411" ,"poe_3.9237999" ,"poe_5.0000000" )
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p1.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;



-- script to generate hazard map mean
CREATE SCHEMA IF NOT EXISTS psra_{prov};

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_hcurves_sa0p2 CASCADE;

-- create table
CREATE TABLE psra_{prov}.psra_{prov}_hcurves_sa0p2(
lon float,
lat float,
depth float,
"poe_0.0500000" float,
"poe_0.0637137" float,
"poe_0.0811888" float,
"poe_0.1034569" float,
"poe_0.1318325" float,
"poe_0.1679909" float,
"poe_0.2140666" float,
"poe_0.2727797" float,
"poe_0.3475964" float,
"poe_0.4429334" float,
"poe_0.5644189" float,
"poe_0.7192249" float,
"poe_0.9164904" float,
"poe_1.1678607" float,
"poe_1.4881757" float,
"poe_1.8963451" float,
"poe_2.4164651" float,
"poe_3.0792411" float,
"poe_3.9237999" float,
"poe_5.0000000" float

);

-- import exposure from csv
COPY psra_{prov}.psra_{prov}_hcurves_sa0p2(lon,lat,depth,"poe_0.0500000" ,"poe_0.0637137" ,"poe_0.0811888" ,"poe_0.1034569" ,"poe_0.1318325" ,"poe_0.1679909" ,
"poe_0.2140666" ,"poe_0.2727797" ,"poe_0.3475964" ,"poe_0.4429334" ,"poe_0.5644189" ,"poe_0.7192249" ,"poe_0.9164904","poe_1.1678607" ,
"poe_1.4881757" ,"poe_1.8963451" ,"poe_2.4164651" ,"poe_3.0792411" ,"poe_3.9237999" ,"poe_5.0000000" )
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_sa0p2.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;



-- script to generate hazard map mean
CREATE SCHEMA IF NOT EXISTS psra_{prov};

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_hcurves_sa0p3 CASCADE;

-- create table
CREATE TABLE psra_{prov}.psra_{prov}_hcurves_sa0p3(
lon float,
lat float,
depth float,
"poe_0.0500000" float,
"poe_0.0637137" float,
"poe_0.0811888" float,
"poe_0.1034569" float,
"poe_0.1318325" float,
"poe_0.1679909" float,
"poe_0.2140666" float,
"poe_0.2727797" float,
"poe_0.3475964" float,
"poe_0.4429334" float,
"poe_0.5644189" float,
"poe_0.7192249" float,
"poe_0.9164904" float,
"poe_1.1678607" float,
"poe_1.4881757" float,
"poe_1.8963451" float,
"poe_2.4164651" float,
"poe_3.0792411" float,
"poe_3.9237999" float,
"poe_5.0000000" float

);

-- import exposure from csv
COPY psra_{prov}.psra_{prov}_hcurves_sa0p3(lon,lat,depth,"poe_0.0500000" ,"poe_0.0637137" ,"poe_0.0811888" ,"poe_0.1034569" ,"poe_0.1318325" ,"poe_0.1679909" ,
"poe_0.2140666" ,"poe_0.2727797" ,"poe_0.3475964" ,"poe_0.4429334" ,"poe_0.5644189" ,"poe_0.7192249" ,"poe_0.9164904","poe_1.1678607" ,
"poe_1.4881757" ,"poe_1.8963451" ,"poe_2.4164651" ,"poe_3.0792411" ,"poe_3.9237999" ,"poe_5.0000000" )
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_sa0p3.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;



-- script to generate hazard map mean
CREATE SCHEMA IF NOT EXISTS psra_{prov};

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_hcurves_sa0p5 CASCADE;

-- create table
CREATE TABLE psra_{prov}.psra_{prov}_hcurves_sa0p5(
lon float,
lat float,
depth float,
"poe-0.0500000" float,
"poe-0.0658662" float,
"poe-0.0867671" float,
"poe-0.1143003" float,
"poe-0.1505706" float,
"poe-0.1983502" float,
"poe-0.2612914" float,
"poe-0.3442054" float,
"poe-0.4534299" float,
"poe-0.5973140" float,
"poe-0.7868559" float,
"poe-1.0365439" float,
"poe-1.3654639" float,
"poe-1.7987580" float,
"poe-2.3695466" float,
"poe-3.1214600" float,
"poe-4.1119734" float,
"poe-5.4168002" float,
"poe-7.1356795" float,
"poe-9.4000000" float

);

-- import exposure from csv
COPY psra_{prov}.psra_{prov}_hcurves_sa0p5(lon,lat,depth,"poe-0.0500000","poe-0.0658662","poe-0.0867671","poe-0.1143003","poe-0.1505706","poe-0.1983502",
"poe-0.2612914","poe-0.3442054","poe-0.4534299","poe-0.5973140","poe-0.7868559","poe-1.0365439","poe-1.3654639","poe-1.7987580","poe-2.3695466",
"poe-3.1214600","poe-4.1119734","poe-5.4168002","poe-7.1356795","poe-9.4000000" )
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_sa0p5.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;



-- script to generate hazard map mean
CREATE SCHEMA IF NOT EXISTS psra_{prov};

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_hcurves_sa0p6 CASCADE;

-- create table
CREATE TABLE psra_{prov}.psra_{prov}_hcurves_sa0p6(
lon float,
lat float,
depth float,
"poe-0.0500000" float,
"poe-0.0658662" float,
"poe-0.0867671" float,
"poe-0.1143003" float,
"poe-0.1505706" float,
"poe-0.1983502" float,
"poe-0.2612914" float,
"poe-0.3442054" float,
"poe-0.4534299" float,
"poe-0.5973140" float,
"poe-0.7868559" float,
"poe-1.0365439" float,
"poe-1.3654639" float,
"poe-1.7987580" float,
"poe-2.3695466" float,
"poe-3.1214600" float,
"poe-4.1119734" float,
"poe-5.4168002" float,
"poe-7.1356795" float,
"poe-9.4000000" float

);

-- import exposure from csv
COPY psra_{prov}.psra_{prov}_hcurves_sa0p6(lon,lat,depth,"poe-0.0500000","poe-0.0658662","poe-0.0867671","poe-0.1143003","poe-0.1505706","poe-0.1983502",
"poe-0.2612914","poe-0.3442054","poe-0.4534299","poe-0.5973140","poe-0.7868559","poe-1.0365439","poe-1.3654639","poe-1.7987580","poe-2.3695466",
"poe-3.1214600","poe-4.1119734","poe-5.4168002","poe-7.1356795","poe-9.4000000" )
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_sa0p6.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;



-- script to generate hazard map mean
CREATE SCHEMA IF NOT EXISTS psra_{prov};

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_hcurves_sa1p0 CASCADE;

-- create table
CREATE TABLE psra_{prov}.psra_{prov}_hcurves_sa1p0(
lon float,
lat float,
depth float,
"poe_0.0500000" float,
"poe_0.0637137" float,
"poe_0.0811888" float,
"poe_0.1034569" float,
"poe_0.1318325" float,
"poe_0.1679909" float,
"poe_0.2140666" float,
"poe_0.2727797" float,
"poe_0.3475964" float,
"poe_0.4429334" float,
"poe_0.5644189" float,
"poe_0.7192249" float,
"poe_0.9164904" float,
"poe_1.1678607" float,
"poe_1.4881757" float,
"poe_1.8963451" float,
"poe_2.4164651" float,
"poe_3.0792411" float,
"poe_3.9237999" float,
"poe_5.0000000" float

);

-- import exposure from csv
COPY psra_{prov}.psra_{prov}_hcurves_sa1p0(lon,lat,depth,"poe_0.0500000" ,"poe_0.0637137" ,"poe_0.0811888" ,"poe_0.1034569" ,"poe_0.1318325" ,"poe_0.1679909" ,
"poe_0.2140666" ,"poe_0.2727797" ,"poe_0.3475964" ,"poe_0.4429334" ,"poe_0.5644189" ,"poe_0.7192249" ,"poe_0.9164904","poe_1.1678607" ,
"poe_1.4881757" ,"poe_1.8963451" ,"poe_2.4164651" ,"poe_3.0792411" ,"poe_3.9237999" ,"poe_5.0000000" )
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_sa1p0.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;



-- script to generate hazard map mean
CREATE SCHEMA IF NOT EXISTS psra_{prov};

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_hcurves_sa2p0 CASCADE;

-- create table
CREATE TABLE psra_{prov}.psra_{prov}_hcurves_sa2p0(
lon float,
lat float,
depth float,
"poe_0.0500000" float,
"poe_0.0637137" float,
"poe_0.0811888" float,
"poe_0.1034569" float,
"poe_0.1318325" float,
"poe_0.1679909" float,
"poe_0.2140666" float,
"poe_0.2727797" float,
"poe_0.3475964" float,
"poe_0.4429334" float,
"poe_0.5644189" float,
"poe_0.7192249" float,
"poe_0.9164904" float,
"poe_1.1678607" float,
"poe_1.4881757" float,
"poe_1.8963451" float,
"poe_2.4164651" float,
"poe_3.0792411" float,
"poe_3.9237999" float,
"poe_5.0000000" float

);

-- import exposure from csv
COPY psra_{prov}.psra_{prov}_hcurves_sa2p0(lon,lat,depth,"poe_0.0500000" ,"poe_0.0637137" ,"poe_0.0811888" ,"poe_0.1034569" ,"poe_0.1318325" ,"poe_0.1679909" ,
"poe_0.2140666" ,"poe_0.2727797" ,"poe_0.3475964" ,"poe_0.4429334" ,"poe_0.5644189" ,"poe_0.7192249" ,"poe_0.9164904","poe_1.1678607" ,
"poe_1.4881757" ,"poe_1.8963451" ,"poe_2.4164651" ,"poe_3.0792411" ,"poe_3.9237999" ,"poe_5.0000000" )
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_sa2p0.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;



-- script to generate hazard map mean
CREATE SCHEMA IF NOT EXISTS psra_{prov};

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_hmaps CASCADE;

-- create table
CREATE TABLE psra_{prov}.psra_{prov}_hmaps(
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
COPY psra_{prov}.psra_{prov}_hmaps(lon,lat,"PGA_0.02","PGA_0.1","SA(0.1)_0.02","SA(0.1)_0.1","SA(0.2)_0.02","SA(0.2)_0.1","SA(0.3)_0.02","SA(0.3)_0.1","SA(0.5)_0.02","SA(0.5)_0.1","SA(0.6)_0.02","SA(0.6)_0.1","SA(1.0)_0.02","SA(1.0)_0.1","SA(10.0)_0.02","SA(10.0)_0.1","SA(2.0)_0.02","SA(2.0)_0.1","SA(5.0)_0.02","SA(5.0)_0.1")
    FROM 'D:\Workspace\data\psra_new_datasets\1_cHazard\{prov}\cH_{prov}_hmaps.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;

-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE psra_{prov}.psra_{prov}_hmaps ADD COLUMN geom geometry(Point,4326);
UPDATE psra_{prov}.psra_{prov}_hmaps SET geom = st_setsrid(st_makepoint(lon,lat),4326);

-- create spatial index
CREATE INDEX {prov}_hmaps_idx
ON psra_{prov}.psra_{prov}_hmaps using GIST (geom);


-- removed for automation purposes, reintroduce after finalized chazard maps and generate xref create tables.
/* 
DROP TABLE IF EXISTS psra_{prov}.exposure_{prov} CASCADE;

CREATE TABLE psra_{prov}.exposure_{prov} AS
(
SELECT id,
sauid,
sauidlon,
sauidlat,
geom

FROM exposure.canada_exposure 
WHERE PRUID = '59'
);
*/

-- attach assetID to hazard mean map based on closest location
DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_hmaps_xref CASCADE;

CREATE TABLE psra_{prov}.psra_{prov}_hmaps_xref AS
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

--FROM psra_{prov}.exposure_{prov} a
FROM exposure.canada_exposure a
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

FROM psra_{prov}.psra_{prov}_hmaps
ORDER BY a.geom <-> geom
LIMIT 1
) AS b;

DROP TABLE IF EXISTS psra_{prov}.exposure_{prov};



-- script to generate hazard map mean
CREATE SCHEMA IF NOT EXISTS psra_{prov};

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_uhs CASCADE;

-- create table
CREATE TABLE psra_{prov}.psra_{prov}_uhs(
lon float,
lat float,
"0.02_PGA" float,
"0.02_SA(0.1)" float,
"0.02_SA(0.2)" float,
"0.02_SA(0.3)" float,
"0.02_SA(0.5)" float,
"0.02_SA(0.6)" float,
"0.02_SA(1.0)" float,
"0.02_SA(10.0)" float,
"0.02_SA(2.0)" float,
"0.02_SA(5.0)" float,
"0.1_PGA" float,
"0.1_SA(0.1)" float,
"0.1_SA(0.2)" float,
"0.1_SA(0.3)" float,
"0.1_SA(0.5)" float,
"0.1_SA(0.6)" float,
"0.1_SA(1.0)" float,
"0.1_SA(10.0)" float,
"0.1_SA(2.0)" float,
"0.1_SA(5.0)" float

);

-- import exposure from csv
COPY psra_{prov}.psra_{prov}_uhs(lon,lat,"0.02_PGA","0.02_SA(0.1)","0.02_SA(0.2)","0.02_SA(0.3)","0.02_SA(0.5)","0.02_SA(0.6)","0.02_SA(1.0)","0.02_SA(10.0)",
"0.02_SA(2.0)","0.02_SA(5.0)","0.1_PGA","0.1_SA(0.1)","0.1_SA(0.2)","0.1_SA(0.3)","0.1_SA(0.5)","0.1_SA(0.6)","0.1_SA(1.0)","0.1_SA(10.0)","0.1_SA(2.0)",
"0.1_SA(5.0)" )
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_uhs.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;