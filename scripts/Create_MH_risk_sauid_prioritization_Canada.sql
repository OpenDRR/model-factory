-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_nhsl_hazard_threat;

DROP TABLE IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_s_tbl CASCADE;
CREATE TABLE results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_s_tbl AS
SELECT
-- location
a."Sauid",
a.pruid,
a.prname,
a.eruid,
a.cduid,
a.cdname,
a.csduid,
a.fsauid,
a.dauid,
a.saccode,
a.sactype,
"E_SauidLon",
"E_SauidLat",

-- geometry
a."E_AreaKm2",
a."E_AreaHa",

-- buildings absolute
a."E_CensusDU",
a."Et_BldgNum",
CASE
	WHEN a."Et_BldgNum" = 0 THEN 0
	WHEN a."Et_BldgNum" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY a."Et_BldgNum") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_BldgNum" < (SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY a."Et_BldgNum") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_BldgNum" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY a."Et_BldgNum") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_BldgNum" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_BldgNum") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_BldgNum" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_BldgNum") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END AS "ET_BldgNum_abs_rating",

-- building relative
b."Et_BldgNum" AS "CSD_BldgNum",
(a."Et_BldgNum"/NULLIF(b."Et_BldgNum",0)) AS "Et_BldgNum_rel",
CASE
	WHEN (a."Et_BldgNum"/NULLIF(b."Et_BldgNum",0)) IS NULL THEN 0
	WHEN (a."Et_BldgNum"/NULLIF(b."Et_BldgNum",0)) = 0 THEN 0
	WHEN (a."Et_BldgNum"/NULLIF(b."Et_BldgNum",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_BldgNum"/NULLIF(b."Et_BldgNum",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_BldgNum"/NULLIF(b."Et_BldgNum",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_BldgNum"/NULLIF(b."Et_BldgNum",0))) 
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_BldgNum"/NULLIF(b."Et_BldgNum",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_BldgNum"/NULLIF(b."Et_BldgNum",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_BldgNum"/NULLIF(b."Et_BldgNum",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_BldgNum"/NULLIF(b."Et_BldgNum",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_BldgNum"/NULLIF(b."Et_BldgNum",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_BldgNum"/NULLIF(b."Et_BldgNum",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END AS "Et_BldgNum_rel_rating",

-- population absolute
a."Et_PopNight",
CASE
	WHEN a."Et_PopNight" = 0 THEN 0
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_PopNight" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END AS "Et_PopNight_abs_rating",

-- population relative
b."Et_PopNight" AS "CSD_PopNight",
(a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) AS "Et_PopNight_rel", -- divide by zero error, set null
CASE
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) IS NULL THEN 0 -- catch null values from divide by zero error, set null
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) = 0 THEN 0
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END AS "Et_PopNight_rel_rating",

-- population visualization
a."Et_PopNight"/(NULLIF(a."E_AreaKm2",0)*100) AS "PPH",
CASE
	WHEN a."Et_PopNight"/(NULLIF(a."E_AreaKm2",0)*100) < (SELECT exp_pp FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 'Low'
	WHEN a."Et_PopNight"/(NULLIF(a."E_AreaKm2",0)*100) < (SELECT exp_pp FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 'Moderate'
	WHEN a."Et_PopNight"/(NULLIF(a."E_AreaKm2",0)*100) > (SELECT exp_pp FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 'High'
	ELSE 'Low' END AS "PPH_Exposure_Level",
a."HTt_Exposure",

-- assets absolute
a."Et_AssetValue" AS "Et_AssetValue",
CASE
	WHEN a."Et_AssetValue" = 0 THEN 0
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_AssetValue" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END AS "Et_AssetValue_abs_rating",

-- assets relative
b."Et_AssetValue" AS "CSD_AssetValue",
(a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) AS "Et_AssetValue_rel",
CASE
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) IS NULL THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) = 0 THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END AS "Et_AssetValue_rel_rating",

-- social vulnerability
c."SVlt_Score",

-- eq shaking prioritization
-- hazard intensity
a."HTi_PGA500",

-- pga threat
a."HTd_PGA500",

-- pga priority - absolute
CASE
	WHEN a."HTd_PGA500" = 'None' THEN 0
	WHEN a."HTd_PGA500" = 'Low' THEN 1
	WHEN a."HTd_PGA500" = 'Moderate' THEN 2
	WHEN a."HTd_PGA500" = 'Considerable' THEN 3
	WHEN a."HTd_PGA500" = 'High' THEN 4
	WHEN a."HTd_PGA500" = 'Extreme' THEN 5
	ELSE 0 END AS "eq_bld_dmg_pot_abs",
(CASE
	WHEN a."HTd_PGA500" = 'None' THEN 0
	WHEN a."HTd_PGA500" = 'Low' THEN 1
	WHEN a."HTd_PGA500" = 'Moderate' THEN 2
	WHEN a."HTd_PGA500" = 'Considerable' THEN 3
	WHEN a."HTd_PGA500" = 'High' THEN 4
	WHEN a."HTd_PGA500" = 'Extreme' THEN 5
	ELSE 0 END) * (CASE
	WHEN a."Et_AssetValue" = 0 THEN 0
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_AssetValue" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END) AS "eq_asset_loss_pot_abs",
CASE
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_PGA500" > (SELECT pga_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END AS "eq_human_impct_pot_abs",
(CASE
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_PGA500" > (SELECT pga_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END) * (CASE
	WHEN a."Et_PopNight" = 0 THEN 0
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_PopNight" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END) AS "eq_human_loss_pot_abs",
((CASE
	WHEN a."HTd_PGA500" = 'None' THEN 0
	WHEN a."HTd_PGA500" = 'Low' THEN 1
	WHEN a."HTd_PGA500" = 'Moderate' THEN 2
	WHEN a."HTd_PGA500" = 'Considerable' THEN 3
	WHEN a."HTd_PGA500" = 'High' THEN 4
	WHEN a."HTd_PGA500" = 'Extreme' THEN 5
	ELSE 0 END) * (CASE
	WHEN a."Et_AssetValue" = 0 THEN 0
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_AssetValue" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END) + (CASE
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_PGA500" > (SELECT pga_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END) * (CASE
	WHEN a."Et_PopNight" = 0 THEN 0
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_PopNight" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END)) * c."SVlt_Score" AS "eq_shaking_score_abs",

-- pga priority - relative
CASE
	WHEN a."HTd_PGA500" = 'None' THEN 0
	WHEN a."HTd_PGA500" = 'Low' THEN 1
	WHEN a."HTd_PGA500" = 'Moderate' THEN 2
	WHEN a."HTd_PGA500" = 'Considerable' THEN 3
	WHEN a."HTd_PGA500" = 'High' THEN 4
	WHEN a."HTd_PGA500" = 'Extreme' THEN 5
	ELSE 0 END AS "eq_bld_dmg_pot_rel",
(CASE
	WHEN a."HTd_PGA500" = 'None' THEN 0
	WHEN a."HTd_PGA500" = 'Low' THEN 1
	WHEN a."HTd_PGA500" = 'Moderate' THEN 2
	WHEN a."HTd_PGA500" = 'Considerable' THEN 3
	WHEN a."HTd_PGA500" = 'High' THEN 4
	WHEN a."HTd_PGA500" = 'Extreme' THEN 5
	ELSE 0 END) * (CASE
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) IS NULL THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) = 0 THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END) AS "eq_asset_loss_pot_rel",
CASE
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_PGA500" > (SELECT pga_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END AS "eq_human_impct_pot_rel",
(CASE
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_PGA500" > (SELECT pga_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END) * (CASE
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) IS NULL THEN 0 -- catch null values from divide by zero error, set null
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) = 0 THEN 0
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END) AS "eq_human_loss_pot_rel",
((CASE
	WHEN a."HTd_PGA500" = 'None' THEN 0
	WHEN a."HTd_PGA500" = 'Low' THEN 1
	WHEN a."HTd_PGA500" = 'Moderate' THEN 2
	WHEN a."HTd_PGA500" = 'Considerable' THEN 3
	WHEN a."HTd_PGA500" = 'High' THEN 4
	WHEN a."HTd_PGA500" = 'Extreme' THEN 5
	ELSE 0 END) * (CASE
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) IS NULL THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) = 0 THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END) + (CASE
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_PGA500" < (SELECT pga_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_PGA500" > (SELECT pga_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END) * (CASE
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) IS NULL THEN 0 -- catch null values from divide by zero error, set null
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) = 0 THEN 0
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END)) * c."SVlt_Score" AS "eq_shaking_score_rel",

-- flood threat and prioritization
-- hazard intensity
a."HTi_Fld500",

-- threat
a."HTd_Fld500",

-- flood priority - absolute
CASE
	WHEN a."HTd_Fld500" = 'None' THEN 0
	WHEN a."HTd_Fld500" = 'Low' THEN 1
	WHEN a."HTd_Fld500" = 'Moderate' THEN 2
	WHEN a."HTd_Fld500" = 'Considerable' THEN 3
	WHEN a."HTd_Fld500" = 'High' THEN 4
	WHEN a."HTd_Fld500" = 'Extreme' THEN 5
	ELSE 0 END AS "fld_bld_dmg_pot_abs",
(CASE
	WHEN a."HTd_Fld500" = 'None' THEN 0
	WHEN a."HTd_Fld500" = 'Low' THEN 1
	WHEN a."HTd_Fld500" = 'Moderate' THEN 2
	WHEN a."HTd_Fld500" = 'Considerable' THEN 3
	WHEN a."HTd_Fld500" = 'High' THEN 4
	WHEN a."HTd_Fld500" = 'Extreme' THEN 5
	ELSE 0 END) * (CASE
	WHEN a."Et_AssetValue" = 0 THEN 0
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_AssetValue" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END) AS "fld_asset_loss_pot_abs",
CASE
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Fld500" > (SELECT fld_tsun_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END AS "fld_human_impct_pot_abs",
(CASE
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Fld500" > (SELECT fld_tsun_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END) * (CASE
	WHEN a."Et_PopNight" = 0 THEN 0
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_PopNight" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END) AS "fld_human_loss_pot_abs",
((CASE
	WHEN a."HTd_Fld500" = 'None' THEN 0
	WHEN a."HTd_Fld500" = 'Low' THEN 1
	WHEN a."HTd_Fld500" = 'Moderate' THEN 2
	WHEN a."HTd_Fld500" = 'Considerable' THEN 3
	WHEN a."HTd_Fld500" = 'High' THEN 4
	WHEN a."HTd_Fld500" = 'Extreme' THEN 5
	ELSE 0 END) * (CASE
	WHEN a."Et_AssetValue" = 0 THEN 0
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_AssetValue" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END) + (CASE
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Fld500" > (SELECT fld_tsun_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END) * (CASE
	WHEN a."Et_PopNight" = 0 THEN 0
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_PopNight" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END)) * c."SVlt_Score" AS "fld_priority_score_abs",

-- flood priority - relative
CASE
	WHEN a."HTd_Fld500" = 'None' THEN 0
	WHEN a."HTd_Fld500" = 'Low' THEN 1
	WHEN a."HTd_Fld500" = 'Moderate' THEN 2
	WHEN a."HTd_Fld500" = 'Considerable' THEN 3
	WHEN a."HTd_Fld500" = 'High' THEN 4
	WHEN a."HTd_Fld500" = 'Extreme' THEN 5
	ELSE 0 END AS "fld_bld_dmg_pot_rel",
(CASE
	WHEN a."HTd_Fld500" = 'None' THEN 0
	WHEN a."HTd_Fld500" = 'Low' THEN 1
	WHEN a."HTd_Fld500" = 'Moderate' THEN 2
	WHEN a."HTd_Fld500" = 'Considerable' THEN 3
	WHEN a."HTd_Fld500" = 'High' THEN 4
	WHEN a."HTd_Fld500" = 'Extreme' THEN 5
	ELSE 0 END) * (CASE
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) IS NULL THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) = 0 THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END) AS "fld_asset_loss_pot_rel",
CASE
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Fld500" > (SELECT fld_tsun_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END AS "fld_human_impct_pot_rel",
(CASE
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Fld500" > (SELECT fld_tsun_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END) * (CASE
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) IS NULL THEN 0 -- catch null values from divide by zero error, set null
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) = 0 THEN 0
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END) AS "fld_human_loss_pot_rel",
((CASE
	WHEN a."HTd_Fld500" = 'None' THEN 0
	WHEN a."HTd_Fld500" = 'Low' THEN 1
	WHEN a."HTd_Fld500" = 'Moderate' THEN 2
	WHEN a."HTd_Fld500" = 'Considerable' THEN 3
	WHEN a."HTd_Fld500" = 'High' THEN 4
	WHEN a."HTd_Fld500" = 'Extreme' THEN 5
	ELSE 0 END) * (CASE
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) IS NULL THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) = 0 THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END) + (CASE
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Fld500" < (SELECT fld_tsun_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Fld500" > (SELECT fld_tsun_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END) * (CASE
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) IS NULL THEN 0 -- catch null values from divide by zero error, set null
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) = 0 THEN 0
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END)) * c."SVlt_Score" AS "fld_priority_score_rel",

-- wildfire threat and prioritization
-- hazard intensity
a."HTi_Wildfire",

-- threat
a."HTd_Wildfire",

-- wildfire priority - absolute
CASE
	WHEN a."HTd_Wildfire" = 'None' THEN 0
	WHEN a."HTd_Wildfire" = 'Low' THEN 1
	WHEN a."HTd_Wildfire" = 'Moderate' THEN 2
	WHEN a."HTd_Wildfire" = 'Considerable' THEN 3
	WHEN a."HTd_Wildfire" = 'High' THEN 4
	WHEN a."HTd_Wildfire" = 'Extreme' THEN 5
	ELSE 0 END AS "wildfire_bld_dmg_pot_abs",
(CASE
	WHEN a."HTd_Wildfire" = 'None' THEN 0
	WHEN a."HTd_Wildfire" = 'Low' THEN 1
	WHEN a."HTd_Wildfire" = 'Moderate' THEN 2
	WHEN a."HTd_Wildfire" = 'Considerable' THEN 3
	WHEN a."HTd_Wildfire" = 'High' THEN 4
	WHEN a."HTd_Wildfire" = 'Extreme' THEN 5
	ELSE 0 END) * (CASE
	WHEN a."Et_AssetValue" = 0 THEN 0
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_AssetValue" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END) AS "wildfire_asset_loss_pot_abs",
CASE
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Wildfire" > (SELECT wildfire_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END AS "wildfire_human_impct_pot_abs",
(CASE
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Wildfire" > (SELECT wildfire_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END) * (CASE
	WHEN a."Et_PopNight" = 0 THEN 0
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_PopNight" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END) AS wildfire_human_loss_pot_abs,
((CASE
	WHEN a."HTd_Wildfire" = 'None' THEN 0
	WHEN a."HTd_Wildfire" = 'Low' THEN 1
	WHEN a."HTd_Wildfire" = 'Moderate' THEN 2
	WHEN a."HTd_Wildfire" = 'Considerable' THEN 3
	WHEN a."HTd_Wildfire" = 'High' THEN 4
	WHEN a."HTd_Wildfire" = 'Extreme' THEN 5
	ELSE 0 END) * (CASE
	WHEN a."Et_AssetValue" = 0 THEN 0
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_AssetValue" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END) + (CASE
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Wildfire" > (SELECT wildfire_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END) * (CASE
	WHEN a."Et_PopNight" = 0 THEN 0
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_PopNight" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END)) * c."SVlt_Score" AS "wildfire_priority_score_abs",

-- wildfire priority - relative
CASE
	WHEN a."HTd_Wildfire" = 'None' THEN 0
	WHEN a."HTd_Wildfire" = 'Low' THEN 1
	WHEN a."HTd_Wildfire" = 'Moderate' THEN 2
	WHEN a."HTd_Wildfire" = 'Considerable' THEN 3
	WHEN a."HTd_Wildfire" = 'High' THEN 4
	WHEN a."HTd_Wildfire" = 'Extreme' THEN 5
	ELSE 0 END AS "wildfire_bld_dmg_pot_rel",
(CASE
	WHEN a."HTd_Wildfire" = 'None' THEN 0
	WHEN a."HTd_Wildfire" = 'Low' THEN 1
	WHEN a."HTd_Wildfire" = 'Moderate' THEN 2
	WHEN a."HTd_Wildfire" = 'Considerable' THEN 3
	WHEN a."HTd_Wildfire" = 'High' THEN 4
	WHEN a."HTd_Wildfire" = 'Extreme' THEN 5
	ELSE 0 END) * (CASE
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) IS NULL THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) = 0 THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END) AS "wildfire_asset_loss_pot_rel",
CASE
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Wildfire" > (SELECT wildfire_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END AS "wildfire_human_impct_pot_rel",
(CASE
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Wildfire" > (SELECT wildfire_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END) * (CASE
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) IS NULL THEN 0 -- catch null values from divide by zero error, set null
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) = 0 THEN 0
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END) AS "wildfire_human_loss_pot_rel",
((CASE
	WHEN a."HTd_Wildfire" = 'None' THEN 0
	WHEN a."HTd_Wildfire" = 'Low' THEN 1
	WHEN a."HTd_Wildfire" = 'Moderate' THEN 2
	WHEN a."HTd_Wildfire" = 'Considerable' THEN 3
	WHEN a."HTd_Wildfire" = 'High' THEN 4
	WHEN a."HTd_Wildfire" = 'Extreme' THEN 5
	ELSE 0 END) * (CASE
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) IS NULL THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) = 0 THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END) + (CASE
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Wildfire" < (SELECT wildfire_pp_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Wildfire" > (SELECT wildfire_pp_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END) * (CASE
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) IS NULL THEN 0 -- catch null values from divide by zero error, set null
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) = 0 THEN 0
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END)) * c."SVlt_Score" AS "wildfire_priority_score_rel",
	
-- cyclone threat and prioritization
-- hazard intensity
"HTi_Cy500",

-- threat
"HTd_Cy500",

-- cyclone priority - absolute
CASE
	WHEN a."HTd_Cy500" = 'None' THEN 0
	WHEN a."HTd_Cy500" = 'Low' THEN 1
	WHEN a."HTd_Cy500" = 'Moderate' THEN 2
	WHEN a."HTd_Cy500" = 'Considerable' THEN 3
	WHEN a."HTd_Cy500" = 'High' THEN 4
	WHEN a."HTd_Cy500" = 'Extreme' THEN 5
	ELSE 0 END AS "cy_bld_dmg_pot_abs",
(CASE
	WHEN a."HTd_Cy500" = 'None' THEN 0
	WHEN a."HTd_Cy500" = 'Low' THEN 1
	WHEN a."HTd_Cy500" = 'Moderate' THEN 2
	WHEN a."HTd_Cy500" = 'Considerable' THEN 3
	WHEN a."HTd_Cy500" = 'High' THEN 4
	WHEN a."HTd_Cy500" = 'Extreme' THEN 5
	ELSE 0 END) * (CASE
	WHEN a."Et_AssetValue" = 0 THEN 0
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_AssetValue" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END) AS "cy_asset_loss_pot_abs",
CASE
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Cy500" > (SELECT cy_ppl_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END AS "cy_human_impct_pot_abs",
(CASE
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Cy500" > (SELECT cy_ppl_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END) * (CASE
	WHEN a."Et_PopNight" = 0 THEN 0
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_PopNight" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END) AS "cy_human_loss_pot_abs",
((CASE
	WHEN a."HTd_Cy500" = 'None' THEN 0
	WHEN a."HTd_Cy500" = 'Low' THEN 1
	WHEN a."HTd_Cy500" = 'Moderate' THEN 2
	WHEN a."HTd_Cy500" = 'Considerable' THEN 3
	WHEN a."HTd_Cy500" = 'High' THEN 4
	WHEN a."HTd_Cy500" = 'Extreme' THEN 5
	ELSE 0 END) * (CASE
	WHEN a."Et_AssetValue" = 0 THEN 0
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_AssetValue" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_AssetValue" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY "Et_AssetValue") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END) + (CASE
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Cy500" > (SELECT cy_ppl_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END) * (CASE
	WHEN a."Et_PopNight" = 0 THEN 0
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 1
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 2
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 3
	WHEN a."Et_PopNight" < (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 4
	WHEN a."Et_PopNight" > (SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY a."Et_PopNight") FROM results_nhsl_hazard_threat.hazard_threat_values_s a) THEN 5
	ELSE 0 END)) * c."SVlt_Score" AS "cy_priority_score_abs",

-- cyclone priority - relative
CASE
	WHEN a."HTd_Cy500" = 'None' THEN 0
	WHEN a."HTd_Cy500" = 'Low' THEN 1
	WHEN a."HTd_Cy500" = 'Moderate' THEN 2
	WHEN a."HTd_Cy500" = 'Considerable' THEN 3
	WHEN a."HTd_Cy500" = 'High' THEN 4
	WHEN a."HTd_Cy500" = 'Extreme' THEN 5
	ELSE 0 END AS "cy_bld_dmg_pot_rel",
(CASE
	WHEN a."HTd_Cy500" = 'None' THEN 0
	WHEN a."HTd_Cy500" = 'Low' THEN 1
	WHEN a."HTd_Cy500" = 'Moderate' THEN 2
	WHEN a."HTd_Cy500" = 'Considerable' THEN 3
	WHEN a."HTd_Cy500" = 'High' THEN 4
	WHEN a."HTd_Cy500" = 'Extreme' THEN 5
	ELSE 0 END) * (CASE
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) IS NULL THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) = 0 THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END) AS "cy_asset_loss_pot_rel",
CASE
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Cy500" > (SELECT cy_ppl_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END AS "cy_human_impct_pot_rel",
(CASE
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Cy500" > (SELECT cy_ppl_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END) * (CASE
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) IS NULL THEN 0 -- catch null values from divide by zero error, set null
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) = 0 THEN 0
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END) AS "cy_human_loss_pot_rel",
((CASE
	WHEN a."HTd_Cy500" = 'None' THEN 0
	WHEN a."HTd_Cy500" = 'Low' THEN 1
	WHEN a."HTd_Cy500" = 'Moderate' THEN 2
	WHEN a."HTd_Cy500" = 'Considerable' THEN 3
	WHEN a."HTd_Cy500" = 'High' THEN 4
	WHEN a."HTd_Cy500" = 'Extreme' THEN 5
	ELSE 0 END) * (CASE
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) IS NULL THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) = 0 THEN 0
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_AssetValue"/NULLIF(b."Et_AssetValue",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END) + (CASE
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'None') THEN 0
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Low') THEN 1
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Moderate') THEN 2
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Considerable') THEN 3
	WHEN a."HTi_Cy500" < (SELECT cy_ppl_to FROM mh.mh_ratings_thresholds WHERE impact_potential = 'High') THEN 4
	WHEN a."HTi_Cy500" > (SELECT cy_ppl_frm FROM mh.mh_ratings_thresholds WHERE impact_potential = 'Extreme') THEN 5
	ELSE 0 END) * (CASE
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) IS NULL THEN 0 -- catch null values from divide by zero error, set null
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) = 0 THEN 0
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 1
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.50) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 2
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 3
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) < 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 4
	WHEN (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)) > 
		(SELECT percentile_cont(0.95) WITHIN GROUP (ORDER BY (a."Et_PopNight"/NULLIF(b."Et_PopNight",0)))
		FROM results_nhsl_hazard_threat.hazard_threat_values_s a
		LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid) THEN 5
	ELSE 0 END)) * c."SVlt_Score" AS "cy_priority_score_rel",
0 AS total_abs_score,
0 AS total_rel_score,
a.geom_poly

FROM results_nhsl_hazard_threat.hazard_threat_values_s a
LEFT JOIN results_nhsl_hazard_threat.hazard_threat_values_csd b ON a.csduid = b.csduid
LEFT JOIN results_nhsl_social_fabric.nhsl_social_fabric_all_indicators_s_tbl c ON a."Sauid" = c."Sauid"
ORDER BY a."Sauid" ASC; 

-- update total absolute and relative scores
UPDATE results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_s_tbl
SET total_abs_score = eq_shaking_score_abs + fld_priority_score_abs + wildfire_priority_score_abs + cy_priority_score_abs;

UPDATE results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_s_tbl
SET total_rel_score = eq_shaking_score_rel + fld_priority_score_rel + wildfire_priority_score_rel + cy_priority_score_rel;



-- create view
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_s CASCADE;

CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_s AS 
SELECT * FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_s_tbl;

-- aggregate to csd level
DROP TABLE IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_prioritization_csd_tbl CASCADE;
CREATE TABLE results_nhsl_hazard_threat.nhsl_hazard_threat_prioritization_csd_tbl AS
SELECT
a.csduid,
b."CSDNAME",
SUM("E_AreaKm2") AS "Et_AreaKm2",
SUM("E_AreaHa") AS "Et_AreaHa",
SUM("Et_BldgNum") AS "Et_BldgNum",
SUM("Et_AssetValue") AS "Et_AssetValue",
SUM("Et_PopNight") AS "Et_PopNight",
SUM(eq_shaking_score_abs) AS "eq_shaking_score_abs",
SUM(eq_shaking_score_rel) AS "eq_shaking_score_rel",
SUM(fld_priority_score_abs) AS "fld_priority_score_abs",
SUM(fld_priority_score_rel) AS "fld_priority_score_rel",
SUM(wildfire_priority_score_abs) AS "wildfire_priority_score_abs",
SUM(wildfire_priority_score_rel) AS "wildfire_priority_score_rel",
SUM(cy_priority_score_abs) AS "cy_priority_score_abs",
SUM(cy_priority_score_rel) AS "cy_priority_score_rel",
SUM(total_abs_score) AS "total_abs_score",
SUM(total_rel_score) AS "total_rel_score",
b.geom
FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_s_tbl a
LEFT JOIN boundaries."Geometry_CSDUID" b on a.csduid = b."CSDUID"
GROUP BY a.csduid,b."CSDNAME",b.geom;

-- create view
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_prioritization_csd CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_prioritization_csd AS
SELECT * FROM results_nhsl_hazard_threat.nhsl_hazard_threat_prioritization_csd_tbl;