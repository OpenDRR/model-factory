-- script to generate hazard map mean
CREATE SCHEMA IF NOT EXISTS psra_bc;

DROP TABLE IF EXISTS psra_bc.psra_bc_hcurves_sa0p3 CASCADE;

-- create table
CREATE TABLE psra_bc.psra_bc_hcurves_sa0p3(
lon float,
lat float,
depth float,
"poe_0.0500000" float,
"poe_0.0637137" float,
"poe_0.0811888" float,
"poe_0.1034569" float,
"poe_0.1318325" float,
"poe_0.1679909" float,
"poe_0.2140666" float,
"poe_0.2727797" float,
"poe_0.3475964" float,
"poe_0.4429334" float,
"poe_0.5644189" float,
"poe_0.7192249" float,
"poe_0.9164904" float,
"poe_1.1678607" float,
"poe_1.4881757" float,
"poe_1.8963451" float,
"poe_2.4164651" float,
"poe_3.0792411" float,
"poe_3.9237999" float,
"poe_5.0000000" float

);

-- import exposure from csv
COPY psra_bc.psra_bc_hcurves_sa0p3(lon,lat,depth,"poe_0.0500000" ,"poe_0.0637137" ,"poe_0.0811888" ,"poe_0.1034569" ,"poe_0.1318325" ,"poe_0.1679909" ,
"poe_0.2140666" ,"poe_0.2727797" ,"poe_0.3475964" ,"poe_0.4429334" ,"poe_0.5644189" ,"poe_0.7192249" ,"poe_0.9164904","poe_1.1678607" ,
"poe_1.4881757" ,"poe_1.8963451" ,"poe_2.4164651" ,"poe_3.0792411" ,"poe_3.9237999" ,"poe_5.0000000" )
    FROM '/usr/src/app/chazard/bc/cH_BC_hcurves_sa0p3.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;