-- script to agg curves stats
DROP TABLE IF EXISTS psra_bc.psra_bc5920a1_agg_curves_stats_b0, psra_bc.psra_bc5920a1_agg_curves_stats_r2 CASCADE;

-- create table
CREATE TABLE psra_bc.psra_bc5920a1_agg_curves_stats_b0(
return_period varchar,
stat varchar,
loss_type varchar,
fsauid varchar,
"GenOcc" varchar,
"GenType" varchar,
loss_value float,
loss_ratio float,
annual_frequency_of_exceedence float
);

-- import exposure from csv
COPY psra_bc.psra_bc5920a1_agg_curves_stats_b0(return_period,stat,loss_type,fsauid,"GenOcc","GenType",loss_value,loss_ratio,annual_frequency_of_exceedence)
    FROM '/usr/src/app/ebrisk/bc/ebR_BC5920A1_agg_curves-stats_b0.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;



-- create table
CREATE TABLE psra_bc.psra_bc5920a1_agg_curves_stats_r2(
return_period varchar,
stat varchar,
loss_type varchar,
fsauid varchar,
"GenOcc" varchar,
"GenType" varchar,
loss_value float,
loss_ratio float,
annual_frequency_of_exceedence float
);

-- import exposure from csv
COPY psra_bc.psra_bc5920a1_agg_curves_stats_r2(return_period,stat,loss_type,fsauid,"GenOcc","GenType",loss_value,loss_ratio,annual_frequency_of_exceedence)
    FROM '/usr/src/app/ebrisk/bc/ebR_BC5920A1_agg_curves-stats_r2.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;