-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_nhsl_physical_exposure;

-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Buildings
SELECT 
a.id AS "BldgID",
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLat",
a.sauid AS "Sauid",
CAST(CAST(ROUND(CAST(a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgNum",
a.taxonomy AS "E_BldgTaxon",
CAST(CAST(ROUND(CAST(a.bldg_ft2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgArea",
--CAST(CAST(ROUND(CAST(CASE WHEN a.genocc IN ('Residential-LD','Residential-MD','Residential-HD') THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaRes",
--CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Commercial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaComm",
--CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Industrial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaInd",
--CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Civic' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaCivic",
--CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Agricultural' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaAgr",
a.landuse AS "E_LandUse",
a.genocc AS "E_BldgOccG",
a.occclass1 AS "E_BldgOccS1",
a.occclass2 AS "E_BldgOccS2",
a.gentype AS "E_BldgTypeG",
a.bldgtype AS "E_BldgTypeS",
CAST(CAST(ROUND(CAST(a.numfloors AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_NumFloors",
a.bldepoch AS "E_BldgEpoch",
a.ssc_zone AS "SSC_Zone",
a.ss_region AS "E_SSRegion",
a.eqdeslev AS "E_BldgDesLev",

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.2 People
CAST(CAST(ROUND(CAST(a.day AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_PopDay",
CAST(CAST(ROUND(CAST(a.night AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_PopNight",
CAST(CAST(ROUND(CAST(a.transit AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_PopTransit",

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.2 Assets
CAST(CAST(ROUND(CAST(a.structural + a.nonstructural + a.contents AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_AssetValue",
CAST(CAST(ROUND(CAST(a.structural + a.nonstructural AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgValue",
CAST(CAST(ROUND(CAST(a.structural AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_StrValue",
CAST(CAST(ROUND(CAST(a.nonstructural AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_NStrValue",
CAST(CAST(ROUND(CAST(a.contents AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_ContValue",
CAST(CAST(ROUND(CAST(a.retrofitting AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_RetrofitCost",

b."PRUID" AS "pruid",
b."PRNAME" AS "prname",
b."ERUID" AS "eruid",
b."ERNAME" AS "ername",
b."CDUID" AS "cduid",
b."CDNAME" AS "cdname",
b."CSDUID" AS "csduid",
b."CSDNAME" AS "csdname",
b."CFSAUID" AS "fsauid",
b."DAUIDt" AS "dauid",
b."SACCODE" AS "saccode",
b."SACTYPE" AS "sactype",

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt";


--create views for province
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_nl CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_nl AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b WHERE pruid ='10';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_pe CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_pe AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b WHERE pruid ='11';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_ns CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_ns AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b WHERE pruid ='12';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_nb CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_nb AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b WHERE pruid ='13';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_qc CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_qc AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b WHERE pruid ='24';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_on CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_on AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b WHERE pruid ='35';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_mb CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_mb AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b WHERE pruid ='46';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_sk CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_sk AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b WHERE pruid ='47';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_ab CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_ab AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b WHERE pruid ='48';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_bc CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_bc AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b WHERE pruid ='59';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_yt CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_yt AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b WHERE pruid ='60';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_nt CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_nt AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b WHERE pruid ='61';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_nu CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_nu AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b WHERE pruid ='62';