## Earthquake Scenarios (DSRA)
- ### Notes
	- **GitHub Repo**
	    - Latest geopackages, data dictionary, documentation etc.
	    - [OpenDRR Earthquake Scenarios Repo](https://github.com/OpenDRR/earthquake-scenarios)
	- **GitHub Page**
	    - [OpenDRR Earthquake Scenarios Page](https://opendrr.github.io/earthquake-scenarios/en/index.html)
	-	**working notes**
		-  1_scenario-risk-schema_v1.1
			- [Excel spreadsheet](https://github.com/OpenDRR/model-factory/blob/master/documentation/1_scenario-risk-schema_v1.1.xlsx) where initial phase of indicators were drafted.
		- mapping Sendai Indicators DSRA/PSRA
			- [Excel spreadsheet](https://github.com/OpenDRR/model-factory/blob/master/documentation/mapping%20Sendai%20Indicators%20DSRA_PSRA.xlsx) with draft indicators.

### Source / Output tables (views) 
- This section lists the schemas involved with the creation of the final results, and specific tables involved. Refer to [schemas](schemas.md) section for more schema details. 
- All source csv files are from the earthquake scenario [finished folder](https://github.com/OpenDRR/earthquake-scenarios/tree/master/FINISHED).

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

#### [gmf](schemas.md#gmf)
- shakemap_{EqScenario}
- shakemap_{EqScenario}_xref
- shakemap_scenario_extents_temp

#### [dsra](schemas.md#dsra)
- dsra_{EqScenario}

#### [ruptures](schemas.md#ruptures)
- rupture_table

#### [exposure](schemas.md#exposure)
- canada_exposure

#### [vs30](schemas.md#vs30)
- vs30_can_site_model_xref

#### [results_nhsl_physical_exposure](schemas.md#results_nhsl_physical_exposure)
- nhsl_physical_exposure_indicators_b
- nhsl_physical_exposure_indicators_s

#### [results_dsra_{EqScenario}](schemas.md#results_dsra_{EqScenario})
- All tables/views in this schema are results of earthquake scenario.

### SQL scripts
- A series of python scripts written by Drew Rotheram-Clarke to process the various csv files for each scenario into various dsra related tables.
	- DSRA_outputs2postgres_lfs.py
	- DSRA_runCreateTableShakemap.py
	- DSRA_ruptures2postgres.py
	- DSRA_createRiskProfileIndicators.py
- **Create_scenario_risk_master_tables.sql**
	- Script to attach rupture info to shakemap extents table.
- **Create_scenario_risk_building_Indicators_ALL_shkmp_3857.sql**
	- Script to generate various shakemap, shakemap hexgrid, displaced household calculations, and dsra_{eqScenario}_inidcators_b tables/views.
- **Create_scenario_risk_sauid_Indicators_ALL_shkmp_3857.sql**
	- Script to generate various required shelter calculations, and dsra_{eqScenario}\_indicators_s, and dsra_{eqScenario}\_indicators_csd tables and views.
- **Create_all_tables_update.sql**
	- Script to create and or update various tables in the opendrr db such as creating temp tables, adding geometry columns, and creating indexes etc.
- **Create_table_vs_30_CAN_site_model.sql**
	- Script to create source table source table for site-vgrid_CA.csv.
- **Create_table_vs_30_CAN_site_model_xref.sql**
	- Script to create source table source table for vs30_CAN_site_model_xref.csv.