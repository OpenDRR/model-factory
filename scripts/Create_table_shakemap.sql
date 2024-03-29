-- script to generate shakemap table
DROP TABLE IF EXISTS gmf.shakemap_{eqScenario} CASCADE;

-- create table
CREATE TABLE gmf.shakemap_{eqScenario}
(
    site_id varchar,
    gmv_PGA float,
    gmv_PGV float,
    "gmv_SA(0.1)" float,
    "gmv_SA(0.2)" float,
    "gmv_SA(0.3)" float,
    "gmv_SA(0.5)" float,
    "gmv_SA(0.6)" float,
    "gmv_SA(1.0)" float,
    "gmv_SA(2.0)" float,
    lon float,
    lat float
    
);
