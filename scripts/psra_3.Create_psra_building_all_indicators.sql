CREATE SCHEMA IF NOT EXISTS results_psra_{prov};

-- create psra indicators
DROP VIEW IF EXISTS results_psra_{prov}.psra_{prov}_indicators_b CASCADE;
CREATE VIEW results_psra_{prov}.psra_{prov}_indicators_b AS 

-- 2.0 Seismic Risk (PSRA)
-- 2.1 Probabilistic Seismic Hazard
-- 2.1.1 500yr Hazard Intensity
SELECT 
a.id AS "AssetID",

-- 2.2.2 Event-Based Damage - b0
CAST(CAST(ROUND(CAST(g.structural_slight_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Slight_b0",
CAST(CAST(ROUND(CAST((g.structural_slight_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Slight_b0",

CAST(CAST(ROUND(CAST(g.structural_moderate_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Moderate_b0",
CAST(CAST(ROUND(CAST((g.structural_moderate_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Moderate_b0",

CAST(CAST(ROUND(CAST(g.structural_extensive_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Extensive_b0",
CAST(CAST(ROUND(CAST((g.structural_extensive_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Extensive_b0",

CAST(CAST(ROUND(CAST(g.structural_complete_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Complete_b0",
CAST(CAST(ROUND(CAST((g.structural_complete_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Complete_b0",

CAST(CAST(ROUND(CAST(g.structural_complete_b0 * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Collapse_b0",
CAST(CAST(ROUND(CAST((g.structural_complete_b0/a.number) * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Collapse_b0",
CASE WHEN ((g.structural_complete_b0/a.number) * f.collapse_pc) >0.01 THEN a.number ELSE 0 END AS "eD_Fail_Collapse_b0",

-- q05 - b0
CAST(CAST(ROUND(CAST(j.structural_slight_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Slight05_b0",
CAST(CAST(ROUND(CAST((j.structural_slight_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Slight05_b0",
CAST(CAST(ROUND(CAST(j.structural_moderate_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Moderate05_b0",
CAST(CAST(ROUND(CAST((j.structural_moderate_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Moderate05_b0",
CAST(CAST(ROUND(CAST(j.structural_extensive_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Extensive05_b0",
CAST(CAST(ROUND(CAST((j.structural_extensive_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Extensive05_b0",
CAST(CAST(ROUND(CAST(j.structural_complete_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Complete05_b0",
CAST(CAST(ROUND(CAST((j.structural_complete_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Complete05_b0",
CAST(CAST(ROUND(CAST(j.structural_complete_b0 * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Collapse05_b0",
CAST(CAST(ROUND(CAST((j.structural_complete_b0/a.number) * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Collapse05_b0",
CASE WHEN ((j.structural_complete_b0/a.number) * f.collapse_pc) >0.01 THEN a.number ELSE 0 END AS "eD_Fail_Collapse05_b0",

-- q95 - b0
CAST(CAST(ROUND(CAST(k.structural_slight_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Slight95_b0",
CAST(CAST(ROUND(CAST((k.structural_slight_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Slight95_b0",
CAST(CAST(ROUND(CAST(k.structural_moderate_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Moderate95_b0",
CAST(CAST(ROUND(CAST((k.structural_moderate_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Moderate95_b0",
CAST(CAST(ROUND(CAST(k.structural_extensive_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Extensive95_b0",
CAST(CAST(ROUND(CAST((k.structural_extensive_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Extensive95_b0",
CAST(CAST(ROUND(CAST(k.structural_complete_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Complete95_b0",
CAST(CAST(ROUND(CAST((k.structural_complete_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Complete95_b0",
CAST(CAST(ROUND(CAST(k.structural_complete_b0 * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Collapse95_b0",
CAST(CAST(ROUND(CAST((k.structural_complete_b0/a.number) * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Collapse95_b0",
CASE WHEN ((k.structural_complete_b0/a.number) * f.collapse_pc) >0.01 THEN a.number ELSE 0 END AS "eD_Fail_Collapse95_b0",

-- 2.2.2 Event-Based Damage - r1
CAST(CAST(ROUND(CAST(g.structural_slight_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Slight_r1",
CAST(CAST(ROUND(CAST((g.structural_slight_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Slight_r1",

CAST(CAST(ROUND(CAST(g.structural_moderate_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Moderate_r1",
CAST(CAST(ROUND(CAST((g.structural_moderate_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Moderate_r1",

CAST(CAST(ROUND(CAST(g.structural_extensive_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Extensive_r1",
CAST(CAST(ROUND(CAST((g.structural_extensive_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Extensive_r1",

CAST(CAST(ROUND(CAST(g.structural_complete_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Complete_r1",
CAST(CAST(ROUND(CAST((g.structural_complete_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Complete_r1",

CAST(CAST(ROUND(CAST(g.structural_complete_r1 * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Collapse_r1",
CAST(CAST(ROUND(CAST((g.structural_complete_r1/a.number) * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Collapse_r1",
CASE WHEN ((g.structural_complete_r1/a.number) * f.collapse_pc) >0.01 THEN a.number ELSE 0 END AS "eD_Fail_Collapse_r1",

-- q05 - r1
CAST(CAST(ROUND(CAST(j.structural_slight_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Slight05_r1",
CAST(CAST(ROUND(CAST((j.structural_slight_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Slight05_r1",
CAST(CAST(ROUND(CAST(j.structural_moderate_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Moderate05_r1",
CAST(CAST(ROUND(CAST((j.structural_moderate_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Moderate05_r1",
CAST(CAST(ROUND(CAST(j.structural_extensive_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Extensive05_r1",
CAST(CAST(ROUND(CAST((j.structural_extensive_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Extensive05_r1",
CAST(CAST(ROUND(CAST(j.structural_complete_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Complete05_r1",
CAST(CAST(ROUND(CAST((j.structural_complete_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Complete05_r1",
CAST(CAST(ROUND(CAST(j.structural_complete_r1 * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Collapse05_r1",
CAST(CAST(ROUND(CAST((j.structural_complete_r1/a.number) * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Collapse05_r1",
CASE WHEN ((j.structural_complete_r1/a.number) * f.collapse_pc) >0.01 THEN a.number ELSE 0 END AS "eD_Fail_Collapse05_r1",

-- q95 - r1
CAST(CAST(ROUND(CAST(k.structural_slight_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Slight95_r1",
CAST(CAST(ROUND(CAST((k.structural_slight_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Slight95_r1",
CAST(CAST(ROUND(CAST(k.structural_moderate_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Moderate95_r1",
CAST(CAST(ROUND(CAST((k.structural_moderate_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Moderate95_r1",
CAST(CAST(ROUND(CAST(k.structural_extensive_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Extensive95_r1",
CAST(CAST(ROUND(CAST((k.structural_extensive_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Extensive95_r1",
CAST(CAST(ROUND(CAST(k.structural_complete_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Complete95_r1",
CAST(CAST(ROUND(CAST((k.structural_complete_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Complete95_r1",
CAST(CAST(ROUND(CAST(k.structural_complete_r1 * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Collapse95_r1",
CAST(CAST(ROUND(CAST((k.structural_complete_r1/a.number) * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Collapse95_r1",
CASE WHEN ((k.structural_complete_r1/a.number) * f.collapse_pc) >0.01 THEN a.number ELSE 0 END AS "eD_Fail_Collapse95_r1",


-- 2.3 Affected People
-- 2.3.1 Life Safety - b0
-- CAST(CAST(ROUND(CAST((occupants_b0/0.000001) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eC_Fatality_b0",
-- CAST(CAST(ROUND(CAST(COALESCE(occupants_b0/NULLIF(a.transit,0),0)/0.000001 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eCr_Fatality_b0",
CAST(CAST(ROUND(CAST((occupants_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eC_Fatality_b0",
CAST(CAST(ROUND(CAST(COALESCE(occupants_b0/NULLIF(a.transit,0),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eCr_Fatality_b0",

-- 2.3.1 Life Safety - r1
-- CAST(CAST(ROUND(CAST(occupants_r1/0.000001 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eC_Fatality_r1",
-- CAST(CAST(ROUND(CAST(COALESCE(occupants_r1/NULLIF(a.transit,0),0)/0.000001 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eCr_Fatality_r1",
CAST(CAST(ROUND(CAST(occupants_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eC_Fatality_r1",
CAST(CAST(ROUND(CAST(COALESCE(occupants_r1/NULLIF(a.transit,0),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eCr_Fatality_r1",


-- 2.4.1 Economic Loss - b0
CAST(CAST(ROUND(CAST(i.structural_b0 + i.nonstructural_b0 + i.contents_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Asset_b0",
CAST(CAST(ROUND(CAST((i.structural_b0 + i.nonstructural_b0 + i.contents_b0)/(a.structural + a.nonstructural) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALr_Asset_b0",
CAST(CAST(ROUND(CAST(i.structural_b0 + i.nonstructural_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Bldg_b0",
CAST(CAST(ROUND(CAST((i.structural_b0 + i.nonstructural_b0)/(a.structural + a.nonstructural) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALr_Bldg_b0",
CAST(CAST(ROUND(CAST(i.structural_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Str_b0",
CAST(CAST(ROUND(CAST(i.nonstructural_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_NStr_b0",
CAST(CAST(ROUND(CAST(i.contents_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Cont_b0",

-- 2.4.1 Economic Loss - r1
CAST(CAST(ROUND(CAST(i.structural_r1 + i.nonstructural_r1 + i.contents_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Asset_r1",
CAST(CAST(ROUND(CAST((i.structural_r1 + i.nonstructural_r1 + i.contents_r1)/(a.structural + a.nonstructural) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALr_Asset_r1",
CAST(CAST(ROUND(CAST(i.structural_r1 + i.nonstructural_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Bldg_r1",
CAST(CAST(ROUND(CAST((i.structural_r1 + i.nonstructural_r1)/(a.structural + a.nonstructural) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALr_Bldg_r1",
CAST(CAST(ROUND(CAST(i.structural_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Str_r1",
CAST(CAST(ROUND(CAST(i.nonstructural_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_NStr_r1",
CAST(CAST(ROUND(CAST(i.contents_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Cont_r1",

a.sauid AS "Sauid",
b."PRUID" AS "pruid",
b."PRNAME" AS "prname",
b."ERUID" AS "eruid",
b."CDUID" AS "cduid",
b."CDNAME" AS "cdname",
b."CSDUID" AS "csduid",
b."CSDNAME" AS "csdname",
b."CFSAUID" AS "fsauid",
b."DAUIDt" AS "dauid",
b."SACCODE" AS "saccode",
b."SACTYPE" AS "sactype",
a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt"
LEFT JOIN psra_{prov}.psra_{prov}_hmaps_xref d ON a.id = d.id
LEFT JOIN vs30.vs30_can_site_model_xref e ON a.id = e.id
LEFT JOIN lut.collapse_probability f ON a.bldgtype = f.eqbldgtype
RIGHT JOIN psra_{prov}.psra_{prov}_ed_dmg_mean g ON a.id = g.asset_id
LEFT JOIN mh.mh_intensity_canada h ON a.sauid = h.sauidt
RIGHT JOIN psra_{prov}.psra_{prov}_avg_losses_stats i ON a.id = i.asset_id
LEFT JOIN psra_{prov}.psra_{prov}_ed_dmg_q05 j ON a.id = j.asset_id
LEFT JOIN psra_{prov}.psra_{prov}_ed_dmg_q95 k ON a.id = k.asset_id;