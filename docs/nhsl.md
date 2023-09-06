# National Human Settlement Layers
## Physical Exposure
- ### Notes
	- **Github Repo**
	    - Latest geopackages, data dictionary, documentation etc.
	    - [https://opendrr.github.io/national-human-settlement/en/#nhsl_physical_exposure_indicators-a](https://opendrr.github.io/national-human-settlement/en/#nhsl_physical_exposure_indicators-a)
	- **Github page**
	    - [https://opendrr.github.io/national-human-settlement/en/index.html](https://opendrr.github.io/national-human-settlement/en/index.html)
	-	**working notes**
		- 2_physical-exposure-schema
			- [Excel spreadsheet](https://github.com/wkhchow/model-factory/blob/master/documentation/2_physical-exposure-schema.xlsx) where initial phase of indicators were drafted.


### Source / Output tab (views) 
- This section lists the schemas involved with the creation of the final results, and specific tables involved. Refer to [schemas](schemas.md) section for more schema details. 

#### [exposure](schemas.md#exposure)
- canada_exposure

####  [census](schemas.md#census)
- census_2016_canada

#### [boundaries](schemas.md#boundaries)
- Geometry_SAUID
- HexGrid_1km(_3857), HexGrid_1km_unclipped(_3857)
- HexGrid_5km(_3857), HexGrid_5km_unclipped(_3857)
- HexGrid_10km(_3857), HexGrid_10km_unclipped(_3857) 
- HexGrid_25km(_3857), HexGrid_25km_unclipped(_3857) 
- HexGrid_50km_unclipped(_3857)
- HexGrid_100km_unclipped(_3857)
- SAUID_HexGrid_1km_intersect(_3857), SAUID_HexGrid_1km_intersect_unclipped(_3857), 
- SAUID_HexGrid_5km_intersect(_3857), SAUID_HexGrid_5km_intersect_unclipped(_3857), 
- SAUID_HexGrid_10km_intersect(_3857), SAUID_HexGrid_10km_intersect_unclipped(_3857), 
- SAUID_HexGrid_25km_intersect(_3857), SAUID_HexGrid_25km_intersect_unclipped(_3857), 
- SAUID_HexGrid_50km_intersect_unclipped(_3857), 
- SAUID_HexGrid_100km_intersect_unclipped(_3857), 
- HexGrid_GlobalFabric,
- Sauid_HexGrid_GlobalFabric_intersect

#### [results_nhsl_physical_exposure](schemas.md#results_nhsl_physical_exposure)
- All tables/views in this schema are results of physical exposure. 

### SQL scripts
-    **Create_table_canada_exposure.sql**
		- Script used to create canada_exposure table from BldgExpRef_CA_master_v3p2.csv.
- **Create_table_2016_census_v3.sql**
	- Script to create source table for census-attributes-2016.csv.
- **Create_physical_exposure_building_indicators_PhysicalExposure.sql**
	- Script using exposure source, and Geometry_SAUID tables to generate building level indicators for all of Canada. Subsequent views for each province/territory are generated. 
- **Create_physical_exposure_sauid_indicators_view_PhysicalExposure.sql**
	- Script using exposure source,census_2016_canada, and Geometry_SAUID tables to generate sauid level indicators for all of Canada. Subsequent views for each province/territory are generated.
	- Indicators that are from building level are aggregated up to sauid using aggregation functions (SUM, AVG, MIN, MAX, GROUP BY etc).
- **Create_hexgrid_physical_exposure_aggregation_area_proxy.sql**
	- Physical exposure indicators (sauid) aggregated/proxied into various hexgrid of various sizes and (1km, 5km, 10km, 25km, 50km, 100km) and between clipped and unclipped versions.
	- Script uses nhsl_physical_exposure_indicators_s, SAUID_HexGrid_(1,5,10,25,50,100)km_intersect, and HexGrid_(1,5,10,25,50,100)km  to create the various physical exposure hexgrid views.
- **Create_hexgrid_physical_exposure_aggregation_area_proxy_3857.sql**
	- Same method of Create_hexgrid_physical_exposure_aggregation_area_proxy.sql, except the geometry tables of SAUID_HexGrid_(1,5,10,25,50,100)km_intersect_3857 and HexGrid_(1,5,10,25,50,100)km_3857 are generated in EPSG 3857, resulting in the creation of various physical exposure hexgrid views in EPSG 3857.
- **Create_all_tables_update.sql**
	- Script to create and or update various tables in the opendrr db such as creating temp tables, adding geometry columns, and creating indexes etc.


## Social Fabric
- ### Notes
	- **Github Repo**
		- Latest geopackages, data dictionary, documentation etc.
		    - [https://opendrr.github.io/national-human-settlement/en/#nhsl_social_fabric_indicators-a](https://opendrr.github.io/national-human-settlement/en/#nhsl_social_fabric_indicators-a)
	- **Github page**
		- [https://opendrr.github.io/national-human-settlement/en/index.html](https://opendrr.github.io/national-human-settlement/en/index.html)
	-	**working notes**
		- social-vulnerability-schema
			- [Excel spreadsheet](https://github.com/wkhchow/model-factory/blob/master/documentation/4_social-vulnerability-schema.xlsx) where initial phase of indicators were drafted.


### Source / Output tables (views) 
- This section lists the schemas involved with the creation of the final results, and specific tables involved. Refer to [schemas](schemas.md) section for more schema details. 

#### [boundaries](schemas.md#boundaries)
- Geometry_SAUID
- HexGrid_1km(_3857), HexGrid_1km_unclipped(_3857)
- HexGrid_5km(_3857), HexGrid_5km_unclipped(_3857)
- HexGrid_10km(_3857), HexGrid_10km_unclipped(_3857) 
- HexGrid_25km(_3857), HexGrid_25km_unclipped(_3857) 
- HexGrid_50km_unclipped(_3857)
- HexGrid_100km_unclipped(_3857)
- SAUID_HexGrid_1km_intersect(_3857), SAUID_HexGrid_1km_intersect_unclipped(_3857), 
- SAUID_HexGrid_5km_intersect(_3857), SAUID_HexGrid_5km_intersect_unclipped(_3857), 
- SAUID_HexGrid_10km_intersect(_3857), SAUID_HexGrid_10km_intersect_unclipped(_3857), 
- SAUID_HexGrid_25km_intersect(_3857), SAUID_HexGrid_25km_intersect_unclipped(_3857), 
- SAUID_HexGrid_50km_intersect_unclipped(_3857), 
- SAUID_HexGrid_100km_intersect_unclipped(_3857), 
- HexGrid_GlobalFabric,
- Sauid_HexGrid_GlobalFabric_intersect

#### [sovi](schemas.md#sovi)
- sovi_sauid_nov2021

[results_nhsl_social_fabric](schemas.md#results_nhsl_social_fabric)
- All tables/views in this schema are results of social fabric. 

### SQL scripts
- **Create_table_sovi_sauid.sql**
	- Script used to create source sovi_sauid_nov2021 table from sovi_sauid_nov2021.csv.
- **Create_social_vulnerability_sauid_indicators_SocialFabric.sql**
	- Script used to generate the final indicators for social fabric. The source table has all been pregenerated and this script renames the indicators to the appropriate name as well as attaching various aggregation ID’s and sauid geometry.
    - **Create_hexgrid_social_vulnerability_aggregation_area_proxy.sql**
        - Social fabric indicators (sauid) aggregated/proxied into various hexgrid of various sizes and (1km, 5km, 10km, 25km, 50km, 100km) and between clipped and unclipped versions.
        - Script uses nhsl_social_fabric_indicators_s, SAUID_HexGrid_(1,5,10,25,50,100)km_intersect, and HexGrid_(1,5,10,25,50,100)km  to create the various social fabric hexgrid views.
    - **Create_hexgrid_social_vulnerability_aggregation_area_proxy_3857.sql**
        - Same method of Create_hexgrid_social_vulnerability_aggregation_area_proxy.sql except the geometry tables of SAUID_HexGrid_(1,5,10,25,50,100)km_intersect_3857 and HexGrid_(1,5,10,25,50,100)km_3857 are generated in EPSG 3857.
    - **Create_all_tables_update.sql**
        - Script to create and or update various tables in the opendrr db such as creating temp tables, adding geometry columns, and creating indexes etc.



## Risk Dynamics (not used)
- ### Notes
    - Draft indicators were generated but not released, and are not intended for the public.
    - Risk Dynamics contains population growth, land use change indicators for 1975, 1990, 2000, and 2015 for all of Canada over a 250m population grid.

### Source / Output tables (views) 
- This section lists the schemas involved with the creation of the final results, and specific tables involved. Refer to [schemas](schemas.md) section for more schema details. 

- [ghsl](schemas.md#ghsl)
	- ghsl_mh_intensity_ghsl

- [results_nhsl_risk_dynamics](schemas.md#results_nhsl_risk_dynamics)
	- All tables/views in this schema are results of risk dynamics.

### SQL scripts
- **Create_table_GHSL.sql**
	- Script used to create ghsl_mh_internsity_ghsl table from mh-internsity-ghsl.csv
- **Create_risk_dynamics_indicators.sql**
	- Script used to generate the final indicators for risk dynamics. Source table had all the final indicator values, and this script renames indicators to appropriate names.
- **Create_all_tables_update.sql**
	- Script to create and or update various tables in the opendrr db such as creating temp tables, adding geometry columns, and creating indexes etc.


## Multi Hazard Threat (not used)

- ### Notes
    - Draft indicators were generated but not released, and are not intended for the public.
    - The Hazard threat value contains scores based on different hazards, and pregenerated threshold lookup tables. Using source information from multi hazard, physical exposure indicators, social fabric indicators, and census a series of calculations are made (prereq tables). These values are compared against the threshold lookup tables and assigned scores.
    - **working notes**
        - 3_multi-hazard-threat-schema
	        - [Excel spreadsheet](https://github.com/wkhchow/model-factory/blob/master/documentation/3_multi-hazard-threat-schema.xlsx) where initial phase of indicators were drafted


### Source / Output tables (views) 
- This section lists the schemas involved with the creation of the final results, and specific tables involved. Refer to [schemas](schemas.md) section for more schema details. 

#### [boundaries](schemas.md#boundaries)
- Geometry_SAUID
- HexGrid_1km(_3857), HexGrid_1km_unclipped(_3857)
- HexGrid_5km(_3857), HexGrid_5km_unclipped(_3857)
- HexGrid_10km(_3857), HexGrid_10km_unclipped(_3857) 
- HexGrid_25km(_3857), HexGrid_25km_unclipped(_3857) 
- HexGrid_50km_unclipped(_3857)
- HexGrid_100km_unclipped(_3857)
- SAUID_HexGrid_1km_intersect(_3857), SAUID_HexGrid_1km_intersect_unclipped(_3857), 
- SAUID_HexGrid_5km_intersect(_3857), SAUID_HexGrid_5km_intersect_unclipped(_3857), 
- SAUID_HexGrid_10km_intersect(_3857), SAUID_HexGrid_10km_intersect_unclipped(_3857), 
- SAUID_HexGrid_25km_intersect(_3857), SAUID_HexGrid_25km_intersect_unclipped(_3857), 
- SAUID_HexGrid_50km_intersect_unclipped(_3857), 
- SAUID_HexGrid_100km_intersect_unclipped(_3857), 
- HexGrid_GlobalFabric,
- Sauid_HexGrid_GlobalFabric_intersect

####  [census](schemas.md#census)
- census_2016_canada

#### [exposure](schemas.md#exposure)
- canada_exposure

#### [sovi](schemas.md#sovi)
- sovi_sauid_nov2021

#### [mh](schemas.md#mh)
- mh_intensity_canada
- mh_ratings_thresholds

#### [results_nhsl_hazard_threat](schemas.md#results_nhsl_hazard_threat)
- All tables/views in this schema are results of multi hazard threat.

### SQL scripts
- **Create_table_mh_intensity_canada_v2.sql**
	- Script to create mh_intensity_canada table from HTi_sauid.csv.
- **Create_table_mh_rating_thresholds.sql**
	- Script to create mh_ratings_thresholds from hazard_threat_rating_thresholds.csv.
- **Create_table_mh_thresholds.sql**
	- Script to create mh_thresholds from HTi_thresholds.csv.
- **Create_MH_risk_sauid_prioritization_prereq_tables.sql**
	- Script to calculate hazard threat value prereq table required for generating MH indicators.
- **Create_MH_risk_sauid_prioritization_Canada.sql**
	- Script to generate MH threat indicators at the sauid and csd level.
- **Create_hexgrid_MH_risk_sauid_prioritization_aggregation_area.sql**
	- MH indicators (sauid) aggregated/proxied into various hexgrid of various sizes and (1km, 5km, 10km, 25km, 50km, 100km) and between clipped and unclipped versions.
	- Script uses nhsl_hazard_threat_indicators_s_tbl, SAUID_HexGrid_(1,5,10,25,50,100)km_intersect, and HexGrid_(1,5,10,25,50,100)km  to create the various physical exposure hexgrid views.
- **Create_hexgrid_MH_risk_sauid_prioritization_aggregation_area_3857.sql**
	- Same method of Create_hexgrid_MH_risk_sauid_prioritization_aggregation_area.sqll, except the geometry tables of SAUID_HexGrid_(1,5,10,25,50,100)km_intersect_3857 and HexGrid_(1,5,10,25,50,100)km_3857 are generated in EPSG 3857, resulting in the creation of various physical exposure hexgrid views in EPSG 3857.