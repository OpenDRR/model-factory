-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_nhsl_physical_exposure;

-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Settled Area
SELECT 
a.sauid AS "Sauid",
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_SauidLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_SauidLat",
CAST(CAST(ROUND(CAST(a.sauid_km2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_AreaKm2",
CAST(CAST(ROUND(CAST(a.sauid_ha AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_AreaHa",
a.landuse AS "E_LandUse",
CAST(CAST(ROUND(CAST(SUM(a.bldg_ft2 * a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_BldgArea",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.occtype = 'RES' THEN a.bldg_ft2 * a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_BldgAreaRes",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.occtype = 'COM' THEN a.bldg_ft2 * a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_BldgAreaComm",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.occtype = 'IND' THEN a.bldg_ft2 * a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_BldgAreaInd",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.occtype IN ('GOV','EDU','REL') THEN a.bldg_ft2 * a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_BldgAreaCivic",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.occtype = 'AGR' THEN a.bldg_ft2 * a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_BldgAreaAgr",
CAST(CAST(ROUND(CAST(SUM(a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_BldgNum",
CAST(CAST(ROUND(CAST(c.censuspop AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_CensusPop",
CAST(CAST(ROUND(CAST(c.censusdu AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_CensusDU",
CAST(CAST(ROUND(CAST(AVG(a.popdu) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_People_DU",
CAST(CAST(ROUND(CAST(SUM(a.day)/(a.sauid_km2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_PopDay_Km2",
CAST(CAST(ROUND(CAST(SUM(a.day)/(a.sauid_ha) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_PopDay_Ha",
CAST(CAST(ROUND(CAST(SUM(a.night)/(a.sauid_km2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_PopNight_Km2",
CAST(CAST(ROUND(CAST(SUM(a.night)/(a.sauid_ha) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_PopNight_Ha",
CAST(CAST(ROUND(CAST(SUM(a.number)/(a.sauid_km2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) as "Et_Bldg_Km2",
CAST(CAST(ROUND(CAST(SUM(a.structural + a.nonstructural + a.contents)/(a.sauid_km2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Value_Km2",

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.2 Building Function
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.occtype ='RES' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Res",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.occtype ='COM' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Comm",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.occtype ='IND' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Ind",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.occtype IN ('GOV','EDU','REL') THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Civic",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.occtype ='AGR' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Agr",

-- single family household, res units for RES1, RES2 = 1
CAST(CAST(ROUND(CAST(SUM(CASE 
					  WHEN a.occclass1 = 'RES1' THEN a.number * 1
					  WHEN a.occclass1 = 'RES2' THEN a.number * 1 
					  ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_SFHshld",

-- multi family household, res units for RES3A = 2, RES3B = 4, RES3C = 9, RES3D = 17, RES3E = 32, RES3F = 110, RES4 = 68, RES5 = 50, RES6 = 65
CAST(CAST(ROUND(CAST(SUM(CASE 
					  WHEN a.occclass1 = 'RES3A' THEN a.number * 2
					  WHEN a.occclass1 = 'RES3B' THEN a.number * 4
					  WHEN a.occclass1 = 'RES3C' THEN a.number * 9
					  WHEN a.occclass1 = 'RES3D' THEN a.number * 17
					  WHEN a.occclass1 = 'RES3E' THEN a.number * 32
					  WHEN a.occclass1 = 'RES3F' THEN a.number * 110
					  WHEN a.occclass1 = 'RES4' THEN a.number * 68
					  WHEN a.occclass1 = 'RES5' THEN a.number * 50
					  WHEN a.occclass1 = 'RES6' THEN a.number * 65
					  ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_MFHshld",

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.3 Building Type
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.gentype ='Wood' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Wood",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.gentype ='Concrete' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Concrete",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.gentype ='Precast' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_PreCast",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.gentype ='RMasonry' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_RMasonry",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.gentype ='URMasonry' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_URMasonry",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.gentype ='Steel' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Steel",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.gentype ='Manufactured' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Manufacture",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.eqdeslev ='PC' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_PreCode",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.eqdeslev ='LC' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_LowCode",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.eqdeslev ='MC' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_ModCode",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.eqdeslev ='HC' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_HiCode",

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.4 People
CAST(CAST(ROUND(CAST(SUM(a.day) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_PopDay",
CAST(CAST(ROUND(CAST(SUM(a.night) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_PopNight",
CAST(CAST(ROUND(CAST(SUM(a.transit) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_PopTransit",

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.5 Assets
CAST(CAST(ROUND(CAST(SUM(a.structural + a.nonstructural + a.contents) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_AssetValue",
CAST(CAST(ROUND(CAST(SUM(a.structural + a.nonstructural) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_BldgValue",
CAST(CAST(ROUND(CAST(SUM(a.structural) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_StrValue",
CAST(CAST(ROUND(CAST(SUM(a.nonstructural) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_NStrValue",
CAST(CAST(ROUND(CAST(SUM(a.contents) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_ContValue",

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
d.geom AS "geom_poly"
--d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN census.census_2016_canada c ON a.sauid = c.sauidt
LEFT JOIN boundaries."Geometry_SAUID" d on a.sauid = d."SAUIDt"
GROUP BY a.sauid,a.sauidlon,a.sauidlat,a.landuse,a.sauid_km2,a.sauid_ha,c.censuspop,c.censusdu,c.landuse,d."PRUID",d."PRNAME",d."ERUID",d."ERNAME",
d."CDUID",d."CDNAME",d."CSDUID",d."CSDNAME",d."CFSAUID",d."DAUIDt",d."SACCODE",d."SACTYPE",d.geom;



--create views for province
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_nl CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_nl AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s WHERE pruid ='10';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_pe CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_pe AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s WHERE pruid ='11';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_ns CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_ns AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s WHERE pruid ='12';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_nb CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_nb AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s WHERE pruid ='13';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_qc CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_qc AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s WHERE pruid ='24';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_on CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_on AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s WHERE pruid ='35';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_mb CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_mb AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s WHERE pruid ='46';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_sk CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_sk AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s WHERE pruid ='47';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_ab CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_ab AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s WHERE pruid ='48';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_bc CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_bc AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s WHERE pruid ='59';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_yt CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_yt AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s WHERE pruid ='60';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_nt CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_nt AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s WHERE pruid ='61';

DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_nu CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s_nu AS 
SELECT * FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s WHERE pruid ='62';