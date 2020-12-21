CREATE SCHEMA IF NOT EXISTS results_psra_bc;



-- create psra indicators
DROP VIEW IF EXISTS results_psra_bc.psra_bc5920a2_economic_security_economic_loss_b CASCADE;
CREATE VIEW results_psra_bc.psra_bc5920a2_economic_security_economic_loss_b AS 

-- 2.0 Seismic Risk (PSRA)
-- 2.4 Economic Security
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

-- 2.4.1 Economic Loss - b0
CAST(CAST(ROUND(CAST(h.structural_b0 + h.nonstructural_b0 + h.contents_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Asset_b0",
CAST(CAST(ROUND(CAST((h.structural_b0 + h.nonstructural_b0 + h.contents_b0)/a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALr_Asset_b0",
CAST(CAST(ROUND(CAST(h.structural_b0 + h.nonstructural_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Bldg_b0",
CAST(CAST(ROUND(CAST((h.structural_b0 + h.nonstructural_b0)/a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALr_Bldg_b0",
CAST(CAST(ROUND(CAST(h.structural_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Str_b0",
CAST(CAST(ROUND(CAST(h.nonstructural_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_NStr_b0",
CAST(CAST(ROUND(CAST(h.contents_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Cont_b0",


-- 2.4.1 Economic Loss - r2
CAST(CAST(ROUND(CAST(h.structural_r2 + h.nonstructural_r2 + h.contents_r2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Asset_r2",
CAST(CAST(ROUND(CAST((h.structural_r2 + h.nonstructural_r2 + h.contents_r2)/a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALr_Asset_r2",
CAST(CAST(ROUND(CAST(h.structural_r2 + h.nonstructural_r2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Bldg_r2",
CAST(CAST(ROUND(CAST((h.structural_r2 + h.nonstructural_r2)/a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALr_Bldg_r2",
CAST(CAST(ROUND(CAST(h.structural_r2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Str_r2",
CAST(CAST(ROUND(CAST(h.nonstructural_r2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_NStr_r2",
CAST(CAST(ROUND(CAST(h.contents_r2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAAL_Cont_r2",

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" b on a.sauid = b."SAUIDt"
RIGHT JOIN psra_bc.psra_bc5920a2_avg_losses_stats h ON a.id = h.asset_id;