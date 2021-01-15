-- script to agg curves stats
DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_agg_curves_stats_b0, psra_{prov}.psra_{prov}_agg_curves_stats_r2, psra_{prov}.psra_{prov}_agg_curves_stats CASCADE;

-- create table
CREATE TABLE psra_{prov}.psra_{prov}_agg_curves_stats_b0(
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
COPY psra_{prov}.psra_{prov}_agg_curves_stats_b0(return_period,stat,loss_type,fsauid,"GenOcc","GenType",loss_value,loss_ratio,annual_frequency_of_exceedence)
    FROM '/usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-stats_b0.csv'
        WITH 
          DELIMITER AS ','
          CSV ;



-- create table
CREATE TABLE psra_{prov}.psra_{prov}_agg_curves_stats_r2(
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
COPY psra_{prov}.psra_{prov}_agg_curves_stats_r2(return_period,stat,loss_type,fsauid,"GenOcc","GenType",loss_value,loss_ratio,annual_frequency_of_exceedence)
    FROM '/usr/src/app/ebRisk/{prov}/ebR_{prov}_agg_curves-stats_r2.csv'
        WITH 
          DELIMITER AS ','
          CSV ;



-- combine b0 and r2 tables
CREATE TABLE psra_{prov}.psra_{prov}_agg_curves_stats AS
(SELECT
a.return_period,
a.stat,
a.loss_type,
a.fsauid,
a."GenOcc",
a."GenType",
a.loss_value AS "loss_value_b0",
a.loss_ratio AS "loss_ratio_b0",
b.loss_value AS "loss_value_r2",
b.loss_ratio AS "loss_ratio_r2",
a.annual_frequency_of_exceedence
FROM psra_{prov}.psra_{prov}_agg_curves_stats_b0 a
LEFT JOIN psra_{prov}.psra_{prov}_agg_curves_stats_r2 b ON a.return_period = b.return_period AND a.stat = b.stat AND a.loss_type = b.loss_type AND a.fsauid = b.fsauid AND a."GenOcc" = b."GenOcc" AND
a."GenType" = b."GenType" and a.annual_frequency_of_exceedence = b.annual_frequency_of_exceedence);



DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_agg_curves_stats_b0, psra_{prov}.psra_{prov}_agg_curves_stats_r2;