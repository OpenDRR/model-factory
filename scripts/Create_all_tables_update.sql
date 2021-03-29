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


/*
-- moved to Update_boundaries_SAUID_table.sql
-- create index on geometries tables
CREATE INDEX IF NOT EXISTS geometry_aduid_pruid_idx ON boundaries."Geometry_ADAUID"("ADAUID");

CREATE INDEX IF NOT EXISTS geometry_canada_fid_idx ON boundaries."Geometry_ADAUID"("fid");

CREATE INDEX IF NOT EXISTS geometry_cduid_cduid_idx ON boundaries."Geometry_CDUID"("CDUID");

CREATE INDEX IF NOT EXISTS geometry_csduid_csduid_idx ON boundaries."Geometry_CSDUID"("CSDUID");

CREATE INDEX IF NOT EXISTS geometry_dauid_dauid_idx ON boundaries."Geometry_DAUID"("DAUID");

CREATE INDEX IF NOT EXISTS geometry_eruid_eruid_idx ON boundaries."Geometry_ERUID"("ERUID");

CREATE INDEX IF NOT EXISTS geometry_fsauid_fsauid_idx ON boundaries."Geometry_FSAUID"("CFSAUID");

CREATE INDEX IF NOT EXISTS geometry_pruid_pruid_idx ON boundaries."Geometry_PRUID"("PRUID");

CREATE INDEX IF NOT EXISTS geometry_sauid_sauid_idx ON boundaries."Geometry_SAUID"("SAUIDt");
CREATE INDEX IF NOT EXISTS geometry_sauid_dauid_idx ON boundaries."Geometry_SAUID"("DAUIDt");
CREATE INDEX IF NOT EXISTS geometry_sauid_cfsauid_idx ON boundaries."Geometry_SAUID"("CFSAUID");
CREATE INDEX IF NOT EXISTS geometry_sauid_csduid_idx ON boundaries."Geometry_SAUID"("CSDUID");
CREATE INDEX IF NOT EXISTS geometry_sauid_adauid_idx ON boundaries."Geometry_SAUID"("ADAUID");
CREATE INDEX IF NOT EXISTS geometry_sauid_cduid_idx ON boundaries."Geometry_SAUID"("CDUID");
CREATE INDEX IF NOT EXISTS geometry_sauid_eruid_idx ON boundaries."Geometry_SAUID"("ERUID");
CREATE INDEX IF NOT EXISTS geometry_sauid_pruid_idx ON boundaries."Geometry_SAUID"("PRUID");
*/


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

/*
-- this table contains 460170 rows.  Reduce the empty sauid to 359129 by using physical exposure table.
SELECT sauid
INTO mh.valid_sauid_temp
FROM exposure.canada_exposure
GROUP BY sauid;

-- update table by deleting empty sauid values
DELETE FROM mh.mh_intensity_canada 
WHERE NOT EXISTS (SELECT NULL from mh.valid_sauid_temp a WHERE a.sauid = sauidt);

-- obtain min/max values FOR mh intensity calculations
DROP TABLE IF EXISTS mh.mh_intensity_canada_minmax CASCADE;

SELECT
MIN(pgv) AS "pgv_min",
MAX(pgv) AS "pgv_max",
MIN(pga) AS "pga_min",
MAX(pga) AS "pga_max",
MIN(mmi6) AS "mmi6_min",
MAX(mmi6) AS "mmi6_max",
MIN(mmi7) AS "mmi7_min",
MAX(mmi7) AS "mmi7_max",
MIN(mmi8) AS "mmi8_min",
MAX(mmi8) AS "mmi8_max",
MIN(tsun_ha) AS "tsun_min",
MAX(tsun_ha) AS "tsun_max",
MIN(fl200) AS "fl200_min",
MAX(fl200) AS "fl200_max",
MIN(fl500) AS "fl500_min",
MAX(fl500) AS "fl500_max",
MIN(fl1000) AS "fl1000_min",
MAX(fl1000) AS "fl1000_max",
MIN(lndsus) AS "lndsus_min",
MAX(lndsus) AS "lndsus_max",
MIN(fire) AS "fire_min",
MAX(fire) AS "fire_max",
MIN(cy100) AS "cy100_min",
MAX(cy100) AS "cy100_max",
MIN(cy250) AS "cy250_min",
MAX(cy250) AS "cy250_max",
MIN(cy500) AS "cy500_min",
MAX(cy500) AS "cy500_max",
MIN(cy1000) AS "cy1000_min",
MAX(cy1000) AS "cy1000_max"

INTO mh.mh_intensity_canada_minmax

FROM mh.mh_intensity_canada;


-- calculate mh_sum variable needed for mh threat tables
DROP TABLE IF EXISTS mh.mh_intensity_canada_mhsum;

SELECT 
a.sauidt,

COALESCE((a.pgv - (SELECT pgv_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT pgv_max FROM mh.mh_intensity_canada_minmax) - (SELECT pgv_min FROM mh.mh_intensity_canada_minmax),0),0) +
COALESCE((a.tsun_ha - (SELECT tsun_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT tsun_max FROM mh.mh_intensity_canada_minmax) - (SELECT tsun_min FROM mh.mh_intensity_canada_minmax),0),0) + 
COALESCE((a.fl500 - (SELECT fl500_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT fl500_max FROM mh.mh_intensity_canada_minmax) - (SELECT fl500_min FROM mh.mh_intensity_canada_minmax),0),0) +
COALESCE((a.fire - (SELECT fire_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT fire_max FROM mh.mh_intensity_canada_minmax) - (SELECT fire_min FROM mh.mh_intensity_canada_minmax),0),0) +
COALESCE((a.lndsus - (SELECT lndsus_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT lndsus_max FROM mh.mh_intensity_canada_minmax) - (SELECT lndsus_min FROM mh.mh_intensity_canada_minmax),0),0) +
COALESCE((a.cy500 - (SELECT cy500_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT cy500_max FROM mh.mh_intensity_canada_minmax) - (SELECT cy500_min FROM mh.mh_intensity_canada_minmax),0),0) AS "mh_sum"

INTO mh.mh_intensity_canada_mhsum

FROM mh.mh_intensity_canada a;

-- update min/max value table with mh_sum values
DROP TABLE IF EXISTS mh.mh_intensity_canada_mhsum_temp;
SELECT
MIN(mh_sum) AS "mhsum_min",
MAX(mh_sum) AS "mhsum_max"

INTO mh.mh_intensity_canada_mhsum_temp

FROM mh.mh_intensity_canada_mhsum;


ALTER TABLE mh.mh_intensity_canada_minmax 
ADD COLUMN mhsum_min float,
ADD COLUMN mhsum_max float;

UPDATE mh.mh_intensity_canada_minmax SET mhsum_min = (SELECT mhsum_min FROM mh.mh_intensity_canada_mhsum_temp);
UPDATE mh.mh_intensity_canada_minmax SET mhsum_max = (SELECT mhsum_max FROM mh.mh_intensity_canada_mhsum_temp);

-- create index
CREATE INDEX IF NOT EXISTS mh_intensity_canada_mhsum_sauid_idx ON mh.mh_intensity_canada_mhsum("sauidt");

DROP TABLE IF EXISTS mh.mh_intensity_canada_mhsum_temp, mh.valid_sauid_temp;
*/