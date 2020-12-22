-- script to agg curves stats
DROP TABLE IF EXISTS psra_bc.psra_bc5920a1_src_loss_b0, psra_bc.psra_bc5920a1_src_loss_r2, psra_bc.psra_bc5920a1_src_loss CASCADE;

-- create table
CREATE TABLE psra_bc.psra_bc5920a1_src_loss_b0(
source varchar,
loss_type varchar,
loss_value float,
trt varchar
);

-- import exposure from csv
COPY psra_bc.psra_bc5920a1_src_loss_b0(source,loss_type,loss_value,trt)
    FROM '/usr/src/app/ebRisk/BC/ebR_BC5920A1_src_loss_table_b0.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;



-- create table
CREATE TABLE psra_bc.psra_bc5920a1_src_loss_r2(
source varchar,
loss_type varchar,
loss_value float,
trt varchar
);

-- import exposure from csv
COPY psra_bc.psra_bc5920a1_src_loss_r2(source,loss_type,loss_value,trt)
    FROM '/usr/src/app/ebRisk/BC/ebR_BC5920A1_src_loss_table_r2.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;


CREATE TABLE psra_bc.psra_bc5920a1_src_loss AS
(
SELECT a.source,
a.loss_type,
a.trt,
a.loss_value AS "loss_value_b0",
b.loss_value AS "loss_value_r2"

FROM psra_bc.psra_bc5920a1_src_loss_b0 a
INNER JOIN psra_bc.psra_bc5920a1_src_loss_r2 b ON a.source = b.source AND a.loss_type = b.loss_type AND a.trt = b.trt
);

DROP TABLE IF EXISTS psra_bc.psra_bc5920a1_src_loss_b0, psra_bc.psra_bc5920a1_src_loss_r2 CASCADE;