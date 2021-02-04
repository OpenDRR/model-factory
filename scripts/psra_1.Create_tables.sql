/* psra_1.Create_table_chazard_ALL.sql */
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

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_hcurves_pga(lon,lat,depth,"poe_0.0500000" ,"poe_0.0637137" ,"poe_0.0811888" ,"poe_0.1034569" ,"poe_0.1318325" ,"poe_0.1679909" ,
"poe_0.2140666" ,"poe_0.2727797" ,"poe_0.3475964" ,"poe_0.4429334" ,"poe_0.5644189" ,"poe_0.7192249" ,"poe_0.9164904","poe_1.1678607" ,
"poe_1.4881757" ,"poe_1.8963451" ,"poe_2.4164651" ,"poe_3.0792411" ,"poe_3.9237999" ,"poe_5.0000000" )
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_PGA.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;
*/


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

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_hcurves_Sa0p1(lon,lat,depth,"poe_0.0500000" ,"poe_0.0637137" ,"poe_0.0811888" ,"poe_0.1034569" ,"poe_0.1318325" ,"poe_0.1679909" ,
"poe_0.2140666" ,"poe_0.2727797" ,"poe_0.3475964" ,"poe_0.4429334" ,"poe_0.5644189" ,"poe_0.7192249" ,"poe_0.9164904","poe_1.1678607" ,
"poe_1.4881757" ,"poe_1.8963451" ,"poe_2.4164651" ,"poe_3.0792411" ,"poe_3.9237999" ,"poe_5.0000000" )
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p1.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;
*/


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

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_hcurves_sa0p2(lon,lat,depth,"poe_0.0500000" ,"poe_0.0637137" ,"poe_0.0811888" ,"poe_0.1034569" ,"poe_0.1318325" ,"poe_0.1679909" ,
"poe_0.2140666" ,"poe_0.2727797" ,"poe_0.3475964" ,"poe_0.4429334" ,"poe_0.5644189" ,"poe_0.7192249" ,"poe_0.9164904","poe_1.1678607" ,
"poe_1.4881757" ,"poe_1.8963451" ,"poe_2.4164651" ,"poe_3.0792411" ,"poe_3.9237999" ,"poe_5.0000000" )
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p2.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;
*/


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

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_hcurves_sa0p3(lon,lat,depth,"poe_0.0500000" ,"poe_0.0637137" ,"poe_0.0811888" ,"poe_0.1034569" ,"poe_0.1318325" ,"poe_0.1679909" ,
"poe_0.2140666" ,"poe_0.2727797" ,"poe_0.3475964" ,"poe_0.4429334" ,"poe_0.5644189" ,"poe_0.7192249" ,"poe_0.9164904","poe_1.1678607" ,
"poe_1.4881757" ,"poe_1.8963451" ,"poe_2.4164651" ,"poe_3.0792411" ,"poe_3.9237999" ,"poe_5.0000000" )
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p3.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;
*/


-- script to generate hazard map mean
CREATE SCHEMA IF NOT EXISTS psra_{prov};

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_hcurves_sa0p5 CASCADE;

-- create table
CREATE TABLE psra_{prov}.psra_{prov}_hcurves_sa0p5(
lon float,
lat float,
depth float,
"poe_0.0500000" float,
"poe_0.0658662" float,
"poe_0.0867671" float,
"poe_0.1143003" float,
"poe_0.1505706" float,
"poe_0.1983502" float,
"poe_0.2612914" float,
"poe_0.3442054" float,
"poe_0.4534299" float,
"poe_0.5973140" float,
"poe_0.7868559" float,
"poe_1.0365439" float,
"poe_1.3654639" float,
"poe_1.7987580" float,
"poe_2.3695466" float,
"poe_3.1214600" float,
"poe_4.1119734" float,
"poe_5.4168002" float,
"poe_7.1356795" float,
"poe_9.4000000" float

);

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_hcurves_sa0p5(lon,lat,depth,"poe_0.0500000","poe_0.0658662","poe_0.0867671","poe_0.1143003","poe_0.1505706","poe_0.1983502",
"poe_0.2612914","poe_0.3442054","poe_0.4534299","poe_0.5973140","poe_0.7868559","poe_1.0365439","poe_1.3654639","poe_1.7987580","poe_2.3695466",
"poe_3.1214600","poe_4.1119734","poe_5.4168002","poe_7.1356795","poe_9.4000000" )
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p5.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;
*/


-- script to generate hazard map mean
CREATE SCHEMA IF NOT EXISTS psra_{prov};

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_hcurves_sa0p6 CASCADE;

-- create table
CREATE TABLE psra_{prov}.psra_{prov}_hcurves_sa0p6(
lon float,
lat float,
depth float,
"poe_0.0500000" float,
"poe_0.0658662" float,
"poe_0.0867671" float,
"poe_0.1143003" float,
"poe_0.1505706" float,
"poe_0.1983502" float,
"poe_0.2612914" float,
"poe_0.3442054" float,
"poe_0.4534299" float,
"poe_0.5973140" float,
"poe_0.7868559" float,
"poe_1.0365439" float,
"poe_1.3654639" float,
"poe_1.7987580" float,
"poe_2.3695466" float,
"poe_3.1214600" float,
"poe_4.1119734" float,
"poe_5.4168002" float,
"poe_7.1356795" float,
"poe_9.4000000" float

);

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_hcurves_sa0p6(lon,lat,depth,"poe_0.0500000","poe_0.0658662","poe_0.0867671","poe_0.1143003","poe_0.1505706","poe_0.1983502",
"poe_0.2612914","poe_0.3442054","poe_0.4534299","poe_0.5973140","poe_0.7868559","poe_1.0365439","poe_1.3654639","poe_1.7987580","poe_2.3695466",
"poe_3.1214600","poe_4.1119734","poe_5.4168002","poe_7.1356795","poe_9.4000000" )
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa0p6.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;
*/


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

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_hcurves_sa1p0(lon,lat,depth,"poe_0.0500000" ,"poe_0.0637137" ,"poe_0.0811888" ,"poe_0.1034569" ,"poe_0.1318325" ,"poe_0.1679909" ,
"poe_0.2140666" ,"poe_0.2727797" ,"poe_0.3475964" ,"poe_0.4429334" ,"poe_0.5644189" ,"poe_0.7192249" ,"poe_0.9164904","poe_1.1678607" ,
"poe_1.4881757" ,"poe_1.8963451" ,"poe_2.4164651" ,"poe_3.0792411" ,"poe_3.9237999" ,"poe_5.0000000" )
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa1p0.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;
*/


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

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_hcurves_sa2p0(lon,lat,depth,"poe_0.0500000" ,"poe_0.0637137" ,"poe_0.0811888" ,"poe_0.1034569" ,"poe_0.1318325" ,"poe_0.1679909" ,
"poe_0.2140666" ,"poe_0.2727797" ,"poe_0.3475964" ,"poe_0.4429334" ,"poe_0.5644189" ,"poe_0.7192249" ,"poe_0.9164904","poe_1.1678607" ,
"poe_1.4881757" ,"poe_1.8963451" ,"poe_2.4164651" ,"poe_3.0792411" ,"poe_3.9237999" ,"poe_5.0000000" )
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hcurves_Sa2p0.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;
*/


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

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_hmaps({hmapColumns})
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_hmaps.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;

-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE psra_{prov}.psra_{prov}_hmaps ADD COLUMN geom geometry(Point,4326);
UPDATE psra_{prov}.psra_{prov}_hmaps SET geom = st_setsrid(st_makepoint(lon,lat),4326);

-- create spatial index
CREATE INDEX {prov}_hmaps_idx
ON psra_{prov}.psra_{prov}_hmaps using GIST (geom);
*/

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
/*
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
*/


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

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_uhs({uhsColumns})
    FROM '/usr/src/app/cHazard/{prov}/cH_{prov}_uhs.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;
*/



/* psra_2.Create_table_dmg_mean.sql */
-- script to generate cd/ed structural mean - b0, r2
DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_cd_dmg_mean_b0, psra_{prov}.psra_{prov}_cd_dmg_mean_r2, psra_{prov}.psra_{prov}_cd_dmg_mean, psra_{prov}.psra_{prov}_ed_dmg_mean_b0, psra_{prov}.psra_{prov}_ed_dmg_mean_r2,
psra_{prov}.psra_{prov}_ed_dmg_mean CASCADE;

-- create cd table b0
CREATE TABLE psra_{prov}.psra_{prov}_cd_dmg_mean_b0(
PRIMARY KEY (asset_id),
asset_id varchar, 
"BldEpoch" varchar,
"BldgType" varchar,
"EqDesLev" varchar, 
"GenOcc" varchar, 
"GenType" varchar,
"LandUse" varchar, 
"OccClass" varchar,
"SAC" varchar, 
"SSC_Zone" varchar,
"SauidID" varchar,
adauid varchar, 
cdname varchar, 
cduid varchar,
csdname varchar, 
csduid varchar,
dauid varchar, 
ername varchar,
eruid varchar,
fsauid varchar, 
prname varchar, 
pruid varchar,
sauid varchar, 
taxonomy varchar, 
lon float, 
lat float, 
structural_no_damage float, 
structural_slight float, 
structural_moderate float, 
structural_extensive float, 
structural_complete float
);

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_cd_dmg_mean_b0(asset_id,"BldEpoch","BldgType","EqDesLev","GenOcc","GenType","LandUse","OccClass","SAC","SSC_Zone","SauidID",adauid,cdname,cduid,csdname,csduid,dauid,ername,eruid,fsauid,prname,
pruid,sauid,taxonomy,lon,lat,structural_no_damage,structural_slight,structural_moderate,structural_extensive,structural_complete)
    FROM '/usr/src/app/cDamage/{prov}/cD_{prov}_dmg-mean_b0.csv'
        WITH 
          DELIMITER AS ','
          CSV ;
*/

-- create cd table r2
CREATE TABLE psra_{prov}.psra_{prov}_cd_dmg_mean_r2(
PRIMARY KEY (asset_id),
asset_id varchar, 
"BldEpoch" varchar,
"BldgType" varchar,
"EqDesLev" varchar, 
"GenOcc" varchar, 
"GenType" varchar,
"LandUse" varchar, 
"OccClass" varchar,
"SAC" varchar, 
"SSC_Zone" varchar,
"SauidID" varchar,
adauid varchar, 
cdname varchar, 
cduid varchar,
csdname varchar, 
csduid varchar,
dauid varchar, 
ername varchar,
eruid varchar,
fsauid varchar, 
prname varchar, 
pruid varchar,
sauid varchar, 
taxonomy varchar, 
lon float, 
lat float, 
structural_no_damage float, 
structural_slight float, 
structural_moderate float, 
structural_extensive float, 
structural_complete float
);

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_cd_dmg_mean_r2(asset_id,"BldEpoch","BldgType","EqDesLev","GenOcc","GenType","LandUse","OccClass","SAC","SSC_Zone","SauidID",adauid,cdname,cduid,csdname,csduid,dauid,ername,eruid,fsauid,prname,
pruid,sauid,taxonomy,lon,lat,structural_no_damage,structural_slight,structural_moderate,structural_extensive,structural_complete)
    FROM '/usr/src/app/cDamage/{prov}/cD_{prov}_dmg-mean_r2.csv'
        WITH 
          DELIMITER AS ','
          CSV ;
*/

-- combine cd b0 and r2 table
CREATE TABLE psra_{prov}.psra_{prov}_cd_dmg_mean AS
(SELECT
a.asset_id,
a."BldEpoch",
a."BldgType",
a."EqDesLev",
a."GenOcc",
a."GenType",
a."LandUse",
a."OccClass",
a."SAC",
a."SSC_Zone",
a."SauidID",
a.adauid,
a.cdname,
a.cduid,
a.csdname,
a.csduid,
a.dauid,
a.ername,
a.eruid,
a.fsauid,
a.prname,
a.pruid,
a.sauid,
a.taxonomy,
a.lon,
a.lat,
a.structural_no_damage AS "structural_no_damage_b0",
a.structural_slight AS "structural_slight_b0",
a.structural_moderate AS "structural_moderate_b0",
a.structural_extensive AS "structural_extensive_b0",
a.structural_complete AS "structural_complete_b0",
b.structural_no_damage AS "structural_no_damage_r2",
b.structural_slight AS "structural_slight_r2",
b.structural_moderate AS "structural_moderate_r2",
b.structural_extensive AS "structural_extensive_r2",
b.structural_complete AS "structural_complete_r2"

FROM psra_{prov}.psra_{prov}_cd_dmg_mean_b0 a
INNER JOIN psra_{prov}.psra_{prov}_cd_dmg_mean_r2 b ON a.asset_id = b.asset_id
);

ALTER TABLE psra_{prov}.psra_{prov}_cd_dmg_mean ADD PRIMARY KEY (asset_id);


-- create ed table b0
CREATE TABLE psra_{prov}.psra_{prov}_ed_dmg_mean_b0(
PRIMARY KEY (asset_id),
asset_id varchar, 
"BldEpoch" varchar,
"BldgType" varchar,
"EqDesLev" varchar, 
"GenOcc" varchar, 
"GenType" varchar,
"LandUse" varchar, 
"OccClass" varchar,
"SAC" varchar, 
"SSC_Zone" varchar,
"SauidID" varchar,
adauid varchar, 
cdname varchar, 
cduid varchar,
csdname varchar, 
csduid varchar,
dauid varchar, 
ername varchar,
eruid varchar,
fsauid varchar, 
prname varchar, 
pruid varchar,
sauid varchar, 
taxonomy varchar, 
lon float, 
lat float, 
structural_no_damage float, 
structural_slight float, 
structural_moderate float, 
structural_extensive float, 
structural_complete float
);

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_ed_dmg_mean_b0(asset_id,"BldEpoch","BldgType","EqDesLev","GenOcc","GenType","LandUse","OccClass","SAC","SSC_Zone","SauidID",adauid,cdname,cduid,csdname,csduid,dauid,ername,eruid,fsauid,prname,
pruid,sauid,taxonomy,lon,lat,structural_no_damage,structural_slight,structural_moderate,structural_extensive,structural_complete)
    FROM '/usr/src/app/eDamage/{prov}/eD_{prov}_damages-mean_b0.csv'
        WITH 
          DELIMITER AS ','
          CSV ;
*/

-- create cd table r2
CREATE TABLE psra_{prov}.psra_{prov}_ed_dmg_mean_r2(
PRIMARY KEY (asset_id),
asset_id varchar, 
"BldEpoch" varchar,
"BldgType" varchar,
"EqDesLev" varchar, 
"GenOcc" varchar, 
"GenType" varchar,
"LandUse" varchar, 
"OccClass" varchar,
"SAC" varchar, 
"SSC_Zone" varchar,
"SauidID" varchar,
adauid varchar, 
cdname varchar, 
cduid varchar,
csdname varchar, 
csduid varchar,
dauid varchar, 
ername varchar,
eruid varchar,
fsauid varchar, 
prname varchar, 
pruid varchar,
sauid varchar, 
taxonomy varchar, 
lon float, 
lat float, 
structural_no_damage float, 
structural_slight float, 
structural_moderate float, 
structural_extensive float, 
structural_complete float
);

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_ed_dmg_mean_r2(asset_id,"BldEpoch","BldgType","EqDesLev","GenOcc","GenType","LandUse","OccClass","SAC","SSC_Zone","SauidID",adauid,cdname,cduid,csdname,csduid,dauid,ername,eruid,fsauid,prname,
pruid,sauid,taxonomy,lon,lat,structural_no_damage,structural_slight,structural_moderate,structural_extensive,structural_complete)
    FROM '/usr/src/app/eDamage/{prov}/eD_{prov}_damages-mean_r2.csv'
        WITH 
          DELIMITER AS ','
          CSV ;


-- combine ed b0 and r2 table
CREATE TABLE psra_{prov}.psra_{prov}_ed_dmg_mean AS
(SELECT
a.asset_id,
a."BldEpoch",
a."BldgType",
a."EqDesLev",
a."GenOcc",
a."GenType",
a."LandUse",
a."OccClass",
a."SAC",
a."SSC_Zone",
a."SauidID",
a.adauid,
a.cdname,
a.cduid,
a.csdname,
a.csduid,
a.dauid,
a.ername,
a.eruid,
a.fsauid,
a.prname,
a.pruid,
a.sauid,
a.taxonomy,
a.lon,
a.lat,
a.structural_no_damage AS "structural_no_damage_b0",
a.structural_slight AS "structural_slight_b0",
a.structural_moderate AS "structural_moderate_b0",
a.structural_extensive AS "structural_extensive_b0",
a.structural_complete AS "structural_complete_b0",
b.structural_no_damage AS "structural_no_damage_r2",
b.structural_slight AS "structural_slight_r2",
b.structural_moderate AS "structural_moderate_r2",
b.structural_extensive AS "structural_extensive_r2",
b.structural_complete AS "structural_complete_r2"

FROM psra_{prov}.psra_{prov}_ed_dmg_mean_b0 a
INNER JOIN psra_{prov}.psra_{prov}_ed_dmg_mean_r2 b ON a.asset_id = b.asset_id
);

ALTER TABLE psra_{prov}.psra_{prov}_ed_dmg_mean ADD PRIMARY KEY (asset_id);

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_cd_dmg_mean_b0, psra_{prov}.psra_{prov}_cd_dmg_mean_r2, psra_{prov}.psra_{prov}_ed_dmg_mean_b0, psra_{prov}.psra_{prov}_ed_dmg_mean_r2 CASCADE;

*/


/* psra_3.Create_table_agg_curves_stats.sql */
-- script to agg curves stats
DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_agg_curves_stats_b0, psra_{prov}.psra_{prov}_agg_curves_stats_r2, psra_{prov}.psra_{prov}_agg_curves_stats CASCADE;

-- create table
CREATE TABLE psra_{prov}.psra_{prov}_agg_curves_stats_b0(
return_period varchar,
stat varchar,
loss_type varchar,
fsauid varchar,
"GenOcc" varchar,
"GenType" varchar,
loss_value float,
loss_ratio float,
annual_frequency_of_exceedence float
);

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_agg_curves_stats_b0(return_period,stat,loss_type,fsauid,"GenOcc","GenType",loss_value,loss_ratio,annual_frequency_of_exceedence)
    FROM '/usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-stats_b0.csv'
        WITH 
          DELIMITER AS ','
          CSV ;
*/


-- create table
CREATE TABLE psra_{prov}.psra_{prov}_agg_curves_stats_r2(
return_period varchar,
stat varchar,
loss_type varchar,
fsauid varchar,
"GenOcc" varchar,
"GenType" varchar,
loss_value float,
loss_ratio float,
annual_frequency_of_exceedence float
);

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_agg_curves_stats_r2(return_period,stat,loss_type,fsauid,"GenOcc","GenType",loss_value,loss_ratio,annual_frequency_of_exceedence)
    FROM '/usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-stats_r2.csv'
        WITH 
          DELIMITER AS ','
          CSV ;



-- combine b0 and r2 tables
CREATE TABLE psra_{prov}.psra_{prov}_agg_curves_stats AS
(SELECT
a.return_period,
a.stat,
a.loss_type,
a.fsauid,
a."GenOcc",
a."GenType",
a.loss_value AS "loss_value_b0",
a.loss_ratio AS "loss_ratio_b0",
b.loss_value AS "loss_value_r2",
b.loss_ratio AS "loss_ratio_r2",
a.annual_frequency_of_exceedence
FROM psra_{prov}.psra_{prov}_agg_curves_stats_b0 a
LEFT JOIN psra_{prov}.psra_{prov}_agg_curves_stats_r2 b ON a.return_period = b.return_period AND a.stat = b.stat AND a.loss_type = b.loss_type AND a.fsauid = b.fsauid AND a."GenOcc" = b."GenOcc" AND
a."GenType" = b."GenType" and a.annual_frequency_of_exceedence = b.annual_frequency_of_exceedence);




DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_agg_curves_stats_b0, psra_{prov}.psra_{prov}_agg_curves_stats_r2;
*/



/* psra_3.Create_table_avg_losses_stats.sql */
-- script to agg losses stats
DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_avg_losses_stats_b0, psra_{prov}.psra_{prov}_avg_losses_stats_r2, psra_{prov}.psra_{prov}_avg_losses_stats CASCADE;

-- create table
CREATE TABLE psra_{prov}.psra_{prov}_avg_losses_stats_b0(
PRIMARY KEY(asset_id),
asset_id varchar,
"BldEpoch" varchar,
"BldgType" varchar,
"EqDesLev" varchar,
"GenOcc" varchar,
"GenType" varchar,
"LandUse" varchar,
"OccClass" varchar,
"SAC" varchar,
"SSC_Zone" varchar,
"SauidID" varchar,
adauid varchar,
cdname varchar,
cduid varchar,
csdname varchar,
csduid varchar,
dauid varchar,
ername varchar,
eruid varchar,
fsauid varchar,
prname varchar,
pruid varchar,
sauid varchar,
taxonomy varchar,
lon float,
lat float,
contents float,
nonstructural float,
structural float
);

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_avg_losses_stats_b0(asset_id,"BldEpoch","BldgType","EqDesLev","GenOcc","GenType","LandUse","OccClass","SAC","SSC_Zone","SauidID",adauid,cdname,cduid,csdname,csduid,dauid,ername,eruid,fsauid,prname,pruid,sauid,taxonomy,lon,lat,contents,nonstructural,structural)
    FROM '/usr/src/app/ebRisk/{prov}/ebR_{prov}_avg_losses-stats_b0.csv'
        WITH 
          DELIMITER AS ','
          CSV ;
*/


-- create table
CREATE TABLE psra_{prov}.psra_{prov}_avg_losses_stats_r2(
PRIMARY KEY(asset_id),
asset_id varchar,
"BldEpoch" varchar,
"BldgType" varchar,
"EqDesLev" varchar,
"GenOcc" varchar,
"GenType" varchar,
"LandUse" varchar,
"OccClass" varchar,
"SAC" varchar,
"SSC_Zone" varchar,
"SauidID" varchar,
adauid varchar,
cdname varchar,
cduid varchar,
csdname varchar,
csduid varchar,
dauid varchar,
ername varchar,
eruid varchar,
fsauid varchar,
prname varchar,
pruid varchar,
sauid varchar,
taxonomy varchar,
lon float,
lat float,
contents float,
nonstructural float,
structural float
);

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_avg_losses_stats_r2(asset_id,"BldEpoch","BldgType","EqDesLev","GenOcc","GenType","LandUse","OccClass","SAC","SSC_Zone","SauidID",adauid,cdname,cduid,csdname,csduid,dauid,ername,eruid,fsauid,prname,pruid,sauid,taxonomy,lon,lat,contents,nonstructural,structural)
    FROM '/usr/src/app/ebRisk/{prov}/ebR_{prov}_avg_losses-stats_r2.csv'
        WITH 
          DELIMITER AS ','
          CSV ;


-- combine b0 and r2 table
CREATE TABLE psra_{prov}.psra_{prov}_avg_losses_stats AS
(SELECT
a.asset_id,
a."BldEpoch",
a."BldgType",
a."EqDesLev",
a."GenOcc",
a."GenType",
a."LandUse",
a."OccClass",
a."SAC",
a."SSC_Zone",
a."SauidID",
a.adauid,
a.cdname,
a.cduid,
a.csdname,
a.csduid,
a.dauid,
a.ername,
a.eruid,
a.fsauid,
a.prname,
a.pruid,
a.sauid,
a.taxonomy,
a.lon,
a.lat,
a.contents AS "contents_b0",
a.nonstructural AS "nonstructural_b0",
a.structural AS "structural_b0",
b.contents AS "contents_r2",
b.nonstructural AS "nonstructural_r2",
b.structural AS "structural_r2"

FROM psra_{prov}.psra_{prov}_avg_losses_stats_b0 a
INNER JOIN psra_{prov}.psra_{prov}_avg_losses_stats_r2 b ON a.asset_id = b.asset_id);

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_avg_losses_stats_b0, psra_{prov}.psra_{prov}_avg_losses_stats_r2;
*/



 /* psra_3.Create_table_src_loss_table.sql */
-- script to agg curves stats
DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_src_loss_b0, psra_{prov}.psra_{prov}_src_loss_r2, psra_{prov}.psra_{prov}_src_loss, psra_{prov}.psra_{prov}_src_loss_b0_temp, psra_{prov}.psra_{prov}_src_loss_r2_temp CASCADE;


-- create table
CREATE TABLE psra_{prov}.psra_{prov}_src_loss_b0(
source varchar,
loss_type varchar,
loss_value float,
trt varchar,
region varchar
);

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_src_loss_b0(source,loss_type,loss_value,trt,region)
    FROM '/usr/src/app/ebRisk/{prov}/ebR_{prov}_src_loss_table_b0.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER;



-- create temp table for agg
CREATE TABLE psra_{prov}.psra_{prov}_src_loss_b0_temp AS
(
SELECT
source,
loss_type,
trt,
SUM(loss_value) AS "loss_value",
region

FROM psra_{prov}.psra_{prov}_src_loss_b0
GROUP BY source,loss_type,trt,region);
*/



-- create table
CREATE TABLE psra_{prov}.psra_{prov}_src_loss_r2(
source varchar,
loss_type varchar,
loss_value float,
trt varchar,
region varchar
);

/*
-- import exposure from csv
COPY psra_{prov}.psra_{prov}_src_loss_r2(source,loss_type,loss_value,trt,region)
    FROM '/usr/src/app/ebRisk/{prov}/ebR_{prov}_src_loss_table_r2.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER;




-- create temp table for agg
CREATE TABLE psra_{prov}.psra_{prov}_src_loss_r2_temp AS
(
SELECT
source,
loss_type,
trt,
SUM(loss_value) AS "loss_value",
region


FROM psra_{prov}.psra_{prov}_src_loss_r2
GROUP BY source,loss_type,trt,region);



-- combine src tables into one
CREATE TABLE psra_{prov}.psra_{prov}_src_loss AS
(
SELECT a.source,
a.loss_type,
a.trt,
a.region,
a.loss_value AS "loss_value_b0",
b.loss_value AS "loss_value_r2"

FROM psra_{prov}.psra_{prov}_src_loss_b0_temp a
INNER JOIN psra_{prov}.psra_{prov}_src_loss_r2_temp b ON a.source = b.source AND a.loss_type = b.loss_type AND a.trt = b.trt AND a.region = b.region
);

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_src_loss_b0_temp, psra_{prov}.psra_{prov}_src_loss_r2_temp CASCADE;
*/
