-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_nhsl_physical_exposure;


-- test aggregation to hexbin grids via centroids
--5km
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_hexbin_5km_centroid CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_hexbin_5km_centroid AS 

SELECT
b.gridid_5,
SUM(a."Et_BldgArea") AS "ET_BldgArea",
SUM(a."Et_BldgAreaRes") AS "Et_BldgAreaRes",
SUM(a."Et_BldgAreaComm") AS "Et_BldgAreaComm",
SUM(a."Et_BldgAreaInd") AS "Et_BldgAreaInd",
SUM(a."Et_BldgAreaCivic") AS "Et_BldgAreaCivic",
SUM(a."Et_BldgAreaAgr") AS "Et_BldgAreaAgr",
SUM(a."Et_BldgNum") AS "Et_BldgNum",
SUM(a."E_CensusBldg") AS "E_CensusBldg",
SUM(a."E_CensusPop") AS "E_CensusPop",
SUM(a."E_CensusDU") AS "E_CensusDU",
SUM(a."E_People_DU") AS "E_People_DU",
AVG(a."Et_Pop_Km2") AS "Et_Pop_Km2",
AVG(a."Et_PPH") AS "Et_PPH",
AVG(a."Et_Bldg_Km2") AS "Et_Bldg_Km2",
AVG(a."Et_Value_Km2") AS "Et_Value_Km2",
SUM(a."Et_ResLD") AS "Et_ResLD",
SUM(a."Et_ResMD") AS "Et_ResMD",
SUM(a."Et_RESHD") AS "Et_RESHD",
SUM(a."Et_Comm") AS "Et_Comm",
SUM(a."Et_Ind") AS "Et_Ind",
SUM(a."Et_Civic") AS "Et_Civic",
SUM(a."Et_Agr") AS "Et_Agr",
SUM(a."Et_SFHshld") AS "Et_SFHshld",
SUM(a."ET_MFHshld") AS "ET_MFHshld",
SUM(a."Et_Wood") AS "Et_Wood",
SUM(a."Et_Concrete") AS "Et_Concrete",
SUM(a."Et_PreCast") AS "Et_PreCast",
SUM(a."Et_RMasonry") AS "Et_RMasonry",
SUM(a."Et_URMasonry") AS "Et_URMasonry",
SUM(a."Et_Steel") AS "Et_Steel",
SUM(a."Et_Manufacture") AS "Et_Manufacture",
SUM(a."Et_PreCode") AS "Et_PreCode",
SUM(a."Et_LowCode") AS "Et_LowCode",
SUM(a."Et_ModCode") AS "Et_ModCode",
SUM(a."Et_HiCode") AS "Et_HiCode",
SUM(a."Et_PopDay") AS "Et_PopDay",
SUM(a."Et_PopNight") AS "Et_PopNight",
SUM(a."Et_PopTransit") AS "Et_PopTransit",
SUM(a."Et_AssetValue") AS "Et_AssetValue",
SUM(a."Et_BldgValue") AS "Et_BldgValue",
SUM(a."Et_StrValue") AS "Et_StrValue",
SUM(a."Et_NStrValue") AS "Et_NStrValue",
SUM(a."Et_ContValue") AS "Et_ContValue",

c.geom

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_s a
LEFT JOIN boundaries."SAUID_HexGrid" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_5km" c ON b.gridid_5 = c.gridid_5
GROUP BY b.gridid_5,c.geom;



--10km
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_hexbin_10km_centroid CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_hexbin_10km_centroid AS 

SELECT
b.gridid_10,
SUM(a."Et_BldgArea") AS "ET_BldgArea",
SUM(a."Et_BldgAreaRes") AS "Et_BldgAreaRes",
SUM(a."Et_BldgAreaComm") AS "Et_BldgAreaComm",
SUM(a."Et_BldgAreaInd") AS "Et_BldgAreaInd",
SUM(a."Et_BldgAreaCivic") AS "Et_BldgAreaCivic",
SUM(a."Et_BldgAreaAgr") AS "Et_BldgAreaAgr",
SUM(a."Et_BldgNum") AS "Et_BldgNum",
SUM(a."E_CensusBldg") AS "E_CensusBldg",
SUM(a."E_CensusPop") AS "E_CensusPop",
SUM(a."E_CensusDU") AS "E_CensusDU",
SUM(a."E_People_DU") AS "E_People_DU",
AVG(a."Et_Pop_Km2") AS "Et_Pop_Km2",
AVG(a."Et_PPH") AS "Et_PPH",
AVG(a."Et_Bldg_Km2") AS "Et_Bldg_Km2",
AVG(a."Et_Value_Km2") AS "Et_Value_Km2",
SUM(a."Et_ResLD") AS "Et_ResLD",
SUM(a."Et_ResMD") AS "Et_ResMD",
SUM(a."Et_RESHD") AS "Et_RESHD",
SUM(a."Et_Comm") AS "Et_Comm",
SUM(a."Et_Ind") AS "Et_Ind",
SUM(a."Et_Civic") AS "Et_Civic",
SUM(a."Et_Agr") AS "Et_Agr",
SUM(a."Et_SFHshld") AS "Et_SFHshld",
SUM(a."ET_MFHshld") AS "ET_MFHshld",
SUM(a."Et_Wood") AS "Et_Wood",
SUM(a."Et_Concrete") AS "Et_Concrete",
SUM(a."Et_PreCast") AS "Et_PreCast",
SUM(a."Et_RMasonry") AS "Et_RMasonry",
SUM(a."Et_URMasonry") AS "Et_URMasonry",
SUM(a."Et_Steel") AS "Et_Steel",
SUM(a."Et_Manufacture") AS "Et_Manufacture",
SUM(a."Et_PreCode") AS "Et_PreCode",
SUM(a."Et_LowCode") AS "Et_LowCode",
SUM(a."Et_ModCode") AS "Et_ModCode",
SUM(a."Et_HiCode") AS "Et_HiCode",
SUM(a."Et_PopDay") AS "Et_PopDay",
SUM(a."Et_PopNight") AS "Et_PopNight",
SUM(a."Et_PopTransit") AS "Et_PopTransit",
SUM(a."Et_AssetValue") AS "Et_AssetValue",
SUM(a."Et_BldgValue") AS "Et_BldgValue",
SUM(a."Et_StrValue") AS "Et_StrValue",
SUM(a."Et_NStrValue") AS "Et_NStrValue",
SUM(a."Et_ContValue") AS "Et_ContValue",

c.geom

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_s a
LEFT JOIN boundaries."SAUID_HexGrid" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_10km" c ON b.gridid_10 = c.gridid_10
GROUP BY b.gridid_10,c.geom;



--25km
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_hexbin_25km_centroid CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_hexbin_25km_centroid AS 

SELECT
b.gridid_25,
SUM(a."Et_BldgArea") AS "ET_BldgArea",
SUM(a."Et_BldgAreaRes") AS "Et_BldgAreaRes",
SUM(a."Et_BldgAreaComm") AS "Et_BldgAreaComm",
SUM(a."Et_BldgAreaInd") AS "Et_BldgAreaInd",
SUM(a."Et_BldgAreaCivic") AS "Et_BldgAreaCivic",
SUM(a."Et_BldgAreaAgr") AS "Et_BldgAreaAgr",
SUM(a."Et_BldgNum") AS "Et_BldgNum",
SUM(a."E_CensusBldg") AS "E_CensusBldg",
SUM(a."E_CensusPop") AS "E_CensusPop",
SUM(a."E_CensusDU") AS "E_CensusDU",
SUM(a."E_People_DU") AS "E_People_DU",
AVG(a."Et_Pop_Km2") AS "Et_Pop_Km2",
AVG(a."Et_PPH") AS "Et_PPH",
AVG(a."Et_Bldg_Km2") AS "Et_Bldg_Km2",
AVG(a."Et_Value_Km2") AS "Et_Value_Km2",
SUM(a."Et_ResLD") AS "Et_ResLD",
SUM(a."Et_ResMD") AS "Et_ResMD",
SUM(a."Et_RESHD") AS "Et_RESHD",
SUM(a."Et_Comm") AS "Et_Comm",
SUM(a."Et_Ind") AS "Et_Ind",
SUM(a."Et_Civic") AS "Et_Civic",
SUM(a."Et_Agr") AS "Et_Agr",
SUM(a."Et_SFHshld") AS "Et_SFHshld",
SUM(a."ET_MFHshld") AS "ET_MFHshld",
SUM(a."Et_Wood") AS "Et_Wood",
SUM(a."Et_Concrete") AS "Et_Concrete",
SUM(a."Et_PreCast") AS "Et_PreCast",
SUM(a."Et_RMasonry") AS "Et_RMasonry",
SUM(a."Et_URMasonry") AS "Et_URMasonry",
SUM(a."Et_Steel") AS "Et_Steel",
SUM(a."Et_Manufacture") AS "Et_Manufacture",
SUM(a."Et_PreCode") AS "Et_PreCode",
SUM(a."Et_LowCode") AS "Et_LowCode",
SUM(a."Et_ModCode") AS "Et_ModCode",
SUM(a."Et_HiCode") AS "Et_HiCode",
SUM(a."Et_PopDay") AS "Et_PopDay",
SUM(a."Et_PopNight") AS "Et_PopNight",
SUM(a."Et_PopTransit") AS "Et_PopTransit",
SUM(a."Et_AssetValue") AS "Et_AssetValue",
SUM(a."Et_BldgValue") AS "Et_BldgValue",
SUM(a."Et_StrValue") AS "Et_StrValue",
SUM(a."Et_NStrValue") AS "Et_NStrValue",
SUM(a."Et_ContValue") AS "Et_ContValue",

c.geom

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_s a
LEFT JOIN boundaries."SAUID_HexGrid" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_25km" c ON b.gridid_25 = c.gridid_25
GROUP BY b.gridid_25,c.geom;



--50km
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_hexbin_50km_centroid CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_hexbin_50km_centroid AS 

SELECT
b.gridid_50,
SUM(a."Et_BldgArea") AS "ET_BldgArea",
SUM(a."Et_BldgAreaRes") AS "Et_BldgAreaRes",
SUM(a."Et_BldgAreaComm") AS "Et_BldgAreaComm",
SUM(a."Et_BldgAreaInd") AS "Et_BldgAreaInd",
SUM(a."Et_BldgAreaCivic") AS "Et_BldgAreaCivic",
SUM(a."Et_BldgAreaAgr") AS "Et_BldgAreaAgr",
SUM(a."Et_BldgNum") AS "Et_BldgNum",
SUM(a."E_CensusBldg") AS "E_CensusBldg",
SUM(a."E_CensusPop") AS "E_CensusPop",
SUM(a."E_CensusDU") AS "E_CensusDU",
SUM(a."E_People_DU") AS "E_People_DU",
AVG(a."Et_Pop_Km2") AS "Et_Pop_Km2",
AVG(a."Et_PPH") AS "Et_PPH",
AVG(a."Et_Bldg_Km2") AS "Et_Bldg_Km2",
AVG(a."Et_Value_Km2") AS "Et_Value_Km2",
SUM(a."Et_ResLD") AS "Et_ResLD",
SUM(a."Et_ResMD") AS "Et_ResMD",
SUM(a."Et_RESHD") AS "Et_RESHD",
SUM(a."Et_Comm") AS "Et_Comm",
SUM(a."Et_Ind") AS "Et_Ind",
SUM(a."Et_Civic") AS "Et_Civic",
SUM(a."Et_Agr") AS "Et_Agr",
SUM(a."Et_SFHshld") AS "Et_SFHshld",
SUM(a."ET_MFHshld") AS "ET_MFHshld",
SUM(a."Et_Wood") AS "Et_Wood",
SUM(a."Et_Concrete") AS "Et_Concrete",
SUM(a."Et_PreCast") AS "Et_PreCast",
SUM(a."Et_RMasonry") AS "Et_RMasonry",
SUM(a."Et_URMasonry") AS "Et_URMasonry",
SUM(a."Et_Steel") AS "Et_Steel",
SUM(a."Et_Manufacture") AS "Et_Manufacture",
SUM(a."Et_PreCode") AS "Et_PreCode",
SUM(a."Et_LowCode") AS "Et_LowCode",
SUM(a."Et_ModCode") AS "Et_ModCode",
SUM(a."Et_HiCode") AS "Et_HiCode",
SUM(a."Et_PopDay") AS "Et_PopDay",
SUM(a."Et_PopNight") AS "Et_PopNight",
SUM(a."Et_PopTransit") AS "Et_PopTransit",
SUM(a."Et_AssetValue") AS "Et_AssetValue",
SUM(a."Et_BldgValue") AS "Et_BldgValue",
SUM(a."Et_StrValue") AS "Et_StrValue",
SUM(a."Et_NStrValue") AS "Et_NStrValue",
SUM(a."Et_ContValue") AS "Et_ContValue",

c.geom

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_s a
LEFT JOIN boundaries."SAUID_HexGrid" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_50km" c ON b.gridid_50 = c.gridid_50
GROUP BY b.gridid_50,c.geom;



--100km
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_hexbin_100km_centroid CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_hexbin_100km_centroid AS 

SELECT
b.gridid_100,
SUM(a."Et_BldgArea") AS "ET_BldgArea",
SUM(a."Et_BldgAreaRes") AS "Et_BldgAreaRes",
SUM(a."Et_BldgAreaComm") AS "Et_BldgAreaComm",
SUM(a."Et_BldgAreaInd") AS "Et_BldgAreaInd",
SUM(a."Et_BldgAreaCivic") AS "Et_BldgAreaCivic",
SUM(a."Et_BldgAreaAgr") AS "Et_BldgAreaAgr",
SUM(a."Et_BldgNum") AS "Et_BldgNum",
SUM(a."E_CensusBldg") AS "E_CensusBldg",
SUM(a."E_CensusPop") AS "E_CensusPop",
SUM(a."E_CensusDU") AS "E_CensusDU",
SUM(a."E_People_DU") AS "E_People_DU",
AVG(a."Et_Pop_Km2") AS "Et_Pop_Km2",
AVG(a."Et_PPH") AS "Et_PPH",
AVG(a."Et_Bldg_Km2") AS "Et_Bldg_Km2",
AVG(a."Et_Value_Km2") AS "Et_Value_Km2",
SUM(a."Et_ResLD") AS "Et_ResLD",
SUM(a."Et_ResMD") AS "Et_ResMD",
SUM(a."Et_RESHD") AS "Et_RESHD",
SUM(a."Et_Comm") AS "Et_Comm",
SUM(a."Et_Ind") AS "Et_Ind",
SUM(a."Et_Civic") AS "Et_Civic",
SUM(a."Et_Agr") AS "Et_Agr",
SUM(a."Et_SFHshld") AS "Et_SFHshld",
SUM(a."ET_MFHshld") AS "ET_MFHshld",
SUM(a."Et_Wood") AS "Et_Wood",
SUM(a."Et_Concrete") AS "Et_Concrete",
SUM(a."Et_PreCast") AS "Et_PreCast",
SUM(a."Et_RMasonry") AS "Et_RMasonry",
SUM(a."Et_URMasonry") AS "Et_URMasonry",
SUM(a."Et_Steel") AS "Et_Steel",
SUM(a."Et_Manufacture") AS "Et_Manufacture",
SUM(a."Et_PreCode") AS "Et_PreCode",
SUM(a."Et_LowCode") AS "Et_LowCode",
SUM(a."Et_ModCode") AS "Et_ModCode",
SUM(a."Et_HiCode") AS "Et_HiCode",
SUM(a."Et_PopDay") AS "Et_PopDay",
SUM(a."Et_PopNight") AS "Et_PopNight",
SUM(a."Et_PopTransit") AS "Et_PopTransit",
SUM(a."Et_AssetValue") AS "Et_AssetValue",
SUM(a."Et_BldgValue") AS "Et_BldgValue",
SUM(a."Et_StrValue") AS "Et_StrValue",
SUM(a."Et_NStrValue") AS "Et_NStrValue",
SUM(a."Et_ContValue") AS "Et_ContValue",

c.geom

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_all_indicators_s a
LEFT JOIN boundaries."SAUID_HexGrid" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_100km" c ON b.gridid_100 = c.gridid_100
GROUP BY b.gridid_100,c.geom;