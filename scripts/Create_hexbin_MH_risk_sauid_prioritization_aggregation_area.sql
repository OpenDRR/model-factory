
-- test aggregation to hexbin grids area proxy

--5km
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_prioritization_hexgrid_5km;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_prioritization_hexgrid_5km AS 
SELECT
b.gridid_5,
--SUM("E_AreaKm2" * b.area_ratio) AS "Et_AreaKm2",
--SUM("E_AreaHa" * b.area_ratio) AS "Et_AreaHa",
SUM("Et_BldgNum" * b.area_ratio) AS "Et_BldgNum",
SUM("Et_AssetValue" * b.area_ratio) AS "Et_AssetValue",
SUM("Et_PopNight" * b.area_ratio) AS "Et_PopNight",
SUM(eq_shaking_score_abs * b.area_ratio) AS "eq_shaking_score_abs",
SUM(eq_shaking_score_rel * b.area_ratio) AS "eq_shaking_score_rel",
SUM(fld_priority_score_abs * b.area_ratio) AS "fld_priority_score_abs",
SUM(fld_priority_score_rel * b.area_ratio) AS "fld_priority_score_rel",
SUM(wildfire_priority_score_abs * b.area_ratio) AS "wildfire_priority_score_abs",
SUM(wildfire_priority_score_rel * b.area_ratio) AS "wildfire_priority_score_rel",
SUM(cy_priority_score_abs * b.area_ratio) AS "cy_priority_score_abs",
SUM(cy_priority_score_rel * b.area_ratio) AS "cy_priority_score_rel",
SUM(total_abs_score * b.area_ratio) AS "total_abs_score",
SUM(total_rel_score * b.area_ratio) AS "total_rel_score",
c.geom

FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_s_tbl a
LEFT JOIN boundaries."SAUID_HexGrid_5km_intersect" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_5km" c ON b.gridid_5 = c.gridid_5
GROUP BY b.gridid_5,c.geom;


-- 10km
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_prioritization_hexgrid_10km;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_prioritization_hexgrid_10km AS 
SELECT
b.gridid_10,
--SUM("E_AreaKm2" * b.area_ratio) AS "Et_AreaKm2",
--SUM("E_AreaHa" * b.area_ratio) AS "Et_AreaHa",
SUM("Et_BldgNum" * b.area_ratio) AS "Et_BldgNum",
SUM("Et_AssetValue" * b.area_ratio) AS "Et_AssetValue",
SUM("Et_PopNight" * b.area_ratio) AS "Et_PopNight",
SUM(eq_shaking_score_abs * b.area_ratio) AS "eq_shaking_score_abs",
SUM(eq_shaking_score_rel * b.area_ratio) AS "eq_shaking_score_rel",
SUM(fld_priority_score_abs * b.area_ratio) AS "fld_priority_score_abs",
SUM(fld_priority_score_rel * b.area_ratio) AS "fld_priority_score_rel",
SUM(wildfire_priority_score_abs * b.area_ratio) AS "wildfire_priority_score_abs",
SUM(wildfire_priority_score_rel * b.area_ratio) AS "wildfire_priority_score_rel",
SUM(cy_priority_score_abs * b.area_ratio) AS "cy_priority_score_abs",
SUM(cy_priority_score_rel * b.area_ratio) AS "cy_priority_score_rel",
SUM(total_abs_score * b.area_ratio) AS "total_abs_score",
SUM(total_rel_score * b.area_ratio) AS "total_rel_score",
c.geom

FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_s_tbl a
LEFT JOIN boundaries."SAUID_HexGrid_10km_intersect" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_10km" c ON b.gridid_10 = c.gridid_10
GROUP BY b.gridid_10,c.geom;

-- 25km
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_prioritization_hexgrid_25km;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_prioritization_hexgrid_25km AS 
SELECT
b.gridid_25,
--SUM("E_AreaKm2" * b.area_ratio) AS "Et_AreaKm2",
--SUM("E_AreaHa" * b.area_ratio) AS "Et_AreaHa",
SUM("Et_BldgNum" * b.area_ratio) AS "Et_BldgNum",
SUM("Et_AssetValue" * b.area_ratio) AS "Et_AssetValue",
SUM("Et_PopNight" * b.area_ratio) AS "Et_PopNight",
SUM(eq_shaking_score_abs * b.area_ratio) AS "eq_shaking_score_abs",
SUM(eq_shaking_score_rel * b.area_ratio) AS "eq_shaking_score_rel",
SUM(fld_priority_score_abs * b.area_ratio) AS "fld_priority_score_abs",
SUM(fld_priority_score_rel * b.area_ratio) AS "fld_priority_score_rel",
SUM(wildfire_priority_score_abs * b.area_ratio) AS "wildfire_priority_score_abs",
SUM(wildfire_priority_score_rel * b.area_ratio) AS "wildfire_priority_score_rel",
SUM(cy_priority_score_abs * b.area_ratio) AS "cy_priority_score_abs",
SUM(cy_priority_score_rel * b.area_ratio) AS "cy_priority_score_rel",
SUM(total_abs_score * b.area_ratio) AS "total_abs_score",
SUM(total_rel_score * b.area_ratio) AS "total_rel_score",
c.geom

FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_s_tbl a
LEFT JOIN boundaries."SAUID_HexGrid_25km_intersect" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_25km" c ON b.gridid_25 = c.gridid_25
GROUP BY b.gridid_25,c.geom;


-- 50km
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_prioritization_hexgrid_50km;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_prioritization_hexgrid_50km AS 
SELECT
b.gridid_50,
--SUM("E_AreaKm2" * b.area_ratio) AS "Et_AreaKm2",
--SUM("E_AreaHa" * b.area_ratio) AS "Et_AreaHa",
SUM("Et_BldgNum" * b.area_ratio) AS "Et_BldgNum",
SUM("Et_AssetValue" * b.area_ratio) AS "Et_AssetValue",
SUM("Et_PopNight" * b.area_ratio) AS "Et_PopNight",
SUM(eq_shaking_score_abs * b.area_ratio) AS "eq_shaking_score_abs",
SUM(eq_shaking_score_rel * b.area_ratio) AS "eq_shaking_score_rel",
SUM(fld_priority_score_abs * b.area_ratio) AS "fld_priority_score_abs",
SUM(fld_priority_score_rel * b.area_ratio) AS "fld_priority_score_rel",
SUM(wildfire_priority_score_abs * b.area_ratio) AS "wildfire_priority_score_abs",
SUM(wildfire_priority_score_rel * b.area_ratio) AS "wildfire_priority_score_rel",
SUM(cy_priority_score_abs * b.area_ratio) AS "cy_priority_score_abs",
SUM(cy_priority_score_rel * b.area_ratio) AS "cy_priority_score_rel",
SUM(total_abs_score * b.area_ratio) AS "total_abs_score",
SUM(total_rel_score * b.area_ratio) AS "total_rel_score",
c.geom

FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_s_tbl a
LEFT JOIN boundaries."SAUID_HexGrid_50km_intersect" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_50km" c ON b.gridid_50 = c.gridid_50
GROUP BY b.gridid_50,c.geom;

-- 100km
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_prioritization_hexgrid_100km;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_prioritization_hexgrid_100km AS 
SELECT
b.gridid_100,
--SUM("E_AreaKm2" * b.area_ratio) AS "Et_AreaKm2",
--SUM("E_AreaHa" * b.area_ratio) AS "Et_AreaHa",
SUM("Et_BldgNum" * b.area_ratio) AS "Et_BldgNum",
SUM("Et_AssetValue" * b.area_ratio) AS "Et_AssetValue",
SUM("Et_PopNight" * b.area_ratio) AS "Et_PopNight",
SUM(eq_shaking_score_abs * b.area_ratio) AS "eq_shaking_score_abs",
SUM(eq_shaking_score_rel * b.area_ratio) AS "eq_shaking_score_rel",
SUM(fld_priority_score_abs * b.area_ratio) AS "fld_priority_score_abs",
SUM(fld_priority_score_rel * b.area_ratio) AS "fld_priority_score_rel",
SUM(wildfire_priority_score_abs * b.area_ratio) AS "wildfire_priority_score_abs",
SUM(wildfire_priority_score_rel * b.area_ratio) AS "wildfire_priority_score_rel",
SUM(cy_priority_score_abs * b.area_ratio) AS "cy_priority_score_abs",
SUM(cy_priority_score_rel * b.area_ratio) AS "cy_priority_score_rel",
SUM(total_abs_score * b.area_ratio) AS "total_abs_score",
SUM(total_rel_score * b.area_ratio) AS "total_rel_score",
c.geom

FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_s_tbl a
LEFT JOIN boundaries."SAUID_HexGrid_100km_intersect" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_100km" c ON b.gridid_100 = c.gridid_100
GROUP BY b.gridid_100,c.geom;


-- global fabric
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_prioritization_hexgrid_global_fabric;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_prioritization_hexgrid_global_fabric AS 
SELECT
b.gridid,
--SUM("E_AreaKm2" * b.area_ratio) AS "Et_AreaKm2",
--SUM("E_AreaHa" * b.area_ratio) AS "Et_AreaHa",
SUM("Et_BldgNum" * b.area_ratio) AS "Et_BldgNum",
SUM("Et_AssetValue" * b.area_ratio) AS "Et_AssetValue",
SUM("Et_PopNight" * b.area_ratio) AS "Et_PopNight",
SUM(eq_shaking_score_abs * b.area_ratio) AS "eq_shaking_score_abs",
SUM(eq_shaking_score_rel * b.area_ratio) AS "eq_shaking_score_rel",
SUM(fld_priority_score_abs * b.area_ratio) AS "fld_priority_score_abs",
SUM(fld_priority_score_rel * b.area_ratio) AS "fld_priority_score_rel",
SUM(wildfire_priority_score_abs * b.area_ratio) AS "wildfire_priority_score_abs",
SUM(wildfire_priority_score_rel * b.area_ratio) AS "wildfire_priority_score_rel",
SUM(cy_priority_score_abs * b.area_ratio) AS "cy_priority_score_abs",
SUM(cy_priority_score_rel * b.area_ratio) AS "cy_priority_score_rel",
SUM(total_abs_score * b.area_ratio) AS "total_abs_score",
SUM(total_rel_score * b.area_ratio) AS "total_rel_score",
c.geom

FROM results_nhsl_hazard_threat.nhsl_hazard_threat_all_indicators_s_tbl a
LEFT JOIN boundaries."SAUID_HexGrid_GlobalFabric_intersect" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_GlobalFabric" c ON b.gridid = c.gridid
GROUP BY b.gridid,c.geom;