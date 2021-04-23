-- script to generate collapse probability table

DROP TABLE IF EXISTS lut.collapse_probability CASCADE;

-- create table
CREATE TABLE lut.collapse_probability(
    "typology" varchar,
    "eqbldgtype" varchar,
    "collapse_pc" float
     
);