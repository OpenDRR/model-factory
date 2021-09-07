-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_dsra_{eqScenario};


DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap;

CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_shakemap AS
(
SELECT 
site_id,
"gmv_SA(0.1)",
"gmv_SA(0.2)",
"gmv_SA(0.3)",
"gmv_SA(0.5)",
"gmv_SA(1.0)",
"gmv_SA(2.0)",
lon,
lat,
geom,
gmv_pga,
gmv_pgv
FROM gmf.shakemap_{eqScenario}
WHERE "gmv_SA(0.3)" >= 0.02
);

-- add polygon extents with smoothing scenario extents table for each scenario
INSERT INTO gmf.shakemap_scenario_extents_temp(scenario,geom)
SELECT '{eqScenario}',st_astext(st_chaikinsmoothing(st_concavehull(st_collect(geom),0.98))) FROM gmf.shakemap_{eqScenario} WHERE "gmv_SA(0.3)" >= 0.02;

-- create index
CREATE INDEX IF NOT EXISTS {eqScenario}_assetid_idx ON dsra.dsra_{eqScenario}("AssetID");


--intermediates table to calculate displaced households for DSRA
DROP TABLE IF EXISTS results_dsra_{eq_Scenario}.{eq_Scenario}.displhshld_calc1 CASCADE;
CREATE TABLE results_dsra_{eq_Scenario}.{eq_Scenario}.displhshld_calc1 AS
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
a."sC_Downtime_b0",
a."sC_Downtime_r1",
d."E_CensusDU",
b."E_BldgOccG",
b."E_SFHshld",
b."E_MFHshld",

-- SFM
CASE WHEN b."E_BldgOccG" = 'Residential-LD' THEN (a."sD_Moderate_b0" / c.number) ELSE 0 END AS "SFM_b0",
CASE WHEN b."E_BldgOccG" = 'Residential-LD' THEN (a."sD_Moderate_r1" / c.number) ELSE 0 END AS "SFM_r1",
--CASE WHEN b."E_BldgOccG" = 'Residential-LD' THEN (a."sD_Moderate_b0") ELSE 0 END AS "SFM_b0",
--CASE WHEN b."E_BldgOccG" = 'Residential-LD' THEN (a."sD_Moderate_r1") ELSE 0 END AS "SFM_r1",

-- SFE
CASE WHEN b."E_BldgOccG" = 'Residential-LD' THEN (a."sD_Extensive_b0" / c.number) ELSE 0 END AS "SFE_b0",
CASE WHEN b."E_BldgOccG" = 'Residential-LD' THEN (a."sD_Extensive_r1" / c.number) ELSE 0 END AS "SFE_r1",
--CASE WHEN b."E_BldgOccG" = 'Residential-LD' THEN (a."sD_Extensive_b0") ELSE 0 END AS "SFE_b0",
--CASE WHEN b."E_BldgOccG" = 'Residential-LD' THEN (a."sD_Extensive_r1") ELSE 0 END AS "SFE_r1",

-- SFC
CASE WHEN b."E_BldgOccG" = 'Residential-LD' THEN (a."sD_Complete_b0" / c.number) ELSE 0 END AS "SFC_b0",
CASE WHEN b."E_BldgOccG" = 'Residential-LD' THEN (a."sD_Complete_r1" / c.number) ELSE 0 END AS "SFC_r1",
--CASE WHEN b."E_BldgOccG" = 'Residential-LD' THEN (a."sD_Complete_b0") ELSE 0 END AS "SFC_b0",
--CASE WHEN b."E_BldgOccG" = 'Residential-LD' THEN (a."sD_Complete_r1") ELSE 0 END AS "SFC_r1",

-- MFM
CASE WHEN b."E_BldgOccG" = 'Residential-MD' OR b."E_BldgOccG" = 'Residential-HD' THEN (a."sD_Moderate_b0" / c.number) ELSE 0 END AS "MFM_b0",
CASE WHEN b."E_BldgOccG" = 'Residential-MD' OR b."E_BldgOccG" = 'Residential-HD' THEN (a."sD_Moderate_r1" / c.number) ELSE 0 END AS "MFM_r1",
--CASE WHEN b."E_BldgOccG" = 'Residential-MD' OR b."E_BldgOccG" = 'Residential-HD' THEN (a."sD_Moderate_b0") ELSE 0 END AS "MFM_b0",
--CASE WHEN b."E_BldgOccG" = 'Residential-MD' OR b."E_BldgOccG" = 'Residential-HD' THEN (a."sD_Moderate_r1") ELSE 0 END AS "MFM_r1",

-- MFE
CASE WHEN b."E_BldgOccG" = 'Residential-MD' OR b."E_BldgOccG" = 'Residential-HD' THEN (a."sD_Extensive_b0" / c.number) ELSE 0 END AS "MFE_b0",
CASE WHEN b."E_BldgOccG" = 'Residential-MD' OR b."E_BldgOccG" = 'Residential-HD' THEN (a."sD_Extensive_r1" / c.number) ELSE 0 END AS "MFE_r1",
--CASE WHEN b."E_BldgOccG" = 'Residential-MD' OR b."E_BldgOccG" = 'Residential-HD' THEN (a."sD_Extensive_b0") ELSE 0 END AS "MFE_b0",
--CASE WHEN b."E_BldgOccG" = 'Residential-MD' OR b."E_BldgOccG" = 'Residential-HD' THEN (a."sD_Extensive_r1") ELSE 0 END AS "MFE_r1",

-- MFC
CASE WHEN b."E_BldgOccG" = 'Residential-MD' OR b."E_BldgOccG" = 'Residential-HD' THEN (a."sD_Complete_b0" / c.number) ELSE 0 END AS "MFC_b0",
CASE WHEN b."E_BldgOccG" = 'Residential-MD' OR b."E_BldgOccG" = 'Residential-HD' THEN (a."sD_Complete_r1" / c.number) ELSE 0 END AS "MFC_r1",
--CASE WHEN b."E_BldgOccG" = 'Residential-MD' OR b."E_BldgOccG" = 'Residential-HD' THEN (a."sD_Complete_b0") ELSE 0 END AS "MFC_b0",
--CASE WHEN b."E_BldgOccG" = 'Residential-MD' OR b."E_BldgOccG" = 'Residential-HD' THEN (a."sD_Complete_r1") ELSE 0 END AS "MFC_r1",

0 AS "W_SFM",
0 AS "W_SFE",
1 AS "W_SFC",
0 AS "W_MFM",
0.9 AS "W_MFE",
1 AS "W_MFC"

FROM dsra.dsra_sim9p0_cascadiainterfacebestfault a
LEFT JOIN results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b b ON a."AssetID" = b."BldgID"
LEFT JOIN exposure.canada_exposure c ON  a."AssetID" = c.id
LEFT JOIN results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_s d ON c.sauid = d."Sauid"
);


--intermediate tables to calculate displaced households for DSRA
DROP TABLE IF EXISTS results_dsra_{eq_Scenario}.{eq_Scenario}.displhshld_calc2 CASCADE;
CREATE TABLE results_dsra_{eq_Scenario}.{eq_Scenario}.displhshld_calc2 AS
(
SELECT
"AssetID",
-- ([W_SFM]*[SFM]) + ([W_SFE]*[SFE]) + ([W_SFC]*[SFC]) = SF
("W_SFM" * "SFM_b0") + ("W_SFE" * "SFE_b0") + ("W_SFC" * "SFC_b0") AS "SF_b0",
("W_SFM" * "SFM_r1") + ("W_SFE" * "SFE_r1") + ("W_SFC" * "SFC_r1") AS "SF_r1",

--([W_MFM]*[MFM]) + ([W_MFE]*[MFE]) + ([W_MFC]*MFC]) = MF
("W_MFM" * "MFM_b0") + ("W_MFE" * "MFE_b0") + ("W_MFC" * "MFC_b0") AS "MF_b0",
("W_MFM" * "MFM_r1") + ("W_MFE" * "MFE_r1") + ("W_MFC" * "MFC_r1") AS "MF_r1"

FROM results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_displhshld_calc1
);


--intermediate tables to calculate displaced households for DSRA
DROP TABLE IF EXISTS results_dsra_{eq_Scenario}.{eq_Scenario}.displhshld_calc3 CASCADE;
CREATE TABLE results_dsra_{eq_Scenario}.{eq_Scenario}.displhshld_calc3 AS
(
SELECT
a."AssetID",

--(([SF_Hshlds] * [SF]) + ([MF_Hshlds] * [MF])) * ([CensusDU] / ([SF_Hshlds] + [MF_Hshlds]) = DH
--COALESCE((a."E_SFHshld" * b."SF_b0") + (a."E_MFHshld" * b."MF_b0") * (a."E_CensusDU" /NULLIF((a."E_SFHshld" + a."E_MFHshld"),0)),0) AS "sC_DisplHshld_b0",
COALESCE((a."E_SFHshld" * b."SF_b0") + (a."E_MFHshld" * b."MF_b0"),0) AS "sC_DisplHshld_b0",
--COALESCE((a."E_SFHshld" * b."SF_r1") + (a."E_MFHshld" * b."MF_r1") * (a."E_CensusDU" /NULLIF((a."E_SFHshld" + a."E_MFHshld"),0)),0) AS "sC_DisplHshld_r1",
COALESCE((a."E_SFHshld" * b."SF_r1") + (a."E_MFHshld" * b."MF_r1"),0) AS "sC_DisplHshld_r1"

FROM results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_displhshld_calc1 a
LEFT JOIN results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_displhshld_calc2 b on a."AssetID" = b."AssetID"
);


--intermediate tables to calculate displaced households for DSRA
DROP TABLE IF EXISTS results_dsra_{eq_Scenario}.{eq_Scenario}.displhshld CASCADE;
CREATE TABLE results_dsra_{eq_Scenario}.{eq_Scenario}.displhshld AS
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
a."sC_Downtime_b0",
a."sC_Downtime_r1",
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

FROM results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_displhshld_calc1 a
LEFT JOIN results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_displhshld_calc2 b ON a."AssetID" = b."AssetID"
LEFT JOIN results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_displhshld_calc3 c ON a."AssetID" = c."AssetID"
);

DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_displhshld_calc1,results_dsra_{eqScenario}.{eqScenario}_displhshld_calc2,results_dsra_{eqScenario}.{eqScenario}_displhshld_calc3;


-- create scenario risk building indicators
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_all_indicators_b CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_all_indicators_b AS 

--3.0 Earthquake Scenario Risk (DSRA)
--3.1 Scenario Hazard
SELECT 
a."AssetID",

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
e.site_id AS "sH_SiteID",
CAST(CAST(ROUND(CAST(e.lon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_SiteLon",
CAST(CAST(ROUND(CAST(e.lat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_SiteLat",
--CAST(CAST(ROUND(CAST(d.vs_lon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS  "sH_Vs30Lon",
--CAST(CAST(ROUND(CAST(d.vs_lat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Vs30Lat",
CAST(CAST(ROUND(CAST(d.vs30 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Vs30",
CAST(CAST(ROUND(CAST(d.z1pt0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_z1p0",
CAST(CAST(ROUND(CAST(d.z2pt5 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_z2p5",
--CAST(CAST(ROUND(CAST(e."gmv_pgv" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_PGV",
CAST(CAST(ROUND(CAST(e."gmv_pga" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_PGA",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.1)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p1",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.2)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p2",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.3)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p3",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.5)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p5",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.6)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p6",
CAST(CAST(ROUND(CAST(e."gmv_SA(1.0)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa1p0",
CAST(CAST(ROUND(CAST(e."gmv_SA(2.0)" AS NUMERIC),6) AS FLOAT) AS NUMERIC)AS "sH_Sa2p0",


-- 3.0 Earthquake Scenario Risk (DSRA)
-- 3.2 Building Damage
-- 3.2.1 Damage State - b0
CAST(CAST(ROUND(CAST(a."sD_None_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_None_b0",
CAST(CAST(ROUND(CAST(a."sD_None_b0" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_None_b0",
--CAST(CAST(ROUND(CAST(a."sD_None_stdv_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDsd_None_b0",

CAST(CAST(ROUND(CAST(a."sD_Slight_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Slight_b0",
CAST(CAST(ROUND(CAST(a."sD_Slight_b0" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Slight_b0",
--CAST(CAST(ROUND(CAST(a."sD_Slight_stdv_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDsd_Slight_b0",

CAST(CAST(ROUND(CAST(a."sD_Moderate_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Moderate_b0",
CAST(CAST(ROUND(CAST(a."sD_Moderate_b0" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Moderate_b0",
--CAST(CAST(ROUND(CAST(a."sD_Moderate_stdv_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDsd_Moderate_b0",

CAST(CAST(ROUND(CAST(a."sD_Extensive_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Extensive_b0",
CAST(CAST(ROUND(CAST(a."sD_Extensive_b0" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Extensive_b0",
--CAST(CAST(ROUND(CAST(a."sD_Extensive_stdv_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDsd_Extensive_b0",

CAST(CAST(ROUND(CAST(a."sD_Complete_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Complete_b0",
CAST(CAST(ROUND(CAST(a."sD_Complete_b0" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Complete_b0",
--CAST(CAST(ROUND(CAST(a."sD_Complete_stdv_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDsd_Complete_b0",

CAST(CAST(ROUND(CAST(a."sD_Collapse_b0" * b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Collapse_b0",
CAST(CAST(ROUND(CAST(a."sD_Collapse_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Collapse_b0",
--CAST(CAST(ROUND(CAST(a."sD_Complete_stdv_b0" * g.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDsd_Collapse_b0",

-- 3.2.1 Damage State - r1
CAST(CAST(ROUND(CAST(a."sD_None_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_None_r1",
CAST(CAST(ROUND(CAST(a."sD_None_r1" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_None_r1",
--CAST(CAST(ROUND(CAST(a."sD_None_stdv_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDsd_None_r1",

CAST(CAST(ROUND(CAST(a."sD_Slight_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Slight_r1",
CAST(CAST(ROUND(CAST(a."sD_Slight_r1" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Slight_r1",
--CAST(CAST(ROUND(CAST(a."sD_Slight_stdv_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDsd_Slight_r1",

CAST(CAST(ROUND(CAST(a."sD_Moderate_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Moderate_r1",
CAST(CAST(ROUND(CAST(a."sD_Moderate_r1" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Moderate_r1",
--CAST(CAST(ROUND(CAST(a."sD_Moderate_stdv_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDsd_Moderate_r1",

CAST(CAST(ROUND(CAST(a."sD_Extensive_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Extensive_r1",
CAST(CAST(ROUND(CAST(a."sD_Extensive_r1" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Extensive_r1",
--CAST(CAST(ROUND(CAST(a."sD_Extensive_stdv_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDsd_Extensive_r1",

CAST(CAST(ROUND(CAST(a."sD_Complete_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Complete_r1",
CAST(CAST(ROUND(CAST(a."sD_Complete_r1" / b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Complete_r1",
--CAST(CAST(ROUND(CAST(a."sD_Complete_stdv_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDsd_Complete_r1",

CAST(CAST(ROUND(CAST(a."sD_Collapse_r1" * b.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Collapse_r1",
CAST(CAST(ROUND(CAST(a."sD_Collapse_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Collapse_r1",
--CAST(CAST(ROUND(CAST(a."sD_Complete_stdv_r1" * g.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDsd_Collapse_r1",


-- 3.0 Earthquake Scenario Risk (DSRA)
-- 3.2 Building Damage
-- 3.2.1 Recovery - b0
--CAST(CAST(ROUND(CAST(a."sC_Repair_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Repair_b0",
--CAST(CAST(ROUND(CAST(a."sC_Construxn_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Recovery_b0",
--CAST(CAST(ROUND(CAST(a."sC_Downtime_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Downtime_b0",
CAST(CAST(ROUND(CAST(a."sC_Repair_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Repair_b0",
CAST(CAST(ROUND(CAST(a."sC_Recovery_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Recovery_b0",
CAST(CAST(ROUND(CAST(a."sC_Downtime_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Downtime_b0",
CAST(CAST(ROUND(CAST((a."sC_DebrisBW_b0" + a."sC_DebrisC_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DebrisTotal_b0",
CAST(CAST(ROUND(CAST(a."sC_DebrisBW_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DebrisBW_b0",
CAST(CAST(ROUND(CAST(a."sC_DebrisC_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DebrisCS_b0",

-- 3.2.1 Recovery - r1
--CAST(CAST(ROUND(CAST(a."sC_Repair_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Repair_r1",
--CAST(CAST(ROUND(CAST(a."sC_Construxn_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Recovery_r1",
--CAST(CAST(ROUND(CAST(a."sC_Downtime_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Downtime_r1",
CAST(CAST(ROUND(CAST(a."sC_Repair_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Repair_r1",
CAST(CAST(ROUND(CAST(a."sC_Recovery_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Recovery_r1",
CAST(CAST(ROUND(CAST(a."sC_Downtime_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Downtime_r1",
CAST(CAST(ROUND(CAST((a."sC_DebrisBW_r1" + a."sC_DebrisC_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DebrisTotal_r1",
CAST(CAST(ROUND(CAST(a."sC_DebrisBW_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DebrisBW_r1",
CAST(CAST(ROUND(CAST(a."sC_DebrisC_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DebrisCS_r1",
-- 3.2.3 Building Characteristics
b.bldgtype AS "E_BldgTypeG",
b.occtype AS "E_OccType",


-- 3.0 Earthquake Scenario Risk (DSRA)
-- 3.3 Affected People
-- 3.3.1 Casualties - b0
--CAST(CAST(ROUND(CAST(a."sL_Fatalities_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Fatality_b0",
--CAST(CAST(ROUND(CAST(a."sL_Fatalities_stdv_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLsd_Fatality_b0",
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
--CAST(CAST(ROUND(CAST(a."sL_Fatalities_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Fatality_r1",
--CAST(CAST(ROUND(CAST(a."sL_Fatalities_stdv_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLsd_Fatality_r1",
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
CAST(CAST(ROUND(CAST(a."sC_DisplRes_3_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes3_b0",
CAST(CAST(ROUND(CAST(a."sC_DisplRes_30_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes30_b0",
CAST(CAST(ROUND(CAST(a."sC_DisplRes_90_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes90_b0",
CAST(CAST(ROUND(CAST(a."sC_DisplRes_180_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes180_b0",
CAST(CAST(ROUND(CAST(a."sC_DisplRes_360_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes360_b0",

CAST(CAST(ROUND(CAST(h."sC_DisplHshld_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplHshld_b0",


CAST(CAST(ROUND(CAST(a."sC_DisrupEmpl_30_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisrupEmpl_30_b0",
CAST(CAST(ROUND(CAST(a."sC_DisrupEmpl_90_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisrupEmpl_90_b0",
CAST(CAST(ROUND(CAST(a."sC_DisrupEmpl_180_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisrupEmpl_180_b0",
CAST(CAST(ROUND(CAST(a."sC_DisrupEmpl_360_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisrupEmpl_360_b0",

-- 3.3.2 Social Disruption - r1
-- sC_Shelter -- calculated at sauid level only
CAST(CAST(ROUND(CAST(a."sC_DisplRes_3_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes3_r1",
CAST(CAST(ROUND(CAST(a."sC_DisplRes_30_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes30_r1",
CAST(CAST(ROUND(CAST(a."sC_DisplRes_90_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes90_r1",
CAST(CAST(ROUND(CAST(a."sC_DisplRes_360_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes360_r1",

CAST(CAST(ROUND(CAST(h."sC_DisplHshld_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplHshld_r1",

CAST(CAST(ROUND(CAST(a."sC_DisrupEmpl_30_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisrupEmpl_30_r1",
CAST(CAST(ROUND(CAST(a."sC_DisrupEmpl_90_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisrupEmpl_90_r1",
CAST(CAST(ROUND(CAST(a."sC_DisrupEmpl_180_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisrupEmpl_180_r1",
CAST(CAST(ROUND(CAST(a."sC_DisrupEmpl_360_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisrupEmpl_360_r1",


-- 3.0 Earthquake Scenario Risk (DSRA)
-- 3.4 Economic Security
-- 3.4.1 Economic Loss - b0
CAST(CAST(ROUND(CAST(a."sL_Str_b0" + a."sL_NStr_b0" + a."sL_Cont_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Asset_b0",
CAST(CAST(ROUND(CAST(a."sL_Str_b0" + a."sL_NStr_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Bldg_b0",
CAST(CAST(ROUND(CAST(COALESCE(((a."sL_Str_b0" + a."sL_NStr_b0")/(b.number))/NULLIF(((b.structural + b.nonstructural)/(b.number)),0),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLr_Bldg_b0",

CAST(CAST(ROUND(CAST((((a."sL_Str_b0" + a."sL_NStr_b0") - (a."sL_Str_r1" + a."sL_NStr_r1"))/(b.number))/((b.retrofitting)/(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLr1_BCR_b0",
--CAST(CAST(ROUND(CAST((((a."sL_Str_b0" + a."sL_NStr_b0" + a."sL_Cont_b0") - (a."sL_Str_r1" + a."sL_NStr_r1" + a."sL_Cont_r1"))/(b.retrofitting)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLr1_BCR_b0",

CAST(CAST(ROUND(CAST((((a."sL_Str_b0" + a."sL_NStr_b0") - (a."sL_Str_r1" + a."sL_NStr_r1"))/(b.number)) * ((EXP(-0.025*50)/0.025))/((b.retrofitting)/(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "SLr1_RoI",
--CAST(CAST(ROUND(CAST((((a."sL_Str_b0" + a."sL_NStr_b0" + a."sL_Cont_b0") - (a."sL_Str_r1" + a."sL_NStr_r1" + a."sL_Cont_r1")) * ((EXP(-0.03*100)/0.03)/(b.retrofitting))) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "SLr1_RoI",

CAST(CAST(ROUND(CAST(a."sL_Str_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Str_b0",
--CAST(CAST(ROUND(CAST(a."sL_Str_stdv_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLsd_Str_b0",

CAST(CAST(ROUND(CAST(a."sL_NStr_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_NStr_b0",
--CAST(CAST(ROUND(CAST(a."sL_NStr_stdv_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLsd_NStr_b0",

CAST(CAST(ROUND(CAST(a."sL_Cont_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Cont_b0",
--CAST(CAST(ROUND(CAST(a."sL_Cont_stdv_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLsd_Cont_b0",

-- 3.4.1 Economic Loss - r1
CAST(CAST(ROUND(CAST(a."sL_Str_r1" + a."sL_NStr_r1" + a."sL_Cont_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Asset_r1",
CAST(CAST(ROUND(CAST(a."sL_Str_r1" + a."sL_NStr_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Bldg_r1",
CAST(CAST(ROUND(CAST(COALESCE(((a."sL_Str_r1" + a."sL_NStr_r1")/(b.number))/NULLIF(((b.structural + b.nonstructural)/(b.number)),0),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLr_Bldg_r1",

CAST(CAST(ROUND(CAST(a."sL_Str_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Str_r1",
--CAST(CAST(ROUND(CAST(a."sL_Str_stdv_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLsd_Str_r1",

CAST(CAST(ROUND(CAST(a."sL_NStr_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_NStr_r1",
--CAST(CAST(ROUND(CAST(a."sL_NStr_stdv_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLsd_NStr_r1",

CAST(CAST(ROUND(CAST(a."sL_Cont_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Cont_r1",
--CAST(CAST(ROUND(CAST(a."sL_Cont_stdv_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLsd_Cont_r1",

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
b.landuse,
b.geom AS "geom_point"

FROM dsra.dsra_{eqScenario} a
LEFT JOIN exposure.canada_exposure b ON a."AssetID" = b.id
LEFT JOIN vs30.vs30_can_site_model_xref d ON a."AssetID" = d.id
LEFT JOIN boundaries."Geometry_SAUID" c on b.sauid = c."SAUIDt"
LEFT JOIN gmf.shakemap_{eqScenario}_xref e ON b.id = e.id
LEFT JOIN ruptures.rupture_table f ON f.rupture_name = a."Rupture_Abbr"
--LEFT JOIN lut.collapse_probability g ON b.bldgtype = g.eqbldgtype
WHERE e."gmv_SA(0.3)" >=0.02;



-- insert dsra info into master dsra table per scenario
INSERT INTO dsra.dsra_all_scenarios_tbl(assetid,sauid,pruid,prname,eruid,ername,cduid,cdname,csduid,csdname,fsauid,dauid,sh_rupname,sh_rupabbr,sh_mag,sh_hypolon,sh_hypolat,sh_hypodepth,sh_rake,geom_point)
SELECT "AssetID","Sauid",pruid,prname,eruid,ername,cduid,cdname,csduid,csdname,fsauid,dauid,"sH_RupName","sH_Mag","sH_HypoLon","sH_HypoLat","sH_HypoDepth","sH_Rake",geom_point
FROM results_dsra_{eqScenario}.dsra_{eqScenario}_all_indicators_b;