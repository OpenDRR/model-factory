-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_dsra_{eqScenario};




--intermediates table to calculate shelter for DSRA
DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_shelter_calc1 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.{eqScenario}_shelter_calc1 AS
(
SELECT 
a."Sauid",
SUM(a."sC_DisplHshld_b0") AS "sCt_DisplHshld_b0",
SUM(a."sC_DisplHshld_r1") AS "sCt_DisplHshld_r1",
SUM(b."E_PopNight") AS "Et_PopNight"
	
FROM results_dsra_sim9p0_cascadiainterfacebestfault.dsra_sim9p0_cascadiainterfacebestfault_all_indicators_b a
--FROM results_dsra_{eqScenario}.dsra_{eqScenario}_all_indicators_b a
LEFT JOIN results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_b b ON a."AssetID" = b."BldgID"
GROUP BY a."Sauid"
);


--intermediates table to calculate shelter for DSRA
DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}.shelter_calc2 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.{eqScenario}.shelter_calc2 AS
(
SELECT
a."Sauid",
a."sCt_DisplHshld_b0",
a."sCt_DisplHshld_r1",
a."Et_PopNight",
b."E_CensusPop",
b."E_CensusDU",
b."E_People_DU",
b."Et_SFHshld",
b."Et_MFHshld",

--IM
--IF [Inc_Hshld] =< $15,000, THEN 0.62 = IM1
CASE WHEN c.inc_hshld <= 15000 THEN 0.62 ELSE 0 END AS "IM1",
--IF [Inc_Hshld] > $15,000 AND [Inc_Hshld] =<, $20,000 THEN 0.42 = IM2
CASE WHEN c.inc_hshld > 15000 AND c.inc_hshld <= 20000 THEN 0.29 ELSE 0 END AS "IM2",
--IF [Inc_Hshld] > $20,000 AND [Inc_Hshld] =<, $35,000 THEN 0.29 = IM3
CASE WHEN c.inc_hshld > 20000 AND c.inc_hshld <= 35000 THEN 0.29 ELSE 0 END AS "IM3",
--IF [Inc_Hshld] > $35,000 AND [Inc_Hshld] =<, $50,000 THEN  0.22 = IM4
CASE WHEN c.inc_hshld > 35000 AND c.inc_hshld <= 50000 THEN 0.29 ELSE 0 END AS "IM4",
--IF [Inc_Hshld] > $50,000 THEN 0.13 = IM5
CASE WHEN c.inc_hshld > 50000 THEN 0.13 ELSE 0 END AS "IM5",

--EM
--[Imm_LT5_p] * 0.24 = EM1, Imm_LT5_p = IF [Imm_LT5_t] =1 Then ([Imm_LT5] x [CensusPop]
--CASE WHEN d."VFt_ImmLT5" = 1 THEN c.imm_lt5 * b."E_CensusPop" * 0.24 ELSE 0 END AS "EM1",
--CASE WHEN d."VFt_ImmLT5" = 1 THEN c.imm_lt5 * 0.24 ELSE 0 END AS "EM1",
c.imm_lt5 * 0.24 AS "EM1",

--[Live_Alone_p] * 0.48 = EM2,  Live_Alone_p = IF [Live_Alone_t] =1 Then ([Live_Alone] x [CensusPop]
--CASE WHEN d."VFt_LivAlone" = 1 THEN c.live_alone * b."E_CensusPop" * 0.48 ELSE 0 END AS "EM2",
--CASE WHEN d."VFt_LivAlone" = 1 THEN c.live_alone * 0.48 ELSE 0 END AS "EM2",
c.live_alone * 0.48 AS "EM2",

--[No_EngFr_p] * 0.47 = EM3, No_EngFr_p = IF [No_EngFr_t] =1 Then ([No_EngFr] x [CensusPop]
--CASE WHEN d."VFt_LivAlone" = 1 THEN c.live_alone * b."E_CensusPop" * 0.47 ELSE 0 END AS "EM3",
--CASE WHEN d."VFt_LivAlone" = 1 THEN c.live_alone * 0.47 ELSE 0 END AS "EM3",
c.live_alone * 0.47 AS "EM3",

--[LonePar3Kids_p] * 0.26 = EM4, LonePar3Kids_p = IF [LonePar3Kids_t] =1 Then ([LonePar3Kids] x [CensusPop] 
--CASE WHEN d."VFt_LonPar3Kids" = 1 THEN c.lonepar3kids * b."E_CensusPop" * 0.26 ELSE 0 END AS "EM4",
--CASE WHEN d."VFt_LonPar3Kids" = 1 THEN c.lonepar3kids * 0.26 ELSE 0 END AS "EM4",
c.lonepar3kids * 0.26 AS "EM4",

--[Indigenous_p] * 0.26 = EM5, Indigenous_p = IF [Indigenous_t] =1 Then ([Indigenous] x [CensusPop]
--CASE WHEN d."VAt_Indigenous" = 1 THEN c.indigenous * b."E_CensusPop" * 0.26 ELSE 0 END AS "EM5",
--CASE WHEN d."VAt_Indigenous" = 1 THEN c.indigenous * 0.26 ELSE 0 END AS "EM5",
c.indigenous * 0.26 AS "EM5",

--OM
--[Renter_p] * 0.40 = OM1, Renter_p = IF [Renter_t] =1 Then ([Renter] x [CensusPop]
--CASE WHEN d."VHt_Renter" = 1 THEN c.renter * b."E_CensusPop" * 0.40 ELSE 0 END AS "OM1",
--CASE WHEN d."VHt_Renter" = 1 THEN c.renter * 0.40 ELSE 0 END AS "OM1",
c.renter * 0.40 AS "OM1",

--(([CensusDU] * People_DU]) - [Renter] ) * 0.40 = OM2
--((b."E_CensusDU" * b."E_People_DU") - c.renter) * 0.40 AS "OM2",
1 - c.renter * 0.40 AS "OM2",

--AM
--[Age_GT65_p] * 0.40 = AM1, Age_GT65_p = IF [Age_GT65_t] =1 Then ([Age_GT65] x [CensusPop]
--CASE WHEN d."VAt_AgeGT65" = 1 THEN c.age_gt65 * b."E_CensusPop" * 0.40 ELSE 0 END AS "AM1",
--CASE WHEN d."VAt_AgeGT65" = 1 THEN c.age_gt65 * 0.40 ELSE 0 END AS "AM1",
c.age_gt65 * 0.40 AS "AM1",

--[Age_LT6_p] * 0.40 = AM2, Age_LT6_p = IF [Age_LT6_t] =1 Then ([Age_LT6] x [CensusPop]
--CASE WHEN d."VAt_AgeLT6" = 1 THEN c.age_lt6 * b."E_CensusPop" * 0.40 ELSE 0 END AS "AM2"
--CASE WHEN d."VAt_AgeLT6" = 1 THEN c.age_lt6 * 0.40 ELSE 0 END AS "AM2",
c.age_lt6 * 0.40 AS "AM2"


FROM results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_shelter_calc1 a
LEFT JOIN results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_s b ON a."Sauid" = b."Sauid"
LEFT JOIN sovi.sovi_census_canada c ON b."Sauid" = c.sauidt
LEFT JOIN results_nhsl_social_fabric.nhsl_social_fabric_all_indicators_s d ON a."Sauid" = d."Sauid"
);


-- intermediates table to calculate shelter for DSRA
DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}.shelter_calc3 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.{eqScenario}.shelter_calc3 AS
(
SELECT
"Sauid",

--(0.73* ([IM1]+[IM2]+[IM3]+[IM4]+[IM5])) + (0.27*([EM1]+[EM2]+[EM3]+[EM4]+[EM5])) = sigma
(0.73 * ("IM1" + "IM2" + "IM3" + "IM4" + "IM5")) + (0.27 * ("EM1" + "EM2" + "EM3" + "EM4" + "EM5")) AS "sigma"

FROM results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_shelter_calc2
--FROM results_dsra_{eqScenario}.{eqScenario}_shelter_calc2
);


-- intermediates table to calculate shelter for DSRA
--DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}.shelter_calc4 CASCADE;
--CREATE TABLE results_dsra_{eqScenario}.{eqScenario}.shelter_calc4 AS
DROP TABLE IF EXISTS results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_shelter_calc4 CASCADE;
CREATE TABLE results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_shelter_calc4 AS
(
SELECT
a."Sauid",
--[sigma] * (([DisplHshld] * [CensusPop]) / CensusDU) * ([IM1]+[IM2]+[IM3]+[IM4]+[IM5]) * ([EM1]+[EM2]+[EM3]+[EM4]+[EM5]) * ([OM1]+[OM2]) * ([AM1]+[AM2]) = Shelter
--b.sigma * COALESCE(((a."sCt_DisplHshld_b0" * a."E_CensusPop") / NULLIF(a."E_CensusDU",0)),0) * (a."IM1" + a."IM2" + a."IM3" + a."IM4" + a."IM5") * (a."EM1" + a."EM2" + a."EM3" + a."EM4" + a."EM5") * (a."OM1" + a."OM2") * (a."AM1" + a."AM2") AS "sCt_Shelter_b0",
b.sigma * COALESCE(((a."sCt_DisplHshld_b0" * a."Et_PopNight") / NULLIF((a."Et_SFHshld" + a."Et_MFHshld"),0)),0) * (a."IM1" + a."IM2" + a."IM3" + a."IM4" + a."IM5") * (a."EM1" + a."EM2" + a."EM3" + a."EM4" + a."EM5") * (a."OM1" + a."OM2") * (a."AM1" + a."AM2") AS "sCt_Shelter_b0",
--b.sigma * COALESCE(((a."sCt_DisplHshld_r1" * a."E_CensusPop") / NULLIF(a."E_CensusDU",0)),0) * (a."IM1" + a."IM2" + a."IM3" + a."IM4" + a."IM5") * (a."EM1" + a."EM2" + a."EM3" + a."EM4" + a."EM5") * (a."OM1" + a."OM2") * (a."AM1" + a."AM2") AS "sCt_Shelter_r1"
b.sigma * COALESCE(((a."sCt_DisplHshld_r1" * a."Et_PopNight") / NULLIF((a."Et_SFHshld" + a."Et_MFHshld"),0)),0) * (a."IM1" + a."IM2" + a."IM3" + a."IM4" + a."IM5") * (a."EM1" + a."EM2" + a."EM3" + a."EM4" + a."EM5") * (a."OM1" + a."OM2") * (a."AM1" + a."AM2") AS "sCt_Shelter_r1"

FROM results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_shelter_calc2 a
LEFT JOIN results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_shelter_calc3 b ON a."Sauid" = b."Sauid"
);


--intermediates table to calculate shelter for DSRA
--DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_shelter CASCADE;
--CREATE TABLE results_dsra_{eqScenario}.{eqScenario}_shelter AS
(
SELECT
a."Sauid",
a."sCt_DisplHshld_b0",
a."sCt_DisplHshld_r1",
a."Et_PopNight",
a."E_CensusPop",
a."E_CensusDU",
a."E_People_DU",
a."Et_SFHshld",
a."Et_MFHshld",
a."IM1",
a."IM2",
a."IM3",
a."IM4",
a."IM5",
a."EM1",
a."EM2",
a."EM3",
a."EM4",
a."EM5",
a."OM1",
a."OM2",
a."AM1",
a."AM2",
b.sigma,
c."sCt_Shelter_b0",
c."sCt_Shelter_r1"

FROM results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_shelter_calc2 a
LEFT JOIN results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_shelter_calc3 b ON a."Sauid" = b."Sauid"
LEFT JOIN results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_shelter_calc4 c ON a."Sauid" = c."Sauid"
);

--DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_shelter_calc1,results_dsra_{eqScenario}.{eqScenario}_shelter_calc2,results_dsra_{eqScenario}.{eqScenario}_shelter_calc3,results_dsra_{eqScenario}.{eqScenario}_shelter_calc4;
DROP TABLE IF EXISTS results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_shelter_calc1,results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_shelter_calc2,results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_shelter_calc3,results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_shelter_calc4;




-- create scenario risk sauid indicators
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_all_indicators_s CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_all_indicators_s AS 

SELECT
b.sauid AS "Sauid",

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
CAST(CAST(ROUND(CAST(d.vs_lon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS  "sH_Vs30Lon",
CAST(CAST(ROUND(CAST(d.vs_lat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Vs30Lat",
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
CAST(CAST(ROUND(CAST(SUM(a."sD_None_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_None_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_None_r1" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_None_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_None_stdv_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_None_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Slight_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Slight_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Slight_r1" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Slight_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Slight_stdv_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Slight_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Moderate_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Moderate_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Moderate_r1" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Moderate_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Moderate_stdv_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Moderate_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Extensive_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Extensive_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Extensive_r1" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Extensive_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Extensive_stdv_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Extensive_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Complete_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Complete_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Complete_r1" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Complete_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Complete_stdv_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Complete_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Collapse_r1" * b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sD_Collapse_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Collapse_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Collapse_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sD_Complete_stdv_r1" * g.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtsd_Collapse_r1",

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
--CAST(CAST(ROUND(CAST(AVG(a."sC_Downtime_b0")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCm_Downtime_b0",
--CAST(CAST(ROUND(CAST(AVG(a."sC_Repair_b0")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCm_Repair_b0",
--CAST(CAST(ROUND(CAST(AVG(a."sC_Construxn_b0")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "SCm_Recovery_b0",
CAST(CAST(ROUND(CAST(AVG(a."sC_Downtime_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "SCm_Downtime_b0",
CAST(CAST(ROUND(CAST(AVG(a."sC_Repair_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCm_Repair_b0",
CAST(CAST(ROUND(CAST(AVG(a."sC_Recovery_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "SCm_Recovery_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisBW_b0" + a."sC_DebrisC_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_DebrisTotal_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisBW_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_DebrisBW_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisC_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_DebrisCS_b0",

-- 3.2.1 Recovery - r1
--CAST(CAST(ROUND(CAST(SUM(a."sD_None_r1" + a."sD_Slight_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_GreenTag_b_r1",
--CAST(CAST(ROUND(CAST(SUM(a."sD_None_r1" + a."sD_Slight_r1")/5 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_GreenTag_i_r1",
--CAST(CAST(ROUND(CAST(SUM(a."sD_Extensive_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_YellowTag_d_r1",
--CAST(CAST(ROUND(CAST(SUM(a."sD_Extensive_r1")/2.5 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_YellowTag_i_r1",
--CAST(CAST(ROUND(CAST(SUM(a."sD_Complete_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_RedTag_b_r1",
--CAST(CAST(ROUND(CAST(SUM(a."sD_Complete_r1")/5 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_RedTag_i_r1" ,
--CAST(CAST(ROUND(CAST(SUM(a."sD_None_r1" + (a."sD_Slight_r1"*0.2) +(a."sD_Moderate_r1"*0.05)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Operational_r1",
--CAST(CAST(ROUND(CAST(SUM((a."sD_Slight_r1"*0.8) + (a."sD_Moderate_r1"*0.75) + (a."sD_Extensive_r1"*0.2)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Functional_r1",
--CAST(CAST(ROUND(CAST(SUM((a."sD_Moderate_r1"*0.2) + (a."sD_Extensive_r1"*0.4)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Repairable_r1",
--CAST(CAST(ROUND(CAST(SUM((a."sD_Extensive_r1"*0.3) + (a."sD_Complete_r1"*0.2)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Failure_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sC_Downtime_r1")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCm_Downtime_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sC_Repair_r1")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCm_Repair_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sC_Construxn_r1")/(AVG(b.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "SCm_Recovery_r1",
CAST(CAST(ROUND(CAST(AVG(a."sC_Downtime_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "SCm_Downtime_r1",
CAST(CAST(ROUND(CAST(AVG(a."sC_Repair_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCm_Repair_r1",
CAST(CAST(ROUND(CAST(AVG(a."sC_Recovery_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "SCm_Recovery_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisBW_r1" + a."sC_DebrisC_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_DebrisTotal_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisBW_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_DebrisBW_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisC_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_DebrisCS_r1",

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
--CAST(CAST(ROUND(CAST(SUM(a."sL_Fatalities_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Fatality_r1",
--CAST(CAST(ROUND(CAST(AVG(a."sL_Fatalities_stdv_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLtsd_Fatality_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL1_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasDayL1_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL2_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasDayL2_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL3_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasDayL3_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasDayL4_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasDayL4_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL1_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasNightL1_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL2_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasNightL2_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL3_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasNightL3_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasNightL4_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasNightL4_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL1_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasTransitL1_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL2_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasTransitL2_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL3_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasTransitL3_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_CasTransitL4_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_CasTransitL4_r1",

-- 3.3.2 Social Disruption - b0
CAST(CAST(ROUND(CAST(k."sCt_Shelter_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Shelter_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_3_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res3_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_30_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res30_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_90_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res90_b0",
CAST(CAST(ROUND(CAST(AVG(COALESCE(a."sC_DisplRes_90_b0"/NULLIF((b.night),0),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCr_DisplRes90_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_180_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res180_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_360_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res360_b0",

CAST(CAST(ROUND(CAST(k."sCt_DisplHshld_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_DisplHshld_b0",

CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_30_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl30_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_90_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl90_b0",
CAST(CAST(ROUND(CAST(AVG(COALESCE(a."sC_DisrupEmpl_90_b0"/NULLIF((b.day),0),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCr_Empl90_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_180_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl180_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_360_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl360_b0",

-- 3.3.2 Social Disruption - r1
CAST(CAST(ROUND(CAST(k."sCt_Shelter_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Shelter_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_3_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res3_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_30_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res30_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_90_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res90_r1",
CAST(CAST(ROUND(CAST(AVG(COALESCE(a."sC_DisplRes_90_r1"/NULLIF((b.night),0),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCr_Res90_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_180_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res180_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_360_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res360_r1",

CAST(CAST(ROUND(CAST(k."sCt_DisplHshld_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_DisplHshld_r1",

CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_30_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl30_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_90_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl90_r1",
CAST(CAST(ROUND(CAST(AVG(COALESCE(a."sC_DisrupEmpl_90_r1"/NULLIF((b.day),0),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCr_Empl90_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_180_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl180_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_360_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl360_r1",

-- 3.4 Economic Security
-- 3.4.1 Economic Loss - b0
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_b0" + a."sL_NStr_b0" + a."sL_Cont_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Asset_b0",
CAST(CAST(ROUND(CAST(COALESCE(AVG((a."sL_Str_b0" + a."sL_NStr_b0" + a."sL_Cont_b0")/(NULLIF((b.structural + b.nonstructural + b.contents),0))),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLm_Asset_b0",
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_b0" + a."sL_NStr_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Bldg_b0",
CAST(CAST(ROUND(CAST(COALESCE(AVG((a."sL_Str_b0" + a."sL_NStr_b0")/(NULLIF((b.structural + b.nonstructural + b.contents),0))),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmr_Bldg_b0",
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Str_b0",
--CAST(CAST(ROUND(CAST(SUM(a."sL_Str_stdv_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmsd_Str_b0",
CAST(CAST(ROUND(CAST(SUM(a."sL_NStr_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_NStr_b0",
--CAST(CAST(ROUND(CAST(SUM(a."sL_NStr_stdv_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmsd_NStr_b0",
CAST(CAST(ROUND(CAST(SUM(a."sL_Cont_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Cont_b0",
--CAST(CAST(ROUND(CAST(SUM(a."sL_Cont_stdv_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmsd_Cont_b0",

-- 3.4.1 Economic Loss - r1
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_r1" + a."sL_NStr_r1" + a."sL_Cont_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Asset_r1",
CAST(CAST(ROUND(CAST(COALESCE(AVG((a."sL_Str_r1" + a."sL_NStr_r1" + a."sL_Cont_r1")/(NULLIF((b.structural + b.nonstructural + b.contents),0))),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLm_Asset_r1",
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_r1" + a."sL_NStr_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Bldg_r1",
CAST(CAST(ROUND(CAST(COALESCE(AVG((a."sL_Str_r1" + a."sL_NStr_r1")/(NULLIF((b.structural + b.nonstructural + b.contents),0))),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmr_Bldg_r1",
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Str_r1",
--CAST(CAST(ROUND(CAST(SUM(a."sL_Str_stdv_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmsd_Str_r1",
CAST(CAST(ROUND(CAST(SUM(a."sL_NStr_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_NStr_r1",
--CAST(CAST(ROUND(CAST(SUM(a."sL_NStr_stdv_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmsd_NStr_r1",
CAST(CAST(ROUND(CAST(SUM(a."sL_Cont_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Cont_r1",
--CAST(CAST(ROUND(CAST(SUM(a."sL_Cont_stdv_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmsd_Cont_r1",

/*
CAST(CAST(ROUND(CAST(CASE WHEN (AVG((((a."sL_Str_b0" + a."sL_NStr_b0") - (a."sL_Str_r1" + a."sL_NStr_r1"))/(b.number))/((b.retrofitting)/(b.number)))) > 0 
THEN (AVG((((a."sL_Str_b0" + a."sL_NStr_b0") - (a."sL_Str_r1" + a."sL_NStr_r1"))/(b.number))/((b.retrofitting)/(b.number)))) ELSE 1 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmr1_BCR" ,
*/
--CAST(CAST(ROUND(CAST(CASE WHEN (AVG(((a."sL_Str_b0" + a."sL_NStr_b0" + a."sL_Cont_b0") - (a."sL_Str_r1" + a."sL_NStr_r1" + a."sL_Cont_r1"))/(b.retrofitting))) > 0
--THEN (AVG(((a."sL_Str_b0" + a."sL_NStr_b0" + a."sL_Cont_b0") - (a."sL_Str_r1" + a."sL_NStr_r1" + a."sL_Cont_r1"))/(b.retrofitting))) ELSE 1 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmr1_BCR" ,

/*
CAST(CAST(ROUND(CAST(CASE WHEN (AVG((((a."sL_Str_b0" + a."sL_NStr_b0") - (a."sL_Str_r1" + a."sL_NStr_r1"))/(b.number)) * ((EXP(-0.025*0.50)/0.025)/((b.retrofitting)/(b.number))))) > 0
THEN (AVG((((a."sL_Str_b0" + a."sL_NStr_b0") - (a."sL_Str_r1" + a."sL_NStr_r1"))/(b.number)) * ((EXP(-0.025*0.50)/0.025)/((b.retrofitting)/(b.number))))) ELSE 1 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmr1_RoI",
*/
--CAST(CAST(ROUND(CAST(CASE WHEN (AVG(((a."sL_Str_b0" + a."sL_NStr_b0" + a."sL_Cont_b0") - (a."sL_Str_r1" + a."sL_NStr_r1" + a."sL_Cont_r1")) * ((EXP(-0.03*100)/0.03)/(b.retrofitting)))) > 0
--THEN (AVG(((a."sL_Str_b0" + a."sL_NStr_b0" + a."sL_Cont_b0") - (a."sL_Str_r1" + a."sL_NStr_r1" + a."sL_Cont_r1")) * ((EXP(-0.03*100)/0.03)/(b.retrofitting)))) ELSE 1 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmr1_RoI",

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

FROM dsra.dsra_{eqScenario} a
LEFT JOIN exposure.canada_exposure b ON a."AssetID" = b.id 
LEFT JOIN vs30.vs30_can_site_model_xref d ON a."AssetID" = d.id
LEFT JOIN gmf.shakemap_{eqScenario}_xref e ON b.id = e.id
LEFT JOIN ruptures.rupture_table f ON f.rupture_name = a."Rupture_Abbr"
--LEFT JOIN lut.collapse_probability g ON b.bldgtype = g.eqbldgtype
--LEFT JOIN census.census_2016_canada h ON b.sauid = h.sauidt
LEFT JOIN boundaries."Geometry_SAUID" i ON b.sauid = i."SAUIDt"
--LEFT JOIN sovi.sovi_census_canada j ON b.sauid = j.sauidt
LEFT JOIN results_dsra_sim9p0_cascadiainterfacebestfault.sim9p0_cascadiainterfacebestfault_shelter k ON b.sauid = k."Sauid"
WHERE e."gmv_SA(0.3)" >=0.02
GROUP BY a."Rupture_Abbr",a."gmpe_Model",b.sauid,b.landuse,d.vs30,d.z1pt0,d.z2pt5,d.vs_lon,d.vs_lat,e.site_id,e.lon,e.lat,f.source_type,
f.magnitude,f.lon,f.lat,f.depth,f.rake,e."gmv_pga",e."gmv_SA(0.1)",e."gmv_SA(0.2)",e."gmv_SA(0.3)",e."gmv_SA(0.5)",e."gmv_SA(0.6)",e."gmv_SA(1.0)",e."gmv_SA(0.3)",e."gmv_SA(2.0)",
i."PRUID",i."PRNAME",i."ERUID",i."ERNAME",i."CDUID",i."CDNAME",i."CSDUID",i."CSDNAME",i."CFSAUID",i."DAUIDt",i."SACCODE",i."SACTYPE",k."sCt_DisplHshld_b0",k."sCt_DisplHshld_r1",k."sCt_Shelter_b0",k."sCt_Shelter_r1",i.geom;
/*
GROUP BY a."Rupture_Abbr",a."gmpe_Model",b.sauid,b.landuse,d.vs30,d.z1pt0,d.z2pt5,d.vs_lon,d.vs_lat,e.site_id,e.lon,e.lat,f.source_type,
f.magnitude,f.lon,f.lat,f.depth,f.rake,e."gmv_pga",e."gmv_SA(0.1)",e."gmv_SA(0.2)",e."gmv_SA(0.3)",e."gmv_SA(0.5)",e."gmv_SA(0.6)",e."gmv_SA(1.0)",e."gmv_SA(0.3)",e."gmv_SA(2.0)",
h.censuspop,h.censusdu,b.popdu,j.inc_hshld,j.imm_lt5,j.live_alone,j.no_engfr,j.lonepar3kids,j.indigenous,j.renter,j.age_lt6,j.age_gt65,i."PRUID",i."PRNAME",i."ERUID",i."ERNAME",i."CDUID",i."CDNAME",i."CSDUID",
i."CSDNAME",i."CFSAUID",i."DAUIDt",i."SACCODE",i."SACTYPE",k."sCt_DisplHshld_b0",k."sCt_DisplHshld_r1",i.geom;
*/