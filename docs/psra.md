## Seismic Risk Model (PSRA)
- ### Notes
	- **Github Repo**
	    - Latest geopackages, data dictionary, documentation etc.
			- [https://github.com/OpenDRR/seismic-risk-model](https://github.com/OpenDRR/seismic-risk-model)
	- **Github page**
	    - [https://opendrr.github.io/seismic-risk-model/en/](https://opendrr.github.io/seismic-risk-model/en/)
	-	**working notes**
		- mapping Sendai Indicators DSRA/PSRA
			- [Excel spreadsheet](https://github.com/wkhchow/model-factory/blob/master/documentation/mapping%20Sendai%20Indicators%20DSRA_PSRA.xlsx) with draft indicators.

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