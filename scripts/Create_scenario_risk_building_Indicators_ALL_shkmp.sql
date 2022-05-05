-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_dsra_{eqScenario};

-- create shakemap table and view
DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_shakemap_tbl CASCADE;
CREATE TABLE results_dsra_{eqScenario}.{eqScenario}_shakemap_tbl AS
SELECT 
DISTINCT(a.site_id) AS "SiteID",
a.lon AS "Lon",
a.lat AS "Lat",
c."Rupture_Abbr" AS "sH_RupName",
d.magnitude AS "sH_Mag",
c."gmpe_Model" AS "sH_GMPE",
a.gmv_pga AS "sH_PGA",
a."gmv_SA(0.1)" AS "sH_Sa0p1",
a."gmv_SA(0.2)" AS "sH_Sa0p2",
a."gmv_SA(0.3)" AS "sH_Sa0p3",
a."gmv_SA(0.5)" AS "sH_Sa0p5",
a."gmv_SA(0.6)" AS "sH_Sa0p6",
a."gmv_SA(1.0)" AS "sH_Sa1p0",
a."gmv_SA(2.0)" AS "sH_Sa2p0",
a.geom

FROM gmf.shakemap_{eqScenario} a
LEFT JOIN gmf.shakemap_{eqScenario}_xref b ON a.site_id = b.site_id
LEFT JOIN dsra.dsra_{eqScenario} c ON b.id = c."AssetID"
LEFT JOIN ruptures.rupture_table d ON d.rupture_name = c."Rupture_Abbr";
--WHERE a."gmv_SA(0.3)" >= 0.02;


-- update rupture, mag, gmpe information
DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_shakemap_temp CASCADE;
CREATE TABLE results_dsra_{eqScenario}.{eqScenario}_shakemap_temp AS
SELECT
DISTINCT(a."Rupture_Abbr"),
b.magnitude,
a."gmpe_Model"

FROM dsra.dsra_{eqScenario} a
LEFT JOIN ruptures.rupture_table b ON a."Rupture_Abbr" = b.rupture_name;


UPDATE results_dsra_{eqScenario}.{eqScenario}_shakemap_tbl
SET "sH_RupName" = (SELECT "Rupture_Abbr" FROM results_dsra_{eqScenario}.{eqScenario}_shakemap_temp),
    "sH_Mag" = (SELECT magnitude FROM results_dsra_{eqScenario}.{eqScenario}_shakemap_temp),
    "sH_GMPE" = (SELECT "gmpe_Model" FROM results_dsra_{eqScenario}.{eqScenario}_shakemap_temp);


-- create indexes
CREATE INDEX IF NOT EXISTS dsra_{eqScenario}_siteid_idx ON results_dsra_{eqScenario}.{eqScenario}_shakemap_tbl("SiteID");
CREATE INDEX IF NOT EXISTS dsra_{eqScenario}_geom_dx ON results_dsra_{eqScenario}.{eqScenario}_shakemap_tbl USING GIST(geom);

DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_shakemap_temp;

DROP VIEW IF EXISTS  results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap AS SELECT * FROM results_dsra_{eqScenario}.{eqScenario}_shakemap_tbl;



-- add polygon extents to scenario extents table for each scenario
INSERT INTO gmf.shakemap_scenario_extents_temp(scenario,geom)
SELECT '{eqScenario}',st_astext(st_concavehull(st_collect(geom),0.98)) FROM gmf.shakemap_{eqScenario};
--SELECT '{eqScenario}',st_astext(st_chaikinsmoothing(st_concavehull(st_collect(geom),0.98))) FROM gmf.shakemap_{eqScenario} WHERE "gmv_SA(0.3)" >= 0.02;


-- add 10m buffer to ensure all assetIDs are captured
UPDATE gmf.shakemap_scenario_extents_temp
SET geom = ST_BUFFER(geom,0.0001) WHERE scenario = '{eqScenario}';



-- clipped
-- create shakemap in hexgrid for display - 5km
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5 CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5 AS

SELECT
b.gridid_5,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_5km" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_5;

-- create shakemap in hexgrid for display - 10km
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_10 CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_10 AS

SELECT
b.gridid_10,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_10km" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_10,b.geom;



-- create shakemap in hexgrid for display - 25km
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_25 CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_25 AS

SELECT
b.gridid_25,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_25km" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_25,b.geom;



-- create shakemap in hexgrid for display - 1km
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_f;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_f AS
SELECT
a.gridid_1,
a.geom

FROM boundaries."HexGrid_1km" a
JOIN gmf.shakemap_scenario_extents_temp b ON ST_INTERSECTS(a.geom,b.geom)
WHERE b.scenario = '{eqScenario}';

-- calculate avg, min, max pga of shakemap points within 1km hexgrid
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_t CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_t AS

SELECT
b.gridid_1,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_1km" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_1,b.geom;

-- create dsra scenario shakemap 1km hexgrid and assign PGA value based on nearest shakemap ID
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_t1 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_t1 AS
SELECT
a.gridid_1,
0.00 AS "sH_PGA_avg",
0.00 AS "sH_PGA_min",
b."sH_PGA" AS "sH_PGA_max",
a.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_f a
CROSS JOIN LATERAL 
(
SELECT
"sH_PGA",
geom
	
FROM results_dsra_{eqScenario}.{eqScenario}_shakemap_tbl
ORDER BY a.geom <-> geom
LIMIT 1
) AS b;

-- update dsra shakeap 1km hexgrid with calculated max PGA values
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_t1 b
SET "sH_PGA_max" = a."sH_PGA_max",
"sH_PGA_min" = a."sH_PGA_min",
"sH_PGA_avg" = a."sH_PGA_avg"
FROM results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_t a
WHERE a.gridid_1 = b.gridid_1;

-- remove duplicate gridid_1 values from selection
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_tbl CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_tbl AS
SELECT
DISTINCT(gridid_1),
"sH_PGA_avg",
"sH_PGA_min",
"sH_PGA_max",
geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_t1;

-- update assigned 0.00 to null
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_tbl
SET "sH_PGA_avg" = NULL WHERE "sH_PGA_avg" = 0.00;
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_tbl
SET "sH_PGA_min" = NULL WHERE "sH_PGA_min" = 0.00;

-- drop t
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_t,
results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_t1,
results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_f CASCADE;

-- create view
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1 AS SELECT * FROM results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_tbl;



-- unclipped
-- create shakemap in hexgrid for display - 5km
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc_f;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc_f AS
SELECT
a.gridid_5,
a.geom

FROM boundaries."HexGrid_5km_unclipped" a
JOIN gmf.shakemap_scenario_extents_temp b ON ST_INTERSECTS(a.geom,b.geom)
WHERE b.scenario = '{eqScenario}';


-- calculate avg, min, max pga of shakemap points within 5km hexgrid
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc_t_CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc_t AS

SELECT
b.gridid_5,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_5km_unclipped" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_5,b.geom;


-- create dsra scenario shakemap 5km hexgrid and assign PGA value based on nearest shakemap ID
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_5_uc_t1 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc_t1 AS
SELECT
a.gridid_5,
0.00 AS "sH_PGA_avg",
0.00 AS "sH_PGA_min",
b."sH_PGA" AS "sH_PGA_max",
a.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc_f a
CROSS JOIN LATERAL 
(
SELECT
"sH_PGA",
geom
	
FROM results_dsra_{eqScenario}.{eqScenario}_shakemap_tbl
ORDER BY a.geom <-> geom
LIMIT 1
) AS b;

-- update dsra shakeap 5km hexgrid with calculated max PGA values
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc_t1 b
SET "sH_PGA_max" = a."sH_PGA_max",
"sH_PGA_min" = a."sH_PGA_min",
"sH_PGA_avg" = a."sH_PGA_avg"
FROM results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc_t a
WHERE a.gridid_5 = b.gridid_5;

-- remove duplicate gridid_5 values from selection
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc_tbl CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc_tbl AS
SELECT
DISTINCT(gridid_5),
"sH_PGA_avg",
"sH_PGA_min",
"sH_PGA_max",
geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc_t1;

-- update assigned 0.00 to null
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc_tbl
SET "sH_PGA_avg" = NULL WHERE "sH_PGA_avg" = 0.00;
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc_tbl
SET "sH_PGA_min" = NULL WHERE "sH_PGA_min" = 0.00;

-- drop t
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc_t,
results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc_t1,
results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc_f CASCADE;

-- create view
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc AS SELECT * FROM results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_5_uc_tbl;



-- create shakemap in hexgrid for display - 10km
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_10_uc CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_10_uc AS

SELECT
b.gridid_10,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_10km_unclipped" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_10,b.geom;



-- create shakemap in hexgrid for display - 25km
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_25_uc CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_25_uc AS

SELECT
b.gridid_25,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_25km_unclipped" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_25,b.geom;


-- create shakemap in hexgrid for display - 50km
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_50_uc CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_50_uc AS

SELECT
b.gridid_50,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_50km_unclipped" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_50,b.geom;

-- create shakemap in hexgrid for display - 100km
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_100_uc CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_100_uc AS

SELECT
b.gridid_100,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_100km_unclipped" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_100,b.geom;



-- create shakemap in hexgrid for display - 1km
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_f;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_f AS
SELECT
a.gridid_1,
a.geom

FROM boundaries."HexGrid_1km_unclipped" a
JOIN gmf.shakemap_scenario_extents_temp b ON ST_INTERSECTS(a.geom,b.geom)
WHERE b.scenario = '{eqScenario}';

-- calculate avg, min, max pga of shakemap points within 1km hexgrid
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_t CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_t AS

SELECT
b.gridid_1,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_1km_unclipped" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_1,b.geom;

-- create dsra scenario shakemap 1km hexgrid and assign PGA value based on nearest shakemap ID
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_t1 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_t1 AS
SELECT
a.gridid_1,
0.00 AS "sH_PGA_avg",
0.00 AS "sH_PGA_min",
b."sH_PGA" AS "sH_PGA_max",
a.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_f a
CROSS JOIN LATERAL 
(
SELECT
"sH_PGA",
geom
	
FROM results_dsra_{eqScenario}.{eqScenario}_shakemap_tbl
ORDER BY a.geom <-> geom
LIMIT 1
) AS b;

-- update dsra shakeap 1km hexgrid with calculated max PGA values
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_t1 b
SET "sH_PGA_max" = a."sH_PGA_max",
"sH_PGA_min" = a."sH_PGA_min",
"sH_PGA_avg" = a."sH_PGA_avg"
FROM results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_t a
WHERE a.gridid_1 = b.gridid_1;

-- remove duplicate gridid_1 values from selection
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_tbl CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_tbl AS
SELECT
DISTINCT(gridid_1),
"sH_PGA_avg",
"sH_PGA_min",
"sH_PGA_max",
geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_t1;

-- update assigned 0.00 to null
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_tbl
SET "sH_PGA_avg" = NULL WHERE "sH_PGA_avg" = 0.00;
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_tbl
SET "sH_PGA_min" = NULL WHERE "sH_PGA_min" = 0.00;

-- drop t
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_t,
results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_t1,
results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_f CASCADE;

-- create view
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc AS SELECT * FROM results_dsra_{eqScenario}.dsra_{eqScenario}_sm_hg_1_uc_tbl;



-- create index
CREATE INDEX IF NOT EXISTS {eqScenario}_assetid_idx ON dsra.dsra_{eqScenario}("AssetID");


--intermediates table to calculate displaced households for DSRA
DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_displhshld_calc1 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.{eqScenario}_displhshld_calc1 AS
(
SELECT
a."AssetID",
c.number,
a."sD_Moderate_b0",
a."sD_Moderate_r1",
a."sD_Extensive_b0",
a."sD_Extensive_r1",
a."sD_Complete_b0",
a."sD_Complete_r1",
a."sC_Interruption_b0",
a."sC_Interruption_r1",
d."E_CensusDU",
b."E_BldgOccG",
b."E_SFHshld",
b."E_MFHshld",

-- SFM
CASE WHEN c.occclass1 IN ('RES1','RES2') THEN (a."sD_Moderate_b0" / c.number) ELSE 0 END AS "SFM_b0",
CASE WHEN c.occclass1 IN ('RES1','RES2') THEN (a."sD_Moderate_r1" / c.number) ELSE 0 END AS "SFM_r1",

-- SFE
CASE WHEN c.occclass1 IN ('RES1','RES2') THEN (a."sD_Extensive_b0" / c.number) ELSE 0 END AS "SFE_b0",
CASE WHEN c.occclass1 IN ('RES1','RES2')THEN (a."sD_Extensive_r1" / c.number) ELSE 0 END AS "SFE_r1",

-- SFC
CASE WHEN c.occclass1 IN ('RES1','RES2') THEN (a."sD_Complete_b0" / c.number) ELSE 0 END AS "SFC_b0",
CASE WHEN c.occclass1 IN ('RES1','RES2') THEN (a."sD_Complete_r1" / c.number) ELSE 0 END AS "SFC_r1",

-- MFM
CASE WHEN c.occclass1 IN ('RES3A','RES3B','RES3C','RES3D','RES3E','RES3F','RES4','RES5','RES6') THEN (a."sD_Moderate_b0" / c.number) ELSE 0 END AS "MFM_b0",
CASE WHEN c.occclass1 IN ('RES3A','RES3B','RES3C','RES3D','RES3E','RES3F','RES4','RES5','RES6') THEN (a."sD_Moderate_r1" / c.number) ELSE 0 END AS "MFM_r1",

-- MFE
CASE WHEN c.occclass1 IN ('RES3A','RES3B','RES3C','RES3D','RES3E','RES3F','RES4','RES5','RES6') THEN (a."sD_Extensive_b0" / c.number) ELSE 0 END AS "MFE_b0",
CASE WHEN c.occclass1 IN ('RES3A','RES3B','RES3C','RES3D','RES3E','RES3F','RES4','RES5','RES6') THEN (a."sD_Extensive_r1" / c.number) ELSE 0 END AS "MFE_r1",

-- MFC
CASE WHEN c.occclass1 IN ('RES3A','RES3B','RES3C','RES3D','RES3E','RES3F','RES4','RES5','RES6') THEN (a."sD_Complete_b0" / c.number) ELSE 0 END AS "MFC_b0",
CASE WHEN c.occclass1 IN ('RES3A','RES3B','RES3C','RES3D','RES3E','RES3F','RES4','RES5','RES6') THEN (a."sD_Complete_r1" / c.number) ELSE 0 END AS "MFC_r1",

0 AS "W_SFM",
0 AS "W_SFE",
1 AS "W_SFC",
0 AS "W_MFM",
0.9 AS "W_MFE",
1 AS "W_MFC"

FROM dsra.dsra_{eqScenario} a
LEFT JOIN results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_b b ON a."AssetID" = b."BldgID"
LEFT JOIN exposure.canada_exposure c ON  a."AssetID" = c.id
LEFT JOIN results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s d ON c.sauid = d."Sauid"
);


--intermediate tables to calculate displaced households for DSRA
DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_displhshld_calc2 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.{eqScenario}_displhshld_calc2 AS
(
SELECT
"AssetID",
-- ([W_SFM]*[SFM]) + ([W_SFE]*[SFE]) + ([W_SFC]*[SFC]) = SF
("W_SFM" * "SFM_b0") + ("W_SFE" * "SFE_b0") + ("W_SFC" * "SFC_b0") AS "SF_b0",
("W_SFM" * "SFM_r1") + ("W_SFE" * "SFE_r1") + ("W_SFC" * "SFC_r1") AS "SF_r1",

--([W_MFM]*[MFM]) + ([W_MFE]*[MFE]) + ([W_MFC]*MFC]) = MF
("W_MFM" * "MFM_b0") + ("W_MFE" * "MFE_b0") + ("W_MFC" * "MFC_b0") AS "MF_b0",
("W_MFM" * "MFM_r1") + ("W_MFE" * "MFE_r1") + ("W_MFC" * "MFC_r1") AS "MF_r1"

FROM results_dsra_{eqScenario}.{eqScenario}_displhshld_calc1
);


--intermediate tables to calculate displaced households for DSRA
DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_displhshld_calc3 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.{eqScenario}_displhshld_calc3 AS
(
SELECT
a."AssetID",

--(([SF_Hshlds] * [SF]) + ([MF_Hshlds] * [MF])) * ([CensusDU] / ([SF_Hshlds] + [MF_Hshlds]) = DH
--COALESCE((a."E_SFHshld" * b."SF_b0") + (a."E_MFHshld" * b."MF_b0") * (a."E_CensusDU" /NULLIF((a."E_SFHshld" + a."E_MFHshld"),0)),0) AS "sC_DisplHshld_b0",
COALESCE((a."E_SFHshld" * b."SF_b0") + (a."E_MFHshld" * b."MF_b0"),0) AS "sC_DisplHshld_b0",
--COALESCE((a."E_SFHshld" * b."SF_r1") + (a."E_MFHshld" * b."MF_r1") * (a."E_CensusDU" /NULLIF((a."E_SFHshld" + a."E_MFHshld"),0)),0) AS "sC_DisplHshld_r1",
COALESCE((a."E_SFHshld" * b."SF_r1") + (a."E_MFHshld" * b."MF_r1"),0) AS "sC_DisplHshld_r1"

FROM results_dsra_{eqScenario}.{eqScenario}_displhshld_calc1 a
LEFT JOIN results_dsra_{eqScenario}.{eqScenario}_displhshld_calc2 b on a."AssetID" = b."AssetID"
);


--intermediate tables to calculate displaced households for DSRA
DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_displhshld CASCADE;
CREATE TABLE results_dsra_{eqScenario}.{eqScenario}_displhshld AS
(
SELECT
a."AssetID",
a.number,
a."sD_Moderate_b0",
a."sD_Moderate_r1",
a."sD_Extensive_b0",
a."sD_Extensive_r1",
a."sD_Complete_b0",
a."sD_Complete_r1",
a."sC_Interruption_b0",
a."sC_Interruption_r1",
a."E_CensusDU",
a."E_BldgOccG",
a."E_SFHshld",
a."E_MFHshld",
a."SFM_b0",
a."SFM_r1",
a."SFE_b0",
a."SFE_r1",
a."SFC_b0",
a."SFC_r1",
a."MFM_b0",
a."MFM_r1",
a."MFE_b0",
a."MFE_r1",
a."MFC_b0",
a."MFC_r1",
a."W_SFM",
a."W_SFE",
a."W_SFC",
a."W_MFM",
a."W_MFE",
a."W_MFC",
b."SF_b0",
b."SF_r1",
b."MF_b0",
b."MF_r1",
c."sC_DisplHshld_b0",
c."sC_DisplHshld_r1"

FROM results_dsra_{eqScenario}.{eqScenario}_displhshld_calc1 a
LEFT JOIN results_dsra_{eqScenario}.{eqScenario}_displhshld_calc2 b ON a."AssetID" = b."AssetID"
LEFT JOIN results_dsra_{eqScenario}.{eqScenario}_displhshld_calc3 c ON a."AssetID" = c."AssetID"
);

DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_displhshld_calc1,results_dsra_{eqScenario}.{eqScenario}_displhshld_calc2,results_dsra_{eqScenario}.{eqScenario}_displhshld_calc3;


-- create scenario risk building indicators
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_indicators_b CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_indicators_b AS 

--3.0 Earthquake Scenario Risk (DSRA)
--3.1 Scenario Hazard
SELECT 
a."AssetID",
b.eqdeslev AS "E_BldgDesLev",
b.occtype AS "E_BldgOccG",
b.occclass1 AS "E_BldgOccS1",
b.gentype AS "E_BldgTypeG",
b.bldgtype AS "E_BldgTypeS",

-- 3.1.1 Shakemap Intensity
a."Rupture_Abbr" AS "sH_RupName",
--a."Rupture_Abbr" AS "sH_RupAbbr",
f.source_type AS "sH_Source",
f.magnitude AS "sH_Mag",
CAST(CAST(ROUND(CAST(f.lon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_HypoLon",
CAST(CAST(ROUND(CAST(f.lat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_HypoLat",
CAST(CAST(ROUND(CAST(f.depth AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_HypoDepth",
f.rake AS "sH_Rake",
a."gmpe_Model" AS "sH_GMPE",
CAST(CAST(ROUND(CAST(d.vs30 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Vs30",
CAST(CAST(ROUND(CAST(d.z1pt0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_z1p0",
CAST(CAST(ROUND(CAST(d.z2pt5 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_z2p5",
CAST(CAST(ROUND(CAST(e."gmv_pga" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_PGA",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.1)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p1",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.2)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p2",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.3)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p3",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.5)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p5",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.6)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p6",
CAST(CAST(ROUND(CAST(e."gmv_SA(1.0)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa1p0",
CAST(CAST(ROUND(CAST(e."gmv_SA(2.0)" AS NUMERIC),6) AS FLOAT) AS NUMERIC)AS "sH_Sa2p0",
--0.0 AS "sH_MMI",

-- 3.0 Earthquake Scenario Risk (DSRA)
-- 3.2 Building Damage
-- 3.2.1 Damage State - b0
CAST(CAST(ROUND(CAST(a."sD_None_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_None_b0",
CAST(CAST(ROUND(CAST(a."sD_None_b0" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_None_b0",

CAST(CAST(ROUND(CAST(a."sD_Slight_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Slight_b0",
CAST(CAST(ROUND(CAST(a."sD_Slight_b0" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Slight_b0",

CAST(CAST(ROUND(CAST(a."sD_Moderate_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Moderate_b0",
CAST(CAST(ROUND(CAST(a."sD_Moderate_b0" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Moderate_b0",

CAST(CAST(ROUND(CAST(a."sD_Extensive_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Extensive_b0",
CAST(CAST(ROUND(CAST(a."sD_Extensive_b0" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Extensive_b0",

CAST(CAST(ROUND(CAST(a."sD_Complete_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Complete_b0",
CAST(CAST(ROUND(CAST(a."sD_Complete_b0" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Complete_b0",

CAST(CAST(ROUND(CAST(a."sD_Collapse_b0" * b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Collapse_b0",
CAST(CAST(ROUND(CAST(a."sD_Collapse_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Collapse_b0",

-- 3.2.1 Damage State - r1
CAST(CAST(ROUND(CAST(a."sD_None_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_None_r1",
CAST(CAST(ROUND(CAST(a."sD_None_r1" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_None_r1",

CAST(CAST(ROUND(CAST(a."sD_Slight_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Slight_r1",
CAST(CAST(ROUND(CAST(a."sD_Slight_r1" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Slight_r1",

CAST(CAST(ROUND(CAST(a."sD_Moderate_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Moderate_r1",
CAST(CAST(ROUND(CAST(a."sD_Moderate_r1" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Moderate_r1",

CAST(CAST(ROUND(CAST(a."sD_Extensive_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Extensive_r1",
CAST(CAST(ROUND(CAST(a."sD_Extensive_r1" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Extensive_r1",

CAST(CAST(ROUND(CAST(a."sD_Complete_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Complete_r1",
CAST(CAST(ROUND(CAST(a."sD_Complete_r1" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Complete_r1",

CAST(CAST(ROUND(CAST(a."sD_Collapse_r1" * b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Collapse_r1",
CAST(CAST(ROUND(CAST(a."sD_Collapse_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Collapse_r1",


-- 3.0 Earthquake Scenario Risk (DSRA)
-- 3.2 Building Damage
-- 3.2.1 Recovery - b0
CAST(CAST(ROUND(CAST(a."sC_Interruption_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Interruption_b0",
CAST(CAST(ROUND(CAST(a."sC_Repair_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Repair_b0",
CAST(CAST(ROUND(CAST(a."sC_Recovery_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Recovery_b0",
CAST(CAST(ROUND(CAST((a."sC_DebrisBW_b0" + a."sC_DebrisC_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DebrisTotal_b0",
CAST(CAST(ROUND(CAST(a."sC_DebrisBW_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DebrisBW_b0",
CAST(CAST(ROUND(CAST(a."sC_DebrisC_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DebrisCS_b0",

-- 3.2.1 Recovery - r1
CAST(CAST(ROUND(CAST(a."sC_Interruption_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Interruption_r1",
CAST(CAST(ROUND(CAST(a."sC_Repair_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Repair_r1",
CAST(CAST(ROUND(CAST(a."sC_Recovery_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Recovery_r1",
CAST(CAST(ROUND(CAST((a."sC_DebrisBW_r1" + a."sC_DebrisC_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DebrisTotal_r1",
CAST(CAST(ROUND(CAST(a."sC_DebrisBW_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DebrisBW_r1",
CAST(CAST(ROUND(CAST(a."sC_DebrisC_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DebrisCS_r1",

-- 3.2.3 Building Characteristics
--b.bldgtype AS "E_BldgTypeG",
--b.occtype AS "E_OccType",


-- 3.0 Earthquake Scenario Risk (DSRA)
-- 3.3 Affected People
-- 3.3.1 Casualties - b0
CAST(CAST(ROUND(CAST(a."sC_CasDayL1_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasDayL1_b0",
CAST(CAST(ROUND(CAST(a."sC_CasDayL2_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasDayL2_b0",
CAST(CAST(ROUND(CAST(a."sC_CasDayL3_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasDayL3_b0",
CAST(CAST(ROUND(CAST(a."sC_CasDayL4_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasDayL4_b0",
CAST(CAST(ROUND(CAST(a."sC_CasNightL1_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasNightL1_b0",
CAST(CAST(ROUND(CAST(a."sC_CasNightL2_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasNightL2_b0",
CAST(CAST(ROUND(CAST(a."sC_CasNightL3_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasNightL3_b0",
CAST(CAST(ROUND(CAST(a."sC_CasNightL4_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasNightL4_b0",
CAST(CAST(ROUND(CAST(a."sC_CasTransitL1_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasTransitL1_b0",
CAST(CAST(ROUND(CAST(a."sC_CasTransitL2_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasTransitL2_b0",
CAST(CAST(ROUND(CAST(a."sC_CasTransitL3_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasTransitL3_b0",
CAST(CAST(ROUND(CAST(a."sC_CasTransitL4_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasTransitL4_b0",

-- 3.3.1 Casualties - r1
CAST(CAST(ROUND(CAST(a."sC_CasDayL1_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasDayL1_r1",
CAST(CAST(ROUND(CAST(a."sC_CasDayL2_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasDayL2_r1",
CAST(CAST(ROUND(CAST(a."sC_CasDayL3_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasDayL3_r1",
CAST(CAST(ROUND(CAST(a."sC_CasDayL4_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasDayL4_r1",
CAST(CAST(ROUND(CAST(a."sC_CasNightL1_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasNightL1_r1",
CAST(CAST(ROUND(CAST(a."sC_CasNightL2_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasNightL2_r1",
CAST(CAST(ROUND(CAST(a."sC_CasNightL3_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasNightL3_r1",
CAST(CAST(ROUND(CAST(a."sC_CasNightL4_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasNightL4_r1",
CAST(CAST(ROUND(CAST(a."sC_CasTransitL1_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasTransitL1_r1",
CAST(CAST(ROUND(CAST(a."sC_CasTransitL2_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasTransitL2_r1",
CAST(CAST(ROUND(CAST(a."sC_CasTransitL3_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasTransitL3_r1",
CAST(CAST(ROUND(CAST(a."sC_CasTransitL4_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasTransitL4_r1",


-- 3.0 Earthquake Scenario Risk (DSRA)
-- 3.3 Affected People
-- 3.3.2 Social Disruption - b0
-- sC_Shelter -- calculated at sauid level only
CAST(CAST(ROUND(CAST(a."sC_DisplRes_3_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Res3_b0",
CAST(CAST(ROUND(CAST(a."sC_DisplRes_30_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Res30_b0",
CAST(CAST(ROUND(CAST(a."sC_DisplRes_90_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Res90_b0",
CAST(CAST(ROUND(CAST(COALESCE(a."sC_DisplRes_90_b0"/NULLIF(b.night,0),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCr_Res90_b0",
CAST(CAST(ROUND(CAST(a."sC_DisplRes_180_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Res180_b0",
CAST(CAST(ROUND(CAST(a."sC_DisplRes_360_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Res360_b0",

CAST(CAST(ROUND(CAST(h."sC_DisplHshld_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Hshld_b0",

CAST(CAST(ROUND(CAST(a."sC_DisrupEmpl_30_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Empl30_b0",
CAST(CAST(ROUND(CAST(a."sC_DisrupEmpl_90_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Empl90_b0",
CAST(CAST(ROUND(CAST(COALESCE(a."sC_DisrupEmpl_90_b0"/NULLIF(b.day,0),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCr_Empl90_b0",
CAST(CAST(ROUND(CAST(a."sC_DisrupEmpl_180_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Empl180_b0",
CAST(CAST(ROUND(CAST(a."sC_DisrupEmpl_360_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Empl360_b0",

-- 3.3.2 Social Disruption - r1
-- sC_Shelter -- calculated at sauid level only
CAST(CAST(ROUND(CAST(a."sC_DisplRes_3_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Res3_r1",
CAST(CAST(ROUND(CAST(a."sC_DisplRes_30_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Res30_r1",
CAST(CAST(ROUND(CAST(a."sC_DisplRes_90_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Res90_r1",
CAST(CAST(ROUND(CAST(COALESCE(a."sC_DisplRes_90_r1"/NULLIF(b.night,0),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCr_Res90_r1",
CAST(CAST(ROUND(CAST(a."sC_DisplRes_360_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Res360_r1",

CAST(CAST(ROUND(CAST(h."sC_DisplHshld_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Hshld_r1",

CAST(CAST(ROUND(CAST(a."sC_DisrupEmpl_30_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Empl30_r1",
CAST(CAST(ROUND(CAST(a."sC_DisrupEmpl_90_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Empl90_r1",
CAST(CAST(ROUND(CAST(COALESCE(a."sC_DisrupEmpl_90_r1"/NULLIF(b.day,0),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCr_Empl90_r1",
CAST(CAST(ROUND(CAST(a."sC_DisrupEmpl_180_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Empl180_r1",
CAST(CAST(ROUND(CAST(a."sC_DisrupEmpl_360_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Empl360_r1",


-- 3.0 Earthquake Scenario Risk (DSRA)
-- 3.4 Economic Security
-- 3.4.1 Economic Loss - b0
CAST(CAST(ROUND(CAST(a."sL_Str_b0" + a."sL_NStr_b0" + a."sL_Cont_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Asset_b0",
CAST(CAST(ROUND(CAST(a."sL_Str_b0" + a."sL_NStr_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Bldg_b0",
CAST(CAST(ROUND(CAST(COALESCE(((a."sL_Str_b0" + a."sL_NStr_b0"))/NULLIF(((b.structural + b.nonstructural)),0),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLr_Bldg_b0",

CAST(CAST(ROUND(CAST(a."sL_Str_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Str_b0",

CAST(CAST(ROUND(CAST(a."sL_NStr_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_NStr_b0",

CAST(CAST(ROUND(CAST(a."sL_Cont_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Cont_b0",

-- 3.4.1 Economic Loss - r1
CAST(CAST(ROUND(CAST(a."sL_Str_r1" + a."sL_NStr_r1" + a."sL_Cont_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Asset_r1",
CAST(CAST(ROUND(CAST(a."sL_Str_r1" + a."sL_NStr_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Bldg_r1",
CAST(CAST(ROUND(CAST(COALESCE(((a."sL_Str_r1" + a."sL_NStr_r1"))/NULLIF(((b.structural + b.nonstructural)),0),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLr_Bldg_r1",

CAST(CAST(ROUND(CAST(a."sL_Str_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Str_r1",

CAST(CAST(ROUND(CAST(a."sL_NStr_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_NStr_r1",

CAST(CAST(ROUND(CAST(a."sL_Cont_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Cont_r1",

b.sauid AS "Sauid",
c."PRUID" AS "pruid",
c."PRNAME" AS "prname",
c."ERUID" AS "eruid",
c."ERNAME" AS "ername",
c."CDUID" AS "cduid",
c."CDNAME" AS "cdname",
c."CSDUID" AS "csduid",
c."CSDNAME" AS "csdname",
c."CFSAUID" AS "fsauid",
c."DAUIDt" AS "dauid",
c."SACCODE" AS "saccode",
c."SACTYPE" AS "sactype",
--b.landuse,
b.geom AS "geom_point"

FROM dsra.dsra_{eqScenario} a
LEFT JOIN exposure.canada_exposure b ON a."AssetID" = b.id
LEFT JOIN vs30.vs30_can_site_model_xref d ON a."AssetID" = d.id
LEFT JOIN boundaries."Geometry_SAUID" c on b.sauid = c."SAUIDt"
LEFT JOIN gmf.shakemap_{eqScenario}_xref e ON b.id = e.id
LEFT JOIN ruptures.rupture_table f ON f.rupture_name = a."Rupture_Abbr"
LEFT JOIN results_dsra_{eqScenario}.{eqScenario}_displhshld h ON a."AssetID" = h."AssetID"
JOIN gmf.shakemap_scenario_extents_temp i ON ST_Intersects(b.geom,i.geom) WHERE i.scenario = '{eqScenario}';
--WHERE e."gmv_SA(0.3)" >=0.02;



-- insert dsra info into master dsra table per scenario
-- INSERT INTO dsra.dsra_all_scenarios_tbl(assetid,sauid,pruid,prname,eruid,ername,cduid,cdname,csduid,csdname,fsauid,dauid,sh_rupname,sh_mag,sh_hypolon,sh_hypolat,sh_hypodepth,sh_rake,geom_point)
-- SELECT "AssetID","Sauid",pruid,prname,eruid,ername,cduid,cdname,csduid,csdname,fsauid,dauid,"sH_RupName","sH_Mag","sH_HypoLon","sH_HypoLat","sH_HypoDepth","sH_Rake",geom_point
-- FROM results_dsra_{eqScenario}.dsra_{eqScenario}_indicators_b;

INSERT INTO dsra.dsra_all_scenarios_tbl(assetid,sauid,pruid,prname,eruid,ername,cduid,cdname,csduid,csdname,fsauid,dauid,sh_rupname,sh_mag,sh_hypolon,sh_hypolat,sh_hypodepth,sh_rake)
SELECT "AssetID","Sauid",pruid,prname,eruid,ername,cduid,cdname,csduid,csdname,fsauid,dauid,"sH_RupName","sH_Mag","sH_HypoLon","sH_HypoLat","sH_HypoDepth","sH_Rake"
FROM results_dsra_{eqScenario}.dsra_{eqScenario}_indicators_b;