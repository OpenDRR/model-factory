-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_nhsl_metrovan_physical_exposure;

-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_metrovan_physical_exposure.nhsl_metrovan_physical_exposure_site_ste CASCADE;
CREATE VIEW results_nhsl_metrovan_physical_exposure.nhsl_metrovan_physical_exposure_site_ste AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Site
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

a.geom_site AS "geom_point"

FROM exposure.metrovan_site_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt";



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_metrovan_physical_exposure.nhsl_metrovan_physical_exposure_people_ste CASCADE;
CREATE VIEW results_nhsl_metrovan_physical_exposure.nhsl_metrovan_physical_exposure_people_ste AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.2 People
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
CAST(CAST(ROUND(CAST(a.day AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_PopDay",
CAST(CAST(ROUND(CAST(a.night AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_PopNight",
CAST(CAST(ROUND(CAST(a.transit AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_PopTransit",

a.geom_site AS "geom_point"

FROM exposure.metrovan_site_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt";



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_metrovan_physical_exposure.nhsl_metrovan_physical_exposure_assets_ste CASCADE;
CREATE VIEW results_nhsl_metrovan_physical_exposure.nhsl_metrovan_physical_exposure_assets_ste AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.2 Assets
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
CAST(CAST(ROUND(CAST(a.structural + a.nonstructural + a.contents AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_AssetValue",
CAST(CAST(ROUND(CAST(a.structural + a.nonstructural AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgValue",
CAST(CAST(ROUND(CAST(a.structural AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_StrValue",
CAST(CAST(ROUND(CAST(a.nonstructural AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_NStrValue",
CAST(CAST(ROUND(CAST(a.contents AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_ContValue",
CAST(CAST(ROUND(CAST(a.retrofitting AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_RetrofitCost",

a.geom_site AS "geom_point"

FROM exposure.metrovan_site_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt";