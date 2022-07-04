-- script to test new PSRA calculation
-- CSD level

-- calculate social fabric csd aggregation
DROP TABLE IF EXISTS results_psra_national.psra_sri_social_fabric_score_csd CASCADE;
CREATE TABLE results_psra_national.psra_sri_social_fabric_score_csd AS
(
SELECT
csduid,
AVG("SVlt_Score") AS "SVlt_Score"
FROM results_nhsl_social_fabric.nhsl_social_fabric_indicators_s
GROUP BY csduid
);


-- sri calc table 1
DROP TABLE IF EXISTS results_psra_national.psra_sri_calc1_csd CASCADE;
CREATE TABLE results_psra_national.psra_sri_calc1_csd AS
(
SELECT
a.csduid,

-- exposure
SUM(a."E_CensusPop") AS "E_CensusPop",
SUM(a."Et_PopNight") AS "Et_PopNight",
SUM(a."Et_PopTransit") AS "Et_PopTransit",
SUM(a."Et_BldgNum") AS "Et_BldgNum",
SUM(a."Et_AssetValue") AS "Et_AssetValue",

-- EQ Risk b0
SUM(b."eCt_Fatality_b0") AS "eCt_Fatality_b0",
AVG(b."eCtr_Fatality_b0") AS "eCtr_Fatality_b0",
SUM(b."eAALt_Asset_b0") AS "eAALt_Asset_b0",
AVG(b."eAALm_Asset_b0") AS "eAALm_Asset_b0",
SUM(b."eAALt_Bldg_b0") AS "eAALt_Bldg_b0",
AVG(b."eAALm_Bldg_b0") AS "eAALm_Bldg_b0",
SUM(b."eAALt_Str_b0") AS "eAALt_Str_b0",
SUM(b."eAALt_NStr_b0") AS "eAALt_NStr_b0",
SUM(b."eAALt_Cont_b0") AS "eAALt_Cont_b0",

-- EQ Risk r1
SUM(b."eCt_Fatality_r1") AS "eCt_Fatality_r1",
AVG(b."eCtr_Fatality_r1") AS "eCtr_Fatality_r1",
SUM(b."eAALt_Asset_r1") AS "eAALt_Asset_r1",
AVG(b."eAALm_Asset_r1") AS "eAALm_Asset_r1",
SUM(b."eAALt_Bldg_r1") AS "eAALt_Bldg_r1",
AVG(b."eAALm_Bldg_r1") AS "eAALm_Bldg_r1",
SUM(b."eAALt_Str_r1") AS "eAALt_Str_r1",
SUM(b."eAALt_NStr_r1") AS "eAALt_NStr_r1",
SUM("eAALt_Cont_r1") AS "eAALt_Cont_r1",

-- sovi
AVG(c."SVlt_Score") AS "SVlt_Score_avg",
CASE
	WHEN (AVG(c."SVlt_Score")/(SELECT MAX("SVlt_Score") FROM results_psra_national.psra_sri_social_fabric_score_csd))*100 > 0 THEN
	(AVG(c."SVlt_Score")/(SELECT MAX("SVlt_Score") FROM results_psra_national.psra_sri_social_fabric_score_csd))*100
	WHEN (AVG(c."SVlt_Score")/(SELECT MAX("SVlt_Score") FROM results_psra_national.psra_sri_social_fabric_score_csd))*100 = 0 THEN 0.0001 END AS "SVlt_Score_minmax",
--(AVG(c."SVlt_Score")/(SELECT MAX("SVlt_Score") FROM results_psra_national.psra_sri_social_fabric_score_csd))*100 AS "SVlt_Score_minmax",

-- eqri abs b0
SUM(b."eAALt_Asset_b0") AS "AAL_b0",
SUM(b."eCt_Fatality_b0") AS "AAF_b0",
SUM(b."eCt_Fatality_b0") * 7982324 AS "AAF_VSL_b0",
SUM(b."eAALt_Asset_b0") + (SUM(b."eCt_Fatality_b0") * 7982324) AS "TotalLosses_b0",

-- eqri abs R1
SUM(b."eAALt_Asset_r1") AS "AAL_r1",
SUM(b."eCt_Fatality_r1") AS "AAF_r1",
SUM(b."eCt_Fatality_r1") * 7982324 AS "AAF_VSL_r1",
SUM(b."eAALt_Asset_r1") + (SUM(b."eCt_Fatality_r1") * 7982324) AS "TotalLosses_r1",

-- erqi norm b0
AVG(b."eAALm_Asset_b0") AS "AAL_Ratio_b0",
AVG(b."eCtr_Fatality_b0") AS "AAF_Ratio_b0",

-- erqi norm r1
AVG(b."eAALm_Asset_r1") AS "AAL_Ratio_r1",
AVG(b."eCtr_Fatality_r1") AS "AAF_Ratio_r1"

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s a
RIGHT JOIN results_psra_national.psra_indicators_s_tbl b ON a."Sauid" = b."Sauid"
LEFT JOIN results_nhsl_social_fabric.nhsl_social_fabric_indicators_s c ON a."Sauid" = c."Sauid"
-- WHERE a.csduid ='2466023'
GROUP BY a.csduid
);



-- sri calc table 2
DROP TABLE IF EXISTS results_psra_national.psra_sri_calc2_csd CASCADE;
CREATE TABLE results_psra_national.psra_sri_calc2_csd AS
(
SELECT 
"csduid",
"TotalLosses_b0"/(SELECT MAX("TotalLosses_b0") FROM results_psra_national.psra_sri_calc1_csd) AS "Totallosses_minmax_b0",
"SVlt_Score_minmax" * ("TotalLosses_b0"/(SELECT MAX("TotalLosses_b0") FROM results_psra_national.psra_sri_calc1_csd)*100) AS "eqri_abs_b0",
("SVlt_Score_minmax" * ("TotalLosses_b0"/(SELECT MAX("TotalLosses_b0") FROM results_psra_national.psra_sri_calc1_csd)*100))^(0.333333) AS "eqri_abs_cbrt_b0",
"TotalLosses_b0"/("Et_AssetValue" + ("Et_PopTransit" * 7982324)) AS "TotalLosses_Ratio_b0",

"TotalLosses_b0"/(SELECT MAX("TotalLosses_r1") FROM results_psra_national.psra_sri_calc1_csd) AS "Totallosses_minmax_r1",
"SVlt_Score_minmax" * ("TotalLosses_r1"/(SELECT MAX("TotalLosses_r1") FROM results_psra_national.psra_sri_calc1_csd)*100) AS "eqri_abs_r1",
("SVlt_Score_minmax" * ("TotalLosses_r1"/(SELECT MAX("TotalLosses_r1") FROM results_psra_national.psra_sri_calc1_csd)*100))^(0.333333) AS "eqri_abs_cbrt_r1",
"TotalLosses_r1"/("Et_AssetValue" + ("Et_PopTransit" * 7982324)) AS "TotalLosses_Ratio_r1"

FROM results_psra_national.psra_sri_calc1_csd 
);



-- sri calc table 3
DROP TABLE IF EXISTS results_psra_national.psra_sri_calc3_csd CASCADE;
CREATE TABLE results_psra_national.psra_sri_calc3_csd AS
SELECT
a."csduid",
(a.eqri_abs_cbrt_b0/(SELECT MAX(eqri_abs_cbrt_b0) FROM results_psra_national.psra_sri_calc2_csd)*100) AS "eqri_abs_cbrt_minmax_b0",
(a."TotalLosses_Ratio_b0"/(SELECT MAX("TotalLosses_Ratio_b0") FROM results_psra_national.psra_sri_calc2_csd)*100) AS "TotalLosses_Ratio_minmax_b0",
(a."TotalLosses_Ratio_b0"/(SELECT MAX("TotalLosses_Ratio_b0") FROM results_psra_national.psra_sri_calc2_csd)*100)* b."SVlt_Score_minmax" AS "eqri_norm_b0",
((a."TotalLosses_Ratio_b0"/(SELECT MAX("TotalLosses_Ratio_b0") FROM results_psra_national.psra_sri_calc2_csd)*100)* b."SVlt_Score_minmax")^(0.333333) AS "eqri_norm_cbrt_b0",

(a.eqri_abs_cbrt_r1/(SELECT MAX(eqri_abs_cbrt_r1) FROM results_psra_national.psra_sri_calc2_csd)*100) AS "eqri_abs_cbrt_minmax_r1",
(a."TotalLosses_Ratio_r1"/(SELECT MAX("TotalLosses_Ratio_r1") FROM results_psra_national.psra_sri_calc2_csd)*100) AS "TotalLosses_Ratio_minmax_r1",
(a."TotalLosses_Ratio_r1"/(SELECT MAX("TotalLosses_Ratio_r1") FROM results_psra_national.psra_sri_calc2_csd)*100)* b."SVlt_Score_minmax" AS "eqri_norm_r1",
((a."TotalLosses_Ratio_r1"/(SELECT MAX("TotalLosses_Ratio_r1") FROM results_psra_national.psra_sri_calc2_csd)*100)* b."SVlt_Score_minmax")^(0.333333) AS "eqri_norm_cbrt_r1"

FROM results_psra_national.psra_sri_calc2_csd a
LEFT JOIN results_psra_national.psra_sri_calc1_csd b  ON a."csduid" = b."csduid";



-- sri calc table 4
DROP TABLE IF EXISTS results_psra_national.psra_sri_calc4_csd CASCADE;
CREATE TABLE results_psra_national.psra_sri_calc4_csd AS
(
SELECT
"csduid",
(eqri_norm_cbrt_b0/(SELECT MAX(eqri_norm_cbrt_b0) FROM results_psra_national.psra_sri_calc3_csd)*100) AS "eqri_norm_cbrt_minmax_b0",
(eqri_norm_cbrt_r1/(SELECT MAX(eqri_norm_cbrt_r1) FROM results_psra_national.psra_sri_calc3_csd)*100) AS "eqri_norm_cbrt_minmax_r1"

FROM results_psra_national.psra_sri_calc3_csd
);



-- sri calc table final
DROP TABLE IF EXISTS results_psra_national.psra_sri_calc_csd CASCADE;
CREATE TABLE results_psra_national.psra_sri_calc_csd AS
(
SELECT
a."csduid",

-- exposure
a."E_CensusPop",
a."Et_PopNight",
a."Et_PopTransit",
a."Et_BldgNum",
a."Et_AssetValue",

-- sovi
a."SVlt_Score_avg",
a."SVlt_Score_minmax",

-- EQ risk b0
a."eCt_Fatality_b0",
a."eCtr_Fatality_b0",
a."eAALt_Asset_b0",
a."eAALm_Asset_b0",
a."eAALt_Bldg_b0",
a."eAALm_Bldg_b0",
a."eAALt_Str_b0",
a."eAALt_NStr_b0",
a."eAALt_Cont_b0",

-- eqri abs b0
a."AAL_b0",
a."AAF_b0",
a."AAF_VSL_b0",
a."TotalLosses_b0",
b."Totallosses_minmax_b0",
b.eqri_abs_b0,
b.eqri_abs_cbrt_b0,
c.eqri_abs_cbrt_minmax_b0,
CASE
	WHEN c.eqri_abs_cbrt_minmax_b0 >= 0 AND c.eqri_abs_cbrt_minmax_b0 <= 4.26 THEN 'Very Low Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 4.26 AND c.eqri_abs_cbrt_minmax_b0 <= 11.51 THEN 'Low Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 11.51 AND c.eqri_abs_cbrt_minmax_b0 <= 25.31 THEN 'Moderate Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 25.31 AND c.eqri_abs_cbrt_minmax_b0 <= 50.65 THEN 'High Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 50.65 AND c.eqri_abs_cbrt_minmax_b0 <= 100 THEN 'Very High Score'
END AS "eqri_abs_rating_b0",
	
-- eqri norm b0
a."AAL_Ratio_b0",
a."AAF_Ratio_b0",
b."TotalLosses_Ratio_b0",
c."TotalLosses_Ratio_minmax_b0",
c.eqri_norm_b0,
c.eqri_norm_cbrt_b0,
d.eqri_norm_cbrt_minmax_b0,
CASE
	WHEN d.eqri_norm_cbrt_minmax_b0 >= 0 AND d.eqri_norm_cbrt_minmax_b0 <= 4.41 THEN 'Very Low Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 4.41 AND d.eqri_norm_cbrt_minmax_b0 <= 10.37 THEN 'Relatively Low Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 10.37 AND d.eqri_norm_cbrt_minmax_b0 <= 16.85 THEN 'Relatively Moderate Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 16.85 AND d.eqri_norm_cbrt_minmax_b0 <= 29.63 THEN 'Relatively High Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 29.63 AND d.eqri_norm_cbrt_minmax_b0 <= 100 THEN 'Very High Score'
END AS "eqri_norm_rating_b0",
	
-- EQ risk r1
a."eCt_Fatality_r1",
a."eCtr_Fatality_r1",
a."eAALt_Asset_r1",
a."eAALm_Asset_r1",
a."eAALt_Bldg_r1",
a."eAALm_Bldg_r1",
a."eAALt_Str_r1",
a."eAALt_NStr_r1",
a."eAALt_Cont_r1",
	
-- eqri abs r1
a."AAL_r1",
a."AAF_r1",
a."AAF_VSL_r1",
a."TotalLosses_r1",
b."Totallosses_minmax_r1",
b.eqri_abs_r1,
b.eqri_abs_cbrt_r1,
c.eqri_abs_cbrt_minmax_r1,
CASE
	WHEN c.eqri_abs_cbrt_minmax_b0 >= 0 AND c.eqri_abs_cbrt_minmax_b0 <= 4.07 THEN 'Very Low Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 4.07 AND c.eqri_abs_cbrt_minmax_b0 <= 11.42 THEN 'Low Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 11.42 AND c.eqri_abs_cbrt_minmax_b0 <= 25.04 THEN 'Moderate Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 25.04 AND c.eqri_abs_cbrt_minmax_b0 <= 50.23 THEN 'High Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 50.23 AND c.eqri_abs_cbrt_minmax_b0 <= 100 THEN 'Very High Score'
END AS "eqri_abs_rating_r1",
	
-- eqri norm r1
a."AAL_Ratio_r1",
a."AAF_Ratio_r1",
b."TotalLosses_Ratio_r1",
c."TotalLosses_Ratio_minmax_r1",
c.eqri_norm_r1,
c.eqri_norm_cbrt_r1,
d.eqri_norm_cbrt_minmax_r1,
CASE
	WHEN d.eqri_norm_cbrt_minmax_b0 >= 0 AND d.eqri_norm_cbrt_minmax_b0 <= 8.96 THEN 'Very Low Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 8.96 AND d.eqri_norm_cbrt_minmax_b0 <= 15.75 THEN 'Relatively Low Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 15.75 AND d.eqri_norm_cbrt_minmax_b0 <= 28.90 THEN 'Relatively Moderate Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 28.90 AND d.eqri_norm_cbrt_minmax_b0 <= 48.55 THEN 'Relatively High Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 48.55 AND d.eqri_norm_cbrt_minmax_b0 <= 100 THEN 'Very High Score'
END AS "eqri_norm_rating_r1"
--e.geom

FROM results_psra_national.psra_sri_calc1_csd a
LEFT JOIN results_psra_national.psra_sri_calc2_csd b ON a."csduid" = b."csduid"
LEFT JOIN results_psra_national.psra_sri_calc3_csd c ON a."csduid" = c."csduid"
LEFT JOIN results_psra_national.psra_sri_calc4_csd d ON a."csduid" = d."csduid"
-- LEFT JOIN boundaries."Geometry_CSDUID" e ON a."csduid" = e."CSDUID"
);

DROP TABLE IF EXISTS results_psra_national.psra_sri_calc1_csd, results_psra_national.psra_sri_calc2_csd, results_psra_national.psra_sri_calc3_csd, results_psra_national.psra_sri_calc4_csd,
results_psra_national.psra_sri_social_fabric_score_csd CASCADE;