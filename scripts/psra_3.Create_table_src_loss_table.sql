-- script to agg curves stats
DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_src_loss_b0, psra_{prov}.psra_{prov}_src_loss_r2, psra_{prov}.psra_{prov}_src_loss, psra_{prov}.psra_{prov}_src_loss_b0_temp, psra_{prov}.psra_{prov}_src_loss_r2_temp CASCADE;


-- create table
CREATE TABLE psra_{prov}.psra_{prov}_src_loss_b0(
source varchar,
loss_type varchar,
loss_value float,
trt varchar,
region varchar
);

-- import exposure from csv
COPY psra_{prov}.psra_{prov}_src_loss_b0(source,loss_type,loss_value,trt,region)
    FROM '/usr/src/app/ebRisk/{prov}/ebR_{prov}_src_loss_table_b0.csv'
        WITH 
          DELIMITER AS ','
          CSV ;



-- create temp table for agg
CREATE TABLE psra_{prov}.psra_{prov}_src_loss_b0_temp AS
(
SELECT
source,
loss_type,
trt,
SUM(loss_value) AS "loss_value",
region

FROM psra_{prov}.psra_{prov}_src_loss_b0
GROUP BY source,loss_type,trt,region);




-- create table
CREATE TABLE psra_{prov}.psra_{prov}_src_loss_r2(
source varchar,
loss_type varchar,
loss_value float,
trt varchar,
region varchar
);

-- import exposure from csv
COPY psra_{prov}.psra_{prov}_src_loss_r2(source,loss_type,loss_value,trt,region)
    FROM '/usr/src/app/ebRisk/{prov}/ebR_{prov}_src_loss_table_r2.csv'
        WITH 
          DELIMITER AS ','
          CSV ;




-- create temp table for agg
CREATE TABLE psra_{prov}.psra_{prov}_src_loss_r2_temp AS
(
SELECT
source,
loss_type,
trt,
region
SUM(loss_value) AS "loss_value"

FROM psra_{prov}.psra_{prov}_src_loss_r2
GROUP BY source,loss_type,trt,region);




CREATE TABLE psra_{prov}.psra_{prov}_src_loss AS
(
SELECT a.source,
a.loss_type,
a.trt,
a.region,
a.loss_value AS "loss_value_b0",
b.loss_value AS "loss_value_r2"

FROM psra_{prov}.psra_{prov}_src_loss_b0_temp a
INNER JOIN psra_{prov}.psra_{prov}_src_loss_r2_temp b ON a.source = b.source AND a.loss_type = b.loss_type AND a.trt = b.trt AND a.region = b.region
);

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_src_loss_b0_temp, psra_{prov}.psra_{prov}_src_loss_r2_temp CASCADE;