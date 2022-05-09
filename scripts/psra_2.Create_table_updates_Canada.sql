-- updates to canada tables

-- combine b0 and r1 tables - q05
CREATE TABLE psra_canada.psra_canada_agg_curves_q05 AS
(SELECT
a.return_period,
a.loss_type,
a.prname,
a.loss_value AS "loss_value_b0",
a.loss_ratio AS "loss_ratio_b0",
b.loss_value AS "loss_value_r1",
b.loss_ratio AS "loss_ratio_r1",
a.annual_frequency_of_exceedence

FROM psra_canada.psra_canada_agg_curves_q05_b0 a
LEFT JOIN psra_canada.psra_canada_agg_curves_q05_r1 b ON a.return_period = b.return_period AND a.loss_type = b.loss_type AND a.prname = b.prname
AND a.annual_frequency_of_exceedence = b.annual_frequency_of_exceedence);

-- delete *total* rows from table
DELETE FROM psra_canada.psra_canada_agg_curves_q05 WHERE prname = '*total*';

DROP TABLE IF EXISTS psra_canada.psra_canada_agg_curves_q05_b0, psra_canada.psra_canada_agg_curves_q05_r1;

-- combine b0 and r1 tables - q95
CREATE TABLE psra_canada.psra_canada_agg_curves_q95 AS
(SELECT
a.return_period,
a.loss_type,
a.prname,
a.loss_value AS "loss_value_b0",
a.loss_ratio AS "loss_ratio_b0",
b.loss_value AS "loss_value_r1",
b.loss_ratio AS "loss_ratio_r1",
a.annual_frequency_of_exceedence

FROM psra_canada.psra_canada_agg_curves_q95_b0 a
LEFT JOIN psra_canada.psra_canada_agg_curves_q95_r1 b ON a.return_period = b.return_period AND a.loss_type = b.loss_type AND a.prname = b.prname 
AND a.annual_frequency_of_exceedence = b.annual_frequency_of_exceedence);

-- delete *total* rows from table
DELETE FROM psra_canada.psra_canada_agg_curves_q95 WHERE prname = '*total*';

DROP TABLE IF EXISTS psra_canada.psra_canada_agg_curves_q95_b0, psra_canada.psra_canada_agg_curves_q95_r1;


-- combine b0 and r1 tables
CREATE TABLE psra_canada.psra_canada_agg_curves_stats AS
(SELECT
a.return_period,
a.loss_type,
a.prname,
a.loss_value AS "loss_value_b0",
a.loss_ratio AS "loss_ratio_b0",
b.loss_value AS "loss_value_r1",
b.loss_ratio AS "loss_ratio_r1",
a.annual_frequency_of_exceedence


FROM psra_canada.psra_canada_agg_curves_stats_b0 a
LEFT JOIN psra_canada.psra_canada_agg_curves_stats_r1 b ON a.return_period = b.return_period AND a.loss_type = b.loss_type AND a.prname = b.prname
AND a.annual_frequency_of_exceedence = b.annual_frequency_of_exceedence);

-- delete *total* rows from table
DELETE FROM psra_canada.psra_canada_agg_curves_stats WHERE prname = '*total*';

DROP TABLE IF EXISTS psra_canada.psra_canada_agg_curves_stats_b0, psra_canada.psra_canada_agg_curves_stats_r1;



-- agg losses
-- combine b0 and r1 tables - q05
CREATE TABLE psra_canada.psra_canada_agg_losses_q05 AS
SELECT
a.loss_type,
a.prname,
a.loss_value AS "loss_value_b0",
a.exposed_value AS "exposed_value_b0",
a.loss_ratio AS "loss_ratio_b0",
b.loss_value AS "loss_value_r1",
b.exposed_value AS "exposed_value_r1",
b.loss_ratio AS "loss_ratio_r1"

FROM psra_canada.psra_canada_agg_losses_q05_b0 a
LEFT JOIN psra_canada.psra_canada_agg_losses_q05_r1 b ON a.loss_type = b.loss_type AND a.prname = b.prname;

-- delete *total* rows from table
DELETE FROM psra_canada.psra_canada_agg_losses_q05 WHERE prname = '*total*';

DROP TABLE IF EXISTS psra_canada.psra_canada_agg_losses_q05_b0, psra_canada.psra_canada_agg_losses_q05_r1 CASCADE;



-- combine b0 and r1 tables - q95
CREATE TABLE psra_canada.psra_canada_agg_losses_q95 AS
SELECT
a.loss_type,
a.prname,
a.loss_value AS "loss_value_b0",
a.exposed_value AS "exposed_value_b0",
a.loss_ratio AS "loss_ratio_b0",
b.loss_value AS "loss_value_r1",
b.exposed_value AS "exposed_value_r1",
b.loss_ratio AS "loss_ratio_r1"

FROM psra_canada.psra_canada_agg_losses_q95_b0 a
LEFT JOIN psra_canada.psra_canada_agg_losses_q95_r1 b ON a.loss_type = b.loss_type AND a.prname = b.prname;

-- delete *total* rows from table
DELETE FROM psra_canada.psra_canada_agg_losses_q95 WHERE prname = '*total*';

DROP TABLE IF EXISTS psra_canada.psra_canada_agg_losses_q95_b0, psra_canada.psra_canada_agg_losses_q95_r1 CASCADE;


-- combine b0 and r1 tables
CREATE TABLE psra_canada.psra_canada_agg_losses_stats AS
SELECT
a.loss_type,
a.prname,
a.loss_value AS "loss_value_b0",
a.exposed_value AS "exposed_value_b0",
a.loss_ratio AS "loss_ratio_b0",
b.loss_value AS "loss_value_r1",
b.exposed_value AS "exposed_value_r1",
b.loss_ratio AS "loss_ratio_r1"

FROM psra_canada.psra_canada_agg_losses_stats_b0 a
LEFT JOIN psra_canada.psra_canada_agg_losses_stats_r1 b ON a.loss_type = b.loss_type AND a.prname = b.prname;

-- delete *total* rows from table
DELETE FROM psra_canada.psra_canada_agg_losses_stats WHERE prname = '*total*';

DROP TABLE IF EXISTS psra_canada.psra_canada_agg_losses_stats_b0, psra_canada.psra_canada_agg_losses_stats_r1 CASCADE;



 /* psra_3.Create_table_src_loss_table.sql */
DROP TABLE IF EXISTS psra_canada.psra_canada_src_loss CASCADE;
CREATE TABLE psra_canada.psra_canada_src_loss AS
SELECT 
a.source,
a.loss_type,
a.loss_value AS "loss_value_b0",
b.loss_value AS "loss_value_r1"

FROM psra_canada.psra_canada_src_loss_b0 a
INNER JOIN psra_canada.psra_canada_src_loss_r1 b ON a.source = b.source AND a.loss_type = b.loss_type;