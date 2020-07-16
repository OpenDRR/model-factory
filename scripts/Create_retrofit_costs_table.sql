-- script to generate retrofit costs table

DROP TABLE IF EXISTS lut.retrofit_costs;

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

-- import exposure from csv
COPY lut.retrofit_costs ("Eq_BldgType", "Description", "BldgArea_ft2", "USD_ft2__pre1917", "USD_ft2_1917_1975", "USD_ft2_1975_2019", "RetrofitCost_pc_Total", "USD_RetrofitCost_Bldg", "CAD_RetrofitCost_Bldg")
    FROM '/usr/src/app/retrofit_costs.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;