-- update gmf data and sitemesh data into 1 table incorporating assetID

ALTER TABLE gmf.s_gmfdata_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_pgv" float DEFAULT 0;
ALTER TABLE gmf.s_gmfdata_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(0.1)" float DEFAULT 0;
ALTER TABLE gmf.s_gmfdata_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(0.2)" float DEFAULT 0;
ALTER TABLE gmf.s_gmfdata_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(2.0)" float DEFAULT 0;


DROP TABLE IF EXISTS gmf.gmfdata_sitemesh_{eqScenario}, gmf.gmfdata_sitemesh_{eqScenario}_xref;

SELECT 
-- a."event_id",
a."site_id",
a."gmv_pga",
-- a."gmv_pgv",
-- a."gmv_SA(0.1)",
-- a."gmv_SA(0.2)",
a."gmv_SA(0.3)",
a."gmv_SA(0.5)",
a."gmv_SA(0.6)",
a."gmv_SA(1.0)",
-- a."gmv_SA(2.0)",
b.lon,
b.lat

INTO gmf.gmfdata_sitemesh_{eqScenario}

FROM gmf.s_gmfdata_{eqScenario} a
INNER JOIN sitemesh.s_sitemesh_{eqScenario} b on a.site_id = b.site_id;

-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE gmf.gmfdata_sitemesh_{eqScenario} ADD COLUMN geom geometry(Point,4326);
UPDATE gmf.gmfdata_sitemesh_{eqScenario} SET geom = st_setsrid(st_makepoint(lon,lat),4326);


-- create spatial index
CREATE INDEX gmfdata_sitemesh_{eqScenario}_idx
ON gmf.gmfdata_sitemesh_{eqScenario} using GIST (geom);


-- attach assetID to gmfdata_sitemesh based on closest location -event 0
CREATE TABLE gmf.gmfdata_sitemesh_{eqScenario}_xref AS

SELECT
a."id",
-- b."event_id",
b."site_id",
b."gmv_pga",
-- b."gmv_pgv",
-- b."gmv_SA(0.1)",
-- b."gmv_SA(0.2)",
b."gmv_SA(0.3)",
b."gmv_SA(0.5)",
b."gmv_SA(0.6)",
b."gmv_SA(1.0)",
-- b."gmv_SA(2.0)",
b.lon,
b.lat,
a.lon AS "asset_lon",
a.lat AS "asset_lat",
ST_Distance(a.geom,b.geom) AS "distance"

FROM exposure.canada_exposure a
CROSS JOIN LATERAL 
(
SELECT site_id,
	-- event_id,
	gmv_pga,
	-- gmv_pgv,
	-- "gmv_SA(0.1)",
	-- "gmv_SA(0.2)",
	"gmv_SA(0.3)",
	"gmv_SA(0.5)",
	"gmv_SA(0.6)",
	"gmv_SA(1.0)",
	-- "gmv_SA(2.0)",
	lon,
	lat,
	geom
	
FROM gmf.gmfdata_sitemesh_{eqScenario}
ORDER BY a.geom <-> geom
LIMIT 1
) AS b;