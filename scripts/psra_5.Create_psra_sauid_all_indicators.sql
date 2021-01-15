CREATE SCHEMA IF NOT EXISTS results_psra_{prov};



-- create psra indicators
DROP VIEW IF EXISTS results_psra_{prov}.psra_{prov}_all_indicators_s CASCADE;
CREATE VIEW results_psra_{prov}.psra_{prov}_all_indicators_s AS 


-- 2.0 Seismic Risk (PSRA)
-- 2.1 Probabilistic Seismic Hazard
-- 2.1.1 500yr Hazard Intensity
SELECT 
a.sauid AS "Sauid",
z."PRUID" AS "pruid",
z."PRNAME" AS "prname",
z."ERUID" AS "eruid",
z."ERNAME" AS "ername",
z."CDUID" AS "cduid",
z."CDNAME" AS "cdname",
z."CSDUID" AS "csduid",
z."CSDNAME" AS "csdname",

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
-- pH2500_PGAn
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

-- 2.1.4 50yr Likelihood
CAST(CAST(ROUND(CAST(h.mmi6 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS  "pH_MMI6",
-- MMI6n
CAST(CAST(ROUND(CAST(h.mmi7 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH_MMI7",
-- MMI7n
CAST(CAST(ROUND(CAST(h.mmi8 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "pH_MMI8",
-- MMI8n

-- 2.2 Building Damage
-- 2.2.1 Classical Damage - b0
CAST(CAST(ROUND(CAST(SUM(c.structural_no_damage_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDt_None_b0",
CAST(CAST(ROUND(CAST(AVG(c.structural_no_damage_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDmr_None_b0",

CAST(CAST(ROUND(CAST(SUM(c.structural_slight_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDt_Slight_b0",
CAST(CAST(ROUND(CAST(AVG(c.structural_slight_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDmr_Slight_b0",

CAST(CAST(ROUND(CAST(SUM(c.structural_moderate_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDt_Moderate_b0",
CAST(CAST(ROUND(CAST(AVG(c.structural_moderate_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDmr_Moderate_b0",

CAST(CAST(ROUND(CAST(SUM(c.structural_extensive_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDt_Extensive_b0",
CAST(CAST(ROUND(CAST(AVG(c.structural_extensive_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDmr_Extensive_b0",

CAST(CAST(ROUND(CAST(SUM(c.structural_complete_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDt_Complete_b0",
CAST(CAST(ROUND(CAST(AVG(c.structural_complete_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDmr_Complete_b0",

CAST(CAST(ROUND(CAST(SUM(c.structural_complete_b0 * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDt_Collapse_b0",
CAST(CAST(ROUND(CAST(AVG((c.structural_complete_b0/a.number) * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDmp_Collapse_b0",

-- 2.2.1 Classical Damage - r2
CAST(CAST(ROUND(CAST(SUM(c.structural_no_damage_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDt_None_r2",
CAST(CAST(ROUND(CAST(AVG(c.structural_no_damage_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDmr_None_r2",

CAST(CAST(ROUND(CAST(SUM(c.structural_slight_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDt_Slight_r2",
CAST(CAST(ROUND(CAST(AVG(c.structural_slight_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDmr_Slight_r2",

CAST(CAST(ROUND(CAST(SUM(c.structural_moderate_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDt_Moderate_r2",
CAST(CAST(ROUND(CAST(AVG(c.structural_moderate_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDmr_Moderate_r2",

CAST(CAST(ROUND(CAST(SUM(c.structural_extensive_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDt_Extensive_r2",
CAST(CAST(ROUND(CAST(AVG(c.structural_extensive_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDmr_Extensive_r2",

CAST(CAST(ROUND(CAST(SUM(c.structural_complete_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDt_Complete_r2",
CAST(CAST(ROUND(CAST(AVG(c.structural_complete_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDmr_Complete_r2",

CAST(CAST(ROUND(CAST(SUM(c.structural_complete_r2 * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDt_Collapse_r2",
CAST(CAST(ROUND(CAST(AVG((c.structural_complete_r2/a.number) * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "cDmp_Collapse_r2",

-- 2.2.2 Event-Based Damage - b0
CAST(CAST(ROUND(CAST(SUM(g.structural_no_damage_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_None_b0",
CAST(CAST(ROUND(CAST(AVG(g.structural_no_damage_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDmr_None_b0",

CAST(CAST(ROUND(CAST(SUM(g.structural_slight_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Slight_b0",
CAST(CAST(ROUND(CAST(AVG(g.structural_slight_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDmr_Slight_b0",

CAST(CAST(ROUND(CAST(SUM(g.structural_moderate_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Moderate_b0",
CAST(CAST(ROUND(CAST(AVG(g.structural_moderate_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDmr_Moderate_b0",

CAST(CAST(ROUND(CAST(SUM(g.structural_extensive_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Extensive_b0",
CAST(CAST(ROUND(CAST(AVG(g.structural_extensive_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDmr_Extensive_b0",

CAST(CAST(ROUND(CAST(SUM(g.structural_complete_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Complete_b0",
CAST(CAST(ROUND(CAST(AVG(g.structural_complete_b0/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDmr_Complete_b0",

CAST(CAST(ROUND(CAST(SUM(g.structural_complete_b0 * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Collapse_b0",
CAST(CAST(ROUND(CAST(AVG((g.structural_complete_b0/a.number) * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDmr_Collapse_b0",

-- 2.2.2 Event-Based Damage - r2
CAST(CAST(ROUND(CAST(SUM(g.structural_no_damage_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_None_r2",
CAST(CAST(ROUND(CAST(AVG(g.structural_no_damage_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDmr_None_r2",

CAST(CAST(ROUND(CAST(SUM(g.structural_slight_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Slight_r2",
CAST(CAST(ROUND(CAST(AVG(g.structural_slight_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDmr_Slight_r2",

CAST(CAST(ROUND(CAST(SUM(g.structural_moderate_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Moderate_r2",
CAST(CAST(ROUND(CAST(AVG(g.structural_moderate_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDmr_Moderate_r2",

CAST(CAST(ROUND(CAST(SUM(g.structural_extensive_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Extensive_r2",
CAST(CAST(ROUND(CAST(AVG(g.structural_extensive_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDmr_Extensive_r2",

CAST(CAST(ROUND(CAST(SUM(g.structural_complete_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Complete_r2",
CAST(CAST(ROUND(CAST(AVG(g.structural_complete_r2/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDmr_Complete_r2",

CAST(CAST(ROUND(CAST(SUM(g.structural_complete_r2 * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDt_Collapse_r2",
CAST(CAST(ROUND(CAST(AVG((g.structural_complete_r2/a.number) * f.collapse_pc) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eDmr_Collapse_r2",

-- 2.4.1 Economic Loss - b0
CAST(CAST(ROUND(CAST(SUM(i.structural_b0 + i.nonstructural_b0 + i.contents_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Asset_b0",
CAST(CAST(ROUND(CAST(AVG((i.structural_b0 + i.nonstructural_b0 + i.contents_b0)/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALmr_Asset_b0",
CAST(CAST(ROUND(CAST(SUM(i.structural_b0 + i.nonstructural_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Bldg_b0",
CAST(CAST(ROUND(CAST(AVG((i.structural_b0 + i.nonstructural_b0)/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALmr_Bldg_b0",
CAST(CAST(ROUND(CAST(SUM(i.structural_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Str_b0",
CAST(CAST(ROUND(CAST(SUM(i.nonstructural_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_NStr_b0",
CAST(CAST(ROUND(CAST(SUM(i.contents_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Cont_b0",

-- 2.4.1 Economic Loss - r2
CAST(CAST(ROUND(CAST(SUM(i.structural_r2 + i.nonstructural_r2 + i.contents_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Asset_r2",
CAST(CAST(ROUND(CAST(AVG((i.structural_r2 + i.nonstructural_r2 + i.contents_r2)/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALmr_Asset_r2",
CAST(CAST(ROUND(CAST(SUM(i.structural_r2 + i.nonstructural_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Bldg_r2",
CAST(CAST(ROUND(CAST(AVG((i.structural_r2 + i.nonstructural_r2)/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALmr_Bldg_r2",
CAST(CAST(ROUND(CAST(SUM(i.structural_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Str_r2",
CAST(CAST(ROUND(CAST(SUM(i.nonstructural_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_NStr_r2",
CAST(CAST(ROUND(CAST(SUM(i.contents_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Cont_r2",

--z.geompoint AS "geom_point"
z.geom AS "geom_poly"

FROM exposure.canada_exposure a
RIGHT JOIN psra_{prov}.psra_{prov}_cd_dmg_mean c ON a.id = c.asset_id
LEFT JOIN psra_{prov}.psra_{prov}_hmaps_xref d ON a.id = d.id
LEFT JOIN vs30.vs30_can_site_model_xref e ON a.id = e.id
LEFT JOIN lut.collapse_probability f ON a.bldgtype = f.eqbldgtype
RIGHT JOIN psra_{prov}.psra_{prov}_ed_dmg_mean g ON a.id = g.asset_id
LEFT JOIN mh.mh_intensity_canada h ON a.sauid = h.sauidt
RIGHT JOIN psra_{prov}.psra_{prov}_avg_losses_stats i ON a.id = i.asset_id
LEFT JOIN boundaries."Geometry_SAUID" z ON a.sauid = z."SAUIDt"
GROUP BY a.sauid,d."PGA_0.02",d."SA(0.1)_0.02",d."SA(0.2)_0.02",d."SA(0.3)_0.02",d."SA(0.5)_0.02",d."SA(0.6)_0.02",d."SA(1.0)_0.02",d."SA(2.0)_0.02",d."SA(5.0)_0.02",d."SA(10.0)_0.02",
d."PGA_0.1",d."SA(0.1)_0.1",d."SA(0.2)_0.1",d."SA(0.3)_0.1",d."SA(0.5)_0.1",d."SA(0.6)_0.1",d."SA(1.0)_0.1",d."SA(2.0)_0.1",d."SA(5.0)_0.1",d."SA(10.0)_0.1",
e.vs_lon,e.vs_lat,e.vs30,e.z1pt0,e.z2pt5,h.mmi6,h.mmi7,h.mmi8,z."PRUID",z."PRNAME",z."ERUID",z."ERNAME",z."CDUID",z."CDNAME",z."CSDUID",z."CSDNAME",z.geom;



-- create psra indicators
DROP VIEW IF EXISTS results_psra_{prov}.psra_{prov}_pml_s CASCADE;
CREATE VIEW results_psra_{prov}.psra_{prov}_pml_s AS

-- 2.0 Seismic Risk (PSRA)
-- 2.4 Economic Security
SELECT
a.fsauid,

-- 2.4.2 Probable Maximum Loss
a.loss_value_b0 AS "ePML_b0",
a.loss_ratio_b0 AS "ePMLr_b0",
a.loss_value_r2 AS "ePML_r2",
a.loss_ratio_r2 AS "ePMLr_r2",
a.loss_type AS "ePML_type",
a.return_period AS "ePML_Period",
a.annual_frequency_of_exceedence AS "ePML_Probability",
a."GenOcc" AS "ePML_OccGen",
a."GenType" AS "ePML_BldgType"

FROM psra_{prov}.psra_{prov}_agg_curves_stats a;