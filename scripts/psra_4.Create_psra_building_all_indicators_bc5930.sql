CREATE SCHEMA IF NOT EXISTS results_psra_bc;

-- create psra indicators
DROP VIEW IF EXISTS results_psra_bc.psra_bc5930_all_indicators_b CASCADE;
CREATE VIEW results_psra_bc.psra_bc5930_all_indicators_b AS 

-- 2.0 Seismic Risk (PSRA)
-- 2.1 Probabilistic Seismic Hazard
-- 2.1.1 500yr Hazard Intensity
SELECT 
a.id AS "AssetID",
a.sauid AS "Sauid",
b."PRUID" AS "pruid",
b."PRNAME" AS "prname",
b."ERUID" AS "eruid",
b."ERNAME" AS "ername",
b."CDUID" AS "cduid",
b."CDNAME" AS "cdname",
b."CSDUID" AS "csduid",
b."CSDNAME" AS "csdname",

-- 2.1.1 500yr Hazard Intensity
CAST(CAST(ROUND(CAST(d."PGA_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_PGA",
CAST(CAST(ROUND(CAST(d."SA(0.1)_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_SA0p1",
CAST(CAST(ROUND(CAST(d."SA(0.2)_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_SA0p2",
CAST(CAST(ROUND(CAST(d."SA(0.3)_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_SA0p3",
CAST(CAST(ROUND(CAST(d."SA(0.5)_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_SA0p5",
CAST(CAST(ROUND(CAST(d."SA(0.6)_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_SA0p6",
CAST(CAST(ROUND(CAST(d."SA(1.0)_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_SA1p0",
CAST(CAST(ROUND(CAST(d."SA(2.0)_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_SA2p0",
CAST(CAST(ROUND(CAST(d."SA(5.0)_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_SA5p0",
CAST(CAST(ROUND(CAST(d."SA(10.0)_0.02" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH500_SA10p0",

-- 2.1.2 2500yr Hazard Intensity
CAST(CAST(ROUND(CAST(d."PGA_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_PGA",
-- pH2500_PGA
CAST(CAST(ROUND(CAST(d."SA(0.1)_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_SA0p1",
CAST(CAST(ROUND(CAST(d."SA(0.2)_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_SA0p2",
CAST(CAST(ROUND(CAST(d."SA(0.3)_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_SA0p3",
CAST(CAST(ROUND(CAST(d."SA(0.5)_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_SA0p5",
CAST(CAST(ROUND(CAST(d."SA(0.6)_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_SA0p6",
CAST(CAST(ROUND(CAST(d."SA(1.0)_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_SA1p0",
CAST(CAST(ROUND(CAST(d."SA(2.0)_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_SA2p0",
CAST(CAST(ROUND(CAST(d."SA(5.0)_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_SA5p0",
CAST(CAST(ROUND(CAST(d."SA(10.0)_0.1" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH2500_SA10p0",

-- 2.1.3 Site Amplification
CAST(CAST(ROUND(CAST(e.vs_lon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS  "pH_Vs30Lon",
CAST(CAST(ROUND(CAST(e.vs_lat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH_Vs30Lat",
CAST(CAST(ROUND(CAST(e.vs30 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH_Vs30",
CAST(CAST(ROUND(CAST(e.z1pt0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH_Vs1p0",
CAST(CAST(ROUND(CAST(e.z2pt5 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH_Vs2p5",

CAST(CAST(ROUND(CAST(h.mmi6 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS  "pH_MMI6",
-- MMI6n
CAST(CAST(ROUND(CAST(h.mmi7 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH_MMI7",
-- MMI7n
CAST(CAST(ROUND(CAST(h.mmi8 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH_MMI8",
-- MMI8n


-- 2.2 Building Damage
-- 2.2.1 Classical Damage - b0
CAST(CAST(ROUND(CAST(c.structural_no_damage_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cD_None_b0",
CAST(CAST(ROUND(CAST((c.structural_no_damage_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDr_None_b0",

CAST(CAST(ROUND(CAST(c.structural_slight_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cD_Slight_b0",
CAST(CAST(ROUND(CAST((c.structural_slight_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDr_Slight_b0",

CAST(CAST(ROUND(CAST(c.structural_moderate_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cD_Moderate_b0",
CAST(CAST(ROUND(CAST((c.structural_moderate_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDr_Moderate_b0",

CAST(CAST(ROUND(CAST(c.structural_extensive_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cD_Extensive_b0",
CAST(CAST(ROUND(CAST((c.structural_extensive_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDr_Extensive_b0",

CAST(CAST(ROUND(CAST(c.structural_complete_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cD_Complete_b0",
CAST(CAST(ROUND(CAST((c.structural_complete_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDr_Complete_b0",

CAST(CAST(ROUND(CAST(f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "CDr_Collapse_b0",
CAST(CAST(ROUND(CAST(c.structural_complete_b0 * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cD_Collapse_b0",
CAST(CAST(ROUND(CAST((c.structural_complete_b0/a.number) * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDp_Collapse_b0",


-- 2.2.1 Classical Damage - r2
CAST(CAST(ROUND(CAST(c.structural_no_damage_r2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cD_None_r2",
CAST(CAST(ROUND(CAST((c.structural_no_damage_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDr_None_r2",

CAST(CAST(ROUND(CAST(c.structural_slight_r2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cD_Slight_r2",
CAST(CAST(ROUND(CAST((c.structural_slight_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDr_Slight_r2",

CAST(CAST(ROUND(CAST(c.structural_moderate_r2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cD_Moderate_r2",
CAST(CAST(ROUND(CAST((c.structural_moderate_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDr_Moderate_r2",

CAST(CAST(ROUND(CAST(c.structural_extensive_r2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cD_Extensive_r2",
CAST(CAST(ROUND(CAST((c.structural_extensive_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDr_Extensive_r2",

CAST(CAST(ROUND(CAST(c.structural_complete_r2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cD_Complete_r2",
CAST(CAST(ROUND(CAST((c.structural_complete_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDr_Complete_r2",

CAST(CAST(ROUND(CAST(f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "CDr_Collapse_r2",
CAST(CAST(ROUND(CAST(c.structural_complete_r2 * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cD_Collapse_r2",
CAST(CAST(ROUND(CAST((c.structural_complete_r2/a.number) * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDp_Collapse_r2",

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

-- 2.2.2 Event-Based Damage - r2
CAST(CAST(ROUND(CAST(g.structural_no_damage_r2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_None_r2",
CAST(CAST(ROUND(CAST((g.structural_no_damage_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_None_r2",

CAST(CAST(ROUND(CAST(g.structural_slight_r2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Slight_r2",
CAST(CAST(ROUND(CAST((g.structural_slight_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Slight_r2",

CAST(CAST(ROUND(CAST(g.structural_moderate_r2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Moderate_r2",
CAST(CAST(ROUND(CAST((g.structural_moderate_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Moderate_r2",

CAST(CAST(ROUND(CAST(g.structural_extensive_r2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Extensive_r2",
CAST(CAST(ROUND(CAST((g.structural_extensive_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Extensive_r2",

CAST(CAST(ROUND(CAST(g.structural_complete_r2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Complete_r2",
CAST(CAST(ROUND(CAST((g.structural_complete_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Complete_r2",

CAST(CAST(ROUND(CAST(g.structural_complete_r2 * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eD_Collapse_r2",
CAST(CAST(ROUND(CAST((g.structural_complete_r2/a.number) * f.collapse_pc AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDr_Collapse_r2",

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt"
RIGHT JOIN psra_bc.psra_bc5930_cd_dmg_mean c ON a.id = c.asset_id
LEFT JOIN psra_bc.psra_bc_hmaps_xref d ON a.id = d.id
LEFT JOIN vs30.vs30_can_site_model_xref e ON a.id = e.id
LEFT JOIN lut.collapse_probability f ON a.bldgtype = f.eqbldgtype
RIGHT JOIN psra_bc.psra_bc5930_ed_dmg_mean g ON a.id = g.asset_id
LEFT JOIN mh.mh_intensity_canada h ON a.sauid = h.sauidt;