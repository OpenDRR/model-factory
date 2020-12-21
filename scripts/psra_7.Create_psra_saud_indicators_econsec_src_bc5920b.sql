CREATE SCHEMA IF NOT EXISTS results_psra_bc;

DROP VIEW IF EXISTS results_psra_bc.psra_bc5920b_economic_security_economic_loss_s CASCADE;
CREATE VIEW results_psra_bc.psra_bc5920b_economic_security_economic_loss_s AS 

-- 2.0 Seismic Risk (PSRA)
-- 2.4 Economic Security
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

-- 2.4.1 Economic Loss - b0
CAST(CAST(ROUND(CAST(SUM(h.structural_b0 + h.nonstructural_b0 + h.contents_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Asset_b0",
CAST(CAST(ROUND(CAST(AVG((h.structural_b0 + h.nonstructural_b0 + h.contents_b0)/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALmr_Asset_b0",
CAST(CAST(ROUND(CAST(SUM(h.structural_b0 + h.nonstructural_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Bldg_b0",
CAST(CAST(ROUND(CAST(AVG((h.structural_b0 + h.nonstructural_b0)/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALmr_Bldg_b0",
CAST(CAST(ROUND(CAST(SUM(h.structural_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Str_b0",
CAST(CAST(ROUND(CAST(SUM(h.nonstructural_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_NStr_b0",
CAST(CAST(ROUND(CAST(SUM(h.contents_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Cont_b0",

-- 2.4.1 Economic Loss - r2
CAST(CAST(ROUND(CAST(SUM(h.structural_r2 + h.nonstructural_r2 + h.contents_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Asset_r2",
CAST(CAST(ROUND(CAST(AVG((h.structural_r2 + h.nonstructural_r2 + h.contents_r2)/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALmr_Asset_r2",
CAST(CAST(ROUND(CAST(SUM(h.structural_r2 + h.nonstructural_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Bldg_r2",
CAST(CAST(ROUND(CAST(AVG((h.structural_r2 + h.nonstructural_r2)/a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALmr_Bldg_r2",
CAST(CAST(ROUND(CAST(SUM(h.structural_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Str_r2",
CAST(CAST(ROUND(CAST(SUM(h.nonstructural_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_NStr_r2",
CAST(CAST(ROUND(CAST(SUM(h.contents_r2) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eAALt_Cont_r2",

--z.geompoint AS "geom_point",
z.geom AS "geom_poly"


FROM exposure.canada_exposure a
RIGHT JOIN psra_bc.psra_bc5920b_avg_losses_stats h ON a.id = h.asset_id
LEFT JOIN boundaries."Geometry_SAUID" z ON a.sauid = z."SAUIDt"
GROUP BY a.sauid,z."PRUID",z."PRNAME",z."ERUID",z."ERNAME",z."CDUID",z."CDNAME",z."CSDUID",z."CSDNAME",z.geom;



-- create psra indicators
DROP VIEW IF EXISTS results_psra_bc.psra_bc5920b_economic_security_pml_b0_s CASCADE;
CREATE VIEW results_psra_bc.psra_bc5920b_economic_security_pml_b0_s AS

-- 2.0 Seismic Risk (PSRA)
-- 2.4 Economic Security
SELECT
a.fsauid,

-- 2.4.2 Probable Maximum Loss - b0
a.loss_value AS "ePML",
a.loss_ratio AS "ePMLr",
a.loss_type AS "ePML_type",
a.return_period AS "ePML_Period",
a.annual_frequency_of_exceedence AS "ePML_Probability",
a."GenOcc" AS "ePML_OccGen",
a."GenType" AS "ePML_BldgType"

FROM psra_bc.psra_bc5920b_agg_curves_stats_b0 a;



-- create psra indicators
DROP VIEW IF EXISTS results_psra_bc.psra_bc5920b_economic_security_pml_r2_s CASCADE;
CREATE VIEW results_psra_bc.psra_bc5920b_economic_security_pml_r2_s AS

-- 2.0 Seismic Risk (PSRA)
-- 2.4 Economic Security
SELECT
a.fsauid,

-- 2.4.2 Probable Maximum Loss - r2
a.loss_value AS "ePML",
a.loss_ratio AS "ePMLr",
a.loss_type AS "ePML_type",
a.return_period AS "ePML_Period",
a.annual_frequency_of_exceedence AS "ePML_Probability",
a."GenOcc" AS "ePML_OccGen",
a."GenType" AS "ePML_BldgType"

FROM psra_bc.psra_bc5920b_agg_curves_stats_r2 a;



-- src loss values
DROP VIEW IF EXISTS results_psra_bc.psra_bc5920b_src_loss CASCADE;
CREATE VIEW results_psra_bc.psra_bc5920b_src_loss AS

SELECT 
source AS "src_zone",
trt AS "src_type",
SUM(loss_value_b0)/(SELECT SUM(loss_value_b0) FROM psra_bc.psra_bc5920b_src_loss ) AS "src_value_b0",
SUM(loss_value_r2)/(SELECT SUM(loss_value_r2) FROM psra_bc.psra_bc5920b_src_loss ) AS "src_value_r2"
FROM psra_bc.psra_bc5920b_src_loss
GROUP BY source,trt;


/*

DROP VIEW IF EXISTS results_psra_bc.psra_bc5920b_src_loss CASCADE;
CREATE VIEW results_psra_bc.psra_bc5920b_src_loss AS

SELECT 
a.source AS "src_zone",
a.trt AS "src_type",
SUM(a.loss_value)/(SELECT SUM(loss_value) FROM psra_bc.psra_bc5920b_src_loss_b0 ) AS "src_value_b0",
SUM(b.loss_value)/(SELECT SUM(loss_value) FROM psra_bc.psra_bc5920b_src_loss_b0 ) AS "src_value_r2"
FROM psra_bc.psra_bc5920b_src_loss_b0 a
INNER JOIN psra_bc.psra_bc5920b_src_loss_b0 b ON a.source = b.source AND a.trt = b.trt
GROUP BY a.source,a.trt;

SELECT
SUM(loss_value) AS "TLossValue"
FROM psra_bc.psra_bc5920b_src_loss_b0
GROUP BY source;

-- source - b0,r2
DROP VIEW IF EXISTS results_psra_bc.psra_bc5920b_src_stats_source_b0, results_psra_bc.psra_bc5920b_src_stats_source_R2 CASCADE;

CREATE VIEW results_psra_bc.psra_bc5920b_src_stats_source_b0 AS
(
SELECT 
'bc5920b' AS "region",
source,
SUM(loss_value) AS "total_loss_source",
SUM(loss_value)/(SELECT SUM(loss_value) FROM psra_bc.psra_bc5920b_src_loss_b0 )*100 AS "total_srce_p"
FROM psra_bc.psra_bc5920b_src_loss_b0
GROUP BY source
);

CREATE VIEW results_psra_bc.psra_bc5920b_src_stats_source_r2 AS
(
SELECT 
'bc5920b' AS "region",
source,
SUM(loss_value) AS "total_loss_source",
SUM(loss_value)/(SELECT SUM(loss_value) FROM psra_bc.psra_bc5920b_src_loss_b0 )*100 AS "total_srce_p"
FROM psra_bc.psra_bc5920b_src_loss_r2
GROUP BY source
);


-- loss type - b0,r2
DROP VIEW IF EXISTS results_psra_bc.psra_bc5920b_src_stats_loss_type_b0, results_psra_bc.psra_bc5920b_src_stats_loss_type_r2 CASCADE;

CREATE VIEW results_psra_bc.psra_bc5920b_src_stats_loss_type_b0 AS
(
SELECT
'bc5920b_b0' AS "region",
loss_type,
SUM(loss_value) AS "total_lt",
SUM(loss_value)/(SELECT SUM(loss_value) FROM psra_bc.psra_bc5920b_src_loss_b0 )*100 AS "total_lt_p"
FROM psra_bc.psra_bc5920b_src_loss_b0
GROUP BY loss_type
);

CREATE VIEW results_psra_bc.psra_bc5920b_src_stats_loss_type_r2 AS
(
SELECT
'bc5920b_r2' AS "region",
loss_type,
SUM(loss_value) AS "total_lt",
SUM(loss_value)/(SELECT SUM(loss_value) FROM psra_bc.psra_bc5920b_src_loss_b0 )*100 AS "total_lt_p"
FROM psra_bc.psra_bc5920b_src_loss_r2
GROUP BY loss_type
);


-- source, loss type - b0, r2
DROP VIEW IF EXISTS results_psra_bc.psra_bc5920b_src_stats_source_losstype_b0, results_psra_bc.psra_bc5920b_src_stats_source_losstype_r2 CASCADE;

CREATE VIEW results_psra_bc.psra_bc5920b_src_stats_source_losstype_b0 AS
(
SELECT 
'bc5920b' AS "region",
source,
loss_type,
SUM(loss_value) AS "total_srce_lt",
SUM(loss_value)/(SELECT SUM(loss_value) FROM psra_bc.psra_bc5920b_src_loss_b0 )*100 AS "total_srce_lt_p"
FROM psra_bc.psra_bc5920b_src_loss_b0
GROUP BY source,loss_type
);

CREATE VIEW results_psra_bc.psra_bc5920b_src_stats_source_losstype_r2 AS
(
SELECT 
'bc5920b' AS "region",
source,
loss_type,
SUM(loss_value) AS "total_srce_lt",
SUM(loss_value)/(SELECT SUM(loss_value) FROM psra_bc.psra_bc5920b_src_loss_b0 )*100 AS "total_srce_lt_p"
FROM psra_bc.psra_bc5920b_src_loss_r2
GROUP BY source,loss_type
);


-- source, loss type, trt
DROP VIEW IF EXISTS results_psra_bc.psra_bc5920b_src_stats_source_losstype_trt_b0, results_psra_bc.psra_bc5920b_src_stats_source_losstype_trt_r2 CASCADE;

CREATE VIEW results_psra_bc.psra_bc5920b_src_stats_source_losstype_trt_b0 AS
(
SELECT 
'bc5920b' AS "region",
source,
loss_type,
trt,
SUM(loss_value) AS "total_srce_lt_trt",
SUM(loss_value)/(SELECT SUM(loss_value) FROM psra_bc.psra_bc5920b_src_loss_b0 )*100 AS "total_srce_lt_trt_p"
FROM psra_bc.psra_bc5920b_src_loss_b0
GROUP BY source,loss_type,trt
);

CREATE VIEW results_psra_bc.psra_bc5920b_src_stats_source_losstype_trt_r2  AS
(
SELECT 
'bc5920b' AS "region",
source,
loss_type,
trt,
SUM(loss_value) AS "total_srce_lt_trt",
SUM(loss_value)/(SELECT SUM(loss_value) FROM psra_bc.psra_bc5920b_src_loss_b0 )*100 AS "total_srce_lt_trt_p"
FROM psra_bc.psra_bc5920b_src_loss_r2
GROUP BY source,loss_type,trt
);

*/