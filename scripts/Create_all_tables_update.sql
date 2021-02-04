-- update tables in one script

/* Create_table_canada_exposure.psql */
-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE exposure.canada_exposure ADD COLUMN geom geometry(Point,4326);
UPDATE exposure.canada_exposure SET geom = st_setsrid(st_makepoint(SauidLon,SauidLat),4326);

-- create spatial index
CREATE INDEX canada_exposure_idx
ON exposure.canada_exposure using GIST (geom);

--remove trailing space from 'manufactured ' in gentype
UPDATE exposure.canada_exposure 
SET gentype = REPLACE(gentype,'Manufactured ','Manufactured')
WHERE gentype = 'Manufactured '



/*Create_table_canada_site_exposure_ste.sql */
-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE exposure.metrovan_site_exposure ADD COLUMN geom_site geometry(Point,4326);
UPDATE exposure.metrovan_site_exposure SET geom_site = st_setsrid(st_makepoint(sitelon,sitelat),4326);

-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE exposure.metrovan_site_exposure ADD COLUMN geom_sauid geometry(Point,4326);
UPDATE exposure.metrovan_site_exposure SET geom_sauid = st_setsrid(st_makepoint(sauidlon,sauidlat),4326);

-- create spatial index
CREATE INDEX metrovan_site_exposure_idx
ON exposure.metrovan_site_exposure using GIST (geom_site,geom_sauid);

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

-- create spatial index
CREATE INDEX vs30_can_site_model_idx
ON vs30.vs30_can_site_model using GIST (geom);



/* Create_table_vs_30_CAN_site_model_xref.sql */
-- create index
CREATE INDEX vs30_can_site_model_xref_idx ON vs30.vs30_can_site_model_xref (id);



/* Create_table_2016_census_v3.sql */
-- create index
CREATE INDEX census_2016_canada_idx ON census.census_2016_canada (sauidt);



/* Create_table_sovi_index_canada_v2.sql */
-- create index
CREATE INDEX sovi_index_canada_idx ON sovi.sovi_index_canada (sauidt);



/* Create_table_sovi_census_canada.sql */
-- create index
CREATE INDEX sovi_census_canada_idx ON sovi.sovi_census_canada (sauidt);



/* Create_table_GHSL.sql */
-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE ghsl.ghsl_mh_intensity_ghsl ADD COLUMN geom geometry(Point,4326);
UPDATE ghsl.ghsl_mh_intensity_ghsl SET geom = st_setsrid(st_makepoint(lon,lat),4326);

-- create spatial index
CREATE INDEX ghsl_mh_intensity_ghsl_idx
ON ghsl.ghsl_mh_intensity_ghsl using GIST (geom);

-- some issue with the original source dataset, nulll values are present in ghslid. erase all null ghslid. 
DELETE FROM ghsl.ghsl_mh_intensity_ghsl WHERE ghslid IS NULL;

-- add pkey
ALTER TABLE ghsl.ghsl_mh_intensity_ghsl DROP CONSTRAINT IF EXISTS ghsl_mh_intensity_ghsl_pkey;
ALTER TABLE ghsl.ghsl_mh_intensity_ghsl ADD PRIMARY KEY(ghslID);



/* Create_table_sovi_index_canada_v2.sql */
-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE mh.mh_intensity_canada ADD COLUMN geom geometry(Point,4326);
UPDATE mh.mh_intensity_canada SET geom = st_setsrid(st_makepoint(lon,lat),4326);

-- create spatial index
CREATE INDEX mh_intensity_canada_idx
ON mh.mh_intensity_canada using GIST (geom);

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

DROP TABLE IF EXISTS mh.mh_intensity_canada_mhsum_temp, mh.valid_sauid_temp;