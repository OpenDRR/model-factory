
-- script to generate empty tables for canada
CREATE SCHEMA IF NOT EXISTS psra_canada;


-- script to agg curves - q05
DROP TABLE IF EXISTS psra_canada.psra_canada_agg_curves_q05_b0, psra_canada.psra_canada_agg_curves_q05_r1, psra_canada.psra_canada_agg_curves_q05 CASCADE;

-- create table
CREATE TABLE psra_canada.psra_canada_agg_curves_q05_b0(
return_period float,
loss_value float,
loss_type varchar,
prname varchar,
loss_ratio float,
annual_frequency_of_exceedence float
);

-- create table
CREATE TABLE psra_canada.psra_canada_agg_curves_q05_r1(
return_period float,
loss_value float,
loss_type varchar,
prname varchar,
loss_ratio float,
annual_frequency_of_exceedence float
);



-- script to agg curves - q95
DROP TABLE IF EXISTS psra_canada.psra_canada_agg_curves_q95_b0, psra_canada.psra_canada_agg_curves_q95_r1, psra_canada.psra_canada_agg_curves_q95 CASCADE;

-- create table
CREATE TABLE psra_canada.psra_canada_agg_curves_q95_b0(
return_period float,
loss_value float,
loss_type varchar,
prname varchar,
loss_ratio float,
annual_frequency_of_exceedence float
);

-- create table
CREATE TABLE psra_canada.psra_canada_agg_curves_q95_r1(
return_period float,
loss_value float,
loss_type varchar,
prname varchar,
loss_ratio float,
annual_frequency_of_exceedence float
);


-- script to agg curves stats
DROP TABLE IF EXISTS psra_canada.psra_canada_agg_curves_stats_b0, psra_canada.psra_canada_agg_curves_stats_r1, psra_canada.psra_canada_agg_curves_stats CASCADE;

-- create table
CREATE TABLE psra_canada.psra_canada_agg_curves_stats_b0(
return_period float,
loss_value float,
loss_type varchar,
prname varchar,
loss_ratio float,
annual_frequency_of_exceedence float
);

-- create table
CREATE TABLE psra_canada.psra_canada_agg_curves_stats_r1(
return_period float,
loss_value float,
loss_type varchar,
prname varchar,
loss_ratio float,
annual_frequency_of_exceedence float
);



-- script to agg losses -q05
DROP TABLE IF EXISTS psra_canada.psra_canada_agg_losses_q05_b0, psra_canada.psra_canada_agg_losses_q05_r1, psra_canada.psra_canada_agg_losses_q05 CASCADE;

-- create table
CREATE TABLE psra_canada.psra_canada_agg_losses_q05_b0(
loss_type varchar,
prname varchar,
loss_value float,
exposed_value float,
loss_ratio float
);

-- create table
CREATE TABLE psra_canada.psra_canada_agg_losses_q05_r1(
loss_type varchar,
prname varchar,
loss_value float,
exposed_value float,
loss_ratio float
);



-- add agg_losses tables - q95
DROP TABLE IF EXISTS psra_canada.psra_canada_agg_losses_q95_b0, psra_canada.psra_canada_agg_losses_q95_r1, psra_canada.psra_canada_agg_losses_q95 CASCADE;

-- create table
CREATE TABLE psra_canada.psra_canada_agg_losses_q95_b0(
loss_type varchar,
prname varchar,
loss_value float,
exposed_value float,
loss_ratio float
);

-- create table
CREATE TABLE psra_canada.psra_canada_agg_losses_q95_r1(
loss_type varchar,
prname varchar,
loss_value float,
exposed_value float,
loss_ratio float
);


-- script to agg losses stats
DROP TABLE IF EXISTS psra_canada.psra_canada_agg_losses_stats_b0, psra_canada.psra_canada_agg_losses_stats_r1, psra_canada.psra_canada_agg_losses_stats CASCADE;

-- create table
CREATE TABLE psra_canada.psra_canada_agg_losses_stats_b0(
loss_type varchar,
prname varchar,
loss_value float,
exposed_value float,
loss_ratio float
);

CREATE TABLE psra_canada.psra_canada_agg_losses_stats_r1(
loss_type varchar,
prname varchar,
loss_value float,
exposed_value float,
loss_ratio float
);



 /* psra_3.Create_table_src_loss_table.sql */
-- script to agg curves stats
DROP TABLE IF EXISTS psra_canada.psra_canada_src_loss_b0, psra_canada.psra_canada_src_loss_r1, psra_canada.psra_canada_src_loss CASCADE;

-- create table
CREATE TABLE psra_canada.psra_canada_src_loss_b0(
source varchar,
loss_type varchar,
loss_value float
);

-- create table
CREATE TABLE psra_canada.psra_canada_src_loss_r1(
source varchar,
loss_type varchar,
loss_value float
);