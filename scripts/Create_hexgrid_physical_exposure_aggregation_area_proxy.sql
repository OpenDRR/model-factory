-- test aggregation to hexgrid grids area proxy

-- clipped
--1km
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_1km CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_1km AS 

SELECT
c.gridid_1,
SUM(a."Et_BldgArea" * b.area_ratio) AS "ET_BldgArea",
SUM(a."Et_BldgAreaRes" * b.area_ratio) AS "Et_BldgAreaRes",
SUM(a."Et_BldgAreaComm" * b.area_ratio) AS "Et_BldgAreaComm",
SUM(a."Et_BldgAreaInd" * b.area_ratio) AS "Et_BldgAreaInd",
SUM(a."Et_BldgAreaCivic" * b.area_ratio) AS "Et_BldgAreaCivic",
SUM(a."Et_BldgAreaAgr" * b.area_ratio) AS "Et_BldgAreaAgr",
SUM(a."Et_BldgNum" * b.area_ratio) AS "Et_BldgNum",
SUM(a."E_CensusPop" * b.area_ratio) AS "E_CensusPop",
SUM(a."E_CensusDU" * b.area_ratio) AS "E_CensusDU",
SUM(a."E_People_DU" * b.area_ratio) AS "E_People_DU",
AVG(a."Et_PopDay_Km2" * b.area_ratio) AS "Et_PopDay_Km2",
AVG(a."Et_PopDay_Ha" * b.area_ratio) AS "Et_PopDay_Ha",
AVG(a."Et_PopNight_Km2" * b.area_ratio) AS "Et_PopNight_Km2",
AVG(a."Et_PopNight_Ha" * b.area_ratio) AS "Et_PopNight_Ha",
AVG(a."Et_Bldg_Km2" * b.area_ratio) AS "Et_Bldg_Km2",
AVG(a."Et_Value_Km2" * b.area_ratio) AS "Et_Value_Km2",
SUM(a."Et_Res" * b.area_ratio) AS "Et_Res",
SUM(a."Et_Comm" * b.area_ratio) AS "Et_Comm",
SUM(a."Et_Ind" * b.area_ratio) AS "Et_Ind",
SUM(a."Et_Civic" * b.area_ratio) AS "Et_Civic",
SUM(a."Et_Agr" * b.area_ratio) AS "Et_Agr",
SUM(a."Et_SFHshld" * b.area_ratio) AS "Et_SFHshld",
SUM(a."Et_MFHshld" * b.area_ratio) AS "ET_MFHshld",
SUM(a."Et_Wood" * b.area_ratio) AS "Et_Wood",
SUM(a."Et_Concrete" * b.area_ratio) AS "Et_Concrete",
SUM(a."Et_PreCast" * b.area_ratio) AS "Et_PreCast",
SUM(a."Et_RMasonry" * b.area_ratio) AS "Et_RMasonry",
SUM(a."Et_URMasonry" * b.area_ratio) AS "Et_URMasonry",
SUM(a."Et_Steel" * b.area_ratio) AS "Et_Steel",
SUM(a."Et_Manufacture" * b.area_ratio) AS "Et_Manufacture",
SUM(a."Et_PreCode" * b.area_ratio) AS "Et_PreCode",
SUM(a."Et_LowCode" * b.area_ratio) AS "Et_LowCode",
SUM(a."Et_ModCode" * b.area_ratio) AS "Et_ModCode",
SUM(a."Et_HiCode" * b.area_ratio) AS "Et_HiCode",
SUM(a."Et_PopDay" * b.area_ratio) AS "Et_PopDay",
SUM(a."Et_PopNight" * b.area_ratio) AS "Et_PopNight",
SUM(a."Et_PopTransit" * b.area_ratio) AS "Et_PopTransit",
SUM(a."Et_AssetValue" * b.area_ratio) AS "Et_AssetValue",
SUM(a."Et_BldgValue" * b.area_ratio) AS "Et_BldgValue",
SUM(a."Et_StrValue" * b.area_ratio) AS "Et_StrValue",
SUM(a."Et_NStrValue" * b.area_ratio) AS "Et_NStrValue",
SUM(a."Et_ContValue" * b.area_ratio) AS "Et_ContValue",

c.geom

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s a
LEFT JOIN boundaries."SAUID_HexGrid_1km_intersect" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_1km" c ON b.gridid_1 = c.gridid_1
GROUP BY c.gridid_1,c.geom;



--5km
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_5km CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_5km AS 

SELECT
c.gridid_5,
SUM(a."Et_BldgArea" * b.area_ratio) AS "ET_BldgArea",
SUM(a."Et_BldgAreaRes" * b.area_ratio) AS "Et_BldgAreaRes",
SUM(a."Et_BldgAreaComm" * b.area_ratio) AS "Et_BldgAreaComm",
SUM(a."Et_BldgAreaInd" * b.area_ratio) AS "Et_BldgAreaInd",
SUM(a."Et_BldgAreaCivic" * b.area_ratio) AS "Et_BldgAreaCivic",
SUM(a."Et_BldgAreaAgr" * b.area_ratio) AS "Et_BldgAreaAgr",
SUM(a."Et_BldgNum" * b.area_ratio) AS "Et_BldgNum",
SUM(a."E_CensusPop" * b.area_ratio) AS "E_CensusPop",
SUM(a."E_CensusDU" * b.area_ratio) AS "E_CensusDU",
SUM(a."E_People_DU" * b.area_ratio) AS "E_People_DU",
AVG(a."Et_PopDay_Km2" * b.area_ratio) AS "Et_PopDay_Km2",
AVG(a."Et_PopDay_Ha" * b.area_ratio) AS "Et_PopDay_Ha",
AVG(a."Et_PopNight_Km2" * b.area_ratio) AS "Et_PopNight_Km2",
AVG(a."Et_PopNight_Ha" * b.area_ratio) AS "Et_PopNight_Ha",
AVG(a."Et_Bldg_Km2" * b.area_ratio) AS "Et_Bldg_Km2",
AVG(a."Et_Value_Km2" * b.area_ratio) AS "Et_Value_Km2",
SUM(a."Et_Res" * b.area_ratio) AS "Et_Res",
SUM(a."Et_Comm" * b.area_ratio) AS "Et_Comm",
SUM(a."Et_Ind" * b.area_ratio) AS "Et_Ind",
SUM(a."Et_Civic" * b.area_ratio) AS "Et_Civic",
SUM(a."Et_Agr" * b.area_ratio) AS "Et_Agr",
SUM(a."Et_SFHshld" * b.area_ratio) AS "Et_SFHshld",
SUM(a."Et_MFHshld" * b.area_ratio) AS "ET_MFHshld",
SUM(a."Et_Wood" * b.area_ratio) AS "Et_Wood",
SUM(a."Et_Concrete" * b.area_ratio) AS "Et_Concrete",
SUM(a."Et_PreCast" * b.area_ratio) AS "Et_PreCast",
SUM(a."Et_RMasonry" * b.area_ratio) AS "Et_RMasonry",
SUM(a."Et_URMasonry" * b.area_ratio) AS "Et_URMasonry",
SUM(a."Et_Steel" * b.area_ratio) AS "Et_Steel",
SUM(a."Et_Manufacture" * b.area_ratio) AS "Et_Manufacture",
SUM(a."Et_PreCode" * b.area_ratio) AS "Et_PreCode",
SUM(a."Et_LowCode" * b.area_ratio) AS "Et_LowCode",
SUM(a."Et_ModCode" * b.area_ratio) AS "Et_ModCode",
SUM(a."Et_HiCode" * b.area_ratio) AS "Et_HiCode",
SUM(a."Et_PopDay" * b.area_ratio) AS "Et_PopDay",
SUM(a."Et_PopNight" * b.area_ratio) AS "Et_PopNight",
SUM(a."Et_PopTransit" * b.area_ratio) AS "Et_PopTransit",
SUM(a."Et_AssetValue" * b.area_ratio) AS "Et_AssetValue",
SUM(a."Et_BldgValue" * b.area_ratio) AS "Et_BldgValue",
SUM(a."Et_StrValue" * b.area_ratio) AS "Et_StrValue",
SUM(a."Et_NStrValue" * b.area_ratio) AS "Et_NStrValue",
SUM(a."Et_ContValue" * b.area_ratio) AS "Et_ContValue",

c.geom

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s a
LEFT JOIN boundaries."SAUID_HexGrid_5km_intersect" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_5km" c ON b.gridid_5 = c.gridid_5
GROUP BY c.gridid_5,c.geom;



--10km
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_10km CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_10km AS 

SELECT
c.gridid_10,
SUM(a."Et_BldgArea" * b.area_ratio) AS "ET_BldgArea",
SUM(a."Et_BldgAreaRes" * b.area_ratio) AS "Et_BldgAreaRes",
SUM(a."Et_BldgAreaComm" * b.area_ratio) AS "Et_BldgAreaComm",
SUM(a."Et_BldgAreaInd" * b.area_ratio) AS "Et_BldgAreaInd",
SUM(a."Et_BldgAreaCivic" * b.area_ratio) AS "Et_BldgAreaCivic",
SUM(a."Et_BldgAreaAgr" * b.area_ratio) AS "Et_BldgAreaAgr",
SUM(a."Et_BldgNum" * b.area_ratio) AS "Et_BldgNum",
SUM(a."E_CensusPop" * b.area_ratio) AS "E_CensusPop",
SUM(a."E_CensusDU" * b.area_ratio) AS "E_CensusDU",
SUM(a."E_People_DU" * b.area_ratio) AS "E_People_DU",
AVG(a."Et_PopDay_Km2" * b.area_ratio) AS "Et_PopDay_Km2",
AVG(a."Et_PopDay_Ha" * b.area_ratio) AS "Et_PopDay_Ha",
AVG(a."Et_PopNight_Km2" * b.area_ratio) AS "Et_PopNight_Km2",
AVG(a."Et_PopNight_Ha" * b.area_ratio) AS "Et_PopNight_Ha",
AVG(a."Et_Bldg_Km2" * b.area_ratio) AS "Et_Bldg_Km2",
AVG(a."Et_Value_Km2" * b.area_ratio) AS "Et_Value_Km2",
SUM(a."Et_Res" * b.area_ratio) AS "Et_Res",
SUM(a."Et_Comm" * b.area_ratio) AS "Et_Comm",
SUM(a."Et_Ind" * b.area_ratio) AS "Et_Ind",
SUM(a."Et_Civic" * b.area_ratio) AS "Et_Civic",
SUM(a."Et_Agr" * b.area_ratio) AS "Et_Agr",
SUM(a."Et_SFHshld" * b.area_ratio) AS "Et_SFHshld",
SUM(a."Et_MFHshld" * b.area_ratio) AS "ET_MFHshld",
SUM(a."Et_Wood" * b.area_ratio) AS "Et_Wood",
SUM(a."Et_Concrete" * b.area_ratio) AS "Et_Concrete",
SUM(a."Et_PreCast" * b.area_ratio) AS "Et_PreCast",
SUM(a."Et_RMasonry" * b.area_ratio) AS "Et_RMasonry",
SUM(a."Et_URMasonry" * b.area_ratio) AS "Et_URMasonry",
SUM(a."Et_Steel" * b.area_ratio) AS "Et_Steel",
SUM(a."Et_Manufacture" * b.area_ratio) AS "Et_Manufacture",
SUM(a."Et_PreCode" * b.area_ratio) AS "Et_PreCode",
SUM(a."Et_LowCode" * b.area_ratio) AS "Et_LowCode",
SUM(a."Et_ModCode" * b.area_ratio) AS "Et_ModCode",
SUM(a."Et_HiCode" * b.area_ratio) AS "Et_HiCode",
SUM(a."Et_PopDay" * b.area_ratio) AS "Et_PopDay",
SUM(a."Et_PopNight" * b.area_ratio) AS "Et_PopNight",
SUM(a."Et_PopTransit" * b.area_ratio) AS "Et_PopTransit",
SUM(a."Et_AssetValue" * b.area_ratio) AS "Et_AssetValue",
SUM(a."Et_BldgValue" * b.area_ratio) AS "Et_BldgValue",
SUM(a."Et_StrValue" * b.area_ratio) AS "Et_StrValue",
SUM(a."Et_NStrValue" * b.area_ratio) AS "Et_NStrValue",
SUM(a."Et_ContValue" * b.area_ratio) AS "Et_ContValue",

c.geom

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s a
LEFT JOIN boundaries."SAUID_HexGrid_10km_intersect" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_10km" c ON b.gridid_10 = c.gridid_10
GROUP BY c.gridid_10,c.geom;



--25km
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_25km CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_25km AS 

SELECT
c.gridid_25,
SUM(a."Et_BldgArea" * b.area_ratio) AS "ET_BldgArea",
SUM(a."Et_BldgAreaRes" * b.area_ratio) AS "Et_BldgAreaRes",
SUM(a."Et_BldgAreaComm" * b.area_ratio) AS "Et_BldgAreaComm",
SUM(a."Et_BldgAreaInd" * b.area_ratio) AS "Et_BldgAreaInd",
SUM(a."Et_BldgAreaCivic" * b.area_ratio) AS "Et_BldgAreaCivic",
SUM(a."Et_BldgAreaAgr" * b.area_ratio) AS "Et_BldgAreaAgr",
SUM(a."Et_BldgNum" * b.area_ratio) AS "Et_BldgNum",
SUM(a."E_CensusPop" * b.area_ratio) AS "E_CensusPop",
SUM(a."E_CensusDU" * b.area_ratio) AS "E_CensusDU",
SUM(a."E_People_DU" * b.area_ratio) AS "E_People_DU",
AVG(a."Et_PopDay_Km2" * b.area_ratio) AS "Et_PopDay_Km2",
AVG(a."Et_PopDay_Ha" * b.area_ratio) AS "Et_PopDay_Ha",
AVG(a."Et_PopNight_Km2" * b.area_ratio) AS "Et_PopNight_Km2",
AVG(a."Et_PopNight_Ha" * b.area_ratio) AS "Et_PopNight_Ha",
AVG(a."Et_Bldg_Km2" * b.area_ratio) AS "Et_Bldg_Km2",
AVG(a."Et_Value_Km2" * b.area_ratio) AS "Et_Value_Km2",
SUM(a."Et_Res" * b.area_ratio) AS "Et_Res",
SUM(a."Et_Comm" * b.area_ratio) AS "Et_Comm",
SUM(a."Et_Ind" * b.area_ratio) AS "Et_Ind",
SUM(a."Et_Civic" * b.area_ratio) AS "Et_Civic",
SUM(a."Et_Agr" * b.area_ratio) AS "Et_Agr",
SUM(a."Et_SFHshld" * b.area_ratio) AS "Et_SFHshld",
SUM(a."Et_MFHshld" * b.area_ratio) AS "ET_MFHshld",
SUM(a."Et_Wood" * b.area_ratio) AS "Et_Wood",
SUM(a."Et_Concrete" * b.area_ratio) AS "Et_Concrete",
SUM(a."Et_PreCast" * b.area_ratio) AS "Et_PreCast",
SUM(a."Et_RMasonry" * b.area_ratio) AS "Et_RMasonry",
SUM(a."Et_URMasonry" * b.area_ratio) AS "Et_URMasonry",
SUM(a."Et_Steel" * b.area_ratio) AS "Et_Steel",
SUM(a."Et_Manufacture" * b.area_ratio) AS "Et_Manufacture",
SUM(a."Et_PreCode" * b.area_ratio) AS "Et_PreCode",
SUM(a."Et_LowCode" * b.area_ratio) AS "Et_LowCode",
SUM(a."Et_ModCode" * b.area_ratio) AS "Et_ModCode",
SUM(a."Et_HiCode" * b.area_ratio) AS "Et_HiCode",
SUM(a."Et_PopDay" * b.area_ratio) AS "Et_PopDay",
SUM(a."Et_PopNight" * b.area_ratio) AS "Et_PopNight",
SUM(a."Et_PopTransit" * b.area_ratio) AS "Et_PopTransit",
SUM(a."Et_AssetValue" * b.area_ratio) AS "Et_AssetValue",
SUM(a."Et_BldgValue" * b.area_ratio) AS "Et_BldgValue",
SUM(a."Et_StrValue" * b.area_ratio) AS "Et_StrValue",
SUM(a."Et_NStrValue" * b.area_ratio) AS "Et_NStrValue",
SUM(a."Et_ContValue" * b.area_ratio) AS "Et_ContValue",
c.geom

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s a
LEFT JOIN boundaries."SAUID_HexGrid_25km_intersect" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_25km" c ON b.gridid_25 = c.gridid_25
GROUP BY c.gridid_25,c.geom;


--global fabric
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_global_fabric CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_global_fabric AS 

SELECT
c.gridid,
SUM(a."Et_BldgArea" * b.area_ratio) AS "ET_BldgArea",
SUM(a."Et_BldgAreaRes" * b.area_ratio) AS "Et_BldgAreaRes",
SUM(a."Et_BldgAreaComm" * b.area_ratio) AS "Et_BldgAreaComm",
SUM(a."Et_BldgAreaInd" * b.area_ratio) AS "Et_BldgAreaInd",
SUM(a."Et_BldgAreaCivic" * b.area_ratio) AS "Et_BldgAreaCivic",
SUM(a."Et_BldgAreaAgr" * b.area_ratio) AS "Et_BldgAreaAgr",
SUM(a."Et_BldgNum" * b.area_ratio) AS "Et_BldgNum",
SUM(a."E_CensusPop" * b.area_ratio) AS "E_CensusPop",
SUM(a."E_CensusDU" * b.area_ratio) AS "E_CensusDU",
SUM(a."E_People_DU" * b.area_ratio) AS "E_People_DU",
AVG(a."Et_PopDay_Km2" * b.area_ratio) AS "Et_PopDay_Km2",
AVG(a."Et_PopDay_Ha" * b.area_ratio) AS "Et_PopDay_Ha",
AVG(a."Et_PopNight_Km2" * b.area_ratio) AS "Et_PopNight_Km2",
AVG(a."Et_PopNight_Ha" * b.area_ratio) AS "Et_PopNight_Ha",
AVG(a."Et_Bldg_Km2" * b.area_ratio) AS "Et_Bldg_Km2",
AVG(a."Et_Value_Km2" * b.area_ratio) AS "Et_Value_Km2",
SUM(a."Et_Res" * b.area_ratio) AS "Et_Res",
SUM(a."Et_Comm" * b.area_ratio) AS "Et_Comm",
SUM(a."Et_Ind" * b.area_ratio) AS "Et_Ind",
SUM(a."Et_Civic" * b.area_ratio) AS "Et_Civic",
SUM(a."Et_Agr" * b.area_ratio) AS "Et_Agr",
SUM(a."Et_SFHshld" * b.area_ratio) AS "Et_SFHshld",
SUM(a."Et_MFHshld" * b.area_ratio) AS "ET_MFHshld",
SUM(a."Et_Wood" * b.area_ratio) AS "Et_Wood",
SUM(a."Et_Concrete" * b.area_ratio) AS "Et_Concrete",
SUM(a."Et_PreCast" * b.area_ratio) AS "Et_PreCast",
SUM(a."Et_RMasonry" * b.area_ratio) AS "Et_RMasonry",
SUM(a."Et_URMasonry" * b.area_ratio) AS "Et_URMasonry",
SUM(a."Et_Steel" * b.area_ratio) AS "Et_Steel",
SUM(a."Et_Manufacture" * b.area_ratio) AS "Et_Manufacture",
SUM(a."Et_PreCode" * b.area_ratio) AS "Et_PreCode",
SUM(a."Et_LowCode" * b.area_ratio) AS "Et_LowCode",
SUM(a."Et_ModCode" * b.area_ratio) AS "Et_ModCode",
SUM(a."Et_HiCode" * b.area_ratio) AS "Et_HiCode",
SUM(a."Et_PopDay" * b.area_ratio) AS "Et_PopDay",
SUM(a."Et_PopNight" * b.area_ratio) AS "Et_PopNight",
SUM(a."Et_PopTransit" * b.area_ratio) AS "Et_PopTransit",
SUM(a."Et_AssetValue" * b.area_ratio) AS "Et_AssetValue",
SUM(a."Et_BldgValue" * b.area_ratio) AS "Et_BldgValue",
SUM(a."Et_StrValue" * b.area_ratio) AS "Et_StrValue",
SUM(a."Et_NStrValue" * b.area_ratio) AS "Et_NStrValue",
SUM(a."Et_ContValue" * b.area_ratio) AS "Et_ContValue",

c.geom

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s a
LEFT JOIN boundaries."SAUID_HexGrid_GlobalFabric_intersect" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_GlobalFabric" c ON b.gridid = c.gridid
GROUP BY c.gridid,c.geom;



--unclipped
--1km
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_1km_uc CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_1km_uc AS 

SELECT
c.gridid_1,
SUM(a."Et_BldgArea" * b.area_ratio) AS "ET_BldgArea",
SUM(a."Et_BldgAreaRes" * b.area_ratio) AS "Et_BldgAreaRes",
SUM(a."Et_BldgAreaComm" * b.area_ratio) AS "Et_BldgAreaComm",
SUM(a."Et_BldgAreaInd" * b.area_ratio) AS "Et_BldgAreaInd",
SUM(a."Et_BldgAreaCivic" * b.area_ratio) AS "Et_BldgAreaCivic",
SUM(a."Et_BldgAreaAgr" * b.area_ratio) AS "Et_BldgAreaAgr",
SUM(a."Et_BldgNum" * b.area_ratio) AS "Et_BldgNum",
SUM(a."E_CensusPop" * b.area_ratio) AS "E_CensusPop",
SUM(a."E_CensusDU" * b.area_ratio) AS "E_CensusDU",
SUM(a."E_People_DU" * b.area_ratio) AS "E_People_DU",
AVG(a."Et_PopDay_Km2" * b.area_ratio) AS "Et_PopDay_Km2",
AVG(a."Et_PopDay_Ha" * b.area_ratio) AS "Et_PopDay_Ha",
AVG(a."Et_PopNight_Km2" * b.area_ratio) AS "Et_PopNight_Km2",
AVG(a."Et_PopNight_Ha" * b.area_ratio) AS "Et_PopNight_Ha",
AVG(a."Et_Bldg_Km2" * b.area_ratio) AS "Et_Bldg_Km2",
AVG(a."Et_Value_Km2" * b.area_ratio) AS "Et_Value_Km2",
SUM(a."Et_Res" * b.area_ratio) AS "Et_Res",
SUM(a."Et_Comm" * b.area_ratio) AS "Et_Comm",
SUM(a."Et_Ind" * b.area_ratio) AS "Et_Ind",
SUM(a."Et_Civic" * b.area_ratio) AS "Et_Civic",
SUM(a."Et_Agr" * b.area_ratio) AS "Et_Agr",
SUM(a."Et_SFHshld" * b.area_ratio) AS "Et_SFHshld",
SUM(a."Et_MFHshld" * b.area_ratio) AS "ET_MFHshld",
SUM(a."Et_Wood" * b.area_ratio) AS "Et_Wood",
SUM(a."Et_Concrete" * b.area_ratio) AS "Et_Concrete",
SUM(a."Et_PreCast" * b.area_ratio) AS "Et_PreCast",
SUM(a."Et_RMasonry" * b.area_ratio) AS "Et_RMasonry",
SUM(a."Et_URMasonry" * b.area_ratio) AS "Et_URMasonry",
SUM(a."Et_Steel" * b.area_ratio) AS "Et_Steel",
SUM(a."Et_Manufacture" * b.area_ratio) AS "Et_Manufacture",
SUM(a."Et_PreCode" * b.area_ratio) AS "Et_PreCode",
SUM(a."Et_LowCode" * b.area_ratio) AS "Et_LowCode",
SUM(a."Et_ModCode" * b.area_ratio) AS "Et_ModCode",
SUM(a."Et_HiCode" * b.area_ratio) AS "Et_HiCode",
SUM(a."Et_PopDay" * b.area_ratio) AS "Et_PopDay",
SUM(a."Et_PopNight" * b.area_ratio) AS "Et_PopNight",
SUM(a."Et_PopTransit" * b.area_ratio) AS "Et_PopTransit",
SUM(a."Et_AssetValue" * b.area_ratio) AS "Et_AssetValue",
SUM(a."Et_BldgValue" * b.area_ratio) AS "Et_BldgValue",
SUM(a."Et_StrValue" * b.area_ratio) AS "Et_StrValue",
SUM(a."Et_NStrValue" * b.area_ratio) AS "Et_NStrValue",
SUM(a."Et_ContValue" * b.area_ratio) AS "Et_ContValue",

c.geom

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s a
LEFT JOIN boundaries."SAUID_HexGrid_1km_intersect_unclipped" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_1km_unclipped" c ON b.gridid_1 = c.gridid_1
GROUP BY c.gridid_1,c.geom;



--5km
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_5km_uc CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_5km_uc AS 

SELECT
c.gridid_5,
SUM(a."Et_BldgArea" * b.area_ratio) AS "ET_BldgArea",
SUM(a."Et_BldgAreaRes" * b.area_ratio) AS "Et_BldgAreaRes",
SUM(a."Et_BldgAreaComm" * b.area_ratio) AS "Et_BldgAreaComm",
SUM(a."Et_BldgAreaInd" * b.area_ratio) AS "Et_BldgAreaInd",
SUM(a."Et_BldgAreaCivic" * b.area_ratio) AS "Et_BldgAreaCivic",
SUM(a."Et_BldgAreaAgr" * b.area_ratio) AS "Et_BldgAreaAgr",
SUM(a."Et_BldgNum" * b.area_ratio) AS "Et_BldgNum",
SUM(a."E_CensusPop" * b.area_ratio) AS "E_CensusPop",
SUM(a."E_CensusDU" * b.area_ratio) AS "E_CensusDU",
SUM(a."E_People_DU" * b.area_ratio) AS "E_People_DU",
AVG(a."Et_PopDay_Km2" * b.area_ratio) AS "Et_PopDay_Km2",
AVG(a."Et_PopDay_Ha" * b.area_ratio) AS "Et_PopDay_Ha",
AVG(a."Et_PopNight_Km2" * b.area_ratio) AS "Et_PopNight_Km2",
AVG(a."Et_PopNight_Ha" * b.area_ratio) AS "Et_PopNight_Ha",
AVG(a."Et_Bldg_Km2" * b.area_ratio) AS "Et_Bldg_Km2",
AVG(a."Et_Value_Km2" * b.area_ratio) AS "Et_Value_Km2",
SUM(a."Et_Res" * b.area_ratio) AS "Et_Res",
SUM(a."Et_Comm" * b.area_ratio) AS "Et_Comm",
SUM(a."Et_Ind" * b.area_ratio) AS "Et_Ind",
SUM(a."Et_Civic" * b.area_ratio) AS "Et_Civic",
SUM(a."Et_Agr" * b.area_ratio) AS "Et_Agr",
SUM(a."Et_SFHshld" * b.area_ratio) AS "Et_SFHshld",
SUM(a."Et_MFHshld" * b.area_ratio) AS "ET_MFHshld",
SUM(a."Et_Wood" * b.area_ratio) AS "Et_Wood",
SUM(a."Et_Concrete" * b.area_ratio) AS "Et_Concrete",
SUM(a."Et_PreCast" * b.area_ratio) AS "Et_PreCast",
SUM(a."Et_RMasonry" * b.area_ratio) AS "Et_RMasonry",
SUM(a."Et_URMasonry" * b.area_ratio) AS "Et_URMasonry",
SUM(a."Et_Steel" * b.area_ratio) AS "Et_Steel",
SUM(a."Et_Manufacture" * b.area_ratio) AS "Et_Manufacture",
SUM(a."Et_PreCode" * b.area_ratio) AS "Et_PreCode",
SUM(a."Et_LowCode" * b.area_ratio) AS "Et_LowCode",
SUM(a."Et_ModCode" * b.area_ratio) AS "Et_ModCode",
SUM(a."Et_HiCode" * b.area_ratio) AS "Et_HiCode",
SUM(a."Et_PopDay" * b.area_ratio) AS "Et_PopDay",
SUM(a."Et_PopNight" * b.area_ratio) AS "Et_PopNight",
SUM(a."Et_PopTransit" * b.area_ratio) AS "Et_PopTransit",
SUM(a."Et_AssetValue" * b.area_ratio) AS "Et_AssetValue",
SUM(a."Et_BldgValue" * b.area_ratio) AS "Et_BldgValue",
SUM(a."Et_StrValue" * b.area_ratio) AS "Et_StrValue",
SUM(a."Et_NStrValue" * b.area_ratio) AS "Et_NStrValue",
SUM(a."Et_ContValue" * b.area_ratio) AS "Et_ContValue",

c.geom

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s a
LEFT JOIN boundaries."SAUID_HexGrid_5km_intersect_unclipped" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_5km_unclipped" c ON b.gridid_5 = c.gridid_5
GROUP BY c.gridid_5,c.geom;



--10km
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_10km_uc CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_10km_uc AS 

SELECT
c.gridid_10,
SUM(a."Et_BldgArea" * b.area_ratio) AS "ET_BldgArea",
SUM(a."Et_BldgAreaRes" * b.area_ratio) AS "Et_BldgAreaRes",
SUM(a."Et_BldgAreaComm" * b.area_ratio) AS "Et_BldgAreaComm",
SUM(a."Et_BldgAreaInd" * b.area_ratio) AS "Et_BldgAreaInd",
SUM(a."Et_BldgAreaCivic" * b.area_ratio) AS "Et_BldgAreaCivic",
SUM(a."Et_BldgAreaAgr" * b.area_ratio) AS "Et_BldgAreaAgr",
SUM(a."Et_BldgNum" * b.area_ratio) AS "Et_BldgNum",
SUM(a."E_CensusPop" * b.area_ratio) AS "E_CensusPop",
SUM(a."E_CensusDU" * b.area_ratio) AS "E_CensusDU",
SUM(a."E_People_DU" * b.area_ratio) AS "E_People_DU",
AVG(a."Et_PopDay_Km2" * b.area_ratio) AS "Et_PopDay_Km2",
AVG(a."Et_PopDay_Ha" * b.area_ratio) AS "Et_PopDay_Ha",
AVG(a."Et_PopNight_Km2" * b.area_ratio) AS "Et_PopNight_Km2",
AVG(a."Et_PopNight_Ha" * b.area_ratio) AS "Et_PopNight_Ha",
AVG(a."Et_Bldg_Km2" * b.area_ratio) AS "Et_Bldg_Km2",
AVG(a."Et_Value_Km2" * b.area_ratio) AS "Et_Value_Km2",
SUM(a."Et_Res" * b.area_ratio) AS "Et_Res",
SUM(a."Et_Comm" * b.area_ratio) AS "Et_Comm",
SUM(a."Et_Ind" * b.area_ratio) AS "Et_Ind",
SUM(a."Et_Civic" * b.area_ratio) AS "Et_Civic",
SUM(a."Et_Agr" * b.area_ratio) AS "Et_Agr",
SUM(a."Et_SFHshld" * b.area_ratio) AS "Et_SFHshld",
SUM(a."Et_MFHshld" * b.area_ratio) AS "ET_MFHshld",
SUM(a."Et_Wood" * b.area_ratio) AS "Et_Wood",
SUM(a."Et_Concrete" * b.area_ratio) AS "Et_Concrete",
SUM(a."Et_PreCast" * b.area_ratio) AS "Et_PreCast",
SUM(a."Et_RMasonry" * b.area_ratio) AS "Et_RMasonry",
SUM(a."Et_URMasonry" * b.area_ratio) AS "Et_URMasonry",
SUM(a."Et_Steel" * b.area_ratio) AS "Et_Steel",
SUM(a."Et_Manufacture" * b.area_ratio) AS "Et_Manufacture",
SUM(a."Et_PreCode" * b.area_ratio) AS "Et_PreCode",
SUM(a."Et_LowCode" * b.area_ratio) AS "Et_LowCode",
SUM(a."Et_ModCode" * b.area_ratio) AS "Et_ModCode",
SUM(a."Et_HiCode" * b.area_ratio) AS "Et_HiCode",
SUM(a."Et_PopDay" * b.area_ratio) AS "Et_PopDay",
SUM(a."Et_PopNight" * b.area_ratio) AS "Et_PopNight",
SUM(a."Et_PopTransit" * b.area_ratio) AS "Et_PopTransit",
SUM(a."Et_AssetValue" * b.area_ratio) AS "Et_AssetValue",
SUM(a."Et_BldgValue" * b.area_ratio) AS "Et_BldgValue",
SUM(a."Et_StrValue" * b.area_ratio) AS "Et_StrValue",
SUM(a."Et_NStrValue" * b.area_ratio) AS "Et_NStrValue",
SUM(a."Et_ContValue" * b.area_ratio) AS "Et_ContValue",

c.geom

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s a
LEFT JOIN boundaries."SAUID_HexGrid_10km_intersect_unclipped" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_10km_unclipped" c ON b.gridid_10 = c.gridid_10
GROUP BY c.gridid_10,c.geom;



--25km
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_25km_uc CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_25km_uc AS 

SELECT
c.gridid_25,
SUM(a."Et_BldgArea" * b.area_ratio) AS "ET_BldgArea",
SUM(a."Et_BldgAreaRes" * b.area_ratio) AS "Et_BldgAreaRes",
SUM(a."Et_BldgAreaComm" * b.area_ratio) AS "Et_BldgAreaComm",
SUM(a."Et_BldgAreaInd" * b.area_ratio) AS "Et_BldgAreaInd",
SUM(a."Et_BldgAreaCivic" * b.area_ratio) AS "Et_BldgAreaCivic",
SUM(a."Et_BldgAreaAgr" * b.area_ratio) AS "Et_BldgAreaAgr",
SUM(a."Et_BldgNum" * b.area_ratio) AS "Et_BldgNum",
SUM(a."E_CensusPop" * b.area_ratio) AS "E_CensusPop",
SUM(a."E_CensusDU" * b.area_ratio) AS "E_CensusDU",
SUM(a."E_People_DU" * b.area_ratio) AS "E_People_DU",
AVG(a."Et_PopDay_Km2" * b.area_ratio) AS "Et_PopDay_Km2",
AVG(a."Et_PopDay_Ha" * b.area_ratio) AS "Et_PopDay_Ha",
AVG(a."Et_PopNight_Km2" * b.area_ratio) AS "Et_PopNight_Km2",
AVG(a."Et_PopNight_Ha" * b.area_ratio) AS "Et_PopNight_Ha",
AVG(a."Et_Bldg_Km2" * b.area_ratio) AS "Et_Bldg_Km2",
AVG(a."Et_Value_Km2" * b.area_ratio) AS "Et_Value_Km2",
SUM(a."Et_Res" * b.area_ratio) AS "Et_Res",
SUM(a."Et_Comm" * b.area_ratio) AS "Et_Comm",
SUM(a."Et_Ind" * b.area_ratio) AS "Et_Ind",
SUM(a."Et_Civic" * b.area_ratio) AS "Et_Civic",
SUM(a."Et_Agr" * b.area_ratio) AS "Et_Agr",
SUM(a."Et_SFHshld" * b.area_ratio) AS "Et_SFHshld",
SUM(a."Et_MFHshld" * b.area_ratio) AS "ET_MFHshld",
SUM(a."Et_Wood" * b.area_ratio) AS "Et_Wood",
SUM(a."Et_Concrete" * b.area_ratio) AS "Et_Concrete",
SUM(a."Et_PreCast" * b.area_ratio) AS "Et_PreCast",
SUM(a."Et_RMasonry" * b.area_ratio) AS "Et_RMasonry",
SUM(a."Et_URMasonry" * b.area_ratio) AS "Et_URMasonry",
SUM(a."Et_Steel" * b.area_ratio) AS "Et_Steel",
SUM(a."Et_Manufacture" * b.area_ratio) AS "Et_Manufacture",
SUM(a."Et_PreCode" * b.area_ratio) AS "Et_PreCode",
SUM(a."Et_LowCode" * b.area_ratio) AS "Et_LowCode",
SUM(a."Et_ModCode" * b.area_ratio) AS "Et_ModCode",
SUM(a."Et_HiCode" * b.area_ratio) AS "Et_HiCode",
SUM(a."Et_PopDay" * b.area_ratio) AS "Et_PopDay",
SUM(a."Et_PopNight" * b.area_ratio) AS "Et_PopNight",
SUM(a."Et_PopTransit" * b.area_ratio) AS "Et_PopTransit",
SUM(a."Et_AssetValue" * b.area_ratio) AS "Et_AssetValue",
SUM(a."Et_BldgValue" * b.area_ratio) AS "Et_BldgValue",
SUM(a."Et_StrValue" * b.area_ratio) AS "Et_StrValue",
SUM(a."Et_NStrValue" * b.area_ratio) AS "Et_NStrValue",
SUM(a."Et_ContValue" * b.area_ratio) AS "Et_ContValue",
c.geom

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s a
LEFT JOIN boundaries."SAUID_HexGrid_25km_intersect_unclipped" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_25km_unclipped" c ON b.gridid_25 = c.gridid_25
GROUP BY c.gridid_25,c.geom;

--50km
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_50km_uc CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_50km_uc AS 

SELECT
c.gridid_50,
SUM(a."Et_BldgArea" * b.area_ratio) AS "ET_BldgArea",
SUM(a."Et_BldgAreaRes" * b.area_ratio) AS "Et_BldgAreaRes",
SUM(a."Et_BldgAreaComm" * b.area_ratio) AS "Et_BldgAreaComm",
SUM(a."Et_BldgAreaInd" * b.area_ratio) AS "Et_BldgAreaInd",
SUM(a."Et_BldgAreaCivic" * b.area_ratio) AS "Et_BldgAreaCivic",
SUM(a."Et_BldgAreaAgr" * b.area_ratio) AS "Et_BldgAreaAgr",
SUM(a."Et_BldgNum" * b.area_ratio) AS "Et_BldgNum",
SUM(a."E_CensusPop" * b.area_ratio) AS "E_CensusPop",
SUM(a."E_CensusDU" * b.area_ratio) AS "E_CensusDU",
SUM(a."E_People_DU" * b.area_ratio) AS "E_People_DU",
AVG(a."Et_PopDay_Km2" * b.area_ratio) AS "Et_PopDay_Km2",
AVG(a."Et_PopDay_Ha" * b.area_ratio) AS "Et_PopDay_Ha",
AVG(a."Et_PopNight_Km2" * b.area_ratio) AS "Et_PopNight_Km2",
AVG(a."Et_PopNight_Ha" * b.area_ratio) AS "Et_PopNight_Ha",
AVG(a."Et_Bldg_Km2" * b.area_ratio) AS "Et_Bldg_Km2",
AVG(a."Et_Value_Km2" * b.area_ratio) AS "Et_Value_Km2",
SUM(a."Et_Res" * b.area_ratio) AS "Et_Res",
SUM(a."Et_Comm" * b.area_ratio) AS "Et_Comm",
SUM(a."Et_Ind" * b.area_ratio) AS "Et_Ind",
SUM(a."Et_Civic" * b.area_ratio) AS "Et_Civic",
SUM(a."Et_Agr" * b.area_ratio) AS "Et_Agr",
SUM(a."Et_SFHshld" * b.area_ratio) AS "Et_SFHshld",
SUM(a."Et_MFHshld" * b.area_ratio) AS "ET_MFHshld",
SUM(a."Et_Wood" * b.area_ratio) AS "Et_Wood",
SUM(a."Et_Concrete" * b.area_ratio) AS "Et_Concrete",
SUM(a."Et_PreCast" * b.area_ratio) AS "Et_PreCast",
SUM(a."Et_RMasonry" * b.area_ratio) AS "Et_RMasonry",
SUM(a."Et_URMasonry" * b.area_ratio) AS "Et_URMasonry",
SUM(a."Et_Steel" * b.area_ratio) AS "Et_Steel",
SUM(a."Et_Manufacture" * b.area_ratio) AS "Et_Manufacture",
SUM(a."Et_PreCode" * b.area_ratio) AS "Et_PreCode",
SUM(a."Et_LowCode" * b.area_ratio) AS "Et_LowCode",
SUM(a."Et_ModCode" * b.area_ratio) AS "Et_ModCode",
SUM(a."Et_HiCode" * b.area_ratio) AS "Et_HiCode",
SUM(a."Et_PopDay" * b.area_ratio) AS "Et_PopDay",
SUM(a."Et_PopNight" * b.area_ratio) AS "Et_PopNight",
SUM(a."Et_PopTransit" * b.area_ratio) AS "Et_PopTransit",
SUM(a."Et_AssetValue" * b.area_ratio) AS "Et_AssetValue",
SUM(a."Et_BldgValue" * b.area_ratio) AS "Et_BldgValue",
SUM(a."Et_StrValue" * b.area_ratio) AS "Et_StrValue",
SUM(a."Et_NStrValue" * b.area_ratio) AS "Et_NStrValue",
SUM(a."Et_ContValue" * b.area_ratio) AS "Et_ContValue",

c.geom

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s a
LEFT JOIN boundaries."SAUID_HexGrid_50km_intersect_unclipped" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_50km_unclipped" c ON b.gridid_50 = c.gridid_50
GROUP BY c.gridid_50,c.geom;



--100km
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_100km_uc CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_100km_uc AS 

SELECT
c.gridid_100,
SUM(a."Et_BldgArea" * b.area_ratio) AS "ET_BldgArea",
SUM(a."Et_BldgAreaRes" * b.area_ratio) AS "Et_BldgAreaRes",
SUM(a."Et_BldgAreaComm" * b.area_ratio) AS "Et_BldgAreaComm",
SUM(a."Et_BldgAreaInd" * b.area_ratio) AS "Et_BldgAreaInd",
SUM(a."Et_BldgAreaCivic" * b.area_ratio) AS "Et_BldgAreaCivic",
SUM(a."Et_BldgAreaAgr" * b.area_ratio) AS "Et_BldgAreaAgr",
SUM(a."Et_BldgNum" * b.area_ratio) AS "Et_BldgNum",
SUM(a."E_CensusPop" * b.area_ratio) AS "E_CensusPop",
SUM(a."E_CensusDU" * b.area_ratio) AS "E_CensusDU",
SUM(a."E_People_DU" * b.area_ratio) AS "E_People_DU",
AVG(a."Et_PopDay_Km2" * b.area_ratio) AS "Et_PopDay_Km2",
AVG(a."Et_PopDay_Ha" * b.area_ratio) AS "Et_PopDay_Ha",
AVG(a."Et_PopNight_Km2" * b.area_ratio) AS "Et_PopNight_Km2",
AVG(a."Et_PopNight_Ha" * b.area_ratio) AS "Et_PopNight_Ha",
AVG(a."Et_Bldg_Km2" * b.area_ratio) AS "Et_Bldg_Km2",
AVG(a."Et_Value_Km2" * b.area_ratio) AS "Et_Value_Km2",
SUM(a."Et_Res" * b.area_ratio) AS "Et_Res",
SUM(a."Et_Comm" * b.area_ratio) AS "Et_Comm",
SUM(a."Et_Ind" * b.area_ratio) AS "Et_Ind",
SUM(a."Et_Civic" * b.area_ratio) AS "Et_Civic",
SUM(a."Et_Agr" * b.area_ratio) AS "Et_Agr",
SUM(a."Et_SFHshld" * b.area_ratio) AS "Et_SFHshld",
SUM(a."Et_MFHshld" * b.area_ratio) AS "ET_MFHshld",
SUM(a."Et_Wood" * b.area_ratio) AS "Et_Wood",
SUM(a."Et_Concrete" * b.area_ratio) AS "Et_Concrete",
SUM(a."Et_PreCast" * b.area_ratio) AS "Et_PreCast",
SUM(a."Et_RMasonry" * b.area_ratio) AS "Et_RMasonry",
SUM(a."Et_URMasonry" * b.area_ratio) AS "Et_URMasonry",
SUM(a."Et_Steel" * b.area_ratio) AS "Et_Steel",
SUM(a."Et_Manufacture" * b.area_ratio) AS "Et_Manufacture",
SUM(a."Et_PreCode" * b.area_ratio) AS "Et_PreCode",
SUM(a."Et_LowCode" * b.area_ratio) AS "Et_LowCode",
SUM(a."Et_ModCode" * b.area_ratio) AS "Et_ModCode",
SUM(a."Et_HiCode" * b.area_ratio) AS "Et_HiCode",
SUM(a."Et_PopDay" * b.area_ratio) AS "Et_PopDay",
SUM(a."Et_PopNight" * b.area_ratio) AS "Et_PopNight",
SUM(a."Et_PopTransit" * b.area_ratio) AS "Et_PopTransit",
SUM(a."Et_AssetValue" * b.area_ratio) AS "Et_AssetValue",
SUM(a."Et_BldgValue" * b.area_ratio) AS "Et_BldgValue",
SUM(a."Et_StrValue" * b.area_ratio) AS "Et_StrValue",
SUM(a."Et_NStrValue" * b.area_ratio) AS "Et_NStrValue",
SUM(a."Et_ContValue" * b.area_ratio) AS "Et_ContValue",

c.geom

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_s a
LEFT JOIN boundaries."SAUID_HexGrid_100km_intersect_unclipped" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_100km_unclipped" c ON b.gridid_100 = c.gridid_100
GROUP BY c.gridid_100,c.geom;