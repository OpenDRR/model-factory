CREATE SCHEMA IF NOT EXISTS results_psra_{prov};



-- calculate new EQRiskIndex indicator for PSRA
DROP TABLE IF EXISTS results_psra_{prov}.psra_{prov}_eqriskindex_calc CASCADE;
CREATE TABLE results_psra_{prov}.psra_{prov}_eqriskindex_calc AS
(
SELECT
a.asset_id,
b.sauid,
a.structural_b0,
a.nonstructural_b0,
a.contents_b0,
a.occupants_b0 AS "lifeloss_b0",
a.contents_b0 + a.nonstructural_b0 + a.structural_b0 AS "asset_loss_b0",
a.structural_r1,
a.nonstructural_r1,
a.contents_r1,
a.occupants_r1 AS "lifeloss_r1",
a.contents_r1 + a.nonstructural_r1 + a.structural_r1 AS "asset_loss_r1",
b.structural,
b.nonstructural,
b.contents,
b.structural + b.nonstructural + b.contents AS "asset_value",
b.night,
COALESCE((a.contents_b0 + a.nonstructural_b0 + a.structural_b0)/NULLIF((b.structural + b.nonstructural + b.contents),0),0) AS "bldglossratio_b0",
COALESCE((a.contents_r1 + a.nonstructural_b0 + a.structural_r1)/NULLIF((b.structural + b.nonstructural + b.contents),0),0) AS "bldglossratio_r1",
COALESCE(a.occupants_b0/NULLIF(b.night,0),0) AS "lifelossratio_b0",
COALESCE(a.occupants_r1/NULLIF(b.night,0),0) AS "lifelossratio_r1"

FROM psra_{prov}.psra_{prov}_avg_losses_stats a
--FROM psra_{prov}.psra_{prov}_avg_losses_stats a
LEFT JOIN exposure.canada_exposure b ON a.asset_id = b.id
);



DROP TABLE IF EXISTS results_psra_{prov}.psra_{prov}_eqriskindex CASCADE;
CREATE TABLE results_psra_{prov}.psra_{prov}_eqriskindex AS
(
SELECT
a.sauid,
SUM(a.asset_loss_b0) AS "asset_loss_b0",
SUM(a.asset_loss_r1) AS "asset_loss_r1",
SUM(a.lifeloss_b0) AS "lifeloss_b0",
SUM(a.lifeloss_r1) AS "lifeloss_r1",
SUM(a.lifeloss_b0 * 8000000) AS "lifelosscost_b0",
SUM(a.lifeloss_r1 * 8000000) AS "lifelosscost_r1",
AVG(a.bldglossratio_b0) AS "bldglossratio_b0",
AVG(a.bldglossratio_r1) AS "bldglossratio_r1",
AVG(a.lifelossratio_b0) AS "lifelossratio_b0",
AVG(a.lifelossratio_r1) AS "lifelossratio_r1",
b."SVlt_Score" + 1 AS "SVlt_Score_translated",

--EQ Risk Index calculations
(SUM(a.asset_loss_b0) + SUM(a.lifeloss_b0 * 8000000)) * (b."SVlt_Score" + 1) AS "eqri_abs_score_b0",
'null' AS "eqri_abs_rating_b0",
(AVG(a.bldglossratio_b0) + AVG(a.lifelossratio_b0)) * (b."SVlt_Score" + 1) AS "eqri_rel_score_b0",
'null' AS "eqri_rel_rating_b0",
(SUM(a.asset_loss_r1) + SUM(a.lifeloss_r1 * 8000000)) * (b."SVlt_Score" + 1) AS "eqri_abs_score_r1",
'null' AS "eqri_abs_rating_r1",
(AVG(a.bldglossratio_r1) + AVG(a.lifelossratio_r1)) * (b."SVlt_Score" + 1) AS "eqri_rel_score_r1",
'null' AS "eqri_rel_rating_r1"

FROM results_psra_{prov}.psra_{prov}_eqriskindex_calc a
--FROM results_psra_{prov}.psra_{prov}_eqriskindex_calcs a
LEFT JOIN results_nhsl_social_fabric.nhsl_social_fabric_indicators_s b ON a.sauid = b."Sauid"
GROUP BY a.sauid,b."SVlt_Score"
);



--create threshold lookup table for rating
--DROP TABLE IF EXISTS results_psra_{prov}.psra_{prov}_eqri_thresholds CASCADE;
--CREATE TABLE results_psra_{prov}.psra__{prov}_eqri_thresholds AS
DROP TABLE IF EXISTS results_psra_{prov}.psra_{prov}_eqri_thresholds CASCADE;
CREATE TABLE results_psra_{prov}.psra_{prov}_eqri_thresholds
(
percentile NUMERIC,
abs_score_threshold_b0 FLOAT DEFAULT 0,
abs_score_threshold_r1 FLOAT DEFAULT 0,
rel_score_threshold_b0 FLOAT DEFAULT 0,
rel_score_threshold_r1 FLOAT DEFAULT 0,
rating VARCHAR
);



--insert default values
--INSERT INTO results_psra_{prov}.psra_{prov}_eqri_thresholds (percentile,rating) VALUES
INSERT INTO results_psra_{prov}.psra_{prov}_eqri_thresholds (percentile,rating) VALUES
(0,'Very Low'),
(0.35,'Relatively Low'),
(0.60,'Relatively Moderate'),
(0.80,'Relatively High'),
(0.95,'Very High');

--update values with calculated percentiles
--0.35 percentile
UPDATE results_psra_{prov}.psra_{prov}_eqri_thresholds 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.35) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_{prov}.psra_{prov}_eqriskindex),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.35) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_{prov}.psra_{prov}_eqriskindex),
	rel_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.35) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_{prov}.psra_{prov}_eqriskindex),
	rel_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.35) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_{prov}.psra_{prov}_eqriskindex) WHERE percentile = 0.35;

-- 0.60 percentile
UPDATE results_psra_{prov}.psra_{prov}_eqri_thresholds 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.60) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_{prov}.psra_{prov}_eqriskindex),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.60) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_{prov}.psra_{prov}_eqriskindex),
	rel_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.60) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_{prov}.psra_{prov}_eqriskindex),
	rel_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.60) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_{prov}.psra_{prov}_eqriskindex) WHERE percentile = 0.60;
	
-- 0.80 percentile
UPDATE results_psra_{prov}.psra_{prov}_eqri_thresholds 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_{prov}.psra_{prov}_eqriskindex),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_{prov}.psra_{prov}_eqriskindex),
	rel_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_{prov}.psra_{prov}_eqriskindex),
	rel_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_{prov}.psra_{prov}_eqriskindex) WHERE percentile = 0.80;
	
-- 0.95 percentile
UPDATE results_psra_{prov}.psra_{prov}_eqri_thresholds 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_{prov}.psra_{prov}_eqriskindex),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_{prov}.psra_{prov}_eqriskindex),
	rel_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_{prov}.psra_{prov}_eqriskindex),
	rel_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_{prov}.psra_{prov}_eqriskindex) WHERE percentile = 0.95;


-- update rating with threshold lookup table values
UPDATE results_psra_{prov}.psra_{prov}_eqriskindex
SET eqri_abs_rating_b0 =
	CASE 
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.35) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.60) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.35)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.80) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.6)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.8)
		WHEN eqri_abs_score_b0 > (SELECT abs_score_threshold_b0 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.95)
		ELSE 'Error' END,
	eqri_abs_rating_r1 =
	CASE 
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.35) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.60) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.35)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.80) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.6)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.8)
		WHEN eqri_abs_score_r1 > (SELECT abs_score_threshold_r1 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.95)
		ELSE 'Error' END,
	eqri_rel_rating_b0 =
	CASE 
		WHEN eqri_rel_score_b0 < (SELECT rel_score_threshold_b0 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.35) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0)
		WHEN eqri_rel_score_b0 < (SELECT rel_score_threshold_b0 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.60) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.35)
		WHEN eqri_rel_score_b0 < (SELECT rel_score_threshold_b0 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.80) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.6)
		WHEN eqri_rel_score_b0 < (SELECT rel_score_threshold_b0 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.8)
		WHEN eqri_rel_score_b0 > (SELECT rel_score_threshold_b0 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.95)
		ELSE 'Error' END,
	eqri_rel_rating_r1 =
	CASE 
		WHEN eqri_rel_score_r1 < (SELECT rel_score_threshold_r1 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.35) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0)
		WHEN eqri_rel_score_r1 < (SELECT rel_score_threshold_r1 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.60) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.35)
		WHEN eqri_rel_score_r1 < (SELECT rel_score_threshold_r1 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.80) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.6)
		WHEN eqri_rel_score_r1 < (SELECT rel_score_threshold_r1 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.8)
		WHEN eqri_rel_score_r1 > (SELECT rel_score_threshold_r1 FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_{prov}.psra_{prov}_eqri_thresholds WHERE percentile = 0.95)
		ELSE 'Error' END;



-- create psra indicators
DROP VIEW IF EXISTS results_psra_{prov}.psra_{prov}_indicators_s CASCADE;
CREATE VIEW results_psra_{prov}.psra_{prov}_indicators_s AS 


-- 2.0 Seismic Risk (PSRA)
-- 2.1 Probabilistic Seismic Hazard
-- 2.1.1 500yr Hazard Intensity
SELECT 
a.sauid AS "Sauid",


-- 2.2 Building Damage

-- 2.2.2 Event-Based Damage - b0
CAST(CAST(ROUND(CAST(SUM(g.structural_slight_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Slight_b0",
CAST(CAST(ROUND(CAST(AVG(g.structural_slight_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Slight_b0",

CAST(CAST(ROUND(CAST(SUM(g.structural_moderate_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Moderate_b0",
CAST(CAST(ROUND(CAST(AVG(g.structural_moderate_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Moderate_b0",

CAST(CAST(ROUND(CAST(SUM(g.structural_extensive_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Extensive_b0",
CAST(CAST(ROUND(CAST(AVG(g.structural_extensive_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Extensive_b0",

CAST(CAST(ROUND(CAST(SUM(g.structural_complete_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Complete_b0",
CAST(CAST(ROUND(CAST(AVG(g.structural_complete_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Complete_b0",

CAST(CAST(ROUND(CAST(SUM(g.structural_complete_b0 * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Collapse_b0",
CAST(CAST(ROUND(CAST(AVG((g.structural_complete_b0/a.number) * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Collapse_b0",

-- 2.2.2 Event-Based Damage - r1
CAST(CAST(ROUND(CAST(SUM(g.structural_slight_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Slight_r1",
CAST(CAST(ROUND(CAST(AVG(g.structural_slight_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Slight_r1",
CAST(CAST(ROUND(CAST(SUM(g.structural_moderate_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Moderate_r1",
CAST(CAST(ROUND(CAST(AVG(g.structural_moderate_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Moderate_r1",
CAST(CAST(ROUND(CAST(SUM(g.structural_extensive_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Extensive_r1",
CAST(CAST(ROUND(CAST(AVG(g.structural_extensive_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Extensive_r1",
CAST(CAST(ROUND(CAST(SUM(g.structural_complete_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Complete_r1",
CAST(CAST(ROUND(CAST(AVG(g.structural_complete_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Complete_r1",
CAST(CAST(ROUND(CAST(SUM(g.structural_complete_r1 * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Collapse_r1",
CAST(CAST(ROUND(CAST(AVG((g.structural_complete_r1/a.number) * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Collapse_r1",


-- 2.3 Affected People
-- 2.3.1 Life Safety - b0
CAST(CAST(ROUND(CAST(SUM(occupants_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eC_Fatality_b0",
CAST(CAST(ROUND(CAST(AVG(COALESCE(occupants_b0/NULLIF(a.night,0),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eCr_Fatality_b0",

-- 2.3.1 Life Safety - r1
CAST(CAST(ROUND(CAST(SUM(occupants_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eC_Fatality_r1",
CAST(CAST(ROUND(CAST(AVG(COALESCE(occupants_r1/NULLIF(a.night,0),0)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eCr_Fatality_r1",

-- 2.4.1 Average Annual Loss - b0
CAST(CAST(ROUND(CAST(SUM(i.structural_b0 + i.nonstructural_b0 + i.contents_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Asset_b0",
CAST(CAST(ROUND(CAST(AVG((i.structural_b0 + i.nonstructural_b0 + i.contents_b0)/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALm_Asset_b0",
CAST(CAST(ROUND(CAST(SUM(i.structural_b0 + i.nonstructural_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Bldg_b0",
CAST(CAST(ROUND(CAST(AVG((i.structural_b0 + i.nonstructural_b0)/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALm_Bldg_b0",
CAST(CAST(ROUND(CAST(SUM(i.structural_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Str_b0",
CAST(CAST(ROUND(CAST(SUM(i.nonstructural_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_NStr_b0",
CAST(CAST(ROUND(CAST(SUM(i.contents_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Cont_b0",


-- 2.4.1 Average Annual Loss - r1
CAST(CAST(ROUND(CAST(SUM(i.structural_r1 + i.nonstructural_r1 + i.contents_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Asset_r1",
CAST(CAST(ROUND(CAST(AVG((i.structural_r1 + i.nonstructural_r1 + i.contents_r1)/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALm_Asset_r1",
CAST(CAST(ROUND(CAST(SUM(i.structural_r1 + i.nonstructural_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Bldg_r1",
CAST(CAST(ROUND(CAST(AVG((i.structural_r1 + i.nonstructural_r1)/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALm_Bldg_r1",
CAST(CAST(ROUND(CAST(SUM(i.structural_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Str_r1",
CAST(CAST(ROUND(CAST(SUM(i.nonstructural_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_NStr_r1",
CAST(CAST(ROUND(CAST(SUM(i.contents_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Cont_r1",

-- eq risk index - b0
CAST(CAST(ROUND(CAST(j.eqri_abs_score_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eqri_abs_score_b0",
j.eqri_abs_rating_b0,
CAST(CAST(ROUND(CAST(j.eqri_rel_score_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eqri_rel_score_b0",
j.eqri_rel_rating_b0,

-- eq risk index - r1
CAST(CAST(ROUND(CAST(j.eqri_abs_score_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eqri_abs_score_r1",
j.eqri_abs_rating_r1,
CAST(CAST(ROUND(CAST(j.eqri_rel_score_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eqri_rel_score_r1",
j.eqri_rel_rating_r1,

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
a.landuse,
--z.geompoint AS "geom_point"
z.geom AS "geom_poly"

FROM exposure.canada_exposure a
LEFT JOIN psra_{prov}.psra_{prov}_hmaps_xref d ON a.id = d.id
LEFT JOIN vs30.vs30_can_site_model_xref e ON a.id = e.id
LEFT JOIN lut.collapse_probability f ON a.bldgtype = f.eqbldgtype
RIGHT JOIN psra_{prov}.psra_{prov}_ed_dmg_mean g ON a.id = g.asset_id
LEFT JOIN mh.mh_intensity_canada h ON a.sauid = h.sauidt
RIGHT JOIN psra_{prov}.psra_{prov}_avg_losses_stats i ON a.id = i.asset_id
RIGHT JOIN results_psra_{prov}.psra_{prov}_eqriskindex j ON a.sauid = j.sauid

LEFT JOIN boundaries."Geometry_SAUID" z ON a.sauid = z."SAUIDt"
GROUP BY a.sauid,a.landuse,d."PGA_0.02",d."SA(0.1)_0.02",d."SA(0.2)_0.02",d."SA(0.3)_0.02",d."SA(0.5)_0.02",d."SA(0.6)_0.02",d."SA(1.0)_0.02",d."SA(2.0)_0.02",
d."PGA_0.1",d."SA(0.1)_0.1",d."SA(0.2)_0.1",d."SA(0.3)_0.1",d."SA(0.5)_0.1",d."SA(0.6)_0.1",d."SA(1.0)_0.1",d."SA(2.0)_0.1",d."SA(5.0)_0.1",d."SA(10.0)_0.1",
e.vs_lon,e.vs_lat,e.vs30,e.z1pt0,e.z2pt5,h.mmi6,h.mmi7,h.mmi8,j.eqri_abs_score_b0,j.eqri_abs_rating_b0,j.eqri_rel_score_b0,j.eqri_rel_rating_b0,j.eqri_abs_score_r1,j.eqri_abs_rating_r1,
j.eqri_rel_score_r1,j.eqri_rel_rating_r1,z."PRUID",z."PRNAME",z."ERUID",z."ERNAME",z."CDUID",z."CDNAME",z."CSDUID",z."CSDNAME",z."CFSAUID",z."DAUIDt",z."SACCODE",z."SACTYPE",z.geom;



-- aggregate to csd level
DROP VIEW IF EXISTS results_psra_{prov}.psra_{prov}_indicators_csd CASCADE;
CREATE VIEW results_psra_{prov}.psra_{prov}_indicators_csd AS 

SELECT
a.csduid,
a.csdname,
ROUND(SUM("eDt_Slight_b0"),6) AS "eDt_Slight_b0",
ROUND(AVG("eDtr_Slight_b0"),6) AS "eDtr_Slight_b0",
ROUND(SUM("eDt_Moderate_b0"),6) AS "eDt_Moderate_b0",
ROUND(AVG("eDtr_Moderate_b0"),6) AS "eDtr_Moderate_b0",
ROUND(SUM("eDt_Extensive_b0"),6) AS "eDt_Extensive_b0",
ROUND(AVG("eDtr_Extensive_b0"),6) AS "eDtr_Extensive_b0",
ROUND(SUM("eDt_Complete_b0"),6) AS "eDt_Complete_b0",
ROUND(AVG("eDtr_Complete_b0"),6) AS "eDtr_Complete_b0",
ROUND(SUM("eDt_Collapse_b0"),6) AS "eDt_Collapse_b0",
ROUND(AVG("eDtr_Collapse_b0"),6) AS "eDtr_Collapse_b0",

ROUND(SUM("eDt_Slight_r1"),6) AS "eDt_Slight_r1",
ROUND(AVG("eDtr_Slight_r1"),6) AS "eDtr_Slight_r1",
ROUND(SUM("eDt_Moderate_r1"),6) AS "eDt_Moderate_r1",
ROUND(AVG("eDtr_Moderate_r1"),6) AS "eDtr_Moderate_r1",
ROUND(SUM("eDt_Extensive_r1"),6) AS "eDt_Extensive_r1",
ROUND(AVG("eDtr_Extensive_r1"),6) AS "eDtr_Extensive_r1",
ROUND(SUM("eDt_Complete_r1"),6) AS "eDt_Complete_r1",
ROUND(AVG("eDtr_Complete_r1"),6) AS "eDtr_Complete_r1",
ROUND(SUM("eDt_Collapse_r1"),6) AS "eDt_Collapse_r1",
ROUND(AVG("eDtr_Collapse_r1"),6) AS "eDtr_Collapse_r1",

ROUND(SUM("eC_Fatality_b0"),6) AS "eC_Fatality_b0",
ROUND(AVG("eCr_Fatality_b0"),6) AS "eCr_Fatality_b0",

ROUND(SUM("eC_Fatality_r1"),6) AS "eC_Fatality_r1",
ROUND(AVG("eCr_Fatality_r1"),6) AS "eCr_Fatality_r1",

ROUND(SUM("eAALt_Asset_b0"),6) AS "eAALt_Asset_b0",
ROUND(AVG("eAALm_Asset_b0"),6) AS "eAALm_Asset_b0",
ROUND(SUM("eAALt_Bldg_b0"),6) AS "eAALt_Bldg_b0",
ROUND(AVG("eAALm_Bldg_b0"),6) AS "eAALm_Bldg_b0",
ROUND(SUM("eAALt_Str_b0"),6) AS "eAALt_Str_b0",
ROUND(SUM("eAALt_NStr_b0"),6) AS "eAALt_NStr_b0",
ROUND(SUM("eAALt_Cont_b0"),6) AS "eAALt_Cont_b0",

ROUND(SUM("eAALt_Asset_r1"),6) AS "eAALt_Asset_r1",
ROUND(AVG("eAALm_Asset_r1"),6) AS "eAALm_Asset_r1",
ROUND(SUM("eAALt_Bldg_r1"),6) AS "eAALt_Bldg_r1",
ROUND(AVG("eAALm_Bldg_r1"),6) AS "eAALm_Bldg_r1",
ROUND(SUM("eAALt_Str_r1"),6) AS "eAALt_Str_r1",
ROUND(SUM("eAALt_NStr_r1"),6) AS "eAALt_NStr_r1",
ROUND(SUM("eAALt_Cont_r1"),6) AS "eAALt_Cont_r1",

b.geom

FROM results_psra_{prov}.psra_{prov}_indicators_s a
LEFT JOIN boundaries."Geometry_CSDUID" b ON a.csduid = b."CSDUID"
GROUP BY a.csduid,a.csdname,b.geom;



-- create psra indicators
DROP VIEW IF EXISTS results_psra_{prov}.psra_{prov}_expected_loss_fsa CASCADE;
CREATE VIEW results_psra_{prov}.psra_{prov}_expected_loss_fsa AS

-- 2.0 Seismic Risk (PSRA)
-- 2.4 Economic Security
SELECT
a.fsauid AS "e_FSAUID",

-- 2.4.2 Expected Loss
COALESCE(a.loss_value_b0,0) AS "eEL_b0",
COALESCE(a.loss_ratio_b0,0) AS "eELr_b0",
COALESCE(a.loss_value_r1,0) AS "eEL_r1",
COALESCE(a.loss_ratio_r1,0) AS "eELr_r1",

-- q05
COALESCE(b.loss_value_b0,0) AS "e5L_b0",
COALESCE(b.loss_ratio_b0,0) AS "e5Lr_b0",
COALESCE(b.loss_value_r1,0) AS "e5L_r1",
COALESCE(b.loss_ratio_r1,0) AS "e5Lr_r1",

-- q95
COALESCE(c.loss_value_b0,0) AS "e95L_b0",
COALESCE(c.loss_ratio_b0,0) AS "e95Lr_b0",
COALESCE(c.loss_value_r1,0) AS "e95L_r1",
COALESCE(c.loss_ratio_r1,0) AS "e95Lr_r1",

a.loss_type AS "eEL_type",
a.return_period AS "eEL_Period",
a.annual_frequency_of_exceedence AS "eEL_Probability",
a."GenOcc" AS "eEL_OccGen",
a."GenType" AS "eEL_BldgType",
UPPER('{prov}') AS "e_Aggregation"
--b.geom  -in case fsa geom is needed

FROM psra_{prov}.psra_{prov}_agg_curves_stats a
FULL JOIN psra_{prov}.psra_{prov}_agg_curves_q05 b ON a.return_period = b.return_period AND a.loss_type = b.loss_type AND a.fsauid = b.fsauid AND a."GenOcc" = b."GenOcc" AND a."GenType" = b."GenType" 
	AND a.annual_frequency_of_exceedence = b.annual_frequency_of_exceedence
FULL JOIN psra_{prov}.psra_{prov}_agg_curves_q95 c ON a.return_period = c.return_period AND a.loss_type = c.loss_type AND a.fsauid = c.fsauid AND a."GenOcc" = c."GenOcc" AND a."GenType" = c."GenType" 
	AND a.annual_frequency_of_exceedence = c.annual_frequency_of_exceedence
ORDER BY a.fsauid ASC;
--LEFT JOIN boundaries."Geometry_FSAUID" b ON a.fsauid = b."CFSAUID";


