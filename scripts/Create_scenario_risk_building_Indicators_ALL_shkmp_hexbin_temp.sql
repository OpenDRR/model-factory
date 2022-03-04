-- clipped
-- create shakemap in hexbin for display - 5km
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km AS

SELECT
b.gridid_5,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_5km" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_5;

-- create shakemap in hexbin for display - 10km
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_10km CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_10km AS

SELECT
b.gridid_10,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_10km" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_10,b.geom;



-- create shakemap in hexbin for display - 25km
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_25km CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_25km AS

SELECT
b.gridid_25,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_25km" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_25,b.geom;



-- create shakemap in hexbin for display - 1km
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_full;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_full AS
SELECT
a.gridid_1,
a.geom

FROM boundaries."HexGrid_1km" a
JOIN gmf.shakemap_scenario_extents_temp b ON ST_INTERSECTS(a.geom,b.geom)
WHERE b.scenario = '{eqScenario}';

-- calculate avg, min, max pga of shakemap points within 1km hexbin
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_t CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_t AS

SELECT
b.gridid_1,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_1km" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_1,b.geom;

-- create dsra scenario shakemap 1km hexbin and assign PGA value based on nearest shakemap ID
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_t1 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_t1 AS
SELECT
a.gridid_1,
0.00 AS "sH_PGA_avg",
0.00 AS "sH_PGA_min",
b."sH_PGA" AS "sH_PGA_max",
a.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_full a
CROSS JOIN LATERAL 
(
SELECT
"sH_PGA",
geom
	
FROM results_dsra_{eqScenario}.{eqScenario}_shakemap_tbl
ORDER BY a.geom <-> geom
LIMIT 1
) AS b;

-- update dsra shakeap 1km hexbin with calculated max PGA values
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_t1 b
SET "sH_PGA_max" = a."sH_PGA_max",
"sH_PGA_min" = a."sH_PGA_min",
"sH_PGA_avg" = a."sH_PGA_avg"
FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_t a
WHERE a.gridid_1 = b.gridid_1;

-- remove duplicate gridid_1 values from selection
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_tbl CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_tbl AS
SELECT
DISTINCT(gridid_1),
"sH_PGA_avg",
"sH_PGA_min",
"sH_PGA_max",
geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_t1;

-- update assigned 0.00 to null
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_tbl
SET "sH_PGA_avg" = NULL WHERE "sH_PGA_avg" = 0.00;
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_tbl
SET "sH_PGA_min" = NULL WHERE "sH_PGA_min" = 0.00;

-- drop t
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_t,
results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_t1,
results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_full CASCADE;

-- create view
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km AS SELECT * FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_tbl;



-- unclipped
-- create shakemap in hexbin for display - 5km
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_uc_full;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_uc_full AS
SELECT
a.gridid_5,
a.geom

FROM boundaries."HexGrid_5km_unclipped" a
JOIN gmf.shakemap_scenario_extents_temp b ON ST_INTERSECTS(a.geom,b.geom)
WHERE b.scenario = '{eqScenario}';


-- calculate avg, min, max pga of shakemap points within 5km hexbin
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_uc_t_CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_uc_t AS

SELECT
b.gridid_5,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_5km_unclipped" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_5,b.geom;


-- create dsra scenario shakemap 5km hexbin and assign PGA value based on nearest shakemap ID
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_uc_t1 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_uc_t1 AS
SELECT
a.gridid_5,
0.00 AS "sH_PGA_avg",
0.00 AS "sH_PGA_min",
b."sH_PGA" AS "sH_PGA_max",
a.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_uc_full a
CROSS JOIN LATERAL 
(
SELECT
"sH_PGA",
geom
	
FROM results_dsra_{eqScenario}.{eqScenario}_shakemap_tbl
ORDER BY a.geom <-> geom
LIMIT 1
) AS b;

-- update dsra shakeap 5km hexbin with calculated max PGA values
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_uc_t1 b
SET "sH_PGA_max" = a."sH_PGA_max",
"sH_PGA_min" = a."sH_PGA_min",
"sH_PGA_avg" = a."sH_PGA_avg"
FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_uc_t a
WHERE a.gridid_5 = b.gridid_5;

-- remove duplicate gridid_5 values from selection
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_uc_tbl CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_uc_tbl AS
SELECT
DISTINCT(gridid_5),
"sH_PGA_avg",
"sH_PGA_min",
"sH_PGA_max",
geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_uc_t1;

-- update assigned 0.00 to null
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_uc_tbl
SET "sH_PGA_avg" = NULL WHERE "sH_PGA_avg" = 0.00;
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_uc_tbl
SET "sH_PGA_min" = NULL WHERE "sH_PGA_min" = 0.00;

-- drop t
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_uc_t,
results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_uc_t1,
results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_full_uc CASCADE;

-- create view
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_unclipped;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_unclipped AS SELECT * FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_5km_uc_tbl;



-- create shakemap in hexbin for display - 10km
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_10km_unclipped CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_10km_unclipped AS

SELECT
b.gridid_10,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_10km_unclipped" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_10,b.geom;



-- create shakemap in hexbin for display - 25km
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_25km_unclipped CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_25km_unclipped AS

SELECT
b.gridid_25,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_25km_unclipped" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_25,b.geom;


-- create shakemap in hexbin for display - 50km
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_50km_unclipped CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_50km_unclipped AS

SELECT
b.gridid_50,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_50km_unclipped" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_50,b.geom;

-- create shakemap in hexbin for display - 100km
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_100km_unclipped CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_100km_unclipped AS

SELECT
b.gridid_100,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_100km_unclipped" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_100,b.geom;



-- create shakemap in hexbin for display - 1km
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_full;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_full AS
SELECT
a.gridid_1,
a.geom

FROM boundaries."HexGrid_1km_unclipped" a
JOIN gmf.shakemap_scenario_extents_temp b ON ST_INTERSECTS(a.geom,b.geom)
WHERE b.scenario = '{eqScenario}';

-- calculate avg, min, max pga of shakemap points within 1km hexbin
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_t CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_t AS

SELECT
b.gridid_1,
AVG("sH_PGA") AS "sH_PGA_avg",
MIN("sH_PGA") as "sH_PGA_min",
MAX("sH_PGA") as "sH_PGA_max",
b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap a
JOIN boundaries."HexGrid_1km_unclipped" b ON ST_INTERSECTS(a.geom,b.geom)
GROUP BY b.gridid_1,b.geom;

-- create dsra scenario shakemap 1km hexbin and assign PGA value based on nearest shakemap ID
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_t1 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_t1 AS
SELECT
a.gridid_1,
0.00 AS "sH_PGA_avg",
0.00 AS "sH_PGA_min",
b."sH_PGA" AS "sH_PGA_max",
a.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_full a
CROSS JOIN LATERAL 
(
SELECT
"sH_PGA",
geom
	
FROM results_dsra_{eqScenario}.{eqScenario}_shakemap_tbl
ORDER BY a.geom <-> geom
LIMIT 1
) AS b;

-- update dsra shakeap 1km hexbin with calculated max PGA values
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_t1 b
SET "sH_PGA_max" = a."sH_PGA_max",
"sH_PGA_min" = a."sH_PGA_min",
"sH_PGA_avg" = a."sH_PGA_avg"
FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_t a
WHERE a.gridid_1 = b.gridid_1;

-- remove duplicate gridid_1 values from selection
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_tbl CASCADE;
CREATE TABLE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_tbl AS
SELECT
DISTINCT(gridid_1),
"sH_PGA_avg",
"sH_PGA_min",
"sH_PGA_max",
geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_t1;

-- update assigned 0.00 to null
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_tbl
SET "sH_PGA_avg" = NULL WHERE "sH_PGA_avg" = 0.00;
UPDATE results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_tbl
SET "sH_PGA_min" = NULL WHERE "sH_PGA_min" = 0.00;

-- drop t
DROP TABLE IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_t,
results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_t1,
results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_full CASCADE;

-- create view
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_unclipped;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_unclipped AS SELECT * FROM results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap_hexbin_1km_uc_tbl;
