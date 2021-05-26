-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_dsra_{eqScenario};


-- create scenario risk sauid indicators
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_all_indicators_s CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_all_indicators_s AS 

SELECT
b.sauid AS "Sauid",

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
CAST(CAST(ROUND(CAST(e.lon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "SH_SiteLon",
CAST(CAST(ROUND(CAST(e.lat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "SH_SiteLat",
CAST(CAST(ROUND(CAST(d.vs_lon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS  "sH_Vs30Lon",
CAST(CAST(ROUND(CAST(d.vs_lat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Vs30Lat",
CAST(CAST(ROUND(CAST(d.vs30 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Vs30",
CAST(CAST(ROUND(CAST(d.z1pt0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_z1p0",
CAST(CAST(ROUND(CAST(d.z2pt5 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_z2p5",
CAST(CAST(ROUND(CAST(e."gmv_pgv" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_PGV",
--CAST(CAST(ROUND(CAST(e."gmv_pga" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_PGA",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.1)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p1",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.2)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p2",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.3)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p3",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.5)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p5",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.6)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p6",
CAST(CAST(ROUND(CAST(e."gmv_SA(1.0)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa1p0",
CAST(CAST(ROUND(CAST(e."gmv_SA(2.0)" AS NUMERIC),6) AS FLOAT) AS NUMERIC)AS "sH_Sa2p0", 

-- 3.2 Building Damage
-- 3.2.1 Damage State - b0
CAST(CAST(ROUND(CAST(SUM(a."sD_None_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_None_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_None_b0" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_None_b0",
--CAST(CAST(ROUND(CAST(AVG(a."sD_None_stdv_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_None_b0",

CAST(CAST(ROUND(CAST(SUM(a."sD_Slight_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Slight_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_Slight_b0" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Slight_b0",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Slight_stdv_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Slight_b0",

CAST(CAST(ROUND(CAST(SUM(a."sD_Moderate_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Moderate_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_Moderate_b0" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Moderate_b0",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Moderate_stdv_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Moderate_b0",

CAST(CAST(ROUND(CAST(SUM(a."sD_Extensive_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Extensive_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_Extensive_b0" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Extensive_b0",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Extensive_stdv_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Extensive_b0",

CAST(CAST(ROUND(CAST(SUM(a."sD_Complete_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Complete_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_Complete_b0" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Complete_b0",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Complete_stdv_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Complete_b0",

CAST(CAST(ROUND(CAST(SUM(a."sD_Collapse_b0" * b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Collapse_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_Collapse_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Collapse_b0",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Complete_stdv_b0" * g.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Collapse_b0",

-- 3.2.1 Damage State - r1
CAST(CAST(ROUND(CAST(SUM(a."sD_None_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_None_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_None_r2" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_None_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_None_stdv_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_None_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Slight_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Slight_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Slight_r2" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Slight_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Slight_stdv_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Slight_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Moderate_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Moderate_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Moderate_r2" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Moderate_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Moderate_stdv_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Moderate_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Extensive_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Extensive_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Extensive_r2" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Extensive_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Extensive_stdv_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Extensive_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Complete_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Complete_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Complete_r2" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Complete_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Complete_stdv_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Complete_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Collapse_r2" * b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Collapse_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Collapse_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Collapse_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Complete_stdv_r2" * g.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Collapse_r1",

-- 3.2.1 Recovery - b0
--CAST(CAST(ROUND(CAST(SUM(a."sD_None_b0" + a."sD_Slight_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_GreenTag_b_b0",
--CAST(CAST(ROUND(CAST(SUM(a."sD_None_b0" + a."sD_Slight_b0")/5 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_GreenTag_i_b0",
--CAST(CAST(ROUND(CAST(SUM(a."sD_Extensive_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_YellowTag_d_b0",
--CAST(CAST(ROUND(CAST(SUM(a."sD_Extensive_b0")/2.5 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_YellowTag_i_b0",
--CAST(CAST(ROUND(CAST(SUM(a."sD_Complete_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_RedTag_b_b0",
--CAST(CAST(ROUND(CAST(SUM(a."sD_Complete_b0")/5 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_RedTag_i_b0" ,
--CAST(CAST(ROUND(CAST(SUM(a."sD_None_b0" + (a."sD_Slight_b0"*0.2) +(a."sD_Moderate_b0"*0.05)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Operational_b0",
--CAST(CAST(ROUND(CAST(SUM((a."sD_Slight_b0"*0.8) + (a."sD_Moderate_b0"*0.75) + (a."sD_Extensive_b0"*0.2)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Functional_b0",
--CAST(CAST(ROUND(CAST(SUM((a."sD_Moderate_b0"*0.2) + (a."sD_Extensive_b0"*0.4)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Repairable_b0",
--CAST(CAST(ROUND(CAST(SUM((a."sD_Extensive_b0"*0.3) + (a."sD_Complete_b0"*0.2)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Failure_b0",
CAST(CAST(ROUND(CAST(AVG(a."sC_Downtime_b0")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCm_Downtime_b0",
CAST(CAST(ROUND(CAST(AVG(a."sC_Repair_b0")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCm_Repair_b0",
CAST(CAST(ROUND(CAST(AVG(a."sC_Construxn_b0")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "SCm_Recovery_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisBW_b0" + a."sC_DebrisC_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_DebrisTotal_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisBW_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_DebrisBW_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisC_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_DebrisCS_b0",

-- 3.2.1 Recovery - r1
--CAST(CAST(ROUND(CAST(SUM(a."sD_None_r2" + a."sD_Slight_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_GreenTag_b_r1",
--CAST(CAST(ROUND(CAST(SUM(a."sD_None_r2" + a."sD_Slight_r2")/5 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_GreenTag_i_r1",
--CAST(CAST(ROUND(CAST(SUM(a."sD_Extensive_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_YellowTag_d_r1",
--CAST(CAST(ROUND(CAST(SUM(a."sD_Extensive_r2")/2.5 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_YellowTag_i_r1",
--CAST(CAST(ROUND(CAST(SUM(a."sD_Complete_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_RedTag_b_r1",
--CAST(CAST(ROUND(CAST(SUM(a."sD_Complete_r2")/5 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_RedTag_i_r2" ,
--CAST(CAST(ROUND(CAST(SUM(a."sD_None_r2" + (a."sD_Slight_r2"*0.2) +(a."sD_Moderate_r2"*0.05)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Operational_r1",
--CAST(CAST(ROUND(CAST(SUM((a."sD_Slight_r2"*0.8) + (a."sD_Moderate_r2"*0.75) + (a."sD_Extensive_r2"*0.2)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Functional_r1",
--CAST(CAST(ROUND(CAST(SUM((a."sD_Moderate_r2"*0.2) + (a."sD_Extensive_r2"*0.4)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Repairable_r1",
--CAST(CAST(ROUND(CAST(SUM((a."sD_Extensive_r2"*0.3) + (a."sD_Complete_r2"*0.2)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Failure_r1",
CAST(CAST(ROUND(CAST(AVG(a."sC_Downtime_r2")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCm_Downtime_r1",
CAST(CAST(ROUND(CAST(AVG(a."sC_Repair_r2")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCm_Repair_r1",
CAST(CAST(ROUND(CAST(AVG(a."sC_Construxn_r2")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "SCm_Recovery_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisBW_r2" + a."sC_DebrisC_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_DebrisTotal_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisBW_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_DebrisBW_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisC_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_DebrisCS_r1",

-- 3.3 Affected People
-- 3.3.1 Casualties - b0
--CAST(CAST(ROUND(CAST(SUM(a."sL_Fatalities_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Fatality_b0",
--CAST(CAST(ROUND(CAST(AVG(a."sL_Fatalities_stdv_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLtsd_Fatality_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL1_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasDayL1_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL2_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasDayL2_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL3_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasDayL3_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL4_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasDayL4_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL1_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasNightL1_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL2_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasNightL2_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL3_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasNightL3_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL4_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasNightL4_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL1_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasTransitL1_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL2_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasTransitL2_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL3_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasTransitL3_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL4_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasTransitL4_b0",

-- 3.3.1 Casualties - r1
--CAST(CAST(ROUND(CAST(SUM(a."sL_Fatalities_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Fatality_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sL_Fatalities_stdv_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLtsd_Fatality_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL1_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasDayL1_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL2_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasDayL2_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL3_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasDayL3_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL4_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasDayL4_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL1_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasNightL1_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL2_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasNightL2_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL3_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasNightL3_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL4_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasNightL4_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL1_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasTransitL1_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL2_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasTransitL2_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL3_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasTransitL3_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL4_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasTransitL4_r1",

-- 3.3.2 Social Disruption - b0
CAST(CAST(ROUND(CAST(((0.73 * COALESCE((CASE WHEN j.inc_hshld <= 15000 THEN 0.62 ELSE 0 END),0) + 
COALESCE((CASE WHEN j.inc_hshld > 15000 AND j.inc_hshld <= 20000 THEN 0.42 ELSE 0 END),0) + 
COALESCE((CASE WHEN j.inc_hshld > 20000 AND j.inc_hshld <= 35000 THEN 0.29 ELSE 0 END),0) + 
COALESCE((CASE WHEN j.inc_hshld > 35000 AND j.inc_hshld <= 50000 THEN 0.22 ELSE 0 END),0) + 
COALESCE((CASE WHEN j.inc_hshld > 50000 THEN 0.13 ELSE 0 END),0)) + 
(0.27 * COALESCE(j.imm_lt5 * 0.24,0) + COALESCE(j.live_alone * 0.48,0) + COALESCE(j.no_engfr * 0.47,0) + COALESCE(j.lonepar3kids * 0.26,0) +
COALESCE(j.indigenous * 0.26,0))) *
(COALESCE(((SUM(COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/h.people_du ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_b0" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/h.people_du ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_b0" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/h.people_du ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/h.people_du ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/h.people_du ELSE 0 END),0)),0))) * h.censuspop) / NULLIF(h.censusdu,0),0)) *
(COALESCE((CASE WHEN j.inc_hshld <= 15000 THEN 0.62 ELSE 0 END),0) + 
COALESCE((CASE WHEN j.inc_hshld > 15000 AND j.inc_hshld <= 20000 THEN 0.42 ELSE 0 END),0) + 
COALESCE((CASE WHEN j.inc_hshld > 20000 AND j.inc_hshld <= 35000 THEN 0.29 ELSE 0 END),0) + 
COALESCE((CASE WHEN j.inc_hshld > 35000 AND j.inc_hshld <= 50000 THEN 0.22 ELSE 0 END),0) + 
COALESCE((CASE WHEN j.inc_hshld > 50000 THEN 0.13 ELSE 0 END),0)) * 
(COALESCE(j.imm_lt5 * 0.24,0) + COALESCE(j.live_alone * 0.48,0) + COALESCE(j.no_engfr * 0.47,0) + COALESCE(j.lonepar3kids * 0.26,0) +
COALESCE(j.indigenous * 0.26,0)) * 
(COALESCE(j.renter * 0.40,0) + COALESCE(((h.censusdu * h.people_du) - j.renter) * 0.40,0)) * 
(COALESCE(j.age_gt65 * 0.40,0) + COALESCE(j.age_lt6 * 0.40,0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Shelter_b0",

CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_3_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res3_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_30_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res30_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_90_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res90_b0",
CAST(CAST(ROUND(CAST(AVG(COALESCE(a."sC_DisplRes_90_b0"/NULLIF((b.night),0),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eCr_DisplRes90_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_180_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res180_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_360_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res360_b0",

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
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Hshld_b0",
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
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Hshld3_b0",

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_b0" > 30 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_b0" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_b0" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Hshld30_b0",

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_b0" > 90 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_b0" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_b0" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Hshld90_b0",

CAST(CAST(ROUND(CAST((SUM(CASE WHEN a."sC_Downtime_b0" > 90 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_b0" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_b0" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END)) / 
NULLIF(((SUM(CASE WHEN b.genocc ='Residential-LD' THEN b.number ELSE 0 END) / AVG(b.popdu)) + 
((SUM(CASE WHEN b.genocc ='Residential-MD' THEN b.number ELSE 0 END) + SUM(CASE WHEN b.genocc ='Residential-HD' THEN b.number ELSE 0 END)) / AVG(b.popdu))),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCr_Hshld90_b0",

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_b0" > 180 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_b0" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_b0" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Hshld180_b0",

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_b0" > 360 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_b0" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_b0" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_b0" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_b0" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Hshld360_b0",

CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_30_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl30_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_90_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl90_b0",
CAST(CAST(ROUND(CAST(AVG(COALESCE(a."sC_DisrupEmpl_90_b0"/NULLIF((b.day),0),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCr_Empl90_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_180_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl180_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_360_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl360_b0",

-- 3.3.2 Social Disruption - r1
CAST(CAST(ROUND(CAST(((0.73 * COALESCE((CASE WHEN j.inc_hshld <= 15000 THEN 0.62 ELSE 0 END),0) + 
COALESCE((CASE WHEN j.inc_hshld > 15000 AND j.inc_hshld <= 20000 THEN 0.42 ELSE 0 END),0) + 
COALESCE((CASE WHEN j.inc_hshld > 20000 AND j.inc_hshld <= 35000 THEN 0.29 ELSE 0 END),0) + 
COALESCE((CASE WHEN j.inc_hshld > 35000 AND j.inc_hshld <= 50000 THEN 0.22 ELSE 0 END),0) + 
COALESCE((CASE WHEN j.inc_hshld > 50000 THEN 0.13 ELSE 0 END),0)) + 
(0.27 * COALESCE(j.imm_lt5 * 0.24,0) + COALESCE(j.live_alone * 0.48,0) + COALESCE(j.no_engfr * 0.47,0) + COALESCE(j.lonepar3kids * 0.26,0) +
COALESCE(j.indigenous * 0.26,0))) *
(COALESCE(((SUM(COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/h.people_du ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_r2" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/h.people_du ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_r2" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/h.people_du ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/h.people_du ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/h.people_du ELSE 0 END),0)),0))) * h.censuspop) / NULLIF(h.censusdu,0),0)) *
(COALESCE((CASE WHEN j.inc_hshld <= 15000 THEN 0.62 ELSE 0 END),0) + 
COALESCE((CASE WHEN j.inc_hshld > 15000 AND j.inc_hshld <= 20000 THEN 0.42 ELSE 0 END),0) + 
COALESCE((CASE WHEN j.inc_hshld > 20000 AND j.inc_hshld <= 35000 THEN 0.29 ELSE 0 END),0) + 
COALESCE((CASE WHEN j.inc_hshld > 35000 AND j.inc_hshld <= 50000 THEN 0.22 ELSE 0 END),0) + 
COALESCE((CASE WHEN j.inc_hshld > 50000 THEN 0.13 ELSE 0 END),0)) * 
(COALESCE(j.imm_lt5 * 0.24,0) + COALESCE(j.live_alone * 0.48,0) + COALESCE(j.no_engfr * 0.47,0) + COALESCE(j.lonepar3kids * 0.26,0) +
COALESCE(j.indigenous * 0.26,0)) * 
(COALESCE(j.renter * 0.40,0) + COALESCE(((h.censusdu * h.people_du) - j.renter) * 0.40,0)) * 
(COALESCE(j.age_gt65 * 0.40,0) + COALESCE(j.age_lt6 * 0.40,0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Shelter_r1",

CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_3_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res3_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_30_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res30_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_90_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res90_r1",
CAST(CAST(ROUND(CAST(AVG(COALESCE(a."sC_DisplRes_90_r2"/NULLIF((b.night),0),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eCr_DisplRes90_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_180_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res180_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_360_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res360_r1",

/*
CAST(CAST(ROUND(CAST(SUM(COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END)  * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_r2" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_r2" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Hshld_r1",
*/

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_r2" > 3 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_r2" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_r2" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Hshld3_r1",

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_r2" > 30 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_r2" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_r2" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Hshld30_r1",

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_r2" > 90 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_r2" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_r2" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Hshld90_r1",

CAST(CAST(ROUND(CAST((SUM(CASE WHEN a."sC_Downtime_r2" > 90 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_r2" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_r2" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END)) / 
NULLIF(((SUM(CASE WHEN b.genocc ='Residential-LD' THEN b.number ELSE 0 END) / AVG(b.popdu)) + 
((SUM(CASE WHEN b.genocc ='Residential-MD' THEN b.number ELSE 0 END) + SUM(CASE WHEN b.genocc ='Residential-HD' THEN b.number ELSE 0 END)) / AVG(b.popdu))),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCr_Hshld90_r1",

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_r2" > 180 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_r2" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_r2" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Hshld180_r1",

CAST(CAST(ROUND(CAST(SUM(CASE WHEN a."sC_Downtime_r2" > 360 THEN (COALESCE((((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) * 
((0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-LD' THEN a."sD_Complete_r2" / b.number ELSE 0 END)))) + 
((CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) *
((0 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Moderate_r2" / b.number ELSE 0 END)) + 
(0.9 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Extensive_r2" / b.number ELSE 0 END)) + 
(1 * (CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN a."sD_Complete_r2" / b.number ELSE 0 END))))) * 
((CASE WHEN b.genocc ='Residential-LD' OR b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END) / NULLIF((CASE WHEN b.genocc ='Residential-LD' THEN b.night/b.popdu ELSE 0 END) + 
(CASE WHEN b.genocc ='Residential-MD' OR b.genocc ='Residential-HD' THEN b.night/b.popdu ELSE 0 END),0)),0)) ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Hshld360_r1",

CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_30_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl30_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_90_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl90_r1",
CAST(CAST(ROUND(CAST(AVG(COALESCE(a."sC_DisrupEmpl_90_r2"/NULLIF((b.day),0),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCr_Empl90_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_180_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl180_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_360_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl360_r1",

-- 3.4 Economic Security
-- 3.4.1 Economic Loss - b0
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_b0" + a."sL_NStr_b0" + a."sL_Cont_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Asset_b0",
CAST(CAST(ROUND(CAST(COALESCE(AVG((a."sL_Str_b0" + a."sL_NStr_b0" + a."sL_Cont_b0")/(NULLIF((b.number),0))),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLm_Asset_b0",
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_b0" + a."sL_NStr_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Bldg_b0",
CAST(CAST(ROUND(CAST((COALESCE((AVG(a."sL_Str_b0" + a."sL_NStr_b0"))/ NULLIF(AVG((a."sL_Str_b0" + a."sL_NStr_b0" + a."sL_Cont_b0")),0),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmr_Bldg_b0",
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Str_b0",
--CAST(CAST(ROUND(CAST(SUM(a."sL_Str_stdv_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmsd_Str_b0",
CAST(CAST(ROUND(CAST(SUM(a."sL_NStr_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_NStr_b0",
--CAST(CAST(ROUND(CAST(SUM(a."sL_NStr_stdv_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmsd_NStr_b0",
CAST(CAST(ROUND(CAST(SUM(a."sL_Cont_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Cont_b0",
--CAST(CAST(ROUND(CAST(SUM(a."sL_Cont_stdv_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmsd_Cont_b0",

-- 3.4.1 Economic Loss - r1
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_r2" + a."sL_NStr_r2" + a."sL_Cont_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Asset_r1",
CAST(CAST(ROUND(CAST(COALESCE(AVG((a."sL_Str_r2" + a."sL_NStr_r2" + a."sL_Cont_r2")/(NULLIF((b.number),0))),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLm_Asset_r1",
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_r2" + a."sL_NStr_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Bldg_r1",
CAST(CAST(ROUND(CAST((COALESCE((AVG(a."sL_Str_r2" + a."sL_NStr_r2"))/ NULLIF(AVG((a."sL_Str_r2" + a."sL_NStr_r2" + a."sL_Cont_r2")),0),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmr_Bldg_r1",
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Str_r1",
--CAST(CAST(ROUND(CAST(SUM(a."sL_Str_stdv_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmsd_Str_r1",
CAST(CAST(ROUND(CAST(SUM(a."sL_NStr_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_NStr_r1",
--CAST(CAST(ROUND(CAST(SUM(a."sL_NStr_stdv_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmsd_NStr_r1",
CAST(CAST(ROUND(CAST(SUM(a."sL_Cont_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Cont_r1",
--CAST(CAST(ROUND(CAST(SUM(a."sL_Cont_stdv_r2") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmsd_Cont_r1",

/*
CAST(CAST(ROUND(CAST(CASE WHEN (AVG((((a."sL_Str_b0" + a."sL_NStr_b0") - (a."sL_Str_r2" + a."sL_NStr_r2"))/(b.number))/((b.retrofitting)/(b.number)))) > 0 
THEN (AVG((((a."sL_Str_b0" + a."sL_NStr_b0") - (a."sL_Str_r2" + a."sL_NStr_r2"))/(b.number))/((b.retrofitting)/(b.number)))) ELSE 1 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmr2_BCR" ,

CAST(CAST(ROUND(CAST(CASE WHEN (AVG((((a."sL_Str_b0" + a."sL_NStr_b0") - (a."sL_Str_r2" + a."sL_NStr_r2"))/(b.number)) * ((EXP(-0.025*0.50)/0.025)/((b.retrofitting)/(b.number))))) > 0
THEN (AVG((((a."sL_Str_b0" + a."sL_NStr_b0") - (a."sL_Str_r2" + a."sL_NStr_r2"))/(b.number)) * ((EXP(-0.025*0.50)/0.025)/((b.retrofitting)/(b.number))))) ELSE 1 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmr2_RoI",
*/

i."PRUID" AS "pruid",
i."PRNAME" AS "prname",
i."ERUID" AS "eruid",
i."ERNAME" AS "ername",
i."CDUID" AS "cduid",
i."CDNAME" AS "cdname",
i."CSDUID" AS "csduid",
i."CSDNAME" AS "csdname",
i."CFSAUID" AS "fsauid",
i."DAUIDt" AS "dauid",
i."SACCODE" AS "saccode",
i."SACTYPE" AS "sactype",
b.landuse,
i.geom AS "geom_poly"
--i.geompoint AS "geom_point"

FROM dsra.dsra_{eqScenario} a
LEFT JOIN exposure.metrovan_site_exposure b ON a."AssetID" = b.id 
LEFT JOIN vs30.vs30_can_site_model_metrovan_sauid_exposure_xref d ON b.sauid = d.sauid
LEFT JOIN gmf.shakemap_{eqScenario}_metrovan_sauid_xref e ON b.sauid = e.sauid
LEFT JOIN ruptures.rupture_table f ON f.rupture_name = a."Rupture_Abbr"
--LEFT JOIN lut.collapse_probability g ON b.bldgtype = g.eqbldgtype
LEFT JOIN census.census_2016_canada h ON b.sauid = h.sauidt
LEFT JOIN boundaries."Geometry_SAUID" i ON b.sauid = i."SAUIDt"
LEFT JOIN sovi.sovi_census_canada j ON b.sauid = j.sauidt
WHERE e."gmv_SA(0.3)" >=0.02
GROUP BY a."Rupture_Abbr",a."gmpe_Model",b.sauid,b.landuse,d.vs30,d.z1pt0,d.z2pt5,d.vs_lon,d.vs_lat,e.site_id,e.lon,e.lat,f.source_type,
f.rupture_name,f.magnitude,f.lon,f.lat,f.depth,f.rake,e."gmv_pgv",e."gmv_pga",e."gmv_SA(0.1)",e."gmv_SA(0.2)",e."gmv_SA(0.3)",e."gmv_SA(0.5)",e."gmv_SA(0.6)",e."gmv_SA(1.0)",e."gmv_SA(2.0)",
i."PRUID",i."PRNAME",i."ERUID",i."ERNAME",i."CDUID",i."CDNAME",i."CSDUID",i."CSDNAME",i."CFSAUID",i."DAUIDt",i."SACCODE",i."SACTYPE",j.inc_hshld,j.imm_lt5,j.live_alone,j.no_engfr,j.lonepar3kids,j.indigenous,h.censuspop,h.censusdu,j.renter,h.people_du,j.age_gt65,j.age_lt6,i.geom;