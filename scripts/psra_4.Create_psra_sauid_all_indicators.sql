CREATE SCHEMA IF NOT EXISTS results_psra_{prov};

-- create empty table for sri at SA level to be populated after calculation at national scale
DROP TABLE IF EXISTS results_psra_{prov}.psra_{prov}_eqriskindex CASCADE;
CREATE TABLE results_psra_{prov}.psra_{prov}_eqriskindex AS
(
SELECT
b.sauid,
b.csduid,
0.00 AS "eqri_abs_score_b0",
NULL AS "eqri_abs_rank_b0",
0.00 AS "eqri_norm_score_b0",
NULL AS "eqri_norm_rank_b0",
0.00 AS "eqri_abs_score_r1",
NULL AS "eqri_abs_rank_r1",
0.00 AS "eqri_norm_score_r1",
NULL AS "eqri_norm_rank_r1"

FROM psra_{prov}.psra_{prov}_avg_losses_stats a
LEFT JOIN exposure.canada_exposure b ON a.asset_id = b.id
GROUP BY b.sauid,b.csduid
);



-- create empty table for sri at SA level to be populated after calculation at national scale
DROP TABLE IF EXISTS results_psra_{prov}.psra_{prov}_eqriskindex_csd CASCADE;
CREATE TABLE results_psra_{prov}.psra_{prov}_eqriskindex_csd AS
(
SELECT
b.csduid,
0.00 AS "eqri_abs_score_b0",
NULL AS "eqri_abs_rank_b0",
0.00 AS "eqri_norm_score_b0",
NULL AS "eqri_norm_rank_b0",
0.00 AS "eqri_abs_score_r1",
NULL AS "eqri_abs_rank_r1",
0.00 AS "eqri_norm_score_r1",
NULL AS "eqri_norm_rank_r1"

FROM psra_{prov}.psra_{prov}_avg_losses_stats a
LEFT JOIN exposure.canada_exposure b ON a.asset_id = b.id
GROUP BY b.csduid
);


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
--CASE WHEN AVG((g.structural_complete_b0/a.number) * f.collapse_pc) >0.01 THEN SUM(a.number) ELSE 0 END AS "eDt_Fail_Collapse_b0",
CAST(CAST(ROUND(CAST(SUM(m."eD_Fail_Collapse_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Fail_Collapse_b0",

-- q05 - b0
CAST(CAST(ROUND(CAST(SUM(k.structural_slight_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Slight05_b0",
CAST(CAST(ROUND(CAST(AVG(k.structural_slight_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Slight05_b0",
CAST(CAST(ROUND(CAST(SUM(k.structural_moderate_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Moderate05_b0",
CAST(CAST(ROUND(CAST(AVG(k.structural_moderate_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Moderate05_b0",
CAST(CAST(ROUND(CAST(SUM(k.structural_extensive_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Extensive05_b0",
CAST(CAST(ROUND(CAST(AVG(k.structural_extensive_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Extensive05_b0",
CAST(CAST(ROUND(CAST(SUM(k.structural_complete_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Complete05_b0",
CAST(CAST(ROUND(CAST(AVG(k.structural_complete_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Complete05_b0",
CAST(CAST(ROUND(CAST(SUM(k.structural_complete_b0 * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Collapse05_b0",
CAST(CAST(ROUND(CAST(AVG(k.structural_complete_b0/a.number * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Collapse05_b0",
--CASE WHEN AVG((k.structural_complete_b0/a.number) * f.collapse_pc) >0.01 THEN SUM(a.number) ELSE 0 END AS "eDt_Fail_Collapse05_b0",
CAST(CAST(ROUND(CAST(SUM(m."eD_Fail_Collapse05_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Fail_Collapse05_b0",

-- q95 - b0
CAST(CAST(ROUND(CAST(SUM(l.structural_slight_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Slight95_b0",
CAST(CAST(ROUND(CAST(AVG(l.structural_slight_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Slight95_b0",
CAST(CAST(ROUND(CAST(SUM(l.structural_moderate_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Moderate95_b0",
CAST(CAST(ROUND(CAST(AVG(l.structural_moderate_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Moderate95_b0",
CAST(CAST(ROUND(CAST(SUM(l.structural_extensive_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Extensive95_b0",
CAST(CAST(ROUND(CAST(AVG(l.structural_extensive_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Extensive95_b0",
CAST(CAST(ROUND(CAST(SUM(l.structural_complete_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Complete95_b0",
CAST(CAST(ROUND(CAST(AVG(l.structural_complete_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Complete95_b0",
CAST(CAST(ROUND(CAST(SUM(l.structural_complete_b0 * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Collapse95_b0",
CAST(CAST(ROUND(CAST(AVG(l.structural_complete_b0/a.number * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Collapse95_b0",
--CASE WHEN AVG((l.structural_complete_b0/a.number) * f.collapse_pc) >0.01 THEN SUM(a.number) ELSE 0 END AS "eDt_Fail_Collapse95_b0",
CAST(CAST(ROUND(CAST(SUM(m."eD_Fail_Collapse95_b0") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Fail_Collapse95_b0",


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
--CASE WHEN AVG((g.structural_complete_r1/a.number) * f.collapse_pc) >0.01 THEN SUM(a.number) ELSE 0 END AS "eDt_Fail_Collapse_r1",
CAST(CAST(ROUND(CAST(SUM(m."eD_Fail_Collapse_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Fail_Collapse_r1",

-- q05 - r1
CAST(CAST(ROUND(CAST(SUM(k.structural_slight_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Slight05_r1",
CAST(CAST(ROUND(CAST(AVG(k.structural_slight_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Slight05_r1",
CAST(CAST(ROUND(CAST(SUM(k.structural_moderate_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Moderate05_r1",
CAST(CAST(ROUND(CAST(AVG(k.structural_moderate_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Moderate05_r1",
CAST(CAST(ROUND(CAST(SUM(k.structural_extensive_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Extensive05_r1",
CAST(CAST(ROUND(CAST(AVG(k.structural_extensive_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Extensive05_r1",
CAST(CAST(ROUND(CAST(SUM(k.structural_complete_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Complete05_r1",
CAST(CAST(ROUND(CAST(AVG(k.structural_complete_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Complete05_r1",
CAST(CAST(ROUND(CAST(SUM(k.structural_complete_r1 * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Collapse05_r1",
CAST(CAST(ROUND(CAST(AVG(k.structural_complete_r1/a.number * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Collapse05_r1",
--CASE WHEN AVG((k.structural_complete_r1/a.number) * f.collapse_pc) >0.01 THEN SUM(a.number) ELSE 0 END AS "eDt_Fail_Collapse05_r1",
CAST(CAST(ROUND(CAST(SUM(m."eD_Fail_Collapse05_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Fail_Collapse05_r1",

-- q95 - r1
CAST(CAST(ROUND(CAST(SUM(l.structural_slight_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Slight95_r1",
CAST(CAST(ROUND(CAST(AVG(l.structural_slight_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Slight95_r1",
CAST(CAST(ROUND(CAST(SUM(l.structural_moderate_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Moderate95_r1",
CAST(CAST(ROUND(CAST(AVG(l.structural_moderate_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Moderate95_r1",
CAST(CAST(ROUND(CAST(SUM(l.structural_extensive_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Extensive95_r1",
CAST(CAST(ROUND(CAST(AVG(l.structural_extensive_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Extensive95_r1",
CAST(CAST(ROUND(CAST(SUM(l.structural_complete_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Complete95_r1",
CAST(CAST(ROUND(CAST(AVG(l.structural_complete_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Complete95_r1",
CAST(CAST(ROUND(CAST(SUM(l.structural_complete_r1 * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Collapse95_r1",
CAST(CAST(ROUND(CAST(AVG(l.structural_complete_r1/a.number * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDtr_Collapse95_r1",
--CASE WHEN AVG((l.structural_complete_r1/a.number) * f.collapse_pc) >0.01 THEN SUM(a.number) ELSE 0 END AS "eDt_Fail_Collapse95_r1",
CAST(CAST(ROUND(CAST(SUM(m."eD_Fail_Collapse95_r1") AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Fail_Collapse95_r1",


-- 2.3 Affected People
-- 2.3.1 Life Safety - b0
-- CAST(CAST(ROUND(CAST(SUM(occupants_b0/0.000001) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eCt_Fatality_b0",
-- CAST(CAST(ROUND(CAST(AVG(COALESCE(occupants_b0/NULLIF(a.transit,0),0)/0.000001) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eCtr_Fatality_b0",
CAST(CAST(ROUND(CAST(SUM(occupants_b0) AS NUMERIC),10) AS FLOAT) AS NUMERIC) AS "eCt_Fatality_b0",
CAST(CAST(ROUND(CAST(AVG(COALESCE(occupants_b0/NULLIF(a.transit,0),10)) AS NUMERIC),10) AS FLOAT) AS NUMERIC) AS "eCtr_Fatality_b0",

-- 2.3.1 Life Safety - r1
-- CAST(CAST(ROUND(CAST(SUM(occupants_r1/0.000001) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eCt_Fatality_r1",
-- CAST(CAST(ROUND(CAST(AVG(COALESCE(occupants_r1/NULLIF(a.transit,0),0)/0.000001) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eCtr_Fatality_r1",
CAST(CAST(ROUND(CAST(SUM(occupants_r1) AS NUMERIC),10) AS FLOAT) AS NUMERIC) AS "eCt_Fatality_r1",
CAST(CAST(ROUND(CAST(AVG(COALESCE(occupants_r1/NULLIF(a.transit,0),10)) AS NUMERIC),10) AS FLOAT) AS NUMERIC) AS "eCtr_Fatality_r1",

-- 2.4.1 Average Annual Loss - b0
CAST(CAST(ROUND(CAST(SUM(i.structural_b0 + i.nonstructural_b0 + i.contents_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Asset_b0",
CAST(CAST(ROUND(CAST(AVG((i.structural_b0 + i.nonstructural_b0 + i.contents_b0)/(a.structural + a.nonstructural)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALm_Asset_b0",
CAST(CAST(ROUND(CAST(SUM(i.structural_b0 + i.nonstructural_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Bldg_b0",
CAST(CAST(ROUND(CAST(AVG((i.structural_b0 + i.nonstructural_b0)/(a.structural + a.nonstructural)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALm_Bldg_b0",
CAST(CAST(ROUND(CAST(SUM(i.structural_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Str_b0",
CAST(CAST(ROUND(CAST(SUM(i.nonstructural_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_NStr_b0",
CAST(CAST(ROUND(CAST(SUM(i.contents_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Cont_b0",


-- 2.4.1 Average Annual Loss - r1
CAST(CAST(ROUND(CAST(SUM(i.structural_r1 + i.nonstructural_r1 + i.contents_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Asset_r1",
CAST(CAST(ROUND(CAST(AVG((i.structural_r1 + i.nonstructural_r1 + i.contents_r1)/(a.structural + a.nonstructural)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALm_Asset_r1",
CAST(CAST(ROUND(CAST(SUM(i.structural_r1 + i.nonstructural_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Bldg_r1",
CAST(CAST(ROUND(CAST(AVG((i.structural_r1 + i.nonstructural_r1)/(a.structural + a.nonstructural)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALm_Bldg_r1",
CAST(CAST(ROUND(CAST(SUM(i.structural_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Str_r1",
CAST(CAST(ROUND(CAST(SUM(i.nonstructural_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_NStr_r1",
CAST(CAST(ROUND(CAST(SUM(i.contents_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Cont_r1",

-- eq risk index - b0
CAST(CAST(ROUND(CAST(j.eqri_abs_score_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eqri_abs_score_b0",
j.eqri_abs_rank_b0,
CAST(CAST(ROUND(CAST(j.eqri_norm_score_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eqri_norm_score_b0",
j.eqri_norm_rank_b0,

-- eq risk index - r1
CAST(CAST(ROUND(CAST(j.eqri_abs_score_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eqri_abs_score_r1",
j.eqri_abs_rank_r1,
CAST(CAST(ROUND(CAST(j.eqri_norm_score_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eqri_norm_score_r1",
j.eqri_norm_rank_r1,

z."PRUID" AS "pruid",
z."PRNAME" AS "prname",
z."ERUID" AS "eruid",
z."CDUID" AS "cduid",
z."CDNAME" AS "cdname",
z."CSDUID" AS "csduid",
z."CSDNAME" AS "csdname",
z."CFSAUID" AS "fsauid",
z."DAUIDt" AS "dauid",
z."SACCODE" AS "saccode",
z."SACTYPE" AS "sactype",
--z.geompoint AS "geom_point"
z.geom AS "geom_poly"

FROM exposure.canada_exposure a
LEFT JOIN psra_{prov}.psra_{prov}_hmaps_xref d ON a.id = d.id
LEFT JOIN vs30.vs30_can_site_model_xref e ON a.id = e.id
LEFT JOIN lut.collapse_probability f ON a.bldgtype = f.eqbldgtype
RIGHT JOIN psra_{prov}.psra_{prov}_ed_dmg_mean g ON a.id = g.asset_id
LEFT JOIN mh.mh_intensity_canada h ON a.sauid = h.sauidt
RIGHT JOIN psra_{prov}.psra_{prov}_avg_losses_stats i ON a.id = i.asset_id
LEFT JOIN psra_{prov}.psra_{prov}_ed_dmg_q05 k ON a.id = k.asset_id
RIGHT JOIN results_psra_{prov}.psra_{prov}_eqriskindex j ON a.sauid = j.sauid
LEFT JOIN psra_{prov}.psra_{prov}_ed_dmg_q95 l ON a.id = l.asset_id
LEFT JOIN results_psra_{prov}.psra_{prov}_indicators_b m ON a.id = m."AssetID"
LEFT JOIN boundaries."Geometry_SAUID" z ON a.sauid = z."SAUIDt"
GROUP BY a.sauid,d."PGA_0.02",d."SA(0.1)_0.02",d."SA(0.2)_0.02",d."SA(0.3)_0.02",d."SA(0.5)_0.02",d."SA(0.6)_0.02",d."SA(1.0)_0.02",d."SA(2.0)_0.02",
d."PGA_0.1",d."SA(0.1)_0.1",d."SA(0.2)_0.1",d."SA(0.3)_0.1",d."SA(0.5)_0.1",d."SA(0.6)_0.1",d."SA(1.0)_0.1",d."SA(2.0)_0.1",d."SA(5.0)_0.1",d."SA(10.0)_0.1",
e.vs_lon,e.vs_lat,e.vs30,e.z1pt0,e.z2pt5,h.mmi6,h.mmi7,h.mmi8,j.eqri_abs_score_b0,j.eqri_abs_rank_b0,j.eqri_norm_score_b0,j.eqri_norm_rank_b0,j.eqri_abs_score_r1,j.eqri_abs_rank_r1,
j.eqri_norm_score_r1,j.eqri_norm_rank_r1,z."PRUID",z."PRNAME",z."ERUID",z."CDUID",z."CDNAME",z."CSDUID",z."CSDNAME",z."CFSAUID",z."DAUIDt",z."SACCODE",z."SACTYPE",z.geom;



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
SUM("eDt_Fail_Collapse_b0") AS "eDt_Fail_Collapse_b0",

ROUND(SUM("eDt_Slight05_b0"),6) AS "eDt_Slight05_b0",
ROUND(AVG("eDtr_Slight05_b0"),6) AS "eDtr_Slight05_b0",
ROUND(SUM("eDt_Moderate05_b0"),6) AS "eDt_Moderate05_b0",
ROUND(AVG("eDtr_Moderate05_b0"),6) AS "eDtr_Moderate05_b0",
ROUND(SUM("eDt_Extensive05_b0"),6) AS "eDt_Extensive05_b0",
ROUND(AVG("eDtr_Extensive05_b0"),6) AS "eDtr_Extensive05_b0",
ROUND(SUM("eDt_Complete05_b0"),6) AS "eDt_Complete05_b0",
ROUND(AVG("eDtr_Complete05_b0"),6) AS "eDtr_Complete05_b0",
ROUND(SUM("eDt_Collapse05_b0"),6) AS "eDt_Collapse05_b0",
ROUND(AVG("eDtr_Collapse05_b0"),6) AS "eDtr_Collapse05_b0",
SUM("eDt_Fail_Collapse05_b0") AS "eDt_Fail_Collapse05_b0",

ROUND(SUM("eDt_Slight95_b0"),6) AS "eDt_Slight95_b0",
ROUND(AVG("eDtr_Slight95_b0"),6) AS "eDtr_Slight95_b0",
ROUND(SUM("eDt_Moderate95_b0"),6) AS "eDt_Moderate95_b0",
ROUND(AVG("eDtr_Moderate95_b0"),6) AS "eDtr_Moderate95_b0",
ROUND(SUM("eDt_Extensive95_b0"),6) AS "eDt_Extensive95_b0",
ROUND(AVG("eDtr_Extensive95_b0"),6) AS "eDtr_Extensive95_b0",
ROUND(SUM("eDt_Complete95_b0"),6) AS "eDt_Complete95_b0",
ROUND(AVG("eDtr_Complete95_b0"),6) AS "eDtr_Complete95_b0",
ROUND(SUM("eDt_Collapse95_b0"),6) AS "eDt_Collapse95_b0",
ROUND(AVG("eDtr_Collapse95_b0"),6) AS "eDtr_Collapse95_b0",
SUM("eDt_Fail_Collapse95_b0") AS "eDt_Fail_Collapse95_b0",

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
SUM("eDt_Fail_Collapse_r1") AS "eDt_Fail_Collapse_r1",

ROUND(SUM("eDt_Slight05_r1"),6) AS "eDt_Slight05_r1",
ROUND(AVG("eDtr_Slight05_r1"),6) AS "eDtr_Slight05_r1",
ROUND(SUM("eDt_Moderate05_r1"),6) AS "eDt_Moderate05_r1",
ROUND(AVG("eDtr_Moderate05_r1"),6) AS "eDtr_Moderate05_r1",
ROUND(SUM("eDt_Extensive05_r1"),6) AS "eDt_Extensive05_r1",
ROUND(AVG("eDtr_Extensive05_r1"),6) AS "eDtr_Extensive05_r1",
ROUND(SUM("eDt_Complete05_r1"),6) AS "eDt_Complete05_r1",
ROUND(AVG("eDtr_Complete05_r1"),6) AS "eDtr_Complete05_r1",
ROUND(SUM("eDt_Collapse05_r1"),6) AS "eDt_Collapse05_r1",
ROUND(AVG("eDtr_Collapse05_r1"),6) AS "eDtr_Collapse05_r1",
SUM("eDt_Fail_Collapse05_r1") AS "eDt_Fail_Collapse05_r1",

ROUND(SUM("eDt_Slight95_r1"),6) AS "eDt_Slight95_r1",
ROUND(AVG("eDtr_Slight95_r1"),6) AS "eDtr_Slight95_r1",
ROUND(SUM("eDt_Moderate95_r1"),6) AS "eDt_Moderate95_r1",
ROUND(AVG("eDtr_Moderate95_r1"),6) AS "eDtr_Moderate95_r1",
ROUND(SUM("eDt_Extensive95_r1"),6) AS "eDt_Extensive95_r1",
ROUND(AVG("eDtr_Extensive95_r1"),6) AS "eDtr_Extensive95_r1",
ROUND(SUM("eDt_Complete95_r1"),6) AS "eDt_Complete95_r1",
ROUND(AVG("eDtr_Complete95_r1"),6) AS "eDtr_Complete_95r1",
ROUND(SUM("eDt_Collapse95_r1"),6) AS "eDt_Collapse95_r1",
ROUND(AVG("eDtr_Collapse95_r1"),6) AS "eDtr_Collapse95_r1",
SUM("eDt_Fail_Collapse95_r1") AS "eDt_Fail_Collapse95_r1",

ROUND(SUM("eCt_Fatality_b0"),10) AS "eC_Fatality_b0",
ROUND(AVG("eCtr_Fatality_b0"),10) AS "eCr_Fatality_b0",

ROUND(SUM("eCt_Fatality_r1"),10) AS "eC_Fatality_r1",
ROUND(AVG("eCtr_Fatality_r1"),10) AS "eCr_Fatality_r1",

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

-- placeholder for sri indicators to be updated
ROUND(SUM(a.eqri_abs_score_b0),6) AS "eqri_abs_score_b0",
c.eqri_abs_rank_b0,
ROUND(AVG(a.eqri_norm_score_b0),6) AS "eqri_norm_score_b0",
c.eqri_norm_rank_b0,
ROUND(SUM(a.eqri_abs_score_r1),6) AS "eqri_abs_score_r1",
c.eqri_abs_rank_r1,
ROUND(AVG(a.eqri_norm_score_r1),6) AS "eqri_norm_score_r1",
c.eqri_norm_rank_r1,

b.geom

FROM results_psra_{prov}.psra_{prov}_indicators_s a
LEFT JOIN boundaries."Geometry_CSDUID" b ON a.csduid = b."CSDUID"
LEFT JOIN results_psra_{prov}.psra_{prov}_eqriskindex_csd c ON a.csduid = c.csduid
GROUP BY a.csduid,a.csdname,c.eqri_abs_rank_b0,c.eqri_norm_rank_b0,c.eqri_abs_rank_r1,c.eqri_norm_rank_r1,b.geom;



-- create psra indicators
DROP VIEW IF EXISTS results_psra_{prov}.psra_{prov}_expected_loss_fsa CASCADE;
CREATE VIEW results_psra_{prov}.psra_{prov}_expected_loss_fsa AS

-- 2.0 Seismic Risk (PSRA)
-- 2.4 Economic Security
SELECT
a.fsauid AS "eEL_FSAUID",

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
a."OccType" AS "eEL_OccGen",
a."GenType" AS "eEL_BldgType",
a.region AS "e_Aggregation"
-- UPPER('{prov}') AS "e_Aggregation"
--b.geom  -in case fsa geom is needed

FROM psra_{prov}.psra_{prov}_agg_curves_stats a
FULL JOIN psra_{prov}.psra_{prov}_agg_curves_q05 b ON a.return_period = b.return_period AND a.loss_type = b.loss_type AND a.fsauid = b.fsauid AND a."OccType" = b."OccType" AND a."GenType" = b."GenType" 
	AND a.annual_frequency_of_exceedence = b.annual_frequency_of_exceedence
FULL JOIN psra_{prov}.psra_{prov}_agg_curves_q95 c ON a.return_period = c.return_period AND a.loss_type = c.loss_type AND a.fsauid = c.fsauid AND a."OccType" = c."OccType" AND a."GenType" = c."GenType" 
	AND a.annual_frequency_of_exceedence = c.annual_frequency_of_exceedence
ORDER BY a.return_period,a.fsauid ASC;
--LEFT JOIN boundaries."Geometry_FSAUID" b ON a.fsauid = b."CFSAUID";



-- create psra indicators
DROP VIEW IF EXISTS results_psra_{prov}.psra_{prov}_agg_loss_fsa CASCADE;
CREATE VIEW results_psra_{prov}.psra_{prov}_agg_loss_fsa AS

SELECT
a.fsauid AS "e_FSAUID",
a.loss_type AS "e_LossType",
a."OccType" AS "e_OccGen",
a."GenType" AS "e_BldgType",
a.region AS "e_Aggregation",

-- agg losses stats
COALESCE(a.loss_value_b0,0) AS "e_LossValue_b0",
COALESCE(a.exposed_value_b0,0) AS "e_ExposedValue_b0",
COALESCE(a.loss_ratio_b0,0) AS "e_LossRatio_b0",
COALESCE(a.loss_value_r1,0) AS "e_LossValue_r1",
COALESCE(a.exposed_value_r1,0) AS "e_ExposedValue_r1",
COALESCE(a.loss_ratio_r1,0) AS "e_LossRatio_r1",

-- q05
COALESCE(b.loss_value_b0,0) AS "e_LossValue05_b0",
COALESCE(b.exposed_value_b0,0) AS "e_ExposedValue05_b0",
COALESCE(b.loss_ratio_b0,0) AS "e_LossRatio05_b0",
COALESCE(b.loss_value_r1,0) AS "e_LossValue05_r1",
COALESCE(b.exposed_value_r1,0) AS "e_ExposedValue05_r1",
COALESCE(b.loss_ratio_r1,0) AS "e_LossRatio05_r1",

-- q95
COALESCE(c.loss_value_b0,0) AS "e_LossValue95_b0",
COALESCE(c.exposed_value_b0,0) AS "e_ExposedValue95_b0",
COALESCE(c.loss_ratio_b0,0) AS "e_LossRatio95_b0",
COALESCE(c.loss_value_r1,0) AS "e_LossValue95_r1",
COALESCE(c.exposed_value_r1,0) AS "e_ExposedValue95_r1",
COALESCE(c.loss_ratio_r1,0) AS "e_LossRatio95_r1"

FROM psra_{prov}.psra_{prov}_agg_losses_stats a
LEFT JOIN psra_{prov}.psra_{prov}_agg_losses_q05 b ON a.loss_type = b.loss_type AND a.fsauid = b.fsauid AND a."OccType" = b."OccType" AND a."GenType" = b."GenType"
LEFT JOIN psra_{prov}.psra_{prov}_agg_losses_q95 c ON a.loss_type = c.loss_type AND a.fsauid = c.fsauid AND a."OccType" = c."OccType" AND a."GenType" = c."GenType"
ORDER BY a.loss_type,a.fsauid ASC;