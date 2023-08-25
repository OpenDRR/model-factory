# National Human Settlement Layers
## Physical Exposure
- ### Notes
	- **Github Repo**
	    - Latest geopackages, data dictionary, documentation etc.
	    - [https://opendrr.github.io/national-human-settlement/en/#nhsl_physical_exposure_indicators-a](https://opendrr.github.io/national-human-settlement/en/#nhsl_physical_exposure_indicators-a)
	- **Github page**
	    - [https://opendrr.github.io/national-human-settlement/en/index.html](https://opendrr.github.io/national-human-settlement/en/index.html)
	-	**working notes** (google sheet)
		- 2_physical-exposure-schema.xlsx
			- Worksheet where initial phase of indicators were drafted.
			- [https://docs.google.com/spreadsheets/d/1dsVOAbUAp-V0Xu-dINVbchUzyQZ6EmE_/edit?usp=sharing&ouid=108110519296938878163&rtpof=true&sd=true](https://docs.google.com/spreadsheets/d/1dsVOAbUAp-V0Xu-dINVbchUzyQZ6EmE_/edit?usp=sharing&ouid=108110519296938878163&rtpof=true&sd=true)

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
	-	**working notes** (google sheet)
		- social-vulnerability-schema.xlsx
			- Worksheet where initial phase of indicators were drafted.
			- [https://docs.google.com/spreadsheets/d/1t2VRUVZ6RKKNWdTw4TNvekZzjIoJRpxS/edit?usp=sharing&ouid=108110519296938878163&rtpof=true&sd=true](https://docs.google.com/spreadsheets/d/1t2VRUVZ6RKKNWdTw4TNvekZzjIoJRpxS/edit?usp=sharing&ouid=108110519296938878163&rtpof=true&sd=true)

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



## Risk Dynamics
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


## Multi Hazard Threat

- ### Notes
    - Draft indicators were generated but not released, and are not intended for the public.
    - The Hazard threat value contains scores based on different hazards, and pregenerated threshold lookup tables. Using source information from multi hazard, physical exposure indicators, social fabric indicators, and census a series of calculations are made (prereq tables). These values are compared against the threshold lookup tables and assigned scores.
    - **working notes** (google sheet)
        - 3_multi-hazard-threat-schema.xlsx
        - worksheet where initial phase of indicators were drafted
        - [https://docs.google.com/spreadsheets/d/1bSJGmk4O8iwV-UJGdN1D6sHOZjfEzVtO/edit?usp=sharing&ouid=108110519296938878163&rtpof=true&sd=true](https://docs.google.com/spreadsheets/d/1bSJGmk4O8iwV-UJGdN1D6sHOZjfEzVtO/edit?usp=sharing&ouid=108110519296938878163&rtpof=true&sd=true)

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


## Earthquake Scenarios (DSRA)
- ### Notes
	- **Github Repo**
	    - Latest geopackages, data dictionary, documentation etc.
	    - [https://opendrr.github.io/national-human-settlement/en/#nhsl_physical_exposure_indicators-a](https://opendrr.github.io/national-human-settlement/en/#nhsl_physical_exposure_indicators-a)
	- **Github page**
	    - [https://opendrr.github.io/earthquake-scenarios/en/index.html](https://opendrr.github.io/earthquake-scenarios/en/index.html)
	-	**working notes** (google sheet)
		-  3_multi-hazard-threat-schema.xlsx
			- Worksheet where initial phase of indicators were drafted.
			- [https://docs.google.com/spreadsheets/d/1bSJGmk4O8iwV-UJGdN1D6sHOZjfEzVtO/edit?usp=sharing&ouid=108110519296938878163&rtpof=true&sd=true](https://docs.google.com/spreadsheets/d/1bSJGmk4O8iwV-UJGdN1D6sHOZjfEzVtO/edit?usp=sharing&ouid=108110519296938878163&rtpof=true&sd=true)
		- mapping Sendai Indicators DSRA/PSRA
			- [https://docs.google.com/spreadsheets/d/12nacK6YtvJ0ABwpL9OpV8kwjnZi-PRXLlYjcLnR-x2c/edit#gid=0](https://docs.google.com/spreadsheets/d/12nacK6YtvJ0ABwpL9OpV8kwjnZi-PRXLlYjcLnR-x2c/edit#gid=0)

### Source / Output tables (views) 
- This section lists the schemas involved with the creation of the final results, and specific tables involved. Refer to [schemas](schemas.md) section for more schema details. 
- All source csv files are from the earthquake scenario finished folder.
	- [https://github.com/OpenDRR/earthquake-scenarios/tree/master/FINISHED](https://github.com/OpenDRR/earthquake-scenarios/tree/master/FINISHED)

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


## Seismic Risk Model (PSRA)
- ### Notes
	- **Github Repo**
	    - Latest geopackages, data dictionary, documentation etc.
			- [https://github.com/OpenDRR/seismic-risk-model](https://github.com/OpenDRR/seismic-risk-model)
	- **Github page**
	    - [https://opendrr.github.io/seismic-risk-model/en/](https://opendrr.github.io/seismic-risk-model/en/)
	-	**working notes** (google sheet)
		- mapping Sendai Indicators DSRA/PSRA
		- [https://docs.google.com/spreadsheets/d/12nacK6YtvJ0ABwpL9OpV8kwjnZi-PRXLlYjcLnR-x2c/edit#gid=0](https://docs.google.com/spreadsheets/d/12nacK6YtvJ0ABwpL9OpV8kwjnZi-PRXLlYjcLnR-x2c/edit#gid=0)

### Source / Output tables (views) 
- This section lists the schemas involved with the creation of the final results, and specific tables involved. Refer to [schemas](schemas.md) section for more schema details. 
-  All source csv files are from the seismic risk model repo in various output repos.
	- [https://github.com/OpenDRR/seismic-risk-model/tree/master](https://github.com/OpenDRR/seismic-risk-model/tree/master)

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

#### [exposure](schemas.md#exposure)
- canada_exposure

#### [lut](schemas.md#lut)
- collapse_probability
- psra_source_types

#### [mh](schemas.md#mh)
- mh_intensity_canada

#### [psra_{P/T}](schemas.md#psra_pt)
- All tables in this schema are used for results_psra_{P/T}.

#### [psra_canada](schemas.md#psra_canada)
- All tables in this schema are used for results_psra_canada.

#### [results_psra_{P/T}](schemas.md#results_psra_pt)
- All tables/views in this schema are results of seismic risk model.

#### [results_psra_canada](schemas.md#results_psra_canada)
- All tables/views in this schema are results of seismic risk model.

#### [results_psra_national](schemas.md#results_psra_national)
- All tables/views in this schema are results of seismic risk model. Results from results_psra_{P/T} are merged in this schema.

#### [vs30](schemas.md#vs30)
- vs30_can_site_model_xref


### SQL scripts
- psra_0.create_psra_schema.sql
    - Create default psra_{P/T}, psra_canada schemas.
- psra_1.Create_tables_Canada.sql
    - Create default empty psra_canada schema tables to be loaded. These tables are direct copies from seismic risk model repo.
- psra_1.Create_tables.sql
    - Create default empty psra_{P/T} schema tables to be loaded. These tables are direct copies from seismic risk model repo.
- psra_2.Create_table_updates_Canada.sql
    - Creates finalized tables from tables loaded in psra_1.Create_tables_Canada.sql. Previous tables are deleted.
- psra_2.Create_table_updates.sql
    - Creates finalized tables from tables loaded in psra_1.Create_tables.sql. Previous tables are deleted.
- psra_3.Create_psra_building_all_indicators.sql
    - Create finalized building level indicators for each result_psra_{P/T} schema.
- psra_4.Create_psra_sauid_all_indicators_Canada.sql
    - Create finalized sauid level indicators for results_psra_canada schema.
- psra_4.Create_psra_sauid_all_indicators.sql
- psra_5.Create_psra_sauid_references_indicators.sql
    - Create finalized reference indicators psra_{P/T}\_src_loss for each result_psra_{P/T} schema.
- psra_6.Create_psra_merge_into_national_indicators.sql
    - National indicators are results from the various results_psra_{P/T} schema, including psra_{P/T}\_indicators_b, psra_{P/T}\_indicators_s, psra_{P/T}\_indicators_csd, psra_{P/T}\_expected_loss_fsa, psra_{P/T}_agg_loss_fsa, and psra_{P/T}\_src_loss tables that are merged together into a one national table for each of the tables above. After merging, earthquake risk index calculations are made for indicators_s, and indicators_csd tables and updated. The EQRI values are then updated in the corresponding results_psra_{P/T} as well.
- psra_6a.eqri_calculation_sa.sql
    - Create seismic risk index (eqri) calculations used for settled area.
- psra_6a1.eqri_calculation_csd.sql
    - Create seismic risk index (eqri) calculations used for csd.
- psra_6a2.eqri_calculation_hexgrid_1km_3857.sql
    - Create seismic risk index (eqri) calculations used for 1km hexgrid (EPSG 3857).
- psra_6a2.eqri_calculation_hexgrid_1km_uc_3857.sql
    - Create seismic risk index (eqri) calculations used for 1km hexgrid (EPSG 4326).
- psra_6a2.eqri_calculation_hexgrid_1km_uc.sql
    - Create seismic risk index (eqri) calculations used for 1km unclipped hexgrid (EPSG 3857).
- psra_6a2.eqri_calculation_hexgrid_1km.sql
    - Create seismic risk index (eqri) calculations used for 1km unclipped hexgrid (EPSG 4326).
- psra_6a2.eqri_calculation_hexgrid_5km_3857.sql
    - Create seismic risk index (eqri) calculations used for 5km hexgrid (EPSG 3857).
- psra_6a2.eqri_calculation_hexgrid_5km_uc_3857.sql
    - Create seismic risk index (eqri) calculations used for 5km hexgrid (EPSG 4326).
- psra_6a2.eqri_calculation_hexgrid_5km_uc.sql
    - Create seismic risk index (eqri) calculations used for 5km unclipped hexgrid (EPSG 3857).
- psra_6a2.eqri_calculation_hexgrid_5km.sql
    - Create seismic risk index (eqri) calculations used for 5km unclipped hexgrid (EPSG 4326).
- psra_6a2.eqri_calculation_hexgrid_10km_3857.sql
    - Create seismic risk index (eqri) calculations used for 10km hexgrid (EPSG 3857).
- psra_6a2.eqri_calculation_hexgrid_10km_uc_3857.sql
    - Create seismic risk index (eqri) calculations used for 10km unclipped hexgrid (EPSG 4326).
- psra_6a2.eqri_calculation_hexgrid_10km_uc.sql
    - Create seismic risk index (eqri) calculations used for 10km unclipped hexgrid (EPSG 3857).
- psra_6a2.eqri_calculation_hexgrid_10km.sql
    - Create seismic risk index (eqri) calculations used for 10km hexgrid (EPSG 4326).
- psra_6a2.eqri_calculation_hexgrid_25km_3857.sql
    - Create seismic risk index (eqri) calculations used for 25km hexgrid (EPSG 3857).
- psra_6a2.eqri_calculation_hexgrid_25km_uc_3857.sql
    - Create seismic risk index (eqri) calculations used for 25km unclipped hexgrid (EPSG 3857).
- psra_6a2.eqri_calculation_hexgrid_25km_uc.sql
    - Create seismic risk index (eqri) calculations used for 25km unclipped hexgrid (EPSG 4326).
- psra_6a2.eqri_calculation_hexgrid_25km.sql
    - Create seismic risk index (eqri) calculations used for 25km hexgrid (EPSG 4326).
- psra_6a2.eqri_calculation_hexgrid_50km_uc_3857.sql
    - Create seismic risk index (eqri) calculations used for 50km unclipped hexgrid (EPSG 3857).
- psra_6a2.eqri_calculation_hexgrid_50km_uc.sql
    - Create seismic risk index (eqri) calculations used for 50km unclipped hexgrid (EPSG 4326).
- psra_6a2.eqri_calculation_hexgrid_100km_uc_3857.sql
    - Create seismic risk index (eqri) calculations used for 100km unclipped hexgrid (EPSG 3857).
- psra_6a2.eqri_calculation_hexgrid_100km_uc.sql
    - Create seismic risk index (eqri) calculations used for 100km unclipped hexgrid (EPSG 4326).
