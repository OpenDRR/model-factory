-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_nhsl_hazard_threat;



-- create multi hazard indicators
DROP TABLE IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_tbl CASCADE;
CREATE TABLE results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_tbl AS 

-- 4.0 Multi-Hazard Risk
-- 4.1 Multi-Hazard Threat
-- 4.1.1 Multi-Hazard Intensity
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
d."PRUID" AS "pruid",
d."PRNAME" AS "prname",
d."ERUID" AS "eruid",
d."ERNAME" AS "ername",
d."CDUID" AS "cduid",
d."CDNAME" AS "cdname",
d."CSDUID" AS "csduid",
d."CSDNAME" AS "csdname",
d."CFSAUID" AS "fsauid",
d."DAUIDt" AS "dauid",
d."SACCODE" AS "saccode",
d."SACTYPE" AS "sactype",
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLat",
CAST(CAST(ROUND(CAST(a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgNum",
a.taxonomy AS "E_BldgTaxon",
CAST(CAST(ROUND(CAST(a.bldg_ft2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgArea",
a.landuse AS "E_LandUse",
a.genocc AS "E_BldgOccG",
a.occclass1 AS "E_BldgOccS1",
a.occclass2 AS "E_BldgOccS2",
a.gentype AS "E_BldgTypeG",
a.bldgtype AS "E_BldgTypeS",
a.bldepoch AS "E_BldgEpoch",
a.eqdeslev AS "E_BldgDesLev",
CAST(CAST(ROUND(CAST(a.day AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_PopDay",
CAST(CAST(ROUND(CAST(a.night AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_PopNight",
CAST(CAST(ROUND(CAST(a.transit AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_PopTransit",
CAST(CAST(ROUND(CAST(a.structural + a.nonstructural + a.contents AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_AssetValue",
CAST(CAST(ROUND(CAST(a.structural + a.nonstructural AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgValue",

CASE
	WHEN (c.pop_ha < 35) THEN 'Low'
	WHEN (c.pop_ha > 35 AND c.pop_ha < 75) THEN 'Moderate'
	WHEN (c.pop_ha > 55) THEN 'High'
	ELSE 'None' END AS "HTt_Exposure",

-- PGV
CAST(CAST(ROUND(CAST(b.pgv2500 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "HTi_PGV2500",
CAST(CAST(ROUND(CAST(b.pgv500 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "HTi_PGV500",

CASE 
	WHEN (b.pgv500 > 0.011 AND b.pgv500 < 0.081) THEN 'Low'
	WHEN (b.pgv500 > 0.081 AND b.pgv500 < 0.16) THEN 'Moderate'
	WHEN (b.pgv500 > 0.16 AND b.pgv500 < 0.31) THEN 'Considerable'
	WHEN (b.pgv500 > 0.31 AND b.pgv500 < 0.6) THEN 'High'
	WHEN (b.pgv500 > 0.6) THEN 'Extreme'
	ELSE 'None' END AS "HTd_PGV500",

-- PGA
CAST(CAST(ROUND(CAST(b.pga2500 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "HTi_PGA2500",
CAST(CAST(ROUND(CAST(b.pga500 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "HTi_PGA500",

CASE 
	WHEN (b.pga500 > 0.039 AND b.pga500 <= 0.0920) THEN 'Low'
	WHEN (b.pga500 > 0.0920 AND b.pga500 <= 0.180) THEN 'Moderate'
	WHEN (b.pga500 > 0.180 AND b.pga500 <= 0.340) THEN 'Considerable'
	WHEN (b.pga500 > 0.340 AND b.pga500 <= 0.650) THEN 'High'
	WHEN (b.pga500 > 0.650) THEN 'Extreme'
	ELSE 'None' END AS "HTd_PGA500",

-- Tsunami
CAST(CAST(ROUND(CAST(b.tsun500 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "HTi_Tsun500",

CASE 
	WHEN (b.tsun500 > 0 AND b.tsun500 <= 50) THEN 'Considerable'
	WHEN (b.tsun500 > 50 AND b.tsun500 <= 100) THEN 'High'
	WHEN (b.tsun500 > 100) THEN 'Extreme'
	ELSE 'None' END AS "Htd_Tsun500",

-- Flood
CAST(CAST(ROUND(CAST(b.fld200 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "HTi_Fld200",
CAST(CAST(ROUND(CAST(b.fld500 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "HTi_Fld500",

CASE
	WHEN (b.fld500 > 10 AND b.fld500 < 30) THEN 'Low'
	WHEN (b.fld500 >= 30 AND b.fld500 < 100) THEN 'Moderate'
	WHEN (b.fld500 >= 100 AND b.fld500 < 200) THEN 'Considerable'
	WHEN (b.fld500 >= 200 AND b.fld500 < 400) THEN 'High'
	WHEN (b.fld500 >= 400) THEN 'Extreme'
	ELSE 'None' END AS "HTd_Fld500",

CAST(CAST(ROUND(CAST(b.fld1000 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "HTi_Fld1000",

-- Wildfire
CAST(CAST(ROUND(CAST(b.wildfire AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "HTi_Wildfire",

CASE 
	WHEN (b.wildfire > 200 AND b.wildfire <= 500) THEN 'Low'
	WHEN (b.wildfire > 500 AND b.wildfire <= 2000) THEN 'Moderate'
	WHEN (b.wildfire > 2000 AND b.wildfire <= 4000) THEN 'Considerable'
	WHEN (b.wildfire > 4000 AND b.wildfire < 10000) THEN 'High'
	WHEN (b.wildfire > 10000) THEN 'Extreme'
	ELSE 'None' END AS "HTd_Wildfire",

-- Landslide
CAST(CAST(ROUND(CAST(b.lndsus AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "HTi_LndSus",

CASE 
	WHEN (b.lndsus > 0.5 AND b.lndsus <= 1) THEN 'Low'
	WHEN (b.lndsus > 1 AND b.lndsus <= 2) THEN 'Moderate'
	WHEN (b.lndsus > 2 AND b.lndsus <= 3) THEN 'Considerable'
	WHEN (b.lndsus > 3 AND b.lndsus <= 4) THEN 'High'
	WHEN (b.lndsus > 4) THEN 'Extreme'
	ELSE 'None' END AS "HTd_LndSus",

--Cyclone
CAST(CAST(ROUND(CAST(b.cy100 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "HTi_Cy100",
CAST(CAST(ROUND(CAST(b.cy250 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "HTi_Cy250",
CAST(CAST(ROUND(CAST(b.cy500 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "HTi_Cy500",

CASE
	WHEN (b.cy500 > 89 AND b.cy500 <= 119) THEN 'Low'
	WHEN (b.cy500 > 119 AND b.cy500 <= 153) THEN 'Moderate'
	WHEN (b.cy500 > 154 AND b.cy500 <= 177) THEN 'Considerable'
	WHEN (b.cy500 > 178 AND b.cy500 <= 208) THEN 'High'
	WHEN (b.cy500 > 209) THEN 'Extreme'
	ELSE 'None' END AS "HTd_Cy500",

CAST(CAST(ROUND(CAST(b.cy1000 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "HTi_Cy1000",

d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN mh.mh_intensity_canada b ON a.sauid = b.sauidt
LEFT JOIN sovi.sovi_census_canada c on a.sauid = c.sauidt
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt" 
LEFT JOIN census.census_2016_canada e on a.sauid = e.sauidt;



--create views for province
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b AS 
SELECT * FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_tbl;

DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_nl CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_nl AS 
SELECT * FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_tbl WHERE pruid ='10';

DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_pe CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_pe AS 
SELECT * FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_tbl WHERE pruid ='11';

DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_ns CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_ns AS 
SELECT * FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_tbl WHERE pruid ='12';

DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_nb CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_nb AS 
SELECT * FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_tbl WHERE pruid ='13';

DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_qc CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_qc AS 
SELECT * FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_tbl WHERE pruid ='24';

DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_on CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_on AS 
SELECT * FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_tbl WHERE pruid ='35';

DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_mb CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_mb AS 
SELECT * FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_tbl WHERE pruid ='46';

DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_sk CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_sk AS 
SELECT * FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_tbl WHERE pruid ='47';

DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_ab CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_ab AS 
SELECT * FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_tbl WHERE pruid ='48';

DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_bc CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_bc AS 
SELECT * FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_tbl WHERE pruid ='59';

DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_yt CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_yt AS 
SELECT * FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_tbl WHERE pruid ='60';

DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_nt CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_nt AS 
SELECT * FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_tbl WHERE pruid ='61';

DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_nu CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_nu AS 
SELECT * FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_b_tbl WHERE pruid ='62';