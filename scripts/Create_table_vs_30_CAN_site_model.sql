-- script to generate Canada exposure table

DROP TABLE IF EXISTS vs30.vs30_can_site_model;


-- create table
CREATE TABLE vs30.vs30_can_site_model(
    lon float,
    lat float,
    vs30 float,
    z1pt0 float,
    z2pt5 float   
);