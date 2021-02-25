-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_nhsl_physical_exposure;

-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Building
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
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
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLat",
CAST(CAST(ROUND(CAST(a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgNum",
CAST(CAST(ROUND(CAST(a.bldg_ft2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgArea",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc IN ('Residential-LD','Residential-MD','Residential-HD') THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaRes",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Commercial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaComm",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Industrial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaInd",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Civic' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaCivic",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Agricultural' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaAgr",

a.landuse AS "E_LandUse",
a.genocc AS "E_BldgOccG",
a.occclass1 AS "E_BldgOccS1",
a.occclass2 AS "E_BldgOccS2",
a.gentype AS "E_BldgTypeG",
a.bldgtype AS "E_BldgTypeS",
a.eqdeslev AS "E_BldgDesLev",
a.bldepoch AS "E_BldgEpoch",
a.ssc_zone AS "SSC_Zone",

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

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt";



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_nl CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_nl AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Building
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
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
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLat",
CAST(CAST(ROUND(CAST(a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgNum",
CAST(CAST(ROUND(CAST(a.bldg_ft2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "EBldgArea",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc IN ('Residential-LD','Residential-MD','Residential-HD') THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaRes",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Commercial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaComm",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Industrial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaInd",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Civic' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaCivic",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Agricultural' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaAgr",

a.landuse AS "E_LandUse",
a.genocc AS "E_BldgOccG",
a.occclass1 AS "E_BldgOccS1",
a.occclass2 AS "E_BldgOccS2",
a.gentype AS "E_BldgTypeG",
a.bldgtype AS "E_BldgTypeS",
a.eqdeslev AS "E_BldgDesLev",
a.bldepoch AS "E_BldgEpoch",
a.ssc_zone AS "SSC_Zone",

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

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt"
WHERE b."PRUID" = '10';



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_pe CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_pe AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Building
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
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
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLat",
CAST(CAST(ROUND(CAST(a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgNum",
CAST(CAST(ROUND(CAST(a.bldg_ft2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "EBldgArea",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc IN ('Residential-LD','Residential-MD','Residential-HD') THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaRes",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Commercial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaComm",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Industrial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaInd",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Civic' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaCivic",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Agricultural' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaAgr",

a.landuse AS "E_LandUse",
a.genocc AS "E_BldgOccG",
a.occclass1 AS "E_BldgOccS1",
a.occclass2 AS "E_BldgOccS2",
a.gentype AS "E_BldgTypeG",
a.bldgtype AS "E_BldgTypeS",
a.eqdeslev AS "E_BldgDesLev",
a.bldepoch AS "E_BldgEpoch",
a.ssc_zone AS "SSC_Zone",

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

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt"
WHERE b."PRUID" = '11';



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_ns CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_ns AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Building
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
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
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLat",
CAST(CAST(ROUND(CAST(a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgNum",
CAST(CAST(ROUND(CAST(a.bldg_ft2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "EBldgArea",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc IN ('Residential-LD','Residential-MD','Residential-HD') THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaRes",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Commercial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaComm",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Industrial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaInd",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Civic' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaCivic",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Agricultural' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaAgr",

a.landuse AS "E_LandUse",
a.genocc AS "E_BldgOccG",
a.occclass1 AS "E_BldgOccS1",
a.occclass2 AS "E_BldgOccS2",
a.gentype AS "E_BldgTypeG",
a.bldgtype AS "E_BldgTypeS",
a.eqdeslev AS "E_BldgDesLev",
a.bldepoch AS "E_BldgEpoch",
a.ssc_zone AS "SSC_Zone",

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

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt"
WHERE b."PRUID" = '12';



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_nb CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_nb AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Building
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
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
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLat",
CAST(CAST(ROUND(CAST(a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgNum",
CAST(CAST(ROUND(CAST(a.bldg_ft2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "EBldgArea",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc IN ('Residential-LD','Residential-MD','Residential-HD') THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaRes",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Commercial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaComm",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Industrial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaInd",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Civic' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaCivic",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Agricultural' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaAgr",

a.landuse AS "E_LandUse",
a.genocc AS "E_BldgOccG",
a.occclass1 AS "E_BldgOccS1",
a.occclass2 AS "E_BldgOccS2",
a.gentype AS "E_BldgTypeG",
a.bldgtype AS "E_BldgTypeS",
a.eqdeslev AS "E_BldgDesLev",
a.bldepoch AS "E_BldgEpoch",
a.ssc_zone AS "SSC_Zone",

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

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt"
WHERE b."PRUID" = '13';



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_qc CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_qc AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Building
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
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
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLat",
CAST(CAST(ROUND(CAST(a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgNum",
CAST(CAST(ROUND(CAST(a.bldg_ft2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "EBldgArea",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc IN ('Residential-LD','Residential-MD','Residential-HD') THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaRes",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Commercial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaComm",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Industrial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaInd",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Civic' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaCivic",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Agricultural' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaAgr",

a.landuse AS "E_LandUse",
a.genocc AS "E_BldgOccG",
a.occclass1 AS "E_BldgOccS1",
a.occclass2 AS "E_BldgOccS2",
a.gentype AS "E_BldgTypeG",
a.bldgtype AS "E_BldgTypeS",
a.eqdeslev AS "E_BldgDesLev",
a.bldepoch AS "E_BldgEpoch",
a.ssc_zone AS "SSC_Zone",

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

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt"
WHERE b."PRUID" = '24';



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_on CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_on AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Building
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
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
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLat",
CAST(CAST(ROUND(CAST(a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgNum",
CAST(CAST(ROUND(CAST(a.bldg_ft2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "EBldgArea",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc IN ('Residential-LD','Residential-MD','Residential-HD') THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaRes",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Commercial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaComm",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Industrial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaInd",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Civic' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaCivic",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Agricultural' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaAgr",

a.landuse AS "E_LandUse",
a.genocc AS "E_BldgOccG",
a.occclass1 AS "E_BldgOccS1",
a.occclass2 AS "E_BldgOccS2",
a.gentype AS "E_BldgTypeG",
a.bldgtype AS "E_BldgTypeS",
a.eqdeslev AS "E_BldgDesLev",
a.bldepoch AS "E_BldgEpoch",
a.ssc_zone AS "SSC_Zone",

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

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt"
WHERE b."PRUID" = '35';



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_mb CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_mb AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Building
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
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
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLat",
CAST(CAST(ROUND(CAST(a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgNum",
CAST(CAST(ROUND(CAST(a.bldg_ft2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "EBldgArea",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc IN ('Residential-LD','Residential-MD','Residential-HD') THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaRes",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Commercial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaComm",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Industrial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaInd",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Civic' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaCivic",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Agricultural' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaAgr",

a.landuse AS "E_LandUse",
a.genocc AS "E_BldgOccG",
a.occclass1 AS "E_BldgOccS1",
a.occclass2 AS "E_BldgOccS2",
a.gentype AS "E_BldgTypeG",
a.bldgtype AS "E_BldgTypeS",
a.eqdeslev AS "E_BldgDesLev",
a.bldepoch AS "E_BldgEpoch",
a.ssc_zone AS "SSC_Zone",

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

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt"
WHERE b."PRUID" = '46';



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_sk CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_sk AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Building
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
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
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLat",
CAST(CAST(ROUND(CAST(a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgNum",
CAST(CAST(ROUND(CAST(a.bldg_ft2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "EBldgArea",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc IN ('Residential-LD','Residential-MD','Residential-HD') THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaRes",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Commercial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaComm",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Industrial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaInd",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Civic' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaCivic",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Agricultural' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaAgr",

a.landuse AS "E_LandUse",
a.genocc AS "E_BldgOccG",
a.occclass1 AS "E_BldgOccS1",
a.occclass2 AS "E_BldgOccS2",
a.gentype AS "E_BldgTypeG",
a.bldgtype AS "E_BldgTypeS",
a.eqdeslev AS "E_BldgDesLev",
a.bldepoch AS "E_BldgEpoch",
a.ssc_zone AS "SSC_Zone",

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

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt"
WHERE b."PRUID" = '47';



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_ab CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_ab AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Building
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
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
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLat",
CAST(CAST(ROUND(CAST(a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgNum",
CAST(CAST(ROUND(CAST(a.bldg_ft2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "EBldgArea",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc IN ('Residential-LD','Residential-MD','Residential-HD') THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaRes",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Commercial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaComm",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Industrial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaInd",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Civic' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaCivic",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Agricultural' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaAgr",

a.landuse AS "E_LandUse",
a.genocc AS "E_BldgOccG",
a.occclass1 AS "E_BldgOccS1",
a.occclass2 AS "E_BldgOccS2",
a.gentype AS "E_BldgTypeG",
a.bldgtype AS "E_BldgTypeS",
a.eqdeslev AS "E_BldgDesLev",
a.bldepoch AS "E_BldgEpoch",
a.ssc_zone AS "SSC_Zone",

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

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt"
WHERE b."PRUID" = '48';



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_bc CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_bc AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Building
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
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
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLat",
CAST(CAST(ROUND(CAST(a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgNum",
CAST(CAST(ROUND(CAST(a.bldg_ft2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "EBldgArea",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc IN ('Residential-LD','Residential-MD','Residential-HD') THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaRes",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Commercial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaComm",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Industrial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaInd",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Civic' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaCivic",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Agricultural' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaAgr",

a.landuse AS "E_LandUse",
a.genocc AS "E_BldgOccG",
a.occclass1 AS "E_BldgOccS1",
a.occclass2 AS "E_BldgOccS2",
a.gentype AS "E_BldgTypeG",
a.bldgtype AS "E_BldgTypeS",
a.eqdeslev AS "E_BldgDesLev",
a.bldepoch AS "E_BldgEpoch",
a.ssc_zone AS "SSC_Zone",

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

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt"
WHERE b."PRUID" = '59';


-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_yt CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_yt AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Building
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
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
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLat",
CAST(CAST(ROUND(CAST(a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgNum",
CAST(CAST(ROUND(CAST(a.bldg_ft2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "EBldgArea",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc IN ('Residential-LD','Residential-MD','Residential-HD') THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaRes",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Commercial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaComm",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Industrial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaInd",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Civic' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaCivic",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Agricultural' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaAgr",

a.landuse AS "E_LandUse",
a.genocc AS "E_BldgOccG",
a.occclass1 AS "E_BldgOccS1",
a.occclass2 AS "E_BldgOccS2",
a.gentype AS "E_BldgTypeG",
a.bldgtype AS "E_BldgTypeS",
a.eqdeslev AS "E_BldgDesLev",
a.bldepoch AS "E_BldgEpoch",
a.ssc_zone AS "SSC_Zone",

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

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt"
WHERE b."PRUID" = '60';



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_nt CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_nt AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Building
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
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
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLat",
CAST(CAST(ROUND(CAST(a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgNum",
CAST(CAST(ROUND(CAST(a.bldg_ft2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "EBldgArea",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc IN ('Residential-LD','Residential-MD','Residential-HD') THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaRes",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Commercial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaComm",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Industrial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaInd",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Civic' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaCivic",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Agricultural' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaAgr",

a.landuse AS "E_LandUse",
a.genocc AS "E_BldgOccG",
a.occclass1 AS "E_BldgOccS1",
a.occclass2 AS "E_BldgOccS2",
a.gentype AS "E_BldgTypeG",
a.bldgtype AS "E_BldgTypeS",
a.eqdeslev AS "E_BldgDesLev",
a.bldepoch AS "E_BldgEpoch",
a.ssc_zone AS "SSC_Zone",

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

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt"
WHERE b."PRUID" = '61';



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_nu CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b_nu AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Building
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
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
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLat",
CAST(CAST(ROUND(CAST(a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgNum",
CAST(CAST(ROUND(CAST(a.bldg_ft2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "EBldgArea",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc IN ('Residential-LD','Residential-MD','Residential-HD') THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaRes",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Commercial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaComm",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Industrial' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaInd",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Civic' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaCivic",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Agricultural' THEN a.bldg_ft2 ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaAgr",

a.landuse AS "E_LandUse",
a.genocc AS "E_BldgOccG",
a.occclass1 AS "E_BldgOccS1",
a.occclass2 AS "E_BldgOccS2",
a.gentype AS "E_BldgTypeG",
a.bldgtype AS "E_BldgTypeS",
a.eqdeslev AS "E_BldgDesLev",
a.bldepoch AS "E_BldgEpoch",
a.ssc_zone AS "SSC_Zone",

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

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt"
WHERE b."PRUID" = '62';