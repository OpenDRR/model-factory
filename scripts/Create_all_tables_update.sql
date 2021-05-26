-- update tables in one script

-- create master dsra table
DROP TABLE IF EXISTS dsra.dsra_all_scenarios_tbl CASCADE;
CREATE TABLE dsra.dsra_all_scenarios_tbl(
assetid varchar,
sauid varchar,
dauid varchar,
csduid varchar,
csdname varchar,
fsauid varchar,
cduid varchar,
cdname varchar,
eruid varchar,
ername varchar,
pruid varchar,
prname varchar,
sh_rupname varchar,
sh_rupabbr varchar,
sh_mag varchar,
sh_hypolon float,
sh_hypolat float,
sh_hypodepth float,
sh_rake varchar,
geom_point geometry
); 

-- create gmf scenario extents table temp
DROP TABLE IF EXISTS gmf.shakemap_scenario_extents_temp CASCADE;
CREATE TABLE gmf.shakemap_scenario_extents_temp(
scenario varchar,
geom geometry);


/* Create_table_canada_exposure.psql */
-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE exposure.canada_exposure ADD COLUMN geom geometry(Point,4326);
UPDATE exposure.canada_exposure SET geom = st_setsrid(st_makepoint(SauidLon,SauidLat),4326);

-- create index on canada exposure
CREATE INDEX IF NOT EXISTS canada_exposure_idx ON exposure.canada_exposure using GIST (geom);
CREATE INDEX IF NOT EXISTS canada_exposure_id_idx ON exposure.canada_exposure("id");
CREATE INDEX IF NOT EXISTS canada_exposure_sauid_idx ON exposure.canada_exposure("sauid");


--remove trailing space from 'manufactured ' in gentype
UPDATE exposure.canada_exposure 
SET gentype = REPLACE(gentype,'Manufactured ','Manufactured')
WHERE gentype = 'Manufactured ';



/*Create_table_canada_site_exposure_ste.sql */
-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE exposure.metrovan_site_exposure ADD COLUMN geom_site geometry(Point,4326);
UPDATE exposure.metrovan_site_exposure SET geom_site = st_setsrid(st_makepoint(sitelon,sitelat),4326);

-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE exposure.metrovan_site_exposure ADD COLUMN geom_sauid geometry(Point,4326);
UPDATE exposure.metrovan_site_exposure SET geom_sauid = st_setsrid(st_makepoint(sauidlon,sauidlat),4326);

-- create indexes on site exposure tables
CREATE INDEX IF NOT EXISTS metrovan_site_exposure_id_idx ON exposure.metrovan_site_exposure("id");
CREATE INDEX IF NOT EXISTS metrovan_site_exposure_id_building_idx ON exposure.metrovan_site_exposure("id_building");
CREATE INDEX IF NOT EXISTS metrovan_site_exposure_sauid_idx ON exposure.metrovan_site_exposure("sauidid");
CREATE INDEX IF NOT EXISTS metrovan_site_exposure_geom_site_idx ON exposure.metrovan_site_exposure USING GIST("geom_site");
CREATE INDEX IF NOT EXISTS metrovan_site_exposure_geom_sauid_idx ON exposure.metrovan_site_exposure USING GIST("geom_sauid");

-- drop columns that are not needed
ALTER TABLE exposure.metrovan_site_exposure
DROP COLUMN objectid_1,
DROP COLUMN objectid_12,
DROP COLUMN sauidt,
DROP COLUMN sauidi,
DROP COLUMN lon,
DROP COLUMN lat,
DROP COLUMN area_km2,
DROP COLUMN area_ha,
DROP COLUMN dauidt,
DROP COLUMN dauidi,
DROP COLUMN adauid_1,
DROP COLUMN cfsauid,
DROP COLUMN pruid_1,
DROP COLUMN prname_1,
DROP COLUMN csduid_1,
DROP COLUMN csdname_1,
DROP COLUMN csdtype,
DROP COLUMN cduid_1,
DROP COLUMN cdname_1,
DROP COLUMN cdtype,
DROP COLUMN ccsuid,
DROP COLUMN ccsname,
DROP COLUMN eruid_1,
DROP COLUMN ername_1,
DROP COLUMN saccode,
DROP COLUMN sactype,
DROP COLUMN cmauid,
DROP COLUMN cmapuid,
DROP COLUMN cmaname,
DROP COLUMN cmatype,
DROP COLUMN shape_leng,
DROP COLUMN shape_length,
DROP COLUMN shape_area;



/* Create_table_vs_30_CAN_site_model.sql */
-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE vs30.vs30_can_site_model ADD COLUMN geom geometry(Point,4326);
UPDATE vs30.vs30_can_site_model SET geom = st_setsrid(st_makepoint(lon,lat),4326);

-- create index
CREATE INDEX IF NOT EXISTS vs30_can_site_model_idx ON vs30.vs30_can_site_model using GIST(geom);




/* Create_table_vs_30_CAN_site_model_xref.sql */
-- create indexes 
CREATE INDEX IF NOT EXISTS vs30_can_site_model_xref_idx ON vs30.vs30_can_site_model_xref (id);
CREATE INDEX IF NOT EXISTS vs_30_can_site_model_xref_id_idx ON vs30.vs30_can_site_model_xref("id");



/* Create_table_2016_census_v3.sql */
-- add missing sauid that is new in exposure model but missing in census
INSERT INTO census.census_2016_canada(sauidt)
VALUES(62000215);

-- create index
CREATE INDEX IF NOT EXISTS census_2016_canada_sauid_idx ON census.census_2016_canada("sauidt");



/* Create_table_sovi_index_canada_v2.sql */
-- create index
CREATE INDEX sovi_index_canada_idx ON sovi.sovi_index_canada (sauidt);



/* Create_table_sovi_census_canada.sql */
-- create indexes
CREATE INDEX IF NOT EXISTS sovi_census_canada_sauid_idx ON sovi.sovi_census_canada(sauidt);
CREATE INDEX IF NOT EXISTS sovi_census_canada_dauid_idx ON sovi.sovi_census_canada(dauidt);
CREATE INDEX IF NOT EXISTS sovi_census_canada_cfsauid_idx ON sovi.sovi_census_canada(cfsauid);
CREATE INDEX IF NOT EXISTS sovi_census_canada_csduid_idx ON sovi.sovi_census_canada(csduid);
CREATE INDEX IF NOT EXISTS sovi_census_canada_adauid_idx ON sovi.sovi_census_canada(adauid);
CREATE INDEX IF NOT EXISTS sovi_census_canada_cduid_idx ON sovi.sovi_census_canada(cduid);
CREATE INDEX IF NOT EXISTS sovi_census_canada_eruid_idx ON sovi.sovi_census_canada(eruid);
CREATE INDEX IF NOT EXISTS sovi_census_canada_pruid_idx ON sovi.sovi_census_canada(pruid);

/* sovi_index */
-- create indexes
CREATE INDEX IF NOT EXISTS sovi_index_canada_sauid_idx ON sovi.sovi_index_canada(sauidt);
CREATE INDEX IF NOT EXISTS sovi_index_canada_dauid_idx ON sovi.sovi_index_canada(dauidt);
CREATE INDEX IF NOT EXISTS sovi_index_canada_cfsauid_idx ON sovi.sovi_index_canada(cfsauid);
CREATE INDEX IF NOT EXISTS sovi_index_canada_csduid_idx ON sovi.sovi_index_canada(csduid);
CREATE INDEX IF NOT EXISTS sovi_index_canada_adauid_idx ON sovi.sovi_index_canada(adauid);
CREATE INDEX IF NOT EXISTS sovi_index_canada_cduid_idx ON sovi.sovi_index_canada(cduid);
CREATE INDEX IF NOT EXISTS sovi_index_canada_eruid_idx ON sovi.sovi_index_canada(eruid);
CREATE INDEX IF NOT EXISTS sovi_index_canada_pruid_idx ON sovi.sovi_index_canada(pruid);



/* Create_table_GHSL.sql */
-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE ghsl.ghsl_mh_intensity_ghsl ADD COLUMN geom geometry(Point,4326);
UPDATE ghsl.ghsl_mh_intensity_ghsl SET geom = st_setsrid(st_makepoint(lon,lat),4326);

-- create indexes
CREATE INDEX IF NOT EXISTS ghsl_mh_intensity_ghsl_idx ON ghsl.ghsl_mh_intensity_ghsl using GIST(geom);
CREATE INDEX IF NOT EXISTS ghsl_mh_intensity_ghsl_ghslid_idx ON ghsl.ghsl_mh_intensity_ghsl("ghslid");
CREATE INDEX IF NOT EXISTS ghsl_mh_intensity_ghsl_pruid_idx ON ghsl.ghsl_mh_intensity_ghsl("pruid");
CREATE INDEX IF NOT EXISTS ghsl_mh_intensity_ghsl_cduid_idx ON ghsl.ghsl_mh_intensity_ghsl("cduid");
CREATE INDEX IF NOT EXISTS ghsl_mh_intensity_ghsl_csduid_idx ON ghsl.ghsl_mh_intensity_ghsl("csduid");
CREATE INDEX IF NOT EXISTS ghsl_mh_intensity_ghsl_eruid_idx ON ghsl.ghsl_mh_intensity_ghsl("eruid");

-- some issue with the original source dataset, nulll values are present in ghslid. erase all null ghslid. 
DELETE FROM ghsl.ghsl_mh_intensity_ghsl WHERE ghslid IS NULL;

-- add pkey
ALTER TABLE ghsl.ghsl_mh_intensity_ghsl DROP CONSTRAINT IF EXISTS ghsl_mh_intensity_ghsl_pkey;
ALTER TABLE ghsl.ghsl_mh_intensity_ghsl ADD PRIMARY KEY(ghslID);



/* Create_table_sovi_index_canada_v2.sql */
-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE mh.mh_intensity_canada ADD COLUMN geom geometry(Point,4326);
UPDATE mh.mh_intensity_canada SET geom = st_setsrid(st_makepoint(lon,lat),4326);

-- create indexes
CREATE INDEX IF NOT EXISTS mh_intensity_canada_idx ON mh.mh_intensity_canada using GIST(geom);
CREATE INDEX IF NOT EXISTS mh_intensity_canada_sauid_idx ON mh.mh_intensity_canada("sauidt");
