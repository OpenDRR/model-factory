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

-- 2.3 Affected People
-- 2.3.1 Life Safety - b0
CAST(CAST(ROUND(CAST(occupants_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eC_Fatality_b0",
CAST(CAST(ROUND(CAST(COALESCE(occupants_b0/NULLIF(a.night,0),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eCr_Fatality_b0",

-- 2.3.1 Life Safety - r1
CAST(CAST(ROUND(CAST(occupants_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eC_Fatality_r1",
CAST(CAST(ROUND(CAST(COALESCE(occupants_r1/NULLIF(a.night,0),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eCr_Fatality_r1",

-- 2.4.1 Economic Loss - b0
CAST(CAST(ROUND(CAST(i.structural_b0 + i.nonstructural_b0 + i.contents_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Asset_b0",
CAST(CAST(ROUND(CAST((i.structural_b0 + i.nonstructural_b0 + i.contents_b0)/a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALr_Asset_b0",
CAST(CAST(ROUND(CAST(i.structural_b0 + i.nonstructural_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Bldg_b0",
CAST(CAST(ROUND(CAST((i.structural_b0 + i.nonstructural_b0)/a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALr_Bldg_b0",
CAST(CAST(ROUND(CAST(i.structural_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Str_b0",
CAST(CAST(ROUND(CAST(i.nonstructural_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_NStr_b0",
CAST(CAST(ROUND(CAST(i.contents_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Cont_b0",

-- 2.4.1 Economic Loss - r1
CAST(CAST(ROUND(CAST(i.structural_r1 + i.nonstructural_r1 + i.contents_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Asset_r1",
CAST(CAST(ROUND(CAST((i.structural_r1 + i.nonstructural_r1 + i.contents_r1)/a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALr_Asset_r1",
CAST(CAST(ROUND(CAST(i.structural_r1 + i.nonstructural_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Bldg_r1",
CAST(CAST(ROUND(CAST((i.structural_r1 + i.nonstructural_r1)/a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALr_Bldg_r1",
CAST(CAST(ROUND(CAST(i.structural_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Str_r1",
CAST(CAST(ROUND(CAST(i.nonstructural_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_NStr_r1",
CAST(CAST(ROUND(CAST(i.contents_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Cont_r1",

a.sauid AS "Sauid",
b."PRUID" AS "pruid",
b."PRNAME" AS "prname",
b."ERUID" AS "eruid",
b."ERNAME" AS "ername",
b."CDUID" AS "cduid",
b."CDNAME" AS "cdname",
b."CSDUID" AS "csduid",
b."CSDNAME" AS "csdname",
b."CFSAUID" AS "fsauid",
b."DAUIDt" AS "dauid",
b."SACCODE" AS "saccode",
b."SACTYPE" AS "sactype",
a.landuse,
a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt"
LEFT JOIN psra_{prov}.psra_{prov}_hmaps_xref d ON a.id = d.id
LEFT JOIN vs30.vs30_can_site_model_xref e ON a.id = e.id
LEFT JOIN lut.collapse_probability f ON a.bldgtype = f.eqbldgtype
RIGHT JOIN psra_{prov}.psra_{prov}_ed_dmg_mean g ON a.id = g.asset_id
LEFT JOIN mh.mh_intensity_canada h ON a.sauid = h.sauidt
RIGHT JOIN psra_{prov}.psra_{prov}_avg_losses_stats i ON a.id = i.asset_id;