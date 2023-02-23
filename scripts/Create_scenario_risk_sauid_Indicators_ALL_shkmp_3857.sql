-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_dsra_{eqScenario};




--intermediates table to calculate shelter for DSRA
DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_shelter_calc1 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.{eqScenario}_shelter_calc1 AS
(
SELECT 
a."Sauid",
SUM(a."sC_Hshld_b0") AS "sCt_DisplHshld_b0",
SUM(a."sC_Hshld_r1") AS "sCt_DisplHshld_r1",
SUM(b."E_PopNight") AS "Et_PopNight"
	
FROM results_dsra_{eqScenario}.dsra_{eqScenario}_indicators_b a
LEFT JOIN results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_b b ON a."AssetID" = b."BldgID"
GROUP BY a."Sauid"
);


--intermediates table to calculate shelter for DSRA
DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_shelter_calc2 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.{eqScenario}_shelter_calc2 AS
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
c.inc_hshld,
c.vis_min,
c.indigenous,
c.renter,
c.age_gt65,
c.age_lt6,


--IM
--IF [Inc_Hshld] =< $15,000, THEN 0.62 = IM1
CASE WHEN c.inc_hshld <= 15000 THEN 1 * 0.62 ELSE 0 END AS "IM1",
--IF [Inc_Hshld] > $15,000 AND [Inc_Hshld] =<, $20,000 THEN 0.42 = IM2
CASE WHEN c.inc_hshld > 15000 AND c.inc_hshld <= 20000 THEN 1 * 0.42 ELSE 0 END AS "IM2",
--IF [Inc_Hshld] > $20,000 AND [Inc_Hshld] =<, $35,000 THEN 0.29 = IM3
CASE WHEN c.inc_hshld > 20000 AND c.inc_hshld <= 35000 THEN 1 * 0.29 ELSE 0 END AS "IM3",
--IF [Inc_Hshld] > $35,000 AND [Inc_Hshld] =<, $50,000 THEN  0.22 = IM4
CASE WHEN c.inc_hshld > 35000 AND c.inc_hshld <= 50000 THEN 1 *  0.22 ELSE 0 END AS "IM4",
--IF [Inc_Hshld] > $50,000 THEN 0.13 = IM5
CASE WHEN c.inc_hshld > 50000 THEN 1 * 0.13 ELSE 0 END AS "IM5",

--EM
--1 - vis_min - indigenous *0.24 = white
(1 - c.vis_min - c.indigenous) * 0.24 AS "EM1",

--vis_min * 0.40 = EM2, modification factors is average of Hazus visible minority values avg (0.48 + 0.47 + 0.26) = 0.40
c.vis_min * 0.40 AS "EM2",

--indigenous * 0.26 = EM3
c.indigenous * 0.26 AS "EM3",

---OM
--renter * 0.40 = OM1
c.renter * 0.40 AS "OM1",

--owner * 0.40 = OM2, 1 - renter
1 - c.renter * 0.40 AS "OM2",


--AM
--age_lt6 * 0.40 = AM1
c.age_lt6 * 0.40 AS "AM1",

--1 - (age_lt6 + c.age_gt65) * 0.40, percentage of population between6 and 65
1 - (c.age_lt6 + c.age_gt65) * 0.40 AS "AM2",
	
--age_gt65 * 0.40 = AM3
c.age_gt65 * 0.40 AS "AM3"


FROM results_dsra_{eqScenario}.{eqScenario}_shelter_calc1 a
LEFT JOIN results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s b ON a."Sauid" = b."Sauid"
LEFT JOIN census.census_2016_canada c ON b."Sauid" = c.sauidt
);


-- intermediates table to calculate shelter for DSRA
DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_shelter_calc3 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.{eqScenario}_shelter_calc3 AS
(
SELECT
"Sauid",

--(displaced household * nighttime population)/(households (single fam + multi fam))
COALESCE(((a."sCt_DisplHshld_b0" * a."Et_PopNight") / NULLIF((a."Et_SFHshld" + a."Et_MFHshld"),0)),0) AS "ppl_b0",
COALESCE(((a."sCt_DisplHshld_r1" * a."Et_PopNight") / NULLIF((a."Et_SFHshld" + a."Et_MFHshld"),0)),0) AS "ppl_r1"

FROM results_dsra_{eqScenario}.{eqScenario}_shelter_calc2 a
);


-- intermediates table to calculate shelter for DSRA
DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_shelter_calc4 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.{eqScenario}_shelter_calc4 AS
(
SELECT A."Sauid",
--IM1, EM1, OM1, AM* = X1
((0.73 * a."IM1") + (0.27 * a."EM1") + (0 * a."OM1") + (0 * a."AM1")) + 
((0.73 * a."IM1") + (0.27 * a."EM1") + (0 * a."OM1") + (0 * a."AM2")) + 
((0.73 * a."IM1") + (0.27 * a."EM1") + (0 * a."OM1") + (0 * a."AM3")) AS "X1",

--IM1, EM1, OM2, AM* = X2
((0.73 * a."IM1") + (0.27 * a."EM1") + (0 * a."OM2") + (0 * a."AM1")) + 
((0.73 * a."IM1") + (0.27 * a."EM1") + (0 * a."OM2") + (0 * a."AM2")) + 
((0.73 * a."IM1") + (0.27 * a."EM1") + (0 * a."OM2") + (0 * a."AM3")) AS "X2",

--IM1, EM2, OM1, AM* = X3
((0.73 * a."IM1") + (0.27 * a."EM2") + (0 * a."OM1") + (0 * a."AM1")) + 
((0.73 * a."IM1") + (0.27 * a."EM2") + (0 * a."OM1") + (0 * a."AM2")) + 
((0.73 * a."IM1") + (0.27 * a."EM2") + (0 * a."OM1") + (0 * a."AM3")) AS "X3",

--IM1, EM2, OM2, AM* = X4
((0.73 * a."IM1") + (0.27 * a."EM2") + (0 * a."OM2") + (0 * a."AM1")) + 
((0.73 * a."IM1") + (0.27 * a."EM2") + (0 * a."OM2") + (0 * a."AM2")) + 
((0.73 * a."IM1") + (0.27 * a."EM2") + (0 * a."OM2") + (0 * a."AM3")) AS "X4",

--IM1, EM3, OM1, AM* = X5
((0.73 * a."IM1") + (0.27 * a."EM3") + (0 * a."OM1") + (0 * a."AM1")) + 
((0.73 * a."IM1") + (0.27 * a."EM3") + (0 * a."OM1") + (0 * a."AM2")) + 
((0.73 * a."IM1") + (0.27 * a."EM3") + (0 * a."OM1") + (0 * a."AM3")) AS "X5",

--IM1, EM3, OM2, AM* = X6
((0.73 * a."IM1") + (0.27 * a."EM3") + (0 * a."OM2") + (0 * a."AM1")) + 
((0.73 * a."IM1") + (0.27 * a."EM3") + (0 * a."OM2") + (0 * a."AM2")) + 
((0.73 * a."IM1") + (0.27 * a."EM3") + (0 * a."OM2") + (0 * a."AM3")) AS "X6",

--IM2, EM1, OM1, AM* = X7
((0.73 * a."IM2") + (0.27 * a."EM1") + (0 * a."OM1") + (0 * a."AM1")) + 
((0.73 * a."IM2") + (0.27 * a."EM1") + (0 * a."OM1") + (0 * a."AM2")) + 
((0.73 * a."IM2") + (0.27 * a."EM1") + (0 * a."OM1") + (0 * a."AM3")) AS "X7",

--IM2, EM1, OM2, AM* = X8
((0.73 * a."IM2") + (0.27 * a."EM1") + (0 * a."OM2") + (0 * a."AM1")) + 
((0.73 * a."IM2") + (0.27 * a."EM1") + (0 * a."OM2") + (0 * a."AM2")) + 
((0.73 * a."IM2") + (0.27 * a."EM1") + (0 * a."OM2") + (0 * a."AM3")) AS "X8",

--IM2, EM2, OM1, AM* = X9
((0.73 * a."IM2") + (0.27 * a."EM2") + (0 * a."OM1") + (0 * a."AM1")) + 
((0.73 * a."IM2") + (0.27 * a."EM2") + (0 * a."OM1") + (0 * a."AM2")) + 
((0.73 * a."IM2") + (0.27 * a."EM2") + (0 * a."OM1") + (0 * a."AM3")) AS "X9",

--IM2, EM2, OM2, AM* = X10
((0.73 * a."IM2") + (0.27 * a."EM2") + (0 * a."OM2") + (0 * a."AM1")) + 
((0.73 * a."IM2") + (0.27 * a."EM2") + (0 * a."OM2") + (0 * a."AM2")) + 
((0.73 * a."IM2") + (0.27 * a."EM2") + (0 * a."OM2") + (0 * a."AM3")) AS "X10",

--IM2, EM3, OM1, AM* = X11
((0.73 * a."IM2") + (0.27 * a."EM3") + (0 * a."OM1") + (0 * a."AM1")) + 
((0.73 * a."IM2") + (0.27 * a."EM3") + (0 * a."OM1") + (0 * a."AM2")) + 
((0.73 * a."IM2") + (0.27 * a."EM3") + (0 * a."OM1") + (0 * a."AM3")) AS "X11",

--IM2, EM3, OM2, AM* = X12
((0.73 * a."IM2") + (0.27 * a."EM3") + (0 * a."OM2") + (0 * a."AM1")) + 
((0.73 * a."IM2") + (0.27 * a."EM3") + (0 * a."OM2") + (0 * a."AM2")) + 
((0.73 * a."IM2") + (0.27 * a."EM3") + (0 * a."OM2") + (0 * a."AM3")) AS "X12",

--IM3, EM1, OM1, AM* = X13
((0.73 * a."IM3") + (0.27 * a."EM1") + (0 * a."OM1") + (0 * a."AM1")) + 
((0.73 * a."IM3") + (0.27 * a."EM1") + (0 * a."OM1") + (0 * a."AM2")) + 
((0.73 * a."IM3") + (0.27 * a."EM1") + (0 * a."OM1") + (0 * a."AM3")) AS "X13",

--IM3, EM1, OM2, AM* = X14
((0.73 * a."IM3") + (0.27 * a."EM1") + (0 * a."OM2") + (0 * a."AM1")) + 
((0.73 * a."IM3") + (0.27 * a."EM1") + (0 * a."OM2") + (0 * a."AM2")) + 
((0.73 * a."IM3") + (0.27 * a."EM1") + (0 * a."OM2") + (0 * a."AM3")) AS "X14",

--IM3, EM2, OM1, AM* = X15
((0.73 * a."IM3") + (0.27 * a."EM2") + (0 * a."OM1") + (0 * a."AM1")) + 
((0.73 * a."IM3") + (0.27 * a."EM2") + (0 * a."OM1") + (0 * a."AM2")) + 
((0.73 * a."IM3") + (0.27 * a."EM2") + (0 * a."OM1") + (0 * a."AM3")) AS "X15",

--IM3, EM2, OM2, AM* = X16
((0.73 * a."IM3") + (0.27 * a."EM2") + (0 * a."OM2") + (0 * a."AM1")) + 
((0.73 * a."IM3") + (0.27 * a."EM2") + (0 * a."OM2") + (0 * a."AM2")) + 
((0.73 * a."IM3") + (0.27 * a."EM2") + (0 * a."OM2") + (0 * a."AM3")) AS "X16",

--IM3, EM3, OM1, AM* = X17
((0.73 * a."IM3") + (0.27 * a."EM3") + (0 * a."OM1") + (0 * a."AM1")) + 
((0.73 * a."IM3") + (0.27 * a."EM3") + (0 * a."OM1") + (0 * a."AM2")) + 
((0.73 * a."IM3") + (0.27 * a."EM3") + (0 * a."OM1") + (0 * a."AM3")) AS "X17",

--IM3, EM3, OM2, AM* = X18
((0.73 * a."IM3") + (0.27 * a."EM3") + (0 * a."OM2") + (0 * a."AM1")) + 
((0.73 * a."IM3") + (0.27 * a."EM3") + (0 * a."OM2") + (0 * a."AM2")) + 
((0.73 * a."IM3") + (0.27 * a."EM3") + (0 * a."OM2") + (0 * a."AM3")) AS "X18",

--IM4, EM1, OM1, AM* = X19
((0.73 * a."IM4") + (0.27 * a."EM1") + (0 * a."OM1") + (0 * a."AM1")) + 
((0.73 * a."IM4") + (0.27 * a."EM1") + (0 * a."OM1") + (0 * a."AM2")) + 
((0.73 * a."IM4") + (0.27 * a."EM1") + (0 * a."OM1") + (0 * a."AM3")) AS "X19",

--IM4, EM1, OM2, AM* = X20
((0.73 * a."IM4") + (0.27 * a."EM1") + (0 * a."OM2") + (0 * a."AM1")) + 
((0.73 * a."IM4") + (0.27 * a."EM1") + (0 * a."OM2") + (0 * a."AM2")) + 
((0.73 * a."IM4") + (0.27 * a."EM1") + (0 * a."OM2") + (0 * a."AM3")) AS "X20",

--IM4, EM2, OM1, AM* = X21
((0.73 * a."IM4") + (0.27 * a."EM2") + (0 * a."OM1") + (0 * a."AM1")) + 
((0.73 * a."IM4") + (0.27 * a."EM2") + (0 * a."OM1") + (0 * a."AM2")) + 
((0.73 * a."IM4") + (0.27 * a."EM2") + (0 * a."OM1") + (0 * a."AM3")) AS "X21",

--IM4, EM2, OM2, AM* = X22
((0.73 * a."IM4") + (0.27 * a."EM2") + (0 * a."OM2") + (0 * a."AM1")) + 
((0.73 * a."IM4") + (0.27 * a."EM2") + (0 * a."OM2") + (0 * a."AM2")) + 
((0.73 * a."IM4") + (0.27 * a."EM2") + (0 * a."OM2") + (0 * a."AM3")) AS "X22",

--IM4, EM3, OM1, AM* = X23
((0.73 * a."IM4") + (0.27 * a."EM3") + (0 * a."OM1") + (0 * a."AM1")) + 
((0.73 * a."IM4") + (0.27 * a."EM3") + (0 * a."OM1") + (0 * a."AM2")) + 
((0.73 * a."IM4") + (0.27 * a."EM3") + (0 * a."OM1") + (0 * a."AM3")) AS "X23",

--IM4, EM3, OM2, AM* = X24
((0.73 * a."IM4") + (0.27 * a."EM3") + (0 * a."OM2") + (0 * a."AM1")) + 
((0.73 * a."IM4") + (0.27 * a."EM3") + (0 * a."OM2") + (0 * a."AM2")) + 
((0.73 * a."IM4") + (0.27 * a."EM3") + (0 * a."OM2") + (0 * a."AM3")) AS "X24",

--IM5, EM1, OM1, AM* = X25
((0.73 * a."IM5") + (0.27 * a."EM1") + (0 * a."OM1") + (0 * a."AM1")) + 
((0.73 * a."IM5") + (0.27 * a."EM1") + (0 * a."OM1") + (0 * a."AM2")) + 
((0.73 * a."IM5") + (0.27 * a."EM1") + (0 * a."OM1") + (0 * a."AM3")) AS "X25",

--IM5, EM1, OM2, AM* = X26
((0.73 * a."IM5") + (0.27 * a."EM1") + (0 * a."OM2") + (0 * a."AM1")) + 
((0.73 * a."IM5") + (0.27 * a."EM1") + (0 * a."OM2") + (0 * a."AM2")) + 
((0.73 * a."IM5") + (0.27 * a."EM1") + (0 * a."OM2") + (0 * a."AM3")) AS "X26",

--IM5, EM2, OM1, AM* = X27
((0.73 * a."IM5") + (0.27 * a."EM2") + (0 * a."OM1") + (0 * a."AM1")) + 
((0.73 * a."IM5") + (0.27 * a."EM2") + (0 * a."OM1") + (0 * a."AM2")) + 
((0.73 * a."IM5") + (0.27 * a."EM2") + (0 * a."OM1") + (0 * a."AM3")) AS "X27",

--IM5, EM2, OM2, AM* = X28
((0.73 * a."IM5") + (0.27 * a."EM2") + (0 * a."OM2") + (0 * a."AM1")) + 
((0.73 * a."IM5") + (0.27 * a."EM2") + (0 * a."OM2") + (0 * a."AM2")) + 
((0.73 * a."IM5") + (0.27 * a."EM2") + (0 * a."OM2") + (0 * a."AM3")) AS "X28",

--IM5, EM3, OM1, AM* = X29
((0.73 * a."IM5") + (0.27 * a."EM3") + (0 * a."OM1") + (0 * a."AM1")) + 
((0.73 * a."IM5") + (0.27 * a."EM3") + (0 * a."OM1") + (0 * a."AM2")) + 
((0.73 * a."IM5") + (0.27 * a."EM3") + (0 * a."OM1") + (0 * a."AM3")) AS "X29",

--IM5, EM3, OM2, AM* = X30
((0.73 * a."IM5") + (0.27 * a."EM3") + (0 * a."OM2") + (0 * a."AM1")) + 
((0.73 * a."IM5") + (0.27 * a."EM3") + (0 * a."OM2") + (0 * a."AM2")) + 
((0.73 * a."IM5") + (0.27 * a."EM3") + (0 * a."OM2") + (0 * a."AM3")) AS "X30"

FROM results_dsra_{eqScenario}.{eqScenario}_shelter_calc2 a
LEFT JOIN results_dsra_{eqScenario}.{eqScenario}_shelter_calc3 b ON a."Sauid" = b."Sauid"
);



-- intermediates table to calculate shelter for DSRA
DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_shelter_calc5 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.{eqScenario}_shelter_calc5 AS
(
SELECT 
a."Sauid",

-- alpha
"X1" + "X2" + "X3" + "X4" + "X5" + "X6" + "X7" + "X8" + "X9" + "X10" +
"X11" + "X12" + "X13" + "X14" + "X15" + "X16" + "X17" + "X18" + "X19" + "X20" + 
"X21" + "X22" + "X23" + "X24" + "X25" + "X26" + "X27" + "X28" + "X29" + "X30" AS "alpha"

FROM results_dsra_{eqScenario}.{eqScenario}_shelter_calc4 a
);



-- intermediates table to calculate shelter for DSRA
DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_shelter_calc6 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.{eqScenario}_shelter_calc6 AS
(
SELECT 
a."Sauid",

--IM1, EM1, OM1, AM* = X1
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM1") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM1") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM1") * (a."OM1") * (a."AM3")) AS "X1_b0",

--IM1, EM1, OM2, AM* = X2
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM1") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM1") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM1") * (a."OM2") * (a."AM3")) AS "X2_b0",

--IM1, EM2, OM1, AM* = X3
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM2") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM2") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM2") * (a."OM1") * (a."AM3")) AS "X3_b0",

--IM1, EM2, OM2, AM* = X4
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM2") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM2") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM2") * (a."OM2") * (a."AM3")) AS "X4_b0",

--IM1, EM3, OM1, AM* = X5
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM3") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM3") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM3") * (a."OM1") * (a."AM3")) AS "X5_b0",

--IM1, EM3, OM2, AM* = X6
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM3") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM3") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM1") * (a."EM3") * (a."OM2") * (a."AM3")) AS "X6_b0",

--IM2, EM1, OM1, AM* = X7
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM1") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM1") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM1") * (a."OM1") * (a."AM3")) AS "X7_b0",

--IM2, EM1, OM2, AM* = X8
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM1") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM1") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM1") * (a."OM2") * (a."AM3")) AS "X8_b0",

--IM2, EM2, OM1, AM* = X9
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM2") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM2") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM2") * (a."OM1") * (a."AM3")) AS "X9_b0",

--IM2, EM2, OM2, AM* = X10
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM2") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM2") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM2") * (a."OM2") * (a."AM3")) AS "X10_b0",

--IM2, EM3, OM1, AM* = X11
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM3") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM3") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM3") * (a."OM1") * (a."AM3")) AS "X11_b0",

--IM2, EM3, OM2, AM* = X12
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM3") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM3") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM2") * (a."EM3") * (a."OM2") * (a."AM3")) AS "X12_b0",

--IM3, EM1, OM1, AM* = X13
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM1") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM1") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM1") * (a."OM1") * (a."AM3")) AS "X13_b0",

--IM3, EM1, OM2, AM* = X14
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM1") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM1") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM1") * (a."OM2") * (a."AM3")) AS "X14_b0",

--IM3, EM2, OM1, AM* = X15
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM2") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM2") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM2") * (a."OM1") * (a."AM3")) AS "X15_b0",

--IM3, EM2, OM2, AM* = X16
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM2") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM2") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM2") * (a."OM2") * (a."AM3")) AS "X16_b0",

--IM3, EM3, OM1, AM* = X17
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM3") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM3") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM3") * (a."OM1") * (a."AM3")) AS "X17_b0",

--IM3, EM3, OM2, AM* = X18
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM3") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM3") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM3") * (a."EM3") * (a."OM2") * (a."AM3")) AS "X18_b0",

--IM4, EM1, OM1, AM* = X19
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM1") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM1") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM1") * (a."OM1") * (a."AM3")) AS "X19_b0",

--IM4, EM1, OM2, AM* = X20
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM1") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM1") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM1") * (a."OM2") * (a."AM3")) AS "X20_b0",

--IM4, EM2, OM1, AM* = X21
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM2") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM2") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM2") * (a."OM1") * (a."AM3")) AS "X21_b0",

--IM4, EM2, OM2, AM* = X22
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM2") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM2") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM2") * (a."OM2") * (a."AM3")) AS "X22_b0",

--IM4, EM3, OM1, AM* = X23
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM3") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM3") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM3") * (a."OM1") * (a."AM3")) AS "X23_b0",

--IM4, EM3, OM2, AM* = X24
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM3") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM3") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM4") * (a."EM3") * (a."OM2") * (a."AM3")) AS "X24_b0",

--IM5, EM1, OM1, AM* = X25
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM1") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM1") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM1") * (a."OM1") * (a."AM3")) AS "X25_b0",

--IM5, EM1, OM2, AM* = X26
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM1") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM1") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM1") * (a."OM2") * (a."AM3")) AS "X26_b0",

--IM5, EM2, OM1, AM* = X27
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM2") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM2") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM2") * (a."OM1") * (a."AM3")) AS "X27_b0",

--IM5, EM2, OM2, AM* = X28
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM2") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM2") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM2") * (a."OM2") * (a."AM3")) AS "X28_b0",

--IM5, EM3, OM1, AM* = X29
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM3") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM3") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM3") * (a."OM1") * (a."AM3")) AS "X29_b0" ,

--IM5, EM3, OM2, AM* = X30
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM3") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM3") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_b0") * (a."IM5") * (a."EM3") * (a."OM2") * (a."AM3")) AS "X30_b0",


--IM1, EM1, OM1, AM* = X1
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM1") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM1") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM1") * (a."OM1") * (a."AM3")) AS "X1_r1",

--IM1, EM1, OM2, AM* = X2
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM1") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM1") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM1") * (a."OM2") * (a."AM3")) AS "X2_r1",

--IM1, EM2, OM1, AM* = X3
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM2") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM2") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM2") * (a."OM1") * (a."AM3")) AS "X3_r1",

--IM1, EM2, OM2, AM* = X4
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM2") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM2") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM2") * (a."OM2") * (a."AM3")) AS "X4_r1",

--IM1, EM3, OM1, AM* = X5
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM3") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM3") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM3") * (a."OM1") * (a."AM3")) AS "X5_r1",

--IM1, EM3, OM2, AM* = X6
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM3") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM3") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM1") * (a."EM3") * (a."OM2") * (a."AM3")) AS "X6_r1",

--IM2, EM1, OM1, AM* = X7
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM1") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM1") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM1") * (a."OM1") * (a."AM3")) AS "X7_r1",

--IM2, EM1, OM2, AM* = X8
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM1") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM1") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM1") * (a."OM2") * (a."AM3")) AS "X8_r1",

--IM2, EM2, OM1, AM* = X9
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM2") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM2") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM2") * (a."OM1") * (a."AM3")) AS "X9_r1",

--IM2, EM2, OM2, AM* = X10
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM2") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM2") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM2") * (a."OM2") * (a."AM3")) AS "X10_r1",

--IM2, EM3, OM1, AM* = X11
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM3") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM3") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM3") * (a."OM1") * (a."AM3")) AS "X11_r1",

--IM2, EM3, OM2, AM* = X12
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM3") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM3") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM2") * (a."EM3") * (a."OM2") * (a."AM3")) AS "X12_r1",

--IM3, EM1, OM1, AM* = X13
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM1") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM1") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM1") * (a."OM1") * (a."AM3")) AS "X13_r1",

--IM3, EM1, OM2, AM* = X14
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM1") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM1") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM1") * (a."OM2") * (a."AM3")) AS "X14_r1",

--IM3, EM2, OM1, AM* = X15
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM2") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM2") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM2") * (a."OM1") * (a."AM3")) AS "X15_r1",

--IM3, EM2, OM2, AM* = X16
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM2") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM2") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM2") * (a."OM2") * (a."AM3")) AS "X16_r1",

--IM3, EM3, OM1, AM* = X17
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM3") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM3") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM3") * (a."OM1") * (a."AM3")) AS "X17_r1",

--IM3, EM3, OM2, AM* = X18
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM3") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM3") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM3") * (a."EM3") * (a."OM2") * (a."AM3")) AS "X18_r1",

--IM4, EM1, OM1, AM* = X19
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM1") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM1") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM1") * (a."OM1") * (a."AM3")) AS "X19_r1",

--IM4, EM1, OM2, AM* = X20
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM1") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM1") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM1") * (a."OM2") * (a."AM3")) AS "X20_r1",

--IM4, EM2, OM1, AM* = X21
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM2") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM2") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM2") * (a."OM1") * (a."AM3")) AS "X21_r1",

--IM4, EM2, OM2, AM* = X22
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM2") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM2") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM2") * (a."OM2") * (a."AM3")) AS "X22_r1",

--IM4, EM3, OM1, AM* = X23
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM3") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM3") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM3") * (a."OM1") * (a."AM3")) AS "X23_r1",

--IM4, EM3, OM2, AM* = X24
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM3") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM3") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM4") * (a."EM3") * (a."OM2") * (a."AM3")) AS "X24_r1",

--IM5, EM1, OM1, AM* = X25
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM1") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM1") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM1") * (a."OM1") * (a."AM3")) AS "X25_r1",

--IM5, EM1, OM2, AM* = X26
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM1") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM1") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM1") * (a."OM2") * (a."AM3")) AS "X26_r1",

--IM5, EM2, OM1, AM* = X27
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM2") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM2") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM2") * (a."OM1") * (a."AM3")) AS "X27_r1",

--IM5, EM2, OM2, AM* = X28
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM2") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM2") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM2") * (a."OM2") * (a."AM3")) AS "X28_r1",

--IM5, EM3, OM1, AM* = X29
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM3") * (a."OM1") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM3") * (a."OM1") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM3") * (a."OM1") * (a."AM3")) AS "X29_r1" ,

--IM5, EM3, OM2, AM* = X30
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM3") * (a."OM2") * (a."AM1")) +
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM3") * (a."OM2") * (a."AM2")) +
((c.alpha) * (b."ppl_r1") * (a."IM5") * (a."EM3") * (a."OM2") * (a."AM3")) AS "X30_r1"

FROM results_dsra_{eqScenario}.{eqScenario}_shelter_calc2 a
LEFT JOIN results_dsra_{eqScenario}.{eqScenario}_shelter_calc3 b ON a."Sauid" = b."Sauid"
LEFT JOIN results_dsra_{eqScenario}.{eqScenario}_shelter_calc5 c ON a."Sauid" = c."Sauid"
);



--intermediates table to calculate shelter for DSRA
DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_shelter_calc7 CASCADE;
CREATE TABLE results_dsra_{eqScenario}.{eqScenario}_shelter_calc7 AS
(
SELECT
a."Sauid",

--"sCt_Shelter_b0"
a."X1_b0" + a."X2_b0" + a."X3_b0" + a."X4_b0" + a."X5_b0" + a."X6_b0" + a."X7_b0" + a."X8_b0" + a."X9_b0" + a."X10_b0" + 
a."X11_b0" + a."X12_b0" + a."X13_b0" + a."X14_b0" + a."X15_b0" + a."X16_b0" + a."X17_b0" + a."X18_b0" + a."X19_b0" + a."X20_b0" +
a."X21_b0" + a."X22_b0" + a."X23_b0" + a."X24_b0" + a."X25_b0" + a."X26_b0" + a."X27_b0" + a."X28_b0" + a."X29_b0" + a."X30_b0" AS "sCt_Shelter_b0",

--"sCt_Shelter_r1"
a."X1_r1" + a."X2_r1" + a."X3_r1" + a."X4_r1" + a."X5_r1" + a."X6_r1" + a."X7_r1" + a."X8_r1" + a."X9_r1" + a."X10_r1" + 
a."X11_r1" + a."X12_r1" + a."X13_r1" + a."X14_r1" + a."X15_r1" + a."X16_r1" + a."X17_r1" + a."X18_r1" + a."X19_r1" + a."X20_r1" +
a."X21_r1" + a."X22_r1" + a."X23_r1" + a."X24_r1" + a."X25_r1" + a."X26_r1" + a."X27_r1" + a."X28_r1" + a."X29_r1" + a."X30_r1" AS "sCt_Shelter_r1"

FROM results_dsra_{eqScenario}.{eqScenario}_shelter_calc6 a
);



--intermediates table to calculate shelter for DSRA
DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_shelter CASCADE;
CREATE TABLE results_dsra_{eqScenario}.{eqScenario}_shelter AS
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
a.inc_hshld,
a.vis_min,
a.indigenous,
a.renter,
a.age_gt65,
a.age_lt6,
a."IM1",
a."IM2",
a."IM3",
a."IM4",
a."IM5",
a."EM1",
a."EM2",
a."EM3",
a."OM1",
a."OM2",
a."AM1",
a."AM2",
a."AM3",
b."sCt_Shelter_b0",
b."sCt_Shelter_r1"

FROM results_dsra_{eqScenario}.{eqScenario}_shelter_calc2 a
LEFT JOIN results_dsra_{eqScenario}.{eqScenario}_shelter_calc7 b ON a."Sauid" = b."Sauid"
);



DROP TABLE IF EXISTS results_dsra_{eqScenario}.{eqScenario}_shelter_calc1,results_dsra_{eqScenario}.{eqScenario}_shelter_calc2,results_dsra_{eqScenario}.{eqScenario}_shelter_calc3,
results_dsra_{eqScenario}.{eqScenario}_shelter_calc4,results_dsra_{eqScenario}.{eqScenario}_shelter_calc5,results_dsra_{eqScenario}.{eqScenario}_shelter_calc6,results_dsra_{eqScenario}.{eqScenario}_shelter_calc7;




-- create scenario risk sauid indicators
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_indicators_s CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_indicators_s AS 

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
CAST(CAST(ROUND(CAST(d.vs30 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Vs30",
CAST(CAST(ROUND(CAST(d.z1pt0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_z1p0",
CAST(CAST(ROUND(CAST(d.z2pt5 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_z2p5",
CAST(CAST(ROUND(CAST(e."gmv_pga" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_PGA",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.1)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p1",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.2)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p2",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.3)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p3",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.5)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p5",
CAST(CAST(ROUND(CAST(e."gmv_SA(0.6)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa0p6",
CAST(CAST(ROUND(CAST(e."gmv_SA(1.0)" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sH_Sa1p0",
CAST(CAST(ROUND(CAST(e."gmv_SA(2.0)" AS NUMERIC),6) AS FLOAT) AS NUMERIC)AS "sH_Sa2p0", 
--0.0 AS "sH_MMI",

-- 3.2 Building Damage
-- 3.2.1 Damage State - b0
CAST(CAST(ROUND(CAST(SUM(a."sD_None_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_None_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_None_b0" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_None_b0",

CAST(CAST(ROUND(CAST(SUM(a."sD_Slight_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Slight_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_Slight_b0" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Slight_b0",

CAST(CAST(ROUND(CAST(SUM(a."sD_Moderate_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Moderate_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_Moderate_b0" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Moderate_b0",

CAST(CAST(ROUND(CAST(SUM(a."sD_Extensive_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Extensive_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_Extensive_b0" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Extensive_b0",

CAST(CAST(ROUND(CAST(SUM(a."sD_Complete_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Complete_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_Complete_b0" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Complete_b0",

CAST(CAST(ROUND(CAST(SUM(a."sD_Collapse_b0" * b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Collapse_b0",
CAST(CAST(ROUND(CAST(AVG(a."sD_Collapse_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Collapse_b0",

-- 3.2.1 Damage State - r1
CAST(CAST(ROUND(CAST(SUM(a."sD_None_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_None_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_None_r1" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_None_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Slight_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Slight_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Slight_r1" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Slight_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Moderate_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Moderate_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Moderate_r1" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Moderate_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Extensive_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Extensive_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Extensive_r1" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Extensive_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Complete_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Complete_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Complete_r1" / b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Complete_r1",

CAST(CAST(ROUND(CAST(SUM(a."sD_Collapse_r1" * b.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDt_Collapse_r1",
CAST(CAST(ROUND(CAST(AVG(a."sD_Collapse_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sDtr_Collapse_r1",

-- 3.2.1 Recovery - b0

CAST(CAST(ROUND(CAST(AVG(a."sC_Interruption_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCm_Interruption_b0",
CAST(CAST(ROUND(CAST(AVG(a."sC_Repair_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCm_Repair_b0",
CAST(CAST(ROUND(CAST(AVG(a."sC_Recovery_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "SCm_Recovery_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisBW_b0" + a."sC_DebrisC_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_DebrisTotal_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisBW_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_DebrisBW_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DebrisC_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_DebrisCS_b0",

-- 3.2.1 Recovery - r1
CAST(CAST(ROUND(CAST(AVG(a."sC_Interruption_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCm_Interruption_r1",
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
CAST(CAST(ROUND(CAST(COALESCE(AVG(a."sC_DisplRes_90_b0")/NULLIF(AVG(b.night),0),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCr_Res90_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_180_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res180_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_360_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res360_b0",

CAST(CAST(ROUND(CAST(k."sCt_DisplHshld_b0" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Hshld_b0",

CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_30_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl30_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_90_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl90_b0",
CAST(CAST(ROUND(CAST(COALESCE(AVG(a."sC_DisrupEmpl_90_b0")/NULLIF(AVG(b.day),0),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCr_Empl90_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_180_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl180_b0",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_360_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl360_b0",

-- 3.3.2 Social Disruption - r1
CAST(CAST(ROUND(CAST(k."sCt_Shelter_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Shelter_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_3_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res3_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_30_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res30_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_90_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res90_r1",
CAST(CAST(ROUND(CAST(COALESCE(AVG(a."sC_DisplRes_90_r1")/NULLIF(AVG(b.night),0),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCr_Res90_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_180_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res180_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisplRes_360_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Res360_r1",

CAST(CAST(ROUND(CAST(k."sCt_DisplHshld_r1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Hshld_r1",

CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_30_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl30_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_90_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl90_r1",
CAST(CAST(ROUND(CAST(COALESCE(AVG(a."sC_DisrupEmpl_90_r1")/NULLIF(AVG(b.day),0),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCr_Empl90_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_180_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl180_r1",
CAST(CAST(ROUND(CAST(SUM(a."sC_DisrupEmpl_360_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sCt_Empl360_r1",

-- 3.4 Economic Security
-- 3.4.1 Economic Loss - b0
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_b0" + a."sL_NStr_b0" + a."sL_Cont_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Asset_b0",
CAST(CAST(ROUND(CAST(COALESCE(AVG((a."sL_Str_b0" + a."sL_NStr_b0" + a."sL_Cont_b0")/(NULLIF((b.structural + b.nonstructural + b.contents),0))),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLm_Asset_b0",
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_b0" + a."sL_NStr_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Bldg_b0",
CAST(CAST(ROUND(CAST(COALESCE(AVG((a."sL_Str_b0" + a."sL_NStr_b0")/(NULLIF((b.structural + b.nonstructural),0))),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmr_Bldg_b0",
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Str_b0",
CAST(CAST(ROUND(CAST(SUM(a."sL_NStr_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_NStr_b0",
CAST(CAST(ROUND(CAST(SUM(a."sL_Cont_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Cont_b0",

-- 3.4.1 Economic Loss - r1
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_r1" + a."sL_NStr_r1" + a."sL_Cont_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Asset_r1",
CAST(CAST(ROUND(CAST(COALESCE(AVG((a."sL_Str_r1" + a."sL_NStr_r1" + a."sL_Cont_r1")/(NULLIF((b.structural + b.nonstructural + b.contents),0))),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLm_Asset_r1",
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_r1" + a."sL_NStr_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Bldg_r1",
CAST(CAST(ROUND(CAST(COALESCE(AVG((a."sL_Str_r1" + a."sL_NStr_r1")/(NULLIF((b.structural + b.nonstructural),0))),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLmr_Bldg_r1",
CAST(CAST(ROUND(CAST(SUM(a."sL_Str_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Str_r1",
CAST(CAST(ROUND(CAST(SUM(a."sL_NStr_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_NStr_r1",
CAST(CAST(ROUND(CAST(SUM(a."sL_Cont_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLt_Cont_r1",

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
--b.landuse,
i.geom AS "geom_poly"

FROM dsra.dsra_{eqScenario} a
LEFT JOIN exposure.canada_exposure b ON a."AssetID" = b.id 
LEFT JOIN vs30.vs30_can_site_model_xref d ON a."AssetID" = d.id
LEFT JOIN gmf.shakemap_{eqScenario}_xref e ON b.id = e.id
LEFT JOIN ruptures.rupture_table f ON f.rupture_name = a."Rupture_Abbr"
LEFT JOIN boundaries."Geometry_SAUID" i ON b.sauid = i."SAUIDt"
LEFT JOIN results_dsra_{eqScenario}.{eqScenario}_shelter k ON b.sauid = k."Sauid"
JOIN gmf.shakemap_scenario_extents_temp l ON ST_Intersects(b.geom,l.geom) WHERE l.scenario = '{eqScenario}'
--WHERE e."gmv_SA(0.3)" >=0.02
GROUP BY a."Rupture_Abbr",a."gmpe_Model",b.sauid,d.vs30,d.z1pt0,d.z2pt5,f.source_type,
f.magnitude,f.lon,f.lat,f.depth,f.rake,e."gmv_pga",e."gmv_SA(0.1)",e."gmv_SA(0.2)",e."gmv_SA(0.3)",e."gmv_SA(0.5)",e."gmv_SA(0.6)",e."gmv_SA(1.0)",e."gmv_SA(2.0)",
i."PRUID",i."PRNAME",i."ERUID",i."ERNAME",i."CDUID",i."CDNAME",i."CSDUID",i."CSDNAME",i."CFSAUID",i."DAUIDt",i."SACCODE",i."SACTYPE",k."sCt_DisplHshld_b0",k."sCt_DisplHshld_r1",k."sCt_Shelter_b0",k."sCt_Shelter_r1",i.geom;



-- aggregate to CSD level
DROP VIEW IF EXISTS results_dsra_{eqScenario}.dsra_{eqScenario}_indicators_csd CASCADE;
CREATE VIEW results_dsra_{eqScenario}.dsra_{eqScenario}_indicators_csd AS 

SELECT
a.csduid,
a.csdname,
a."sH_RupName",
a."sH_Source",
a."sH_Mag",
a."sH_HypoLon",
a."sH_HypoLat",
a."sH_HypoDepth",
a."sH_Rake",
a."sH_GMPE",
ROUND(AVG(a."sH_Vs30"),6) AS "sH_Vs30",
ROUND(AVG(a."sH_z1p0"),6) AS "sH_z1p0",
ROUND(AVG(a."sH_z2p5"),6) AS "sH_z2p5",
ROUND(AVG(a."sH_PGA"),6) AS "sH_PGA",
ROUND(AVG(a."sH_Sa0p1"),6) AS "sH_Sa0p1",
ROUND(AVG(a."sH_Sa0p2"),6) AS "sH_Sa0p2",
ROUND(AVG(a."sH_Sa0p3"),6) AS "sH_Sa0p3",
ROUND(AVG(a."sH_Sa0p5"),6) AS "sH_Sa0p5",
ROUND(AVG(a."sH_Sa0p6"),6) AS "sH_Sa0p6",
ROUND(AVG(a."sH_Sa1p0"),6) AS "sH_Sa1p0",
ROUND(AVG(a."sH_Sa2p0"),6) AS "sH_Sa2p0",
--a."sH_MMI",

ROUND(SUM(a."sDt_None_b0"),6) AS "sDt_None_b0",
ROUND(AVG(a."sDtr_None_b0"),6) AS "sDtr_None_b0",
ROUND(SUM(a."sDt_Slight_b0"),6) AS "sDt_Slight_b0",
ROUND(AVG(a."sDtr_Slight_b0"),6) AS "sDtr_Slight_b0",
ROUND(SUM(a."sDt_Moderate_b0"),6) AS "sDt_Moderate_b0",
ROUND(AVG(a."sDtr_Moderate_b0"),6) AS "sDtr_Moderate_b0",
ROUND(SUM(a."sDt_Extensive_b0"),6) AS "sDt_Extensive_b0",
ROUND(AVG(a."sDtr_Extensive_b0"),6) AS "sDtr_Extensive_b0",
ROUND(SUM(a."sDt_Complete_b0"),6) AS "sDt_Complete_b0",
ROUND(AVG(a."sDtr_Complete_b0"),6) AS "sDtr_Complete_b0",
ROUND(SUM(a."sDt_Collapse_b0"),6) AS "sDt_Collapse_b0",
ROUND(AVG(a."sDtr_Collapse_b0"),6) AS "sDtr_Collapse_b0",

ROUND(SUM(a."sDt_None_r1"),6) AS "sDt_None_r1",
ROUND(AVG(a."sDtr_None_r1"),6) AS "sDtr_None_r1",
ROUND(SUM(a."sDt_Slight_r1"),6) AS "sDt_Slight_r1",
ROUND(AVG(a."sDtr_Slight_r1"),6) AS "sDtr_Slight_r1",
ROUND(SUM(a."sDt_Moderate_r1"),6) AS "sDt_Moderate_r1",
ROUND(AVG(a."sDtr_Moderate_r1"),6) AS "sDtr_Moderate_r1",
ROUND(SUM(a."sDt_Extensive_r1"),6) AS "sDt_Extensive_r1",
ROUND(AVG(a."sDtr_Extensive_r1"),6) AS "sDtr_Extensive_r1",
ROUND(SUM(a."sDt_Complete_r1"),6) AS "sDt_Complete_r1",
ROUND(AVG(a."sDtr_Complete_r1"),6) AS "sDtr_Complete_r1",
ROUND(SUM(a."sDt_Collapse_r1"),6) AS "sDt_Collapse_r1",
ROUND(AVG(a."sDtr_Collapse_r1"),6) AS "sDtr_Collapse_r1",

ROUND(AVG(a."sCm_Interruption_b0"),6) AS "sCm_Interruption_b0",
ROUND(AVG(a."sCm_Repair_b0"),6) AS "sCm_Repair_b0",
ROUND(AVG(a."SCm_Recovery_b0"),6) AS "SCm_Recovery_b0",
ROUND(SUM(a."sCt_DebrisTotal_b0"),6) AS "sCt_DebrisTotal_b0" ,
ROUND(SUM(a."sCt_DebrisBW_b0"),6) AS "sCt_DebrisBW_b0",
ROUND(SUM(a."sCt_DebrisCS_b0"),6) AS "sCt_DebrisCS_b0",

ROUND(AVG(a."sCm_Interruption_r1"),6) AS "sCm_Interruption_r1",
ROUND(AVG(a."sCm_Repair_r1"),6) AS "sCm_Repair_r1",
ROUND(AVG(a."SCm_Recovery_r1"),6) AS "SCm_Recovery_r1",
ROUND(SUM(a."sCt_DebrisTotal_r1"),6) AS "sCt_DebrisTotal_r1" ,
ROUND(SUM(a."sCt_DebrisBW_r1"),6) AS "sCt_DebrisBW_r1",
ROUND(SUM(a."sCt_DebrisCS_r1"),6) AS "sCt_DebrisCS_r1",

ROUND(SUM(a."sCt_CasDayL1_b0"),6) AS "sCt_CasDayL1_b0",
ROUND(SUM(a."sCt_CasDayL2_b0"),6) AS "sCt_CasDayL2_b0",
ROUND(SUM(a."sCt_CasDayL3_b0"),6) AS "sCt_CasDayL3_b0",
ROUND(SUM(a."sCt_CasDayL4_b0"),6) AS "sCt_CasDayL4_b0",
ROUND(SUM(a."sCt_CasNightL1_b0"),6) AS "sCt_CasNightL1_b0",
ROUND(SUM(a."sCt_CasNightL2_b0"),6) AS "sCt_CasNightL2_b0",
ROUND(SUM(a."sCt_CasNightL3_b0"),6) AS "sCt_CasNightL3_b0",
ROUND(SUM(a."sCt_CasNightL4_b0"),6) AS "sCt_CasNightL4_b0",
ROUND(SUM(a."sCt_CasTransitL1_b0"),6) AS "sCt_CasTransitL1_b0",
ROUND(SUM(a."sCt_CasTransitL2_b0"),6) AS "sCt_CasTransitL2_b0",
ROUND(SUM(a."sCt_CasTransitL3_b0"),6) AS "sCt_CasTransitL3_b0",
ROUND(SUM(a."sCt_CasTransitL4_b0"),6) AS "sCt_CasTransitL4_b0",

ROUND(SUM(a."sCt_CasDayL1_r1"),6) AS "sCt_CasDayL1_r1",
ROUND(SUM(a."sCt_CasDayL2_r1"),6) AS "sCt_CasDayL2_r1",
ROUND(SUM(a."sCt_CasDayL3_r1"),6) AS "sCt_CasDayL3_r1",
ROUND(SUM(a."sCt_CasDayL4_r1"),6) AS "sCt_CasDayL4_r1",
ROUND(SUM(a."sCt_CasNightL1_r1"),6) AS "sCt_CasNightL1_r1",
ROUND(SUM(a."sCt_CasNightL2_r1"),6) AS "sCt_CasNightL2_r1",
ROUND(SUM(a."sCt_CasNightL3_r1"),6) AS "sCt_CasNightL3_r1",
ROUND(SUM(a."sCt_CasNightL4_r1"),6) AS "sCt_CasNightL4_r1",
ROUND(SUM(a."sCt_CasTransitL1_r1"),6) AS "sCt_CasTransitL1_r1",
ROUND(SUM(a."sCt_CasTransitL2_r1"),6) AS "sCt_CasTransitL2_r1",
ROUND(SUM(a."sCt_CasTransitL3_r1"),6) AS "sCt_CasTransitL3_r1",
ROUND(SUM(a."sCt_CasTransitL4_r1"),6) AS "sCt_CasTransitL4_r1",

ROUND(SUM(a."sCt_Shelter_b0"),6) AS "sCt_Shelter_b0",
ROUND(SUM(a."sCt_Res3_b0"),6) AS "sCt_Res3_b0",
ROUND(SUM(a."sCt_Res30_b0"),6) AS "sCt_Res30_b0",
ROUND(SUM(a."sCt_Res90_b0"),6) AS "sCt_Res90_b0",
ROUND(SUM(a."sCt_Res180_b0"),6) AS "sCt_Res180_b0",
ROUND(SUM(a."sCt_Res360_b0"),6) AS "sCt_Res360_b0",
ROUND(SUM(a."sCt_Hshld_b0"),6) AS "sCt_Hshld_b0",
ROUND(SUM(a."sCt_Empl30_b0"),6) AS "sCt_Empl30_b0",
ROUND(SUM(a."sCt_Empl90_b0"),6) AS "sCt_Empl90_b0",
ROUND(AVG(a."sCr_Empl90_b0"),6) AS "sCr_Empl90_b0",
ROUND(SUM(a."sCt_Empl180_b0"),6) AS "sCt_Empl180_b0",
ROUND(SUM(a."sCt_Empl360_b0"),6) AS "sCt_Empl360_b0",

ROUND(SUM(a."sCt_Shelter_r1"),6) AS "sCt_Shelter_r1",
ROUND(SUM(a."sCt_Res3_r1"),6) AS "sCt_Res3_r1",
ROUND(SUM(a."sCt_Res30_r1"),6) AS "sCt_Res30_r1",
ROUND(SUM(a."sCt_Res90_r1"),6) AS "sCt_Res90_r1",
ROUND(SUM(a."sCt_Res180_r1"),6) AS "sCt_Res180_r1",
ROUND(SUM(a."sCt_Res360_r1"),6) AS "sCt_Res360_r1",
ROUND(SUM(a."sCt_Hshld_r1"),6) AS "sCt_Hshld_r1",
ROUND(SUM(a."sCt_Empl30_r1"),6) AS "sCt_Empl30_r1",
ROUND(SUM(a."sCt_Empl90_r1"),6) AS "sCt_Empl90_r1",
ROUND(AVG(a."sCr_Empl90_r1"),6) AS "sCr_Empl90_r1",
ROUND(SUM(a."sCt_Empl180_r1"),6) AS "sCt_Empl180_r1",
ROUND(SUM(a."sCt_Empl360_r1"),6) AS "sCt_Empl360_r1",

ROUND(SUM(a."sLt_Asset_b0"),6) AS "sLt_Asset_b0",
ROUND(AVG(a."sLm_Asset_b0"),6) AS "sLm_Asset_b0",
ROUND(SUM(a."sLt_Bldg_b0"),6) AS "sLt_Bldg_b0",
ROUND(AVG(a."sLmr_Bldg_b0"),6) AS "sLmr_Bldg_b0",
ROUND(SUM(a."sLt_Str_b0"),6) AS "sLt_Str_b0",
ROUND(SUM(a."sLt_NStr_b0"),6) AS "sLt_NStr_b0",
ROUND(SUM(a."sLt_Cont_b0"),6) AS "sLt_Cont_b0",

ROUND(SUM(a."sLt_Asset_r1"),6) AS "sLt_Asset_r1",
ROUND(AVG(a."sLm_Asset_r1"),6) AS "sLm_Asset_r1",
ROUND(SUM(a."sLt_Bldg_r1"),6) AS "sLt_Bldg_r1",
ROUND(AVG(a."sLmr_Bldg_r1"),6) AS "sLmr_Bldg_r1",
ROUND(SUM(a."sLt_Str_r1"),6) AS "sLt_Str_r1",
ROUND(SUM(a."sLt_NStr_r1"),6) AS "sLt_NStr_r1",
ROUND(SUM(a."sLt_Cont_r1"),6) AS "sLt_Cont_r1",

b.geom

FROM results_dsra_{eqScenario}.dsra_{eqScenario}_indicators_s a
LEFT JOIN boundaries."Geometry_CSDUID" b ON a.csduid = b."CSDUID"
GROUP BY a.csduid,a.csdname,a."sH_RupName",a."sH_Source",a."sH_Mag",a."sH_HypoLon",a."sH_HypoLat",a."sH_HypoDepth",a."sH_Rake",a."sH_GMPE",
b.geom;
-- GROUP BY a.csduid,a.csdname,a."sH_RupName",a."sH_Source",a."sH_Mag",a."sH_MMI",a."sH_HypoLon",a."sH_HypoLat",a."sH_HypoDepth",a."sH_Rake",a."sH_GMPE",
-- b.geom;