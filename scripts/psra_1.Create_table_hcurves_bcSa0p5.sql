-- script to generate hazard map mean
CREATE SCHEMA IF NOT EXISTS psra_bc;

DROP TABLE IF EXISTS psra_bc.psra_bc_hcurves_sa0p5 CASCADE;

-- create table
CREATE TABLE psra_bc.psra_bc_hcurves_sa0p5(
lon float,
lat float,
depth float,
"poe-0.0500000" float,
"poe-0.0658662" float,
"poe-0.0867671" float,
"poe-0.1143003" float,
"poe-0.1505706" float,
"poe-0.1983502" float,
"poe-0.2612914" float,
"poe-0.3442054" float,
"poe-0.4534299" float,
"poe-0.5973140" float,
"poe-0.7868559" float,
"poe-1.0365439" float,
"poe-1.3654639" float,
"poe-1.7987580" float,
"poe-2.3695466" float,
"poe-3.1214600" float,
"poe-4.1119734" float,
"poe-5.4168002" float,
"poe-7.1356795" float,
"poe-9.4000000" float

);

-- import exposure from csv
COPY psra_bc.psra_bc_hcurves_sa0p5(lon,lat,depth,"poe-0.0500000","poe-0.0658662","poe-0.0867671","poe-0.1143003","poe-0.1505706","poe-0.1983502",
"poe-0.2612914","poe-0.3442054","poe-0.4534299","poe-0.5973140","poe-0.7868559","poe-1.0365439","poe-1.3654639","poe-1.7987580","poe-2.3695466",
"poe-3.1214600","poe-4.1119734","poe-5.4168002","poe-7.1356795","poe-9.4000000" )
    FROM '/usr/src/app/cHazard/BC/cH_BC_hcurves_Sa0p5.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;