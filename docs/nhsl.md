# National Human Settlement Layers
## Physical Exposure
- ### Notes
	- **Github Repo**
	    * latest geopackages, data dictionary, documentation etc
	    * [https://opendrr.github.io/national-human-settlement/en/#nhsl_physical_exposure_indicators-a](https://opendrr.github.io/national-human-settlement/en/#nhsl_physical_exposure_indicators-a)
	* **Github page**
	    * [https://opendrr.github.io/national-human-settlement/en/index.html](https://opendrr.github.io/national-human-settlement/en/index.html)
	-	**working notes** (google sheet)
		* 2_physical-exposure-schema.xlsx
	    * worksheet where initial phase of indicators were drafted
		* [https://docs.google.com/spreadsheets/d/1dsVOAbUAp-V0Xu-dINVbchUzyQZ6EmE_/edit?usp=sharing&ouid=108110519296938878163&rtpof=true&sd=true](https://docs.google.com/spreadsheets/d/1dsVOAbUAp-V0Xu-dINVbchUzyQZ6EmE_/edit?usp=sharing&ouid=108110519296938878163&rtpof=true&sd=true)

### Source / Output tables (views) 
- This section lists the schemas involved with the creation of the final results, and specific tables involved. Refer to [schemas](schemas.md) section for more schema details. 

#### exposure
* canada_exposure

####  [census](schemas.md#census)
* census_2016_canada

#### [boundaries](schemas.md#boundaries)
* Geometry_SAUID
* HexGrid_1km(_3857), HexGrid_1km_unclipped(_3857)
* HexGrid_5km(_3857), HexGrid_5km_unclipped(_3857)
* HexGrid_10km(_3857), HexGrid_10km_unclipped(_3857) 
* HexGrid_25km(_3857), HexGrid_25km_unclipped(_3857) 
* HexGrid_50km_unclipped(_3857)
* HexGrid_100km_unclipped(_3857)
* SAUID_HexGrid_1km_intersect(_3857), SAUID_HexGrid_1km_intersect_unclipped(_3857), 
* SAUID_HexGrid_5km_intersect(_3857), SAUID_HexGrid_5km_intersect_unclipped(_3857), 
* SAUID_HexGrid_10km_intersect(_3857), SAUID_HexGrid_10km_intersect_unclipped(_3857), 
* SAUID_HexGrid_25km_intersect(_3857), SAUID_HexGrid_25km_intersect_unclipped(_3857), 
* SAUID_HexGrid_50km_intersect_unclipped(_3857), 
* SAUID_HexGrid_100km_intersect_unclipped(_3857), 
* HexGrid_GlobalFabric,
* Sauid_HexGrid_GlobalFabric_intersect

#### results_nhsl_physical_exposure
* all tables/views in this schema are results of physical exposure 

### SQL scripts
-    **Create_table_canada_exposure.sql**
		- Script used to create canada_exposure table from BldgExpRef_CA_master_v3p2.csv
- **Create_table_2016_census_v3.sql**
	- Script to create source table for census-attributes-2016.csv
- **Create_physical_exposure_building_indicators_PhysicalExposure.sql**
	- Script using exposure source, and Geometry_SAUID tables to generate building level indicators for all of Canada. Subsequent views for each province/territory are generated.. 
- **Create_physical_exposure_sauid_indicators_view_PhysicalExposure.sql**
	- Script using exposure source,census_2016_canada, and Geometry_SAUID tables to generate sauid level indicators for all of Canada. Subsequent views for each province/territory are generated.
	- Indicators that are from building level are aggregated up to sauid using aggregation functions (SUM, AVG, MIN, MAX, GROUP BY etc)
- **Create_hexgrid_physical_exposure_aggregation_area_proxy.sql**
	- Physical exposure indicators (sauid) aggregated/proxied into various hexgrid of various sizes and (1km, 5km, 10km, 25km, 50km, 100km) and between clipped and unclipped versions.
	- Script uses nhsl_physical_exposure_indicators_s, SAUID_HexGrid_(1,5,10,25,50,100)km_intersect, and HexGrid_(1,5,10,25,50,100)km  to create the various physical exposure hexgrid views.
- **Create_hexgrid_physical_exposure_aggregation_area_proxy_3857.sql**
	- Same method of Create_hexgrid_physical_exposure_aggregation_area_proxy.sql, except the geometry tables of SAUID_HexGrid_(1,5,10,25,50,100)km_intersect_3857 and HexGrid_(1,5,10,25,50,100)km_3857 are generated in EPSG 3857, resulting in the creation of various physical exposure hexgrid views in EPSG 3857.
- **Create_all_tables_update.sql**
	- Script to create and or update various tables in the opendrr db such as creating temp tables, adding geometry columns, and creating indexes etc.