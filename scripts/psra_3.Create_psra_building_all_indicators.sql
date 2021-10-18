CREATE SCHEMA IF NOT EXISTS results_psra_{prov};

-- create psra indicators
DROP VIEW IF EXISTS results_psra_{prov}.psra_{prov}_indicators_b CASCADE;
CREATE VIEW results_psra_{prov}.psra_{prov}_indicators_b AS 

-- 2.0 Seismic Risk (PSRA)
-- 2.1 Probabilistic Seismic Hazard
-- 2.1.1 500yr Hazard Intensity
SELECT 
a.id AS "AssetID",

-- 2.1.1 500yr Hazard Intensity
CAST(CAST(ROUND(CAST(d."PGA_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_PGA",
CAST(CAST(ROUND(CAST(d."SA(0.1)_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_SA0p1",
CAST(CAST(ROUND(CAST(d."SA(0.2)_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_SA0p2",
CAST(CAST(ROUND(CAST(d."SA(0.3)_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_SA0p3",
CAST(CAST(ROUND(CAST(d."SA(0.5)_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_SA0p5",
CAST(CAST(ROUND(CAST(d."SA(0.6)_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_SA0p6",
CAST(CAST(ROUND(CAST(d."SA(1.0)_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_SA1p0",
CAST(CAST(ROUND(CAST(d."SA(2.0)_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_SA2p0",

-- 2.1.2 2500yr Hazard Intensity
CAST(CAST(ROUND(CAST(d."PGA_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_PGA",
-- pH2500_PGAn
CAST(CAST(ROUND(CAST(d."SA(0.1)_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_SA0p1",
CAST(CAST(ROUND(CAST(d."SA(0.2)_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_SA0p2",
CAST(CAST(ROUND(CAST(d."SA(0.3)_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_SA0p3",
CAST(CAST(ROUND(CAST(d."SA(0.5)_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_SA0p5",
CAST(CAST(ROUND(CAST(d."SA(0.6)_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_SA0p6",
CAST(CAST(ROUND(CAST(d."SA(1.0)_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_SA1p0",
CAST(CAST(ROUND(CAST(d."SA(2.0)_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_SA2p0",

-- 2.1.3 Site Amplification
CAST(CAST(ROUND(CAST(e.vs_lon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS  "pH_Vs30Lon",
CAST(CAST(ROUND(CAST(e.vs_lat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH_Vs30Lat",
CAST(CAST(ROUND(CAST(e.vs30 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH_Vs30",
CAST(CAST(ROUND(CAST(e.z1pt0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH_Vs1p0",
CAST(CAST(ROUND(CAST(e.z2pt5 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH_Vs2p5",

-- 2.1.4 50yr Likelihood
CAST(CAST(ROUND(CAST(h.mmi6 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS  "pH_MMI6",
CAST(CAST(ROUND(CAST(h.mmi7 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH_MMI7",
CAST(CAST(ROUND(CAST(h.mmi8 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH_MMI8",

-- 2.2.2 Event-Based Damage - b0
CAST(CAST(ROUND(CAST(g.structural_no_damage_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_None_b0",
CAST(CAST(ROUND(CAST((g.structural_no_damage_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_None_b0",

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
CAST(CAST(ROUND(CAST(g.structural_no_damage_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_None_r1",
-- eDsd_None_r1
CAST(CAST(ROUND(CAST((g.structural_no_damage_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_None_r1",

CAST(CAST(ROUND(CAST(g.structural_slight_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Slight_r1",
-- eDsd_Slight_r1
CAST(CAST(ROUND(CAST((g.structural_slight_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Slight_r1",

CAST(CAST(ROUND(CAST(g.structural_moderate_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Moderate_r1",
-- eDsd_Moderate_r1
CAST(CAST(ROUND(CAST((g.structural_moderate_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Moderate_r1",

CAST(CAST(ROUND(CAST(g.structural_extensive_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Extensive_r1",
-- eDsd_Extensive_r1
CAST(CAST(ROUND(CAST((g.structural_extensive_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Extensive_r1",

CAST(CAST(ROUND(CAST(g.structural_complete_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Complete_r1",
-- eDsd_Complete_r1
CAST(CAST(ROUND(CAST((g.structural_complete_r1/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Complete_r1",

CAST(CAST(ROUND(CAST(g.structural_complete_r1 * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Collapse_r1",
-- eDsd_Collapse_r1
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
CAST(CAST(ROUND(CAST((((i.structural_b0 + i.nonstructural_b0) - (i.structural_r1 + i.nonstructural_r1))/(a.number))/((a.retrofitting)/(a.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLr1_BCR_b0",
CAST(CAST(ROUND(CAST((((i.structural_b0 + i.nonstructural_b0) - (i.structural_r1 + i.nonstructural_r1))/(a.number)) * ((EXP(-0.025*50)/0.025))/((a.retrofitting)/(a.number)) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "sLr1_ROI_b0",

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