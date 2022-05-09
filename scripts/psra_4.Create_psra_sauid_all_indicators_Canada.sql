CREATE SCHEMA IF NOT EXISTS results_psra_canada;



-- create psra indicators
DROP VIEW IF EXISTS results_psra_canada.psra_canada_expected_loss CASCADE;
CREATE VIEW results_psra_canada.psra_canada_expected_loss AS

-- 2.0 Seismic Risk (PSRA)
-- 2.4 Economic Security
SELECT
a.prname AS "prname",

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
a.annual_frequency_of_exceedence AS "eEL_Probability"

FROM psra_canada.psra_canada_agg_curves_stats a
FULL JOIN psra_canada.psra_canada_agg_curves_q05 b ON a.return_period = b.return_period AND a.loss_type = b.loss_type AND a.prname = b.prname 
	AND a.annual_frequency_of_exceedence = b.annual_frequency_of_exceedence
FULL JOIN psra_canada.psra_canada_agg_curves_q95 c ON a.return_period = c.return_period AND a.loss_type = c.loss_type AND a.prname = c.prname 
	AND a.annual_frequency_of_exceedence = c.annual_frequency_of_exceedence
ORDER BY a.return_period,a.prname ASC;



-- create psra indicators
DROP VIEW IF EXISTS results_psra_canada.psra_canada_agg_loss CASCADE;
CREATE VIEW results_psra_canada.psra_canada_agg_loss AS

SELECT
a.prname AS "prname",
a.loss_type AS "e_LossType",

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

FROM psra_canada.psra_canada_agg_losses_stats a
LEFT JOIN psra_canada.psra_canada_agg_losses_q05 b ON a.loss_type = b.loss_type AND a.prname = b.prname
LEFT JOIN psra_canada.psra_canada_agg_losses_q95 c ON a.loss_type = c.loss_type AND a.prname = c.prname
ORDER BY a.loss_type,a.prname ASC;



-- src loss values
DROP TABLE IF EXISTS results_psra_canada.psra_canada_src_loss_temp CASCADE;
CREATE TABLE results_psra_canada.psra_canada_src_loss_temp AS
SELECT 
a.source AS "src_zone",
b.tectonicregion AS "src_type",
CASE 
	WHEN a.loss_type IN ('contents','nonstructural','structural') THEN 'building'
	WHEN a.loss_type IN ('occupants') THEN 'occupants'
	END AS "loss_type",
SUM(a.loss_value_b0) AS "src_value_b0",
SUM(a.loss_value_r1) AS "src_value_r1"

FROM psra_canada.psra_canada_src_loss a
LEFT JOIN lut.psra_source_types b ON a.source = b.code
GROUP BY a.source,b.tectonicregion,a.loss_type
ORDER BY a.source ASC;



DROP TABLE IF EXISTS results_psra_canada.psra_canada_src_loss_tbl CASCADE;
CREATE TABLE results_psra_canada.psra_canada_src_loss_tbl AS
SELECT
src_zone,
src_type,
loss_type,
CAST(CAST(ROUND(CAST(SUM(src_value_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "src_value_b0",
CAST(CAST(ROUND(CAST(SUM(src_value_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "src_value_r1"

FROM results_psra_canada.psra_canada_src_loss_temp
GROUP BY src_zone,src_type,loss_type;


DROP VIEW IF EXISTS results_psra_canada.psra_canada_src_loss;

CREATE VIEW results_psra_canada.psra_canada_src_loss AS SELECT * FROM results_psra_canada.psra_canada_src_loss_tbl;

DROP TABLE IF EXISTS results_psra_canada.psra_canada_src_loss_temp,psra_canada.psra_canada_src_loss_b0, psra_canada.psra_canada_src_loss_r1 CASCADE;
