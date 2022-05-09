-- test hexgrid aggregation for psra national level
-- create eqriskindex tables - 1km
DROP TABLE IF EXISTS results_psra_national.psra_eqriskindex_1km_uc CASCADE;

CREATE TABLE results_psra_national.psra_eqriskindex_1km_uc AS 
SELECT 
c.gridid_1,
SUM(a.asset_loss_b0 * b.area_ratio) AS "asset_loss_b0",
SUM(a.asset_loss_r1 * b.area_ratio) AS "asset_loss_r1",
SUM(a.lifeloss_b0 * b.area_ratio) AS "lifeloss_b0",
SUM(a.lifeloss_r1 * b.area_ratio) AS "lifeloss_r1",
SUM(a.lifelosscost_b0 * b.area_ratio) AS "lifelosscost_b0",
SUM(a.lifelosscost_r1 * b.area_ratio) AS "lifelosscost_r1",
AVG(a.bldglossratio_b0 * b.area_ratio) AS "bldglossratio_b0",
AVG(a.bldglossratio_r1 * b.area_ratio) AS "bldglossratio_r1",
AVG(a.lifelossratio_b0 * b.area_ratio) AS "lifelossratio_b0",
AVG(a.lifelossratio_r1 * b.area_ratio) AS "lifelossratio_r1",
AVG(a.lifelossratiocost_b0 * b.area_ratio) AS "lifelossratiocost_b0",
AVG(a.lifelossratiocost_r1 * b.area_ratio) AS "lifelossratiocost_r1",
SUM(a."SVlt_Score_translated" * b.area_ratio) AS "SVlt_Score_translated",
SUM(eqri_abs_score_b0 * b.area_ratio) AS "eqri_abs_score_b0",
'null' AS "eqri_abs_rank_b0",
AVG(eqri_norm_score_b0 * b.area_ratio) AS "eqri_norm_score_b0",
'null' AS "eqri_norm_rank_b0",
SUM(eqri_abs_score_r1 * b.area_ratio) AS "eqri_abs_score_r1",
'null' AS "eqri_abs_rank_r1",
AVG(eqri_norm_score_r1 * b.area_ratio) AS "eqri_norm_score_r1",
'null' AS "eqri_norm_rank_r1"

FROM  results_psra_national.psra_eqriskindex a
LEFT JOIN boundaries."SAUID_HexGrid_1km_intersect_unclipped" b ON a.sauid = b.sauid
LEFT JOIN boundaries."HexGrid_1km_unclipped" c ON b.gridid_1 = c.gridid_1
GROUP BY c.gridid_1,c.geom;

-- normalize norm scores between 0 and 100
UPDATE results_psra_national.psra_eqriskindex_1km_uc
SET eqri_norm_score_b0 = CAST(CAST(ROUND(CAST(((eqri_norm_score_b0 - (SELECT MIN(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_1km_uc)) / ((SELECT MAX(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_1km_uc) - 
(SELECT MIN(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_1km_uc))*100) AS NUMERIC),6) AS FLOAT) AS NUMERIC),
 	eqri_norm_score_r1 = CAST(CAST(ROUND(CAST(((eqri_norm_score_r1 - (SELECT MIN(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_1km_uc)) / ((SELECT MAX(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_1km_uc) - 
	(SELECT MIN(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_1km_uc))*100) AS NUMERIC),6) AS FLOAT) AS NUMERIC);

--create national threshold sauid lookup table for rating - 1km
DROP TABLE IF EXISTS results_psra_national.psra_eqri_thresholds_1km_uc CASCADE;
CREATE TABLE results_psra_national.psra_eqri_thresholds_1km_uc
(
percentile NUMERIC,
abs_score_threshold_b0 FLOAT DEFAULT 0,
abs_score_threshold_r1 FLOAT DEFAULT 0, 
norm_score_threshold_b0 FLOAT DEFAULT 0,
norm_score_threshold_r1 FLOAT DEFAULT 0,
rating VARCHAR
);

INSERT INTO results_psra_national.psra_eqri_thresholds_1km_uc (percentile,rating) VALUES
(0,'Within bottom 50% of communities'),
(0.50,'Within 50-75% of communities'),
(0.75,'Within 75-90% of communities'),
(0.90,'Within 90-95% of communities'),
(0.95,'Within top 5% of communities');

--update values with calculated percentiles - 1km
--0.50 percentile
UPDATE results_psra_national.psra_eqri_thresholds_1km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_1km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_1km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_1km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_1km_uc) WHERE percentile = 0.50;

-- 0.75 percentile
UPDATE results_psra_national.psra_eqri_thresholds_1km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_1km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_1km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_1km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_1km_uc) WHERE percentile = 0.75;
	
-- 0.90 percentile
UPDATE results_psra_national.psra_eqri_thresholds_1km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_1km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_1km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_1km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_1km_uc) WHERE percentile = 0.90;
	
-- 0.95 percentile
UPDATE results_psra_national.psra_eqri_thresholds_1km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_1km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_1km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_1km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_1km_uc) WHERE percentile = 0.95;

-- update percentilerank value for eqriskindex - 1km
UPDATE results_psra_national.psra_eqriskindex_1km_uc
SET eqri_abs_rank_b0 =
	CASE 
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_b0 > (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_abs_rank_r1 =
	CASE 
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_r1 > (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_b0 =
	CASE 
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_b0 > (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_r1 =
	CASE 
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_r1 > (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95)
		ELSE 'null' END;

-- update percentilerank value for eqriskindex - 1km
UPDATE results_psra_national.psra_eqriskindex_1km_uc
SET eqri_abs_rank_b0 =
	CASE 
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_b0 > (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_abs_rank_r1 =
	CASE 
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_r1 > (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_b0 =
	CASE 
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_b0 > (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_r1 =
	CASE 
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_r1 > (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_1km_uc WHERE percentile = 0.95)
		ELSE 'null' END;

-- 1km
DROP VIEW IF EXISTS results_psra_national.psra_indicators_hexgrid_1km_uc CASCADE;
CREATE VIEW results_psra_national.psra_indicators_hexgrid_1km_uc AS
SELECT 
c.gridid_1,
SUM("eDt_Slight_b0" * b.area_ratio) AS "eDt_Slight_b0",
AVG("eDtr_Slight_b0" * b.area_ratio) AS "eDtr_Slight_b0",
SUM("eDt_Moderate_b0" * b.area_ratio) AS "eDt_Moderate_b0",
AVG("eDtr_Moderate_b0" * b.area_ratio) AS "eDtr_Moderate_b0",
SUM("eDt_Extensive_b0" * b.area_ratio) AS "eDt_Extensive_b0",
AVG("eDtr_Extensive_b0" * b.area_ratio) AS "eDtr_Extensive_b0",
SUM("eDt_Complete_b0" * b.area_ratio) AS "eDt_Complete_b0",
AVG("eDtr_Complete_b0" * b.area_ratio) AS "eDtr_Complete_b0",
SUM("eDt_Collapse_b0" * b.area_ratio) AS "eDt_Collapse_b0",
AVG("eDtr_Collapse_b0" * b.area_ratio) AS "eDtr_Collapse_b0",
SUM("eDt_Slight_r1" * b.area_ratio) AS "eDt_Slight_r1",
AVG("eDtr_Slight_r1" * b.area_ratio) AS "eDtr_Slight_r1",
SUM("eDt_Moderate_r1" * b.area_ratio) AS "eDt_Moderate_r1",
AVG("eDtr_Moderate_r1" * b.area_ratio) AS "eDtr_Moderate_r1",
SUM("eDt_Extensive_r1" * b.area_ratio) AS "eDt_Extensive_r1",
AVG("eDtr_Extensive_r1" * b.area_ratio) AS "eDtr_Extensive_r1",
SUM("eDt_Complete_r1" * b.area_ratio) AS "eDt_Complete_r1",
AVG("eDtr_Complete_r1" * b.area_ratio) AS "eDtr_Complete_r1",
SUM("eDt_Collapse_r1" * b.area_ratio) AS "eDt_Collapse_r1",
AVG("eDtr_Collapse_r1" * b.area_ratio) AS "eDtr_Collapse_r1",
SUM("eAALt_Asset_b0" * b.area_ratio) AS "eAALt_Asset_b0",
AVG("eAALm_Asset_b0" * b.area_ratio) AS "eAALm_Asset_b0",
SUM("eAALt_Bldg_b0" * b.area_ratio) AS "eAALt_Bldg_b0",
AVG("eAALm_Bldg_b0" * b.area_ratio) AS "eAALm_Bldg_b0",
SUM("eAALt_Str_b0" * b.area_ratio) AS "eAALt_Str_b0",
SUM("eAALt_NStr_b0" * b.area_ratio) AS "eAALt_NStr_b0",
SUM("eAALt_Cont_b0" * b.area_ratio) AS "eAALt_Cont_b0",
SUM("eAALt_Asset_r1" * b.area_ratio) AS "eAALt_Asset_r1",
AVG("eAALm_Asset_r1" * b.area_ratio) AS "eAALm_Asset_r1",
SUM("eAALt_Bldg_r1" * b.area_ratio) AS "eAALt_Bldg_r1",
AVG("eAALm_Bldg_r1" * b.area_ratio) AS "eAALm_Bldg_r1",
SUM("eAALt_Str_r1" * b.area_ratio) AS "eAALt_Str_r1",
SUM("eAALt_NStr_r1" * b.area_ratio) AS "eAALt_NStr_r1",
SUM("eAALt_Cont_r1" * b.area_ratio) AS "eAALt_Cont_r1",
d.eqri_abs_score_b0,
d.eqri_abs_rank_b0,
d.eqri_norm_score_b0,
d.eqri_norm_rank_b0,
d.eqri_abs_score_r1,
d.eqri_abs_rank_r1,
d.eqri_norm_score_r1,
d.eqri_norm_rank_r1,
c.geom

FROM results_psra_national.psra_indicators_s_tbl a
LEFT JOIN boundaries."SAUID_HexGrid_1km_intersect_unclipped" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_1km_unclipped" c ON b.gridid_1 = c.gridid_1
LEFT JOIN results_psra_national.psra_eqriskindex_1km_uc d ON b.gridid_1 = d.gridid_1
GROUP BY c.gridid_1,d.eqri_abs_score_b0,d.eqri_abs_rank_b0,d.eqri_norm_score_b0,d.eqri_norm_rank_b0,d.eqri_abs_score_r1,d.eqri_abs_rank_r1,d.eqri_norm_score_r1,d.eqri_norm_rank_r1,c.geom;



-- create eqriskindex tables - 5km
DROP TABLE IF EXISTS results_psra_national.psra_eqriskindex_5km_uc CASCADE;

CREATE TABLE results_psra_national.psra_eqriskindex_5km_uc AS 
SELECT 
c.gridid_5,
SUM(a.asset_loss_b0 * b.area_ratio) AS "asset_loss_b0",
SUM(a.asset_loss_r1 * b.area_ratio) AS "asset_loss_r1",
SUM(a.lifeloss_b0 * b.area_ratio) AS "lifeloss_b0",
SUM(a.lifeloss_r1 * b.area_ratio) AS "lifeloss_r1",
SUM(a.lifelosscost_b0 * b.area_ratio) AS "lifelosscost_b0",
SUM(a.lifelosscost_r1 * b.area_ratio) AS "lifelosscost_r1",
AVG(a.bldglossratio_b0 * b.area_ratio) AS "bldglossratio_b0",
AVG(a.bldglossratio_r1 * b.area_ratio) AS "bldglossratio_r1",
AVG(a.lifelossratio_b0 * b.area_ratio) AS "lifelossratio_b0",
AVG(a.lifelossratio_r1 * b.area_ratio) AS "lifelossratio_r1",
AVG(a.lifelossratiocost_b0 * b.area_ratio) AS "lifelossratiocost_b0",
AVG(a.lifelossratiocost_r1 * b.area_ratio) AS "lifelossratiocost_r1",
SUM(a."SVlt_Score_translated" * b.area_ratio) AS "SVlt_Score_translated",
SUM(eqri_abs_score_b0 * b.area_ratio) AS "eqri_abs_score_b0",
'null' AS "eqri_abs_rank_b0",
AVG(eqri_norm_score_b0 * b.area_ratio) AS "eqri_norm_score_b0",
'null' AS "eqri_norm_rank_b0",
SUM(eqri_abs_score_r1 * b.area_ratio) AS "eqri_abs_score_r1",
'null' AS "eqri_abs_rank_r1",
AVG(eqri_norm_score_r1 * b.area_ratio) AS "eqri_norm_score_r1",
'null' AS "eqri_norm_rank_r1"

FROM  results_psra_national.psra_eqriskindex a
LEFT JOIN boundaries."SAUID_HexGrid_5km_intersect_unclipped" b ON a.sauid = b.sauid
LEFT JOIN boundaries."HexGrid_5km_unclipped" c ON b.gridid_5 = c.gridid_5
GROUP BY c.gridid_5,c.geom;

-- normalize norm scores between 0 and 100
UPDATE results_psra_national.psra_eqriskindex_5km_uc
SET eqri_norm_score_b0 = CAST(CAST(ROUND(CAST(((eqri_norm_score_b0 - (SELECT MIN(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_5km_uc)) / ((SELECT MAX(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_5km_uc) - 
(SELECT MIN(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_5km_uc))*100) AS NUMERIC),6) AS FLOAT) AS NUMERIC),
 	eqri_norm_score_r1 = CAST(CAST(ROUND(CAST(((eqri_norm_score_r1 - (SELECT MIN(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_5km_uc)) / ((SELECT MAX(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_5km_uc) - 
	(SELECT MIN(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_5km_uc))*100) AS NUMERIC),6) AS FLOAT) AS NUMERIC);

--create national threshold sauid lookup table for rating - 5km
DROP TABLE IF EXISTS results_psra_national.psra_eqri_thresholds_5km_uc CASCADE;
CREATE TABLE results_psra_national.psra_eqri_thresholds_5km_uc
(
percentile NUMERIC,
abs_score_threshold_b0 FLOAT DEFAULT 0,
abs_score_threshold_r1 FLOAT DEFAULT 0, 
norm_score_threshold_b0 FLOAT DEFAULT 0,
norm_score_threshold_r1 FLOAT DEFAULT 0,
rating VARCHAR
);

INSERT INTO results_psra_national.psra_eqri_thresholds_5km_uc (percentile,rating) VALUES
(0,'Within bottom 50% of communities'),
(0.50,'Within 50-75% of communities'),
(0.75,'Within 75-90% of communities'),
(0.90,'Within 90-95% of communities'),
(0.95,'Within top 5% of communities');

--update values with calculated percentiles - 5km
--0.50 percentile
UPDATE results_psra_national.psra_eqri_thresholds_5km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_5km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_5km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_5km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_5km_uc) WHERE percentile = 0.50;

-- 0.75 percentile
UPDATE results_psra_national.psra_eqri_thresholds_5km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_5km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_5km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_5km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_5km_uc) WHERE percentile = 0.75;
	
-- 0.90 percentile
UPDATE results_psra_national.psra_eqri_thresholds_5km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_5km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_5km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_5km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_5km_uc) WHERE percentile = 0.90;
	
-- 0.95 percentile
UPDATE results_psra_national.psra_eqri_thresholds_5km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_5km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_5km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_5km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_5km_uc) WHERE percentile = 0.95;

-- update percentilerank value for eqriskindex - 5km
UPDATE results_psra_national.psra_eqriskindex_5km_uc
SET eqri_abs_rank_b0 =
	CASE 
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_b0 > (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_abs_rank_r1 =
	CASE 
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_r1 > (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_b0 =
	CASE 
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_b0 > (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_r1 =
	CASE 
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_r1 > (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95)
		ELSE 'null' END;

-- update percentilerank value for eqriskindex - 5km
UPDATE results_psra_national.psra_eqriskindex_5km_uc
SET eqri_abs_rank_b0 =
	CASE 
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_b0 > (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_abs_rank_r1 =
	CASE 
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_r1 > (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_b0 =
	CASE 
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_b0 > (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_r1 =
	CASE 
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_r1 > (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_5km_uc WHERE percentile = 0.95)
		ELSE 'null' END;

-- 1km
DROP VIEW IF EXISTS results_psra_national.psra_indicators_hexgrid_5km_uc CASCADE;
CREATE VIEW results_psra_national.psra_indicators_hexgrid_5km_uc AS
SELECT 
c.gridid_5,
SUM("eDt_Slight_b0" * b.area_ratio) AS "eDt_Slight_b0",
AVG("eDtr_Slight_b0" * b.area_ratio) AS "eDtr_Slight_b0",
SUM("eDt_Moderate_b0" * b.area_ratio) AS "eDt_Moderate_b0",
AVG("eDtr_Moderate_b0" * b.area_ratio) AS "eDtr_Moderate_b0",
SUM("eDt_Extensive_b0" * b.area_ratio) AS "eDt_Extensive_b0",
AVG("eDtr_Extensive_b0" * b.area_ratio) AS "eDtr_Extensive_b0",
SUM("eDt_Complete_b0" * b.area_ratio) AS "eDt_Complete_b0",
AVG("eDtr_Complete_b0" * b.area_ratio) AS "eDtr_Complete_b0",
SUM("eDt_Collapse_b0" * b.area_ratio) AS "eDt_Collapse_b0",
AVG("eDtr_Collapse_b0" * b.area_ratio) AS "eDtr_Collapse_b0",
SUM("eDt_Slight_r1" * b.area_ratio) AS "eDt_Slight_r1",
AVG("eDtr_Slight_r1" * b.area_ratio) AS "eDtr_Slight_r1",
SUM("eDt_Moderate_r1" * b.area_ratio) AS "eDt_Moderate_r1",
AVG("eDtr_Moderate_r1" * b.area_ratio) AS "eDtr_Moderate_r1",
SUM("eDt_Extensive_r1" * b.area_ratio) AS "eDt_Extensive_r1",
AVG("eDtr_Extensive_r1" * b.area_ratio) AS "eDtr_Extensive_r1",
SUM("eDt_Complete_r1" * b.area_ratio) AS "eDt_Complete_r1",
AVG("eDtr_Complete_r1" * b.area_ratio) AS "eDtr_Complete_r1",
SUM("eDt_Collapse_r1" * b.area_ratio) AS "eDt_Collapse_r1",
AVG("eDtr_Collapse_r1" * b.area_ratio) AS "eDtr_Collapse_r1",
SUM("eAALt_Asset_b0" * b.area_ratio) AS "eAALt_Asset_b0",
AVG("eAALm_Asset_b0" * b.area_ratio) AS "eAALm_Asset_b0",
SUM("eAALt_Bldg_b0" * b.area_ratio) AS "eAALt_Bldg_b0",
AVG("eAALm_Bldg_b0" * b.area_ratio) AS "eAALm_Bldg_b0",
SUM("eAALt_Str_b0" * b.area_ratio) AS "eAALt_Str_b0",
SUM("eAALt_NStr_b0" * b.area_ratio) AS "eAALt_NStr_b0",
SUM("eAALt_Cont_b0" * b.area_ratio) AS "eAALt_Cont_b0",
SUM("eAALt_Asset_r1" * b.area_ratio) AS "eAALt_Asset_r1",
AVG("eAALm_Asset_r1" * b.area_ratio) AS "eAALm_Asset_r1",
SUM("eAALt_Bldg_r1" * b.area_ratio) AS "eAALt_Bldg_r1",
AVG("eAALm_Bldg_r1" * b.area_ratio) AS "eAALm_Bldg_r1",
SUM("eAALt_Str_r1" * b.area_ratio) AS "eAALt_Str_r1",
SUM("eAALt_NStr_r1" * b.area_ratio) AS "eAALt_NStr_r1",
SUM("eAALt_Cont_r1" * b.area_ratio) AS "eAALt_Cont_r1",
d.eqri_abs_score_b0,
d.eqri_abs_rank_b0,
d.eqri_norm_score_b0,
d.eqri_norm_rank_b0,
d.eqri_abs_score_r1,
d.eqri_abs_rank_r1,
d.eqri_norm_score_r1,
d.eqri_norm_rank_r1,
c.geom

FROM results_psra_national.psra_indicators_s_tbl a
LEFT JOIN boundaries."SAUID_HexGrid_5km_intersect_unclipped" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_5km_unclipped" c ON b.gridid_5 = c.gridid_5
LEFT JOIN results_psra_national.psra_eqriskindex_5km_uc d ON b.gridid_5 = d.gridid_5
GROUP BY c.gridid_5,d.eqri_abs_score_b0,d.eqri_abs_rank_b0,d.eqri_norm_score_b0,d.eqri_norm_rank_b0,d.eqri_abs_score_r1,d.eqri_abs_rank_r1,d.eqri_norm_score_r1,d.eqri_norm_rank_r1,c.geom;



-- create eqriskindex tables - 10km
DROP TABLE IF EXISTS results_psra_national.psra_eqriskindex_10km_uc CASCADE;

CREATE TABLE results_psra_national.psra_eqriskindex_10km_uc AS 
SELECT 
c.gridid_10,
SUM(a.asset_loss_b0 * b.area_ratio) AS "asset_loss_b0",
SUM(a.asset_loss_r1 * b.area_ratio) AS "asset_loss_r1",
SUM(a.lifeloss_b0 * b.area_ratio) AS "lifeloss_b0",
SUM(a.lifeloss_r1 * b.area_ratio) AS "lifeloss_r1",
SUM(a.lifelosscost_b0 * b.area_ratio) AS "lifelosscost_b0",
SUM(a.lifelosscost_r1 * b.area_ratio) AS "lifelosscost_r1",
AVG(a.bldglossratio_b0 * b.area_ratio) AS "bldglossratio_b0",
AVG(a.bldglossratio_r1 * b.area_ratio) AS "bldglossratio_r1",
AVG(a.lifelossratio_b0 * b.area_ratio) AS "lifelossratio_b0",
AVG(a.lifelossratio_r1 * b.area_ratio) AS "lifelossratio_r1",
AVG(a.lifelossratiocost_b0 * b.area_ratio) AS "lifelossratiocost_b0",
AVG(a.lifelossratiocost_r1 * b.area_ratio) AS "lifelossratiocost_r1",
SUM(a."SVlt_Score_translated" * b.area_ratio) AS "SVlt_Score_translated",
SUM(eqri_abs_score_b0 * b.area_ratio) AS "eqri_abs_score_b0",
'null' AS "eqri_abs_rank_b0",
AVG(eqri_norm_score_b0 * b.area_ratio) AS "eqri_norm_score_b0",
'null' AS "eqri_norm_rank_b0",
SUM(eqri_abs_score_r1 * b.area_ratio) AS "eqri_abs_score_r1",
'null' AS "eqri_abs_rank_r1",
AVG(eqri_norm_score_r1 * b.area_ratio) AS "eqri_norm_score_r1",
'null' AS "eqri_norm_rank_r1"

FROM  results_psra_national.psra_eqriskindex a
LEFT JOIN boundaries."SAUID_HexGrid_10km_intersect_unclipped" b ON a.sauid = b.sauid
LEFT JOIN boundaries."HexGrid_10km_unclipped" c ON b.gridid_10 = c.gridid_10
GROUP BY c.gridid_10,c.geom;

-- normalize norm scores between 0 and 100
UPDATE results_psra_national.psra_eqriskindex_10km_uc
SET eqri_norm_score_b0 = CAST(CAST(ROUND(CAST(((eqri_norm_score_b0 - (SELECT MIN(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_10km_uc)) / ((SELECT MAX(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_10km_uc) - 
(SELECT MIN(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_10km_uc))*100) AS NUMERIC),6) AS FLOAT) AS NUMERIC),
 	eqri_norm_score_r1 = CAST(CAST(ROUND(CAST(((eqri_norm_score_r1 - (SELECT MIN(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_10km_uc)) / ((SELECT MAX(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_10km_uc) - 
	(SELECT MIN(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_10km_uc))*100) AS NUMERIC),6) AS FLOAT) AS NUMERIC);

--create national threshold sauid lookup table for rating - 10km
DROP TABLE IF EXISTS results_psra_national.psra_eqri_thresholds_10km_uc CASCADE;
CREATE TABLE results_psra_national.psra_eqri_thresholds_10km_uc
(
percentile NUMERIC,
abs_score_threshold_b0 FLOAT DEFAULT 0,
abs_score_threshold_r1 FLOAT DEFAULT 0, 
norm_score_threshold_b0 FLOAT DEFAULT 0,
norm_score_threshold_r1 FLOAT DEFAULT 0,
rating VARCHAR
);

INSERT INTO results_psra_national.psra_eqri_thresholds_10km_uc (percentile,rating) VALUES
(0,'Within bottom 50% of communities'),
(0.50,'Within 50-75% of communities'),
(0.75,'Within 75-90% of communities'),
(0.90,'Within 90-95% of communities'),
(0.95,'Within top 5% of communities');

--update values with calculated percentiles - 10km
--0.50 percentile
UPDATE results_psra_national.psra_eqri_thresholds_10km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_10km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_10km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_10km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_10km_uc) WHERE percentile = 0.50;

-- 0.75 percentile
UPDATE results_psra_national.psra_eqri_thresholds_10km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_10km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_10km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_10km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_10km_uc) WHERE percentile = 0.75;
	
-- 0.90 percentile
UPDATE results_psra_national.psra_eqri_thresholds_10km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_10km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_10km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_10km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_10km_uc) WHERE percentile = 0.90;
	
-- 0.95 percentile
UPDATE results_psra_national.psra_eqri_thresholds_10km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_10km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_10km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_10km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_10km_uc) WHERE percentile = 0.95;

-- update percentilerank value for eqriskindex - 10km
UPDATE results_psra_national.psra_eqriskindex_10km_uc
SET eqri_abs_rank_b0 =
	CASE 
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_b0 > (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_abs_rank_r1 =
	CASE 
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_r1 > (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_b0 =
	CASE 
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_b0 > (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_r1 =
	CASE 
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_r1 > (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95)
		ELSE 'null' END;

-- update percentilerank value for eqriskindex - 10km
UPDATE results_psra_national.psra_eqriskindex_10km_uc
SET eqri_abs_rank_b0 =
	CASE 
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_b0 > (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_abs_rank_r1 =
	CASE 
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_r1 > (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_b0 =
	CASE 
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_b0 > (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_r1 =
	CASE 
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_r1 > (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_10km_uc WHERE percentile = 0.95)
		ELSE 'null' END;

-- 10km
DROP VIEW IF EXISTS results_psra_national.psra_indicators_hexgrid_10km_uc CASCADE;
CREATE VIEW results_psra_national.psra_indicators_hexgrid_10km_uc AS
SELECT 
c.gridid_10,
SUM("eDt_Slight_b0" * b.area_ratio) AS "eDt_Slight_b0",
AVG("eDtr_Slight_b0" * b.area_ratio) AS "eDtr_Slight_b0",
SUM("eDt_Moderate_b0" * b.area_ratio) AS "eDt_Moderate_b0",
AVG("eDtr_Moderate_b0" * b.area_ratio) AS "eDtr_Moderate_b0",
SUM("eDt_Extensive_b0" * b.area_ratio) AS "eDt_Extensive_b0",
AVG("eDtr_Extensive_b0" * b.area_ratio) AS "eDtr_Extensive_b0",
SUM("eDt_Complete_b0" * b.area_ratio) AS "eDt_Complete_b0",
AVG("eDtr_Complete_b0" * b.area_ratio) AS "eDtr_Complete_b0",
SUM("eDt_Collapse_b0" * b.area_ratio) AS "eDt_Collapse_b0",
AVG("eDtr_Collapse_b0" * b.area_ratio) AS "eDtr_Collapse_b0",
SUM("eDt_Slight_r1" * b.area_ratio) AS "eDt_Slight_r1",
AVG("eDtr_Slight_r1" * b.area_ratio) AS "eDtr_Slight_r1",
SUM("eDt_Moderate_r1" * b.area_ratio) AS "eDt_Moderate_r1",
AVG("eDtr_Moderate_r1" * b.area_ratio) AS "eDtr_Moderate_r1",
SUM("eDt_Extensive_r1" * b.area_ratio) AS "eDt_Extensive_r1",
AVG("eDtr_Extensive_r1" * b.area_ratio) AS "eDtr_Extensive_r1",
SUM("eDt_Complete_r1" * b.area_ratio) AS "eDt_Complete_r1",
AVG("eDtr_Complete_r1" * b.area_ratio) AS "eDtr_Complete_r1",
SUM("eDt_Collapse_r1" * b.area_ratio) AS "eDt_Collapse_r1",
AVG("eDtr_Collapse_r1" * b.area_ratio) AS "eDtr_Collapse_r1",
SUM("eAALt_Asset_b0" * b.area_ratio) AS "eAALt_Asset_b0",
AVG("eAALm_Asset_b0" * b.area_ratio) AS "eAALm_Asset_b0",
SUM("eAALt_Bldg_b0" * b.area_ratio) AS "eAALt_Bldg_b0",
AVG("eAALm_Bldg_b0" * b.area_ratio) AS "eAALm_Bldg_b0",
SUM("eAALt_Str_b0" * b.area_ratio) AS "eAALt_Str_b0",
SUM("eAALt_NStr_b0" * b.area_ratio) AS "eAALt_NStr_b0",
SUM("eAALt_Cont_b0" * b.area_ratio) AS "eAALt_Cont_b0",
SUM("eAALt_Asset_r1" * b.area_ratio) AS "eAALt_Asset_r1",
AVG("eAALm_Asset_r1" * b.area_ratio) AS "eAALm_Asset_r1",
SUM("eAALt_Bldg_r1" * b.area_ratio) AS "eAALt_Bldg_r1",
AVG("eAALm_Bldg_r1" * b.area_ratio) AS "eAALm_Bldg_r1",
SUM("eAALt_Str_r1" * b.area_ratio) AS "eAALt_Str_r1",
SUM("eAALt_NStr_r1" * b.area_ratio) AS "eAALt_NStr_r1",
SUM("eAALt_Cont_r1" * b.area_ratio) AS "eAALt_Cont_r1",
d.eqri_abs_score_b0,
d.eqri_abs_rank_b0,
d.eqri_norm_score_b0,
d.eqri_norm_rank_b0,
d.eqri_abs_score_r1,
d.eqri_abs_rank_r1,
d.eqri_norm_score_r1,
d.eqri_norm_rank_r1,
c.geom

FROM results_psra_national.psra_indicators_s_tbl a
LEFT JOIN boundaries."SAUID_HexGrid_10km_intersect_unclipped" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_10km_unclipped" c ON b.gridid_10 = c.gridid_10
LEFT JOIN results_psra_national.psra_eqriskindex_10km_uc d ON b.gridid_10 = d.gridid_10
GROUP BY c.gridid_10,d.eqri_abs_score_b0,d.eqri_abs_rank_b0,d.eqri_norm_score_b0,d.eqri_norm_rank_b0,d.eqri_abs_score_r1,d.eqri_abs_rank_r1,d.eqri_norm_score_r1,d.eqri_norm_rank_r1,c.geom;



-- create eqriskindex tables - 25km
DROP TABLE IF EXISTS results_psra_national.psra_eqriskindex_25km_uc CASCADE;

CREATE TABLE results_psra_national.psra_eqriskindex_25km_uc AS 
SELECT 
c.gridid_25,
SUM(a.asset_loss_b0 * b.area_ratio) AS "asset_loss_b0",
SUM(a.asset_loss_r1 * b.area_ratio) AS "asset_loss_r1",
SUM(a.lifeloss_b0 * b.area_ratio) AS "lifeloss_b0",
SUM(a.lifeloss_r1 * b.area_ratio) AS "lifeloss_r1",
SUM(a.lifelosscost_b0 * b.area_ratio) AS "lifelosscost_b0",
SUM(a.lifelosscost_r1 * b.area_ratio) AS "lifelosscost_r1",
AVG(a.bldglossratio_b0 * b.area_ratio) AS "bldglossratio_b0",
AVG(a.bldglossratio_r1 * b.area_ratio) AS "bldglossratio_r1",
AVG(a.lifelossratio_b0 * b.area_ratio) AS "lifelossratio_b0",
AVG(a.lifelossratio_r1 * b.area_ratio) AS "lifelossratio_r1",
AVG(a.lifelossratiocost_b0 * b.area_ratio) AS "lifelossratiocost_b0",
AVG(a.lifelossratiocost_r1 * b.area_ratio) AS "lifelossratiocost_r1",
SUM(a."SVlt_Score_translated" * b.area_ratio) AS "SVlt_Score_translated",
SUM(eqri_abs_score_b0 * b.area_ratio) AS "eqri_abs_score_b0",
'null' AS "eqri_abs_rank_b0",
AVG(eqri_norm_score_b0 * b.area_ratio) AS "eqri_norm_score_b0",
'null' AS "eqri_norm_rank_b0",
SUM(eqri_abs_score_r1 * b.area_ratio) AS "eqri_abs_score_r1",
'null' AS "eqri_abs_rank_r1",
AVG(eqri_norm_score_r1 * b.area_ratio) AS "eqri_norm_score_r1",
'null' AS "eqri_norm_rank_r1"

FROM  results_psra_national.psra_eqriskindex a
LEFT JOIN boundaries."SAUID_HexGrid_25km_intersect_unclipped" b ON a.sauid = b.sauid
LEFT JOIN boundaries."HexGrid_25km_unclipped" c ON b.gridid_25 = c.gridid_25
GROUP BY c.gridid_25,c.geom;

-- normalize norm scores between 0 and 100
UPDATE results_psra_national.psra_eqriskindex_25km_uc
SET eqri_norm_score_b0 = CAST(CAST(ROUND(CAST(((eqri_norm_score_b0 - (SELECT MIN(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_25km_uc)) / ((SELECT MAX(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_25km_uc) - 
(SELECT MIN(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_25km_uc))*100) AS NUMERIC),6) AS FLOAT) AS NUMERIC),
 	eqri_norm_score_r1 = CAST(CAST(ROUND(CAST(((eqri_norm_score_r1 - (SELECT MIN(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_25km_uc)) / ((SELECT MAX(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_25km_uc) - 
	(SELECT MIN(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_25km_uc))*100) AS NUMERIC),6) AS FLOAT) AS NUMERIC);

--create national threshold sauid lookup table for rating - 25km
DROP TABLE IF EXISTS results_psra_national.psra_eqri_thresholds_25km_uc CASCADE;
CREATE TABLE results_psra_national.psra_eqri_thresholds_25km_uc
(
percentile NUMERIC,
abs_score_threshold_b0 FLOAT DEFAULT 0,
abs_score_threshold_r1 FLOAT DEFAULT 0, 
norm_score_threshold_b0 FLOAT DEFAULT 0,
norm_score_threshold_r1 FLOAT DEFAULT 0,
rating VARCHAR
);

INSERT INTO results_psra_national.psra_eqri_thresholds_25km_uc (percentile,rating) VALUES
(0,'Within bottom 50% of communities'),
(0.50,'Within 50-75% of communities'),
(0.75,'Within 75-90% of communities'),
(0.90,'Within 90-95% of communities'),
(0.95,'Within top 5% of communities');

--update values with calculated percentiles - 25km
--0.50 percentile
UPDATE results_psra_national.psra_eqri_thresholds_25km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_25km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_25km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_25km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_25km_uc) WHERE percentile = 0.50;

-- 0.75 percentile
UPDATE results_psra_national.psra_eqri_thresholds_25km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_25km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_25km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_25km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_25km_uc) WHERE percentile = 0.75;
	
-- 0.90 percentile
UPDATE results_psra_national.psra_eqri_thresholds_25km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_25km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_25km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_25km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_25km_uc) WHERE percentile = 0.90;
	
-- 0.95 percentile
UPDATE results_psra_national.psra_eqri_thresholds_25km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_25km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_25km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_25km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_25km_uc) WHERE percentile = 0.95;

-- update percentilerank value for eqriskindex - 25km
UPDATE results_psra_national.psra_eqriskindex_25km_uc
SET eqri_abs_rank_b0 =
	CASE 
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_b0 > (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_abs_rank_r1 =
	CASE 
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_r1 > (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_b0 =
	CASE 
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_b0 > (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_r1 =
	CASE 
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_r1 > (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95)
		ELSE 'null' END;

-- update percentilerank value for eqriskindex - 25km
UPDATE results_psra_national.psra_eqriskindex_25km_uc
SET eqri_abs_rank_b0 =
	CASE 
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_b0 > (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_abs_rank_r1 =
	CASE 
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_r1 > (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_b0 =
	CASE 
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_b0 > (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_r1 =
	CASE 
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_r1 > (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_25km_uc WHERE percentile = 0.95)
		ELSE 'null' END;

-- 25km
DROP VIEW IF EXISTS results_psra_national.psra_indicators_hexgrid_25km_uc CASCADE;
CREATE VIEW results_psra_national.psra_indicators_hexgrid_25km_uc AS
SELECT 
c.gridid_25,
SUM("eDt_Slight_b0" * b.area_ratio) AS "eDt_Slight_b0",
AVG("eDtr_Slight_b0" * b.area_ratio) AS "eDtr_Slight_b0",
SUM("eDt_Moderate_b0" * b.area_ratio) AS "eDt_Moderate_b0",
AVG("eDtr_Moderate_b0" * b.area_ratio) AS "eDtr_Moderate_b0",
SUM("eDt_Extensive_b0" * b.area_ratio) AS "eDt_Extensive_b0",
AVG("eDtr_Extensive_b0" * b.area_ratio) AS "eDtr_Extensive_b0",
SUM("eDt_Complete_b0" * b.area_ratio) AS "eDt_Complete_b0",
AVG("eDtr_Complete_b0" * b.area_ratio) AS "eDtr_Complete_b0",
SUM("eDt_Collapse_b0" * b.area_ratio) AS "eDt_Collapse_b0",
AVG("eDtr_Collapse_b0" * b.area_ratio) AS "eDtr_Collapse_b0",
SUM("eDt_Slight_r1" * b.area_ratio) AS "eDt_Slight_r1",
AVG("eDtr_Slight_r1" * b.area_ratio) AS "eDtr_Slight_r1",
SUM("eDt_Moderate_r1" * b.area_ratio) AS "eDt_Moderate_r1",
AVG("eDtr_Moderate_r1" * b.area_ratio) AS "eDtr_Moderate_r1",
SUM("eDt_Extensive_r1" * b.area_ratio) AS "eDt_Extensive_r1",
AVG("eDtr_Extensive_r1" * b.area_ratio) AS "eDtr_Extensive_r1",
SUM("eDt_Complete_r1" * b.area_ratio) AS "eDt_Complete_r1",
AVG("eDtr_Complete_r1" * b.area_ratio) AS "eDtr_Complete_r1",
SUM("eDt_Collapse_r1" * b.area_ratio) AS "eDt_Collapse_r1",
AVG("eDtr_Collapse_r1" * b.area_ratio) AS "eDtr_Collapse_r1",
SUM("eAALt_Asset_b0" * b.area_ratio) AS "eAALt_Asset_b0",
AVG("eAALm_Asset_b0" * b.area_ratio) AS "eAALm_Asset_b0",
SUM("eAALt_Bldg_b0" * b.area_ratio) AS "eAALt_Bldg_b0",
AVG("eAALm_Bldg_b0" * b.area_ratio) AS "eAALm_Bldg_b0",
SUM("eAALt_Str_b0" * b.area_ratio) AS "eAALt_Str_b0",
SUM("eAALt_NStr_b0" * b.area_ratio) AS "eAALt_NStr_b0",
SUM("eAALt_Cont_b0" * b.area_ratio) AS "eAALt_Cont_b0",
SUM("eAALt_Asset_r1" * b.area_ratio) AS "eAALt_Asset_r1",
AVG("eAALm_Asset_r1" * b.area_ratio) AS "eAALm_Asset_r1",
SUM("eAALt_Bldg_r1" * b.area_ratio) AS "eAALt_Bldg_r1",
AVG("eAALm_Bldg_r1" * b.area_ratio) AS "eAALm_Bldg_r1",
SUM("eAALt_Str_r1" * b.area_ratio) AS "eAALt_Str_r1",
SUM("eAALt_NStr_r1" * b.area_ratio) AS "eAALt_NStr_r1",
SUM("eAALt_Cont_r1" * b.area_ratio) AS "eAALt_Cont_r1",
d.eqri_abs_score_b0,
d.eqri_abs_rank_b0,
d.eqri_norm_score_b0,
d.eqri_norm_rank_b0,
d.eqri_abs_score_r1,
d.eqri_abs_rank_r1,
d.eqri_norm_score_r1,
d.eqri_norm_rank_r1,
c.geom

FROM results_psra_national.psra_indicators_s_tbl a
LEFT JOIN boundaries."SAUID_HexGrid_25km_intersect_unclipped" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_25km_unclipped" c ON b.gridid_25 = c.gridid_25
LEFT JOIN results_psra_national.psra_eqriskindex_25km_uc d ON b.gridid_25 = d.gridid_25
GROUP BY c.gridid_25,d.eqri_abs_score_b0,d.eqri_abs_rank_b0,d.eqri_norm_score_b0,d.eqri_norm_rank_b0,d.eqri_abs_score_r1,d.eqri_abs_rank_r1,d.eqri_norm_score_r1,d.eqri_norm_rank_r1,c.geom;



-- create eqriskindex tables - 50km
DROP TABLE IF EXISTS results_psra_national.psra_eqriskindex_50km_uc CASCADE;

CREATE TABLE results_psra_national.psra_eqriskindex_50km_uc AS 
SELECT 
c.gridid_50,
SUM(a.asset_loss_b0 * b.area_ratio) AS "asset_loss_b0",
SUM(a.asset_loss_r1 * b.area_ratio) AS "asset_loss_r1",
SUM(a.lifeloss_b0 * b.area_ratio) AS "lifeloss_b0",
SUM(a.lifeloss_r1 * b.area_ratio) AS "lifeloss_r1",
SUM(a.lifelosscost_b0 * b.area_ratio) AS "lifelosscost_b0",
SUM(a.lifelosscost_r1 * b.area_ratio) AS "lifelosscost_r1",
AVG(a.bldglossratio_b0 * b.area_ratio) AS "bldglossratio_b0",
AVG(a.bldglossratio_r1 * b.area_ratio) AS "bldglossratio_r1",
AVG(a.lifelossratio_b0 * b.area_ratio) AS "lifelossratio_b0",
AVG(a.lifelossratio_r1 * b.area_ratio) AS "lifelossratio_r1",
AVG(a.lifelossratiocost_b0 * b.area_ratio) AS "lifelossratiocost_b0",
AVG(a.lifelossratiocost_r1 * b.area_ratio) AS "lifelossratiocost_r1",
SUM(a."SVlt_Score_translated" * b.area_ratio) AS "SVlt_Score_translated",
SUM(eqri_abs_score_b0 * b.area_ratio) AS "eqri_abs_score_b0",
'null' AS "eqri_abs_rank_b0",
AVG(eqri_norm_score_b0 * b.area_ratio) AS "eqri_norm_score_b0",
'null' AS "eqri_norm_rank_b0",
SUM(eqri_abs_score_r1 * b.area_ratio) AS "eqri_abs_score_r1",
'null' AS "eqri_abs_rank_r1",
AVG(eqri_norm_score_r1 * b.area_ratio) AS "eqri_norm_score_r1",
'null' AS "eqri_norm_rank_r1"

FROM  results_psra_national.psra_eqriskindex a
LEFT JOIN boundaries."SAUID_HexGrid_50km_intersect_unclipped" b ON a.sauid = b.sauid
LEFT JOIN boundaries."HexGrid_50km_unclipped" c ON b.gridid_50 = c.gridid_50
GROUP BY c.gridid_50,c.geom;

-- normalize norm scores between 0 and 100
UPDATE results_psra_national.psra_eqriskindex_50km_uc
SET eqri_norm_score_b0 = CAST(CAST(ROUND(CAST(((eqri_norm_score_b0 - (SELECT MIN(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_50km_uc)) / ((SELECT MAX(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_50km_uc) - 
(SELECT MIN(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_50km_uc))*100) AS NUMERIC),6) AS FLOAT) AS NUMERIC),
 	eqri_norm_score_r1 = CAST(CAST(ROUND(CAST(((eqri_norm_score_r1 - (SELECT MIN(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_50km_uc)) / ((SELECT MAX(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_50km_uc) - 
	(SELECT MIN(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_50km_uc))*100) AS NUMERIC),6) AS FLOAT) AS NUMERIC);

--create national threshold sauid lookup table for rating - 50km
DROP TABLE IF EXISTS results_psra_national.psra_eqri_thresholds_50km_uc CASCADE;
CREATE TABLE results_psra_national.psra_eqri_thresholds_50km_uc
(
percentile NUMERIC,
abs_score_threshold_b0 FLOAT DEFAULT 0,
abs_score_threshold_r1 FLOAT DEFAULT 0, 
norm_score_threshold_b0 FLOAT DEFAULT 0,
norm_score_threshold_r1 FLOAT DEFAULT 0,
rating VARCHAR
);

INSERT INTO results_psra_national.psra_eqri_thresholds_50km_uc (percentile,rating) VALUES
(0,'Within bottom 50% of communities'),
(0.50,'Within 50-75% of communities'),
(0.75,'Within 75-90% of communities'),
(0.90,'Within 90-95% of communities'),
(0.95,'Within top 5% of communities');

--update values with calculated percentiles - 25km
--0.50 percentile
UPDATE results_psra_national.psra_eqri_thresholds_50km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_50km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_50km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_50km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_50km_uc) WHERE percentile = 0.50;

-- 0.75 percentile
UPDATE results_psra_national.psra_eqri_thresholds_50km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_50km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_50km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_50km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_50km_uc) WHERE percentile = 0.75;
	
-- 0.90 percentile
UPDATE results_psra_national.psra_eqri_thresholds_50km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_50km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_50km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_50km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_50km_uc) WHERE percentile = 0.90;
	
-- 0.95 percentile
UPDATE results_psra_national.psra_eqri_thresholds_50km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_50km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_50km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_50km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_50km_uc) WHERE percentile = 0.95;

-- update percentilerank value for eqriskindex - 50km
UPDATE results_psra_national.psra_eqriskindex_50km_uc
SET eqri_abs_rank_b0 =
	CASE 
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_b0 > (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_abs_rank_r1 =
	CASE 
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_r1 > (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_b0 =
	CASE 
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_b0 > (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_r1 =
	CASE 
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_r1 > (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95)
		ELSE 'null' END;

-- update percentilerank value for eqriskindex - 50km
UPDATE results_psra_national.psra_eqriskindex_50km_uc
SET eqri_abs_rank_b0 =
	CASE 
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_b0 > (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_abs_rank_r1 =
	CASE 
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_r1 > (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_b0 =
	CASE 
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_b0 > (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_r1 =
	CASE 
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_r1 > (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_50km_uc WHERE percentile = 0.95)
		ELSE 'null' END;

-- 50km
DROP VIEW IF EXISTS results_psra_national.psra_indicators_hexgrid_50km_uc CASCADE;
CREATE VIEW results_psra_national.psra_indicators_hexgrid_50km_uc AS
SELECT 
c.gridid_50,
SUM("eDt_Slight_b0" * b.area_ratio) AS "eDt_Slight_b0",
AVG("eDtr_Slight_b0" * b.area_ratio) AS "eDtr_Slight_b0",
SUM("eDt_Moderate_b0" * b.area_ratio) AS "eDt_Moderate_b0",
AVG("eDtr_Moderate_b0" * b.area_ratio) AS "eDtr_Moderate_b0",
SUM("eDt_Extensive_b0" * b.area_ratio) AS "eDt_Extensive_b0",
AVG("eDtr_Extensive_b0" * b.area_ratio) AS "eDtr_Extensive_b0",
SUM("eDt_Complete_b0" * b.area_ratio) AS "eDt_Complete_b0",
AVG("eDtr_Complete_b0" * b.area_ratio) AS "eDtr_Complete_b0",
SUM("eDt_Collapse_b0" * b.area_ratio) AS "eDt_Collapse_b0",
AVG("eDtr_Collapse_b0" * b.area_ratio) AS "eDtr_Collapse_b0",
SUM("eDt_Slight_r1" * b.area_ratio) AS "eDt_Slight_r1",
AVG("eDtr_Slight_r1" * b.area_ratio) AS "eDtr_Slight_r1",
SUM("eDt_Moderate_r1" * b.area_ratio) AS "eDt_Moderate_r1",
AVG("eDtr_Moderate_r1" * b.area_ratio) AS "eDtr_Moderate_r1",
SUM("eDt_Extensive_r1" * b.area_ratio) AS "eDt_Extensive_r1",
AVG("eDtr_Extensive_r1" * b.area_ratio) AS "eDtr_Extensive_r1",
SUM("eDt_Complete_r1" * b.area_ratio) AS "eDt_Complete_r1",
AVG("eDtr_Complete_r1" * b.area_ratio) AS "eDtr_Complete_r1",
SUM("eDt_Collapse_r1" * b.area_ratio) AS "eDt_Collapse_r1",
AVG("eDtr_Collapse_r1" * b.area_ratio) AS "eDtr_Collapse_r1",
SUM("eAALt_Asset_b0" * b.area_ratio) AS "eAALt_Asset_b0",
AVG("eAALm_Asset_b0" * b.area_ratio) AS "eAALm_Asset_b0",
SUM("eAALt_Bldg_b0" * b.area_ratio) AS "eAALt_Bldg_b0",
AVG("eAALm_Bldg_b0" * b.area_ratio) AS "eAALm_Bldg_b0",
SUM("eAALt_Str_b0" * b.area_ratio) AS "eAALt_Str_b0",
SUM("eAALt_NStr_b0" * b.area_ratio) AS "eAALt_NStr_b0",
SUM("eAALt_Cont_b0" * b.area_ratio) AS "eAALt_Cont_b0",
SUM("eAALt_Asset_r1" * b.area_ratio) AS "eAALt_Asset_r1",
AVG("eAALm_Asset_r1" * b.area_ratio) AS "eAALm_Asset_r1",
SUM("eAALt_Bldg_r1" * b.area_ratio) AS "eAALt_Bldg_r1",
AVG("eAALm_Bldg_r1" * b.area_ratio) AS "eAALm_Bldg_r1",
SUM("eAALt_Str_r1" * b.area_ratio) AS "eAALt_Str_r1",
SUM("eAALt_NStr_r1" * b.area_ratio) AS "eAALt_NStr_r1",
SUM("eAALt_Cont_r1" * b.area_ratio) AS "eAALt_Cont_r1",
d.eqri_abs_score_b0,
d.eqri_abs_rank_b0,
d.eqri_norm_score_b0,
d.eqri_norm_rank_b0,
d.eqri_abs_score_r1,
d.eqri_abs_rank_r1,
d.eqri_norm_score_r1,
d.eqri_norm_rank_r1,
c.geom

FROM results_psra_national.psra_indicators_s_tbl a
LEFT JOIN boundaries."SAUID_HexGrid_50km_intersect_unclipped" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_50km_unclipped" c ON b.gridid_50 = c.gridid_50
LEFT JOIN results_psra_national.psra_eqriskindex_50km_uc d ON b.gridid_50 = d.gridid_50
GROUP BY c.gridid_50,d.eqri_abs_score_b0,d.eqri_abs_rank_b0,d.eqri_norm_score_b0,d.eqri_norm_rank_b0,d.eqri_abs_score_r1,d.eqri_abs_rank_r1,d.eqri_norm_score_r1,d.eqri_norm_rank_r1,c.geom;



-- create eqriskindex tables - 100km
DROP TABLE IF EXISTS results_psra_national.psra_eqriskindex_100km_uc CASCADE;

CREATE TABLE results_psra_national.psra_eqriskindex_100km_uc AS 
SELECT 
c.gridid_100,
SUM(a.asset_loss_b0 * b.area_ratio) AS "asset_loss_b0",
SUM(a.asset_loss_r1 * b.area_ratio) AS "asset_loss_r1",
SUM(a.lifeloss_b0 * b.area_ratio) AS "lifeloss_b0",
SUM(a.lifeloss_r1 * b.area_ratio) AS "lifeloss_r1",
SUM(a.lifelosscost_b0 * b.area_ratio) AS "lifelosscost_b0",
SUM(a.lifelosscost_r1 * b.area_ratio) AS "lifelosscost_r1",
AVG(a.bldglossratio_b0 * b.area_ratio) AS "bldglossratio_b0",
AVG(a.bldglossratio_r1 * b.area_ratio) AS "bldglossratio_r1",
AVG(a.lifelossratio_b0 * b.area_ratio) AS "lifelossratio_b0",
AVG(a.lifelossratio_r1 * b.area_ratio) AS "lifelossratio_r1",
AVG(a.lifelossratiocost_b0 * b.area_ratio) AS "lifelossratiocost_b0",
AVG(a.lifelossratiocost_r1 * b.area_ratio) AS "lifelossratiocost_r1",
SUM(a."SVlt_Score_translated" * b.area_ratio) AS "SVlt_Score_translated",
SUM(eqri_abs_score_b0 * b.area_ratio) AS "eqri_abs_score_b0",
'null' AS "eqri_abs_rank_b0",
AVG(eqri_norm_score_b0 * b.area_ratio) AS "eqri_norm_score_b0",
'null' AS "eqri_norm_rank_b0",
SUM(eqri_abs_score_r1 * b.area_ratio) AS "eqri_abs_score_r1",
'null' AS "eqri_abs_rank_r1",
AVG(eqri_norm_score_r1 * b.area_ratio) AS "eqri_norm_score_r1",
'null' AS "eqri_norm_rank_r1"

FROM  results_psra_national.psra_eqriskindex a
LEFT JOIN boundaries."SAUID_HexGrid_100km_intersect_unclipped" b ON a.sauid = b.sauid
LEFT JOIN boundaries."HexGrid_100km_unclipped" c ON b.gridid_100 = c.gridid_100
GROUP BY c.gridid_100,c.geom;

-- normalize norm scores between 0 and 100
UPDATE results_psra_national.psra_eqriskindex_100km_uc
SET eqri_norm_score_b0 = CAST(CAST(ROUND(CAST(((eqri_norm_score_b0 - (SELECT MIN(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_100km_uc)) / ((SELECT MAX(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_100km_uc) - 
(SELECT MIN(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_100km_uc))*100) AS NUMERIC),6) AS FLOAT) AS NUMERIC),
 	eqri_norm_score_r1 = CAST(CAST(ROUND(CAST(((eqri_norm_score_r1 - (SELECT MIN(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_100km_uc)) / ((SELECT MAX(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_100km_uc) - 
	(SELECT MIN(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_100km_uc))*100) AS NUMERIC),6) AS FLOAT) AS NUMERIC);

--create national threshold sauid lookup table for rating - 100km
DROP TABLE IF EXISTS results_psra_national.psra_eqri_thresholds_100km_uc CASCADE;
CREATE TABLE results_psra_national.psra_eqri_thresholds_100km_uc
(
percentile NUMERIC,
abs_score_threshold_b0 FLOAT DEFAULT 0,
abs_score_threshold_r1 FLOAT DEFAULT 0, 
norm_score_threshold_b0 FLOAT DEFAULT 0,
norm_score_threshold_r1 FLOAT DEFAULT 0,
rating VARCHAR
);

INSERT INTO results_psra_national.psra_eqri_thresholds_100km_uc (percentile,rating) VALUES
(0,'Within bottom 50% of communities'),
(0.50,'Within 50-75% of communities'),
(0.75,'Within 75-90% of communities'),
(0.90,'Within 90-95% of communities'),
(0.95,'Within top 5% of communities');

--update values with calculated percentiles - 100km
--0.50 percentile
UPDATE results_psra_national.psra_eqri_thresholds_100km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_100km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_100km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_100km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_100km_uc) WHERE percentile = 0.50;

-- 0.75 percentile
UPDATE results_psra_national.psra_eqri_thresholds_100km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_100km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_100km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_100km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_100km_uc) WHERE percentile = 0.75;
	
-- 0.90 percentile
UPDATE results_psra_national.psra_eqri_thresholds_100km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_100km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_100km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_100km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_100km_uc) WHERE percentile = 0.90;
	
-- 0.95 percentile
UPDATE results_psra_national.psra_eqri_thresholds_100km_uc 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_100km_uc),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_100km_uc),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_100km_uc),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_100km_uc) WHERE percentile = 0.95;

-- update percentilerank value for eqriskindex - 100km
UPDATE results_psra_national.psra_eqriskindex_100km_uc
SET eqri_abs_rank_b0 =
	CASE 
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_b0 > (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_abs_rank_r1 =
	CASE 
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_r1 > (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_b0 =
	CASE 
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_b0 > (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_r1 =
	CASE 
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_r1 > (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95)
		ELSE 'null' END;

-- update percentilerank value for eqriskindex - 100km
UPDATE results_psra_national.psra_eqriskindex_100km_uc
SET eqri_abs_rank_b0 =
	CASE 
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_b0 > (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_abs_rank_r1 =
	CASE 
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.50)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.75)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.90)
		WHEN eqri_abs_score_r1 > (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_b0 =
	CASE 
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_b0 > (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_r1 =
	CASE 
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.50)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.75)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.90)
		WHEN eqri_norm_score_r1 > (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_100km_uc WHERE percentile = 0.95)
		ELSE 'null' END;

-- 1km
DROP VIEW IF EXISTS results_psra_national.psra_indicators_hexgrid_100km_uc CASCADE;
CREATE VIEW results_psra_national.psra_indicators_hexgrid_100km_uc AS
SELECT 
c.gridid_100,
SUM("eDt_Slight_b0" * b.area_ratio) AS "eDt_Slight_b0",
AVG("eDtr_Slight_b0" * b.area_ratio) AS "eDtr_Slight_b0",
SUM("eDt_Moderate_b0" * b.area_ratio) AS "eDt_Moderate_b0",
AVG("eDtr_Moderate_b0" * b.area_ratio) AS "eDtr_Moderate_b0",
SUM("eDt_Extensive_b0" * b.area_ratio) AS "eDt_Extensive_b0",
AVG("eDtr_Extensive_b0" * b.area_ratio) AS "eDtr_Extensive_b0",
SUM("eDt_Complete_b0" * b.area_ratio) AS "eDt_Complete_b0",
AVG("eDtr_Complete_b0" * b.area_ratio) AS "eDtr_Complete_b0",
SUM("eDt_Collapse_b0" * b.area_ratio) AS "eDt_Collapse_b0",
AVG("eDtr_Collapse_b0" * b.area_ratio) AS "eDtr_Collapse_b0",
SUM("eDt_Slight_r1" * b.area_ratio) AS "eDt_Slight_r1",
AVG("eDtr_Slight_r1" * b.area_ratio) AS "eDtr_Slight_r1",
SUM("eDt_Moderate_r1" * b.area_ratio) AS "eDt_Moderate_r1",
AVG("eDtr_Moderate_r1" * b.area_ratio) AS "eDtr_Moderate_r1",
SUM("eDt_Extensive_r1" * b.area_ratio) AS "eDt_Extensive_r1",
AVG("eDtr_Extensive_r1" * b.area_ratio) AS "eDtr_Extensive_r1",
SUM("eDt_Complete_r1" * b.area_ratio) AS "eDt_Complete_r1",
AVG("eDtr_Complete_r1" * b.area_ratio) AS "eDtr_Complete_r1",
SUM("eDt_Collapse_r1" * b.area_ratio) AS "eDt_Collapse_r1",
AVG("eDtr_Collapse_r1" * b.area_ratio) AS "eDtr_Collapse_r1",
SUM("eAALt_Asset_b0" * b.area_ratio) AS "eAALt_Asset_b0",
AVG("eAALm_Asset_b0" * b.area_ratio) AS "eAALm_Asset_b0",
SUM("eAALt_Bldg_b0" * b.area_ratio) AS "eAALt_Bldg_b0",
AVG("eAALm_Bldg_b0" * b.area_ratio) AS "eAALm_Bldg_b0",
SUM("eAALt_Str_b0" * b.area_ratio) AS "eAALt_Str_b0",
SUM("eAALt_NStr_b0" * b.area_ratio) AS "eAALt_NStr_b0",
SUM("eAALt_Cont_b0" * b.area_ratio) AS "eAALt_Cont_b0",
SUM("eAALt_Asset_r1" * b.area_ratio) AS "eAALt_Asset_r1",
AVG("eAALm_Asset_r1" * b.area_ratio) AS "eAALm_Asset_r1",
SUM("eAALt_Bldg_r1" * b.area_ratio) AS "eAALt_Bldg_r1",
AVG("eAALm_Bldg_r1" * b.area_ratio) AS "eAALm_Bldg_r1",
SUM("eAALt_Str_r1" * b.area_ratio) AS "eAALt_Str_r1",
SUM("eAALt_NStr_r1" * b.area_ratio) AS "eAALt_NStr_r1",
SUM("eAALt_Cont_r1" * b.area_ratio) AS "eAALt_Cont_r1",
d.eqri_abs_score_b0,
d.eqri_abs_rank_b0,
d.eqri_norm_score_b0,
d.eqri_norm_rank_b0,
d.eqri_abs_score_r1,
d.eqri_abs_rank_r1,
d.eqri_norm_score_r1,
d.eqri_norm_rank_r1,
c.geom

FROM results_psra_national.psra_indicators_s_tbl a
LEFT JOIN boundaries."SAUID_HexGrid_100km_intersect_unclipped" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_100km_unclipped" c ON b.gridid_100 = c.gridid_100
LEFT JOIN results_psra_national.psra_eqriskindex_100km_uc d ON b.gridid_100 = d.gridid_100
GROUP BY c.gridid_100,d.eqri_abs_score_b0,d.eqri_abs_rank_b0,d.eqri_norm_score_b0,d.eqri_norm_rank_b0,d.eqri_abs_score_r1,d.eqri_abs_rank_r1,d.eqri_norm_score_r1,d.eqri_norm_rank_r1,c.geom;