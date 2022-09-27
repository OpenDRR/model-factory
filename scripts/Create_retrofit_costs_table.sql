-- script to generate retrofit costs table

DROP TABLE IF EXISTS lut.retrofit_costs CASCADE;

-- create table
CREATE TABLE lut.retrofit_costs(
    PRIMARY KEY ("Eq_BldgType"),
    "Eq_BldgType" varchar,
    "Description" varchar,
    "BldgArea_ft2" float,
    "USD_ft2__pre1917" float,
    "USD_ft2_1917_1975" float,
    "USD_ft2_1975_2019" float,
    "RetrofitCost_pc_Total" float,
    "USD_RetrofitCost_Bldg" float,
    "CAD_RetrofitCost_Bldg" float

);
