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
gmv_pgv,
gmv_pga
FROM gmf.shakemap_{eqScenario}
WHERE "gmv_SA(0.3)" >= 0.02
);


-- create index
CREATE INDEX IF NOT EXISTS {eqScenario}_assetid_idx ON dsra.dsra_{eqScenario}("AssetID");

-- create scenario risk building indicators
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_all_indicators_b CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_all_indicators_b AS 

-- 3.0 Earthquake Scenario Risk (DSRA)
-- 3.1 Scenario Hazard
SELECT 
b.id_building AS "AssetID",

-- 3.1.1 Shakemap Intensity
f.rupture_name AS "sH_RupName",
a."Rupture_Abbr" AS "sH_RupAbbr",
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
CAST(CAST(ROUND(CAST(SUM(a."sD_None_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_None_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_None_b0" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_None_b0",
--CAST(CAST(ROUND(CAST(AVG(a."sD_None_stdv_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_None_b0",

CAST(CAST(ROUND(CAST(SUM(a."sD_Slight_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Slight_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_Slight_b0" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Slight_b0",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Slight_stdv_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Slight_b0",

CAST(CAST(ROUND(CAST(SUM(a."sD_Moderate_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Moderate_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_Moderate_b0" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Moderate_b0",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Moderate_stdv_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Moderate_b0",

CAST(CAST(ROUND(CAST(SUM(a."sD_Extensive_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Extensive_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_Extensive_b0" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Extensive_b0",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Extensive_stdv_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Extensive_b0",

CAST(CAST(ROUND(CAST(SUM(a."sD_Complete_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Complete_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_Complete_b0" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Complete_b0",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Complete_stdv_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Complete_b0",

CAST(CAST(ROUND(CAST(SUM(a."sD_Collapse_b0" * b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Collapse_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_Collapse_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Collapse_b0",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Complete_stdv_b0" * g.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Collapse_b0",

-- 3.2.1 Damage State - r1
CAST(CAST(ROUND(CAST(SUM(a."sD_None_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_None_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_None_r2" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_None_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_None_stdv_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_None_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Slight_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Slight_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Slight_r2" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Slight_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Slight_stdv_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Slight_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Moderate_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Moderate_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Moderate_r2" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Moderate_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Moderate_stdv_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Moderate_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Extensive_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Extensive_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Extensive_r2" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Extensive_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Extensive_stdv_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Extensive_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Complete_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Complete_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Complete_r2" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Complete_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Complete_stdv_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Complete_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Collapse_r2" * b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Collapse_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Collapse_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDr_Collapse_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Complete_stdv_r2" * g.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Collapse_r1",

-- 3.0 Earthquake Scenario Risk (DSRA)
-- 3.2 Building Damage
-- 3.2.1 Recovery - b0
CAST(CAST(ROUND(CAST(AVG(a."sC_Repair_b0")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Repair_b0",
CAST(CAST(ROUND(CAST(AVG(a."sC_Construxn_b0")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Recovery_b0",
CAST(CAST(ROUND(CAST(AVG(a."sC_Downtime_b0")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Downtime_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisBW_b0" + a."sC_DebrisC_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DebrisTotal_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisBW_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DebrisBW_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisC_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DebrisCS_b0",

-- 3.2.1 Recovery - r2
CAST(CAST(ROUND(CAST(AVG(a."sC_Repair_r2")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC)AS "sC_Repair_r1",
CAST(CAST(ROUND(CAST(AVG(a."sC_Construxn_r2")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Recovery_r1",
CAST(CAST(ROUND(CAST(AVG(a."sC_Downtime_r2")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_Downtime_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisBW_r2" + a."sC_DebrisC_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DebrisTotal_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisBW_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC)  AS "sC_DebrisBW_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisC_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DebrisCS_r1",

-- 3.0 Earthquake Scenario Risk (DSRA)
-- 3.3 Affected People
-- 3.3.1 Casualties - b0
--CAST(CAST(ROUND(CAST(a."sL_Fatalities_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Fatality_b0",
--CAST(CAST(ROUND(CAST(a."sL_Fatalities_stdv_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLsd_Fatality_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL1_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasDayL1_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL2_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasDayL2_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL3_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasDayL3_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL4_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasDayL4_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL1_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasNightL1_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL2_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasNightL2_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL3_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasNightL3_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL4_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasNightL4_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL1_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasTransitL1_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL2_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasTransitL2_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL3_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasTransitL3_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL4_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasTransitL4_b0",

-- 3.3.1 Casualties - r1
--CAST(CAST(ROUND(CAST(a."sL_Fatalities_r2" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Fatality_r1",
--CAST(CAST(ROUND(CAST(a."sL_Fatalities_stdv_r2" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLsd_Fatality_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL1_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasDayL1_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL2_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasDayL2_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL3_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasDayL3_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL4_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasDayL4_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL1_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasNightL1_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL2_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasNightL2_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL3_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasNightL3_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL4_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasNightL4_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL1_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasTransitL1_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL2_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasTransitL2_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL3_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC)  AS "sC_CasTransitL3_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL4_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_CasTransitL4_r1",

-- 3.0 Earthquake Scenario Risk (DSRA)
-- 3.3 Affected People
-- 3.3.2 Social Disruption - b0
-- sC_Shelter -- calculated at sauid level only
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_3_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes3_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_30_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes30_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_90_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes90_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_180_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes180_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_360_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes360_b0",

/*
CAST(CAST(ROUND(CAST(SUM(COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_b0" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_b0" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplHshld_b0",
*/

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_b0" > 3 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_b0" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_b0" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC)AS "sC_DisplHshld3_b0",

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_b0" > 30 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_b0" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_b0" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC)  AS "sC_DisplHshld30_b0",

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_b0" > 90 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_b0" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_b0" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC)  AS "sC_DisplHshld90_b0",

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_b0" > 180 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_b0" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_b0" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplHshld180_b0",

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_b0" > 360 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_b0" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_b0" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC)  AS "sC_DisplHshld360_b0",

CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_30_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisrupEmpl_30_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_90_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisrupEmpl_90_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_180_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisrupEmpl_180_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_360_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisrupEmpl_360_b0",

-- 3.3.2 Social Disruption - r1
-- sC_Shelter -- calculated at sauid level only
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_3_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes3_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_30_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes30_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_90_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes90_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_360_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplRes360_r1",

CAST(CAST(ROUND(CAST(SUM(COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END)  * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_r2" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_r2" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplHshld_r1",

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_r2" > 3 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_r2" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_r2" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC)  AS "sC_DisplHshld3_r1",

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_r2" > 30 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_r2" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_r2" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC)  AS "sC_DisplHshld30_r1",

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_r2" > 90 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_r2" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_r2" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplHshld90_r1",

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_r2" > 180 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_r2" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_r2" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisplHshld180_r1",

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_r2" > 360 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_r2" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_r2" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC)  AS "sC_DisplHshld360_r1",

CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_30_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisrupEmpl_30_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_90_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisrupEmpl_90_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_180_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisrupEmpl_180_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_360_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sC_DisrupEmpl_360_r1",

-- 3.0 Earthquake Scenario Risk (DSRA)
-- 3.4 Economic Security
-- 3.4.1 Economic Loss - b0
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_b0" + a."sL_NStr_b0" + a."sL_Cont_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Asset_b0",
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_b0" + a."sL_NStr_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Bldg_b0",
CAST(CAST(ROUND(CAST((COALESCE((AVG(a."sL_Str_b0" + a."sL_NStr_b0"))/ NULLIF(AVG((b.structural + b.nonstructural)),0),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLr_Bldg_b0",

CAST(CAST(ROUND(CAST(CASE WHEN (AVG((((a."sL_Str_b0" + a."sL_NStr_b0") - (a."sL_Str_r2" + a."sL_NStr_r2"))/(b.number))/((b.retrofitting)/(b.number)))) > 0 
THEN (AVG((((a."sL_Str_b0" + a."sL_NStr_b0") - (a."sL_Str_r2" + a."sL_NStr_r2"))/(b.number))/((b.retrofitting)/(b.number)))) ELSE 1 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLr2_BCR_b0",

CAST(CAST(ROUND(CAST(CASE WHEN (AVG((((a."sL_Str_b0" + a."sL_NStr_b0") - (a."sL_Str_r2" + a."sL_NStr_r2"))/(b.number)) * ((EXP(-0.025*0.50)/0.025)/((b.retrofitting)/(b.number))))) > 0
THEN (AVG((((a."sL_Str_b0" + a."sL_NStr_b0") - (a."sL_Str_r2" + a."sL_NStr_r2"))/(b.number)) * ((EXP(-0.025*0.50)/0.025)/((b.retrofitting)/(b.number))))) ELSE 1 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "SLr2_RoI",

CAST(CAST(ROUND(CAST(SUM(a."sL_Str_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Str_b0",
--CAST(CAST(ROUND(CAST(a."sL_Str_stdv_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLsd_Str_b0",

CAST(CAST(ROUND(CAST(SUM(a."sL_NStr_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_NStr_b0",
--CAST(CAST(ROUND(CAST(a."sL_NStr_stdv_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLsd_NStr_b0",

CAST(CAST(ROUND(CAST(SUM(a."sL_Cont_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Cont_b0",
--CAST(CAST(ROUND(CAST(a."sL_Cont_stdv_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLsd_Cont_b0",

-- 3.4.1 Economic Loss - r1
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_r2" + a."sL_NStr_r2" + a."sL_Cont_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Asset_r1",
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_r2" + a."sL_NStr_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Bldg_r1",
CAST(CAST(ROUND(CAST((COALESCE((AVG(a."sL_Str_r2" + a."sL_NStr_r2"))/ NULLIF(AVG((b.structural + b.nonstructural)),0),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLr_Bldg_r1",

CAST(CAST(ROUND(CAST(SUM(a."sL_Str_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Str_r1",
--CAST(CAST(ROUND(CAST(a."sL_Str_stdv_r2" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLsd_Str_r1",

CAST(CAST(ROUND(CAST(SUM(a."sL_NStr_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_NStr_r1",
--CAST(CAST(ROUND(CAST(a."sL_NStr_stdv_r2" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLsd_NStr_r1",

CAST(CAST(ROUND(CAST(SUM(a."sL_Cont_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sL_Cont_r1",
--CAST(CAST(ROUND(CAST(a."sL_Cont_stdv_r2" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLsd_Cont_r1",

b.sauid AS "Sauid",
z."PRUID" AS "pruid",
z."PRNAME" AS "prname",
z."ERUID" AS "eruid",
z."ERNAME" AS "ername",
z."CDUID" AS "cduid",
z."CDNAME" AS "cdname",
z."CSDUID" AS "csduid",
z."CSDNAME" AS "csdname",
z."CFSAUID" AS "fsauid",
z."DAUIDt" AS "dauid",
z."SACCODE" AS "saccode",
z."SACTYPE" AS "sactype",
b.landuse,
c.geom_site AS "geom_point"

FROM dsra.dsra_{eqScenario} a
LEFT JOIN exposure.metrovan_site_exposure b ON a."AssetID" = b.id
LEFT JOIN exposure.metrovan_building_exposure c ON c.id = b.id_building 
LEFT JOIN vs30.vs30_can_site_model_metrovan_building_exposure_xref d ON c.id = d.id
LEFT JOIN gmf.shakemap_{eqScenario}_metrovan_building_xref e ON c.id = e.id
LEFT JOIN ruptures.rupture_table f ON f.rupture_name = a."Rupture_Abbr"
--LEFT JOIN lut.collapse_probability g ON b.bldgtype = g.eqbldgtype
LEFT JOIN boundaries."Geometry_SAUID" z ON b.sauidid = z."SAUIDt"
WHERE e."gmv_SA(0.3)" >=0.02
GROUP BY b.id_building,b.sauid,b.landuse,f.rupture_name,a."Rupture_Abbr",f.source_type,f.magnitude,f.lon,f.lat,f.depth,f.rake,a."gmpe_Model",e.site_id,e.lon,e.lat,d.vs_lon,d.vs_lat,
d.vs30,d.z1pt0,d.z2pt5,e."gmv_pgv",e."gmv_pga",e."gmv_SA(0.1)",e."gmv_SA(0.2)",e."gmv_SA(0.3)",e."gmv_SA(0.5)",e."gmv_SA(0.6)",e."gmv_SA(1.0)",e."gmv_SA(2.0)",c.geom_site,
z."PRUID",z."PRNAME",z."ERUID",z."ERNAME",z."CDUID",z."CDNAME",z."CSDUID",z."CSDNAME",z."CFSAUID",z."DAUIDt",z."SACCODE",z."SACTYPE";