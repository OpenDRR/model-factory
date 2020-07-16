-- script to generate collapse probability table

DROP TABLE IF EXISTS lut.collapse_probability;

-- create table
CREATE TABLE lut.collapse_probability(
    "typology" varchar,
    "eqbldgtype" varchar,
    "collapse_pc" float
     
);

-- import exposure from csv
COPY lut.collapse_probability ("typology", "eqbldgtype", "collapse_pc")
    FROM '/usr/src/app/collapse_probability.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;