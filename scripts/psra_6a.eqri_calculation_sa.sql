-- script to test new PSRA calculation

-- SA level
-- sri calc table 1
DROP TABLE IF EXISTS results_psra_national.psra_sri_calc1_sa CASCADE;
CREATE TABLE results_psra_national.psra_sri_calc1_sa AS
(
SELECT
b."Sauid",

-- exposure
a."E_CensusPop",
a."Et_PopNight",
a."Et_PopTransit",
a."Et_BldgNum",
a."Et_AssetValue",

-- EQ Risk b0
b."eCt_Fatality_b0",
b."eCtr_Fatality_b0",
b."eAALt_Asset_b0",
b."eAALm_Asset_b0",
b."eAALt_Bldg_b0",
b."eAALm_Bldg_b0",
b."eAALt_Str_b0",
b."eAALt_NStr_b0",
b."eAALt_Cont_b0",

-- EQ Risk r1
b."eCt_Fatality_r1",
b."eCtr_Fatality_r1",
b."eAALt_Asset_r1",
b."eAALm_Asset_r1",
b."eAALt_Bldg_r1",
b."eAALm_Bldg_r1",
b."eAALt_Str_r1",
b."eAALt_NStr_r1",
b."eAALt_Cont_r1",

-- sovi
c."SVlt_Score",
CASE
	WHEN (c."SVlt_Score"/(SELECT MAX("SVlt_Score") FROM results_nhsl_social_fabric.nhsl_social_fabric_indicators_s))*100 > 0 THEN 
	(c."SVlt_Score"/(SELECT MAX("SVlt_Score") FROM results_nhsl_social_fabric.nhsl_social_fabric_indicators_s))*100
	WHEN (c."SVlt_Score"/(SELECT MAX("SVlt_Score") FROM results_nhsl_social_fabric.nhsl_social_fabric_indicators_s))*100 = 0 THEN 0.0001 END AS "SVlt_Score_minmax",
--(c."SVlt_Score"/(SELECT MAX("SVlt_Score") FROM results_nhsl_social_fabric.nhsl_social_fabric_indicators_s))*100 AS "SVlt_Score_minmax",

-- eqri abs b0
b."eAALt_Asset_b0" AS "AAL_b0",
b."eCt_Fatality_b0" AS "AAF_b0",
b."eCt_Fatality_b0" * 7982324 AS "AAF_VSL_b0",
b."eAALt_Asset_b0" + (b."eCt_Fatality_b0" * 7982324) AS "TotalLosses_b0",

-- eqri abs R1
b."eAALt_Asset_r1" AS "AAL_r1",
b."eCt_Fatality_r1" AS "AAF_r1",
b."eCt_Fatality_r1" * 7982324 AS "AAF_VSL_r1",
b."eAALt_Asset_r1" + (b."eCt_Fatality_r1" * 7982324) AS "TotalLosses_r1",

-- erqi norm b0
b."eAALm_Asset_b0" AS "AAL_Ratio_b0",
b."eCtr_Fatality_b0" AS "AAF_Ratio_b0",

-- erqi norm r1
b."eAALm_Asset_r1" AS "AAL_Ratio_r1",
b."eCtr_Fatality_r1" AS "AAF_Ratio_r1"

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s a
RIGHT JOIN results_psra_national.psra_indicators_s_tbl b ON a."Sauid" = b."Sauid"
LEFT JOIN results_nhsl_social_fabric.nhsl_social_fabric_indicators_s c ON a."Sauid" = c."Sauid"
);



-- sri calc table 2
DROP TABLE IF EXISTS results_psra_national.psra_sri_calc2_sa CASCADE;
CREATE TABLE results_psra_national.psra_sri_calc2_sa AS
(
SELECT 
"Sauid",
"TotalLosses_b0"/(SELECT MAX("TotalLosses_b0") FROM results_psra_national.psra_sri_calc1_sa) AS "Totallosses_minmax_b0",
"SVlt_Score_minmax" * ("TotalLosses_b0"/(SELECT MAX("TotalLosses_b0") FROM results_psra_national.psra_sri_calc1_sa)*100) AS "eqri_abs_b0",
("SVlt_Score_minmax" * ("TotalLosses_b0"/(SELECT MAX("TotalLosses_b0") FROM results_psra_national.psra_sri_calc1_sa)*100))^(0.333333) AS "eqri_abs_cbrt_b0",
"TotalLosses_b0"/("Et_AssetValue" + ("Et_PopTransit" * 7982324)) AS "TotalLosses_Ratio_b0",

"TotalLosses_b0"/(SELECT MAX("TotalLosses_r1") FROM results_psra_national.psra_sri_calc1_sa) AS "Totallosses_minmax_r1",
"SVlt_Score_minmax" * ("TotalLosses_r1"/(SELECT MAX("TotalLosses_r1") FROM results_psra_national.psra_sri_calc1_sa)*100) AS "eqri_abs_r1",
("SVlt_Score_minmax" * ("TotalLosses_r1"/(SELECT MAX("TotalLosses_r1") FROM results_psra_national.psra_sri_calc1_sa)*100))^(0.333333) AS "eqri_abs_cbrt_r1",
"TotalLosses_r1"/("Et_AssetValue" + ("Et_PopTransit" * 7982324)) AS "TotalLosses_Ratio_r1"

FROM results_psra_national.psra_sri_calc1_sa 
);



-- sri calc table 3
DROP TABLE IF EXISTS results_psra_national.psra_sri_calc3_sa CASCADE;
CREATE TABLE results_psra_national.psra_sri_calc3_sa AS
(
SELECT
a."Sauid",
(a.eqri_abs_cbrt_b0/(SELECT MAX(eqri_abs_cbrt_b0) FROM results_psra_national.psra_sri_calc2_sa)*100) AS "eqri_abs_cbrt_minmax_b0",
(a."TotalLosses_Ratio_b0"/(SELECT MAX("TotalLosses_Ratio_b0") FROM results_psra_national.psra_sri_calc2_sa)*100) AS "TotalLosses_Ratio_minmax_b0",
(a."TotalLosses_Ratio_b0"/(SELECT MAX("TotalLosses_Ratio_b0") FROM results_psra_national.psra_sri_calc2_sa)*100)* b."SVlt_Score_minmax" AS "eqri_norm_b0",
((a."TotalLosses_Ratio_b0"/(SELECT MAX("TotalLosses_Ratio_b0") FROM results_psra_national.psra_sri_calc2_sa)*100)* b."SVlt_Score_minmax")^(0.333333) AS "eqri_norm_cbrt_b0",

(a.eqri_abs_cbrt_r1/(SELECT MAX(eqri_abs_cbrt_r1) FROM results_psra_national.psra_sri_calc2_sa)*100) AS "eqri_abs_cbrt_minmax_r1",
(a."TotalLosses_Ratio_r1"/(SELECT MAX("TotalLosses_Ratio_r1") FROM results_psra_national.psra_sri_calc2_sa)*100) AS "TotalLosses_Ratio_minmax_r1",
(a."TotalLosses_Ratio_r1"/(SELECT MAX("TotalLosses_Ratio_r1") FROM results_psra_national.psra_sri_calc2_sa)*100)* b."SVlt_Score_minmax" AS "eqri_norm_r1",
((a."TotalLosses_Ratio_r1"/(SELECT MAX("TotalLosses_Ratio_r1") FROM results_psra_national.psra_sri_calc2_sa)*100)* b."SVlt_Score_minmax")^(0.333333) AS "eqri_norm_cbrt_r1"

FROM results_psra_national.psra_sri_calc2_sa a
LEFT JOIN results_psra_national.psra_sri_calc1_sa b  ON a."Sauid" = b."Sauid"
);



-- sri calc table 4
DROP TABLE IF EXISTS results_psra_national.psra_sri_calc4_sa CASCADE;
CREATE TABLE results_psra_national.psra_sri_calc4_sa AS
(
SELECT
"Sauid",
(eqri_norm_cbrt_b0/(SELECT MAX(eqri_norm_cbrt_b0) FROM results_psra_national.psra_sri_calc3_sa)*100) AS "eqri_norm_cbrt_minmax_b0",
(eqri_norm_cbrt_r1/(SELECT MAX(eqri_norm_cbrt_r1) FROM results_psra_national.psra_sri_calc3_sa)*100) AS "eqri_norm_cbrt_minmax_r1"

FROM results_psra_national.psra_sri_calc3_sa
);



-- sri calc table final
DROP TABLE IF EXISTS results_psra_national.psra_sri_calc_sa CASCADE;
CREATE TABLE results_psra_national.psra_sri_calc_sa AS
(
SELECT
a."Sauid",

-- exposure
a."E_CensusPop",
a."Et_PopNight",
a."Et_PopTransit",
a."Et_BldgNum",
a."Et_AssetValue",

-- sovi
a."SVlt_Score",
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
	WHEN c.eqri_abs_cbrt_minmax_b0 >= 0 AND c.eqri_abs_cbrt_minmax_b0 <= 3.12 THEN 'Very Low Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 3.12 AND c.eqri_abs_cbrt_minmax_b0 <= 8.70 THEN 'Low Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 8.70 AND c.eqri_abs_cbrt_minmax_b0 <= 17.61 THEN 'Moderate Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 17.61 AND c.eqri_abs_cbrt_minmax_b0 <= 30.99 THEN 'High Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 30.99 AND c.eqri_abs_cbrt_minmax_b0 <= 100 THEN 'Very High Score'
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
	WHEN d.eqri_norm_cbrt_minmax_b0 >= 0 AND d.eqri_norm_cbrt_minmax_b0 <= 2.55 THEN 'Very Low Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 2.55 AND d.eqri_norm_cbrt_minmax_b0 <= 6.69 THEN 'Relatively Low Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 6.69 AND d.eqri_norm_cbrt_minmax_b0 <= 11.31 THEN 'Relatively Moderate Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 11.31 AND d.eqri_norm_cbrt_minmax_b0 <= 19.67 THEN 'Relatively High Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 19.67 AND d.eqri_norm_cbrt_minmax_b0 <= 100 THEN 'Very High Score'
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
	WHEN c.eqri_abs_cbrt_minmax_r1 >= 0 AND c.eqri_abs_cbrt_minmax_r1 <= 2.94 THEN 'Very Low Score'
	WHEN c.eqri_abs_cbrt_minmax_r1 > 2.94 AND c.eqri_abs_cbrt_minmax_r1 <= 8.40 THEN 'Low Score'
	WHEN c.eqri_abs_cbrt_minmax_r1 > 8.40 AND c.eqri_abs_cbrt_minmax_r1 <= 17.31 THEN 'Moderate Score'
	WHEN c.eqri_abs_cbrt_minmax_r1 > 17.31 AND c.eqri_abs_cbrt_minmax_r1 <= 31.39 THEN 'High Score'
	WHEN c.eqri_abs_cbrt_minmax_r1 > 31.39 AND c.eqri_abs_cbrt_minmax_r1 <= 100 THEN 'Very High Score'
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
	WHEN d.eqri_norm_cbrt_minmax_r1 >= 0 AND d.eqri_norm_cbrt_minmax_r1 <= 2.30 THEN 'Very Low Score'
	WHEN d.eqri_norm_cbrt_minmax_r1 > 2.30 AND d.eqri_norm_cbrt_minmax_r1 <= 6.28 THEN 'Relatively Low Score'
	WHEN d.eqri_norm_cbrt_minmax_r1 > 6.28 AND d.eqri_norm_cbrt_minmax_r1 <= 11.41 THEN 'Relatively Moderate Score'
	WHEN d.eqri_norm_cbrt_minmax_r1 > 11.41 AND d.eqri_norm_cbrt_minmax_r1 <= 21.23 THEN 'Relatively High Score'
	WHEN d.eqri_norm_cbrt_minmax_r1 > 21.23 AND d.eqri_norm_cbrt_minmax_r1 <= 100 THEN 'Very High Score'
END AS "eqri_norm_rating_r1"
-- e.geom

FROM results_psra_national.psra_sri_calc1_sa a
LEFT JOIN results_psra_national.psra_sri_calc2_sa b ON a."Sauid" = b."Sauid"
LEFT JOIN results_psra_national.psra_sri_calc3_sa c ON a."Sauid" = c."Sauid"
LEFT JOIN results_psra_national.psra_sri_calc4_sa d ON a."Sauid" = d."Sauid"
-- LEFT JOIN boundaries."Geometry_SAUID" e ON a."Sauid" = e."SAUIDt"
);

DROP TABLE IF EXISTS results_psra_national.psra_sri_calc1_sa, results_psra_national.psra_sri_calc2_sa, results_psra_national.psra_sri_calc3_sa, results_psra_national.psra_sri_calc4_sa CASCADE;