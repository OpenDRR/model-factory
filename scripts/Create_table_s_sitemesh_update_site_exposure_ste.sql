-- add columns to s_gmfdata if missing
ALTER TABLE gmf.s_gmfdata_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_pga" float DEFAULT NULL;
ALTER TABLE gmf.s_gmfdata_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_pgv" float DEFAULT NULL;
ALTER TABLE gmf.s_gmfdata_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(0.1)" float DEFAULT NULL;
ALTER TABLE gmf.s_gmfdata_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(0.2)" float DEFAULT NULL;
ALTER TABLE gmf.s_gmfdata_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(0.3)" float DEFAULT NULL;
ALTER TABLE gmf.s_gmfdata_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(0.5)" float DEFAULT NULL;
ALTER TABLE gmf.s_gmfdata_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(0.6)" float DEFAULT NULL;
ALTER TABLE gmf.s_gmfdata_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(1.0)" float DEFAULT NULL;
ALTER TABLE gmf.s_gmfdata_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(2.0)" float DEFAULT NULL;

-- update gmf data and sitemesh data into 1 table incorporating assetID
DROP TABLE IF EXISTS gmf.gmfdata_sitemesh_{eqScenario}_metrovan_site_xref,gmf.gmfdata_sitemesh_{eqScenario}_metrovan_building_xref,
gmf.gmfdata_sitemesh_{eqScenario}_metrovan_sauid_xref CASCADE;

-- attach assetID to gmfdata_sitemesh based on closest location site level
CREATE TABLE gmf.gmfdata_sitemesh_{eqScenario}_metrovan_site_xref AS

SELECT
a."id",
b."site_id",
b."gmv_pgv",
b."gmv_pga",
b."gmv_SA(0.1)",
b."gmv_SA(0.2)",
b."gmv_SA(0.3)",
b."gmv_SA(0.5)",
b."gmv_SA(0.6)",
b."gmv_SA(1.0)",
b."gmv_SA(2.0)",
b.lon,
b.lat,
a.sitelon AS "asset_lon",
a.sitelat AS "asset_lat",
ST_Distance(a.geom_site,b.geom) AS "distance"

FROM exposure.metrovan_site_exposure a
CROSS JOIN LATERAL 
(
SELECT 
	site_id,
	gmv_pga,
	gmv_pgv,
	"gmv_SA(0.1)",
	"gmv_SA(0.2)",
	"gmv_SA(0.3)",
	"gmv_SA(0.5)",
	"gmv_SA(0.6)",
	"gmv_SA(1.0)",
	"gmv_SA(2.0)",
	lon,
	lat,
	geom
	
FROM gmf.gmfdata_sitemesh_{eqScenario}
ORDER BY a.geom_site <-> geom
LIMIT 1
) AS b;

-- create index
CREATE INDEX gmfdata_sitemesh_{eqScenario}_metrovan_site_idx ON gmf.gmfdata_sitemesh_{eqScenario}_metrovan_site_xref (id);


-- attach assetID to gmfdata_sitemesh based on closest location -event 0
CREATE TABLE gmf.gmfdata_sitemesh_{eqScenario}_metrovan_building_xref AS

SELECT
a."id",
b."site_id",
b."gmv_pga",
b."gmv_pgv",
b."gmv_SA(0.1)",
b."gmv_SA(0.2)",
b."gmv_SA(0.3)",
b."gmv_SA(0.5)",
b."gmv_SA(0.6)",
b."gmv_SA(1.0)",
b."gmv_SA(2.0)",
b.lon,
b.lat,
a.sauidlon AS "asset_lon",
a.sauidlat AS "asset_lat",
ST_Distance(a.geom_site,b.geom) AS "distance"

FROM exposure.metrovan_building_exposure a
CROSS JOIN LATERAL 
(
SELECT
	site_id,
	gmv_pga,
	gmv_pgv,
	"gmv_SA(0.1)",
	"gmv_SA(0.2)",
	"gmv_SA(0.3)",
	"gmv_SA(0.5)",
	"gmv_SA(0.6)",
	"gmv_SA(1.0)",
	"gmv_SA(2.0)",
	lon,
	lat,
	geom
	
FROM gmf.gmfdata_sitemesh_{eqScenario}
ORDER BY a.geom_site <-> geom
LIMIT 1
) AS b;

-- create index
CREATE INDEX gmfdata_sitemesh_{eqScenario}_metrovan_building_idx ON gmf.gmfdata_sitemesh_{eqScenario}_metrovan_building_xref (id);


-- attach assetID to gmfdata_sitemesh based on closest location -event 0
CREATE TABLE gmf.gmfdata_sitemesh_{eqScenario}_metrovan_sauid_xref AS

SELECT
a.sauid,
b."site_id",
b."gmv_pga",
b."gmv_pgv",
b."gmv_SA(0.1)",
b."gmv_SA(0.2)",
b."gmv_SA(0.3)",
b."gmv_SA(0.5)",
b."gmv_SA(0.6)",
b."gmv_SA(1.0)",
b."gmv_SA(2.0)",
b.lon,
b.lat,
a.sauidlon AS "asset_lon",
a.sauidlat AS "asset_lat",
ST_Distance(a.geom_site,b.geom) AS "distance"

FROM exposure.metrovan_sauid_exposure a
CROSS JOIN LATERAL 
(
SELECT 
	site_id,
	gmv_pga,
	gmv_pgv,
	"gmv_SA(0.1)",
	"gmv_SA(0.2)",
	"gmv_SA(0.3)",
	"gmv_SA(0.5)",
	"gmv_SA(0.6)",
	"gmv_SA(1.0)",
	"gmv_SA(2.0)",
	lon,
	lat,
	geom
	
FROM gmf.gmfdata_sitemesh_{eqScenario}
ORDER BY a.geom_site <-> geom
LIMIT 1
) AS b;

-- create index
CREATE INDEX gmfdata_sitemesh_{eqScenario}_metrovan_sauid_idx ON gmf.gmfdata_sitemesh_{eqScenario}_metrovan_sauid_xref (sauid);