-- update shakemap table to add geometry and spatial index
-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE gmf.shakemap_{eqScenario} ADD COLUMN geom geometry(Point,4326);
UPDATE gmf.shakemap_{eqScenario} SET geom = st_setsrid(st_makepoint(lon,lat),4326);

-- create spatial index
CREATE INDEX shakemap_{eqScenario}_idx
ON gmf.shakemap_{eqScenario} using GIST (geom);
-- add columns to shakemap if missing
ALTER TABLE gmf.shakemap_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_pga" float DEFAULT NULL;
ALTER TABLE gmf.shakemap_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_pgv" float DEFAULT NULL;
ALTER TABLE gmf.shakemap_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(0.1)" float DEFAULT NULL;
ALTER TABLE gmf.shakemap_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(0.2)" float DEFAULT NULL;
ALTER TABLE gmf.shakemap_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(0.3)" float DEFAULT NULL;
ALTER TABLE gmf.shakemap_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(0.5)" float DEFAULT NULL;
ALTER TABLE gmf.shakemap_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(0.6)" float DEFAULT NULL;
ALTER TABLE gmf.shakemap_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(1.0)" float DEFAULT NULL;
ALTER TABLE gmf.shakemap_{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(2.0)" float DEFAULT NULL;


-- create temp table for xref only on ids matching scenario
DROP TABLE IF EXISTS dsra.exposure_{eqScenario} CASCADE;

CREATE TABLE dsra.exposure_{eqScenario} AS 
(
SELECT
a.id,
a.sauidlon,
a.sauidlat,
a.geom
FROM exposure.canada_exposure a
RIGHT JOIN dsra.dsra_{eqScenario} b ON a.id = b."AssetID"
);



DROP TABLE IF EXISTS gmf.shakemap_{eqScenario}_xref CASCADE;

-- attach assetID to gmfdata_sitemesh based on closest location
CREATE TABLE gmf.shakemap_{eqScenario}_xref AS

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
ST_Distance(a.geom,b.geom) AS "distance"

FROM dsra.exposure_{eqScenario} a
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
	
FROM gmf.shakemap_{eqScenario}
ORDER BY a.geom <-> geom
LIMIT 1
) AS b;

DROP TABLE IF EXISTS dsra.exposure_{eqScenario} CASCADE;

-- add pkey
ALTER TABLE gmf.shakemap_{eqScenario}_xref DROP CONSTRAINT IF EXISTS shakemap_{eqScenario}_pkey;
ALTER TABLE gmf.shakemap_{eqScenario}_xref ADD PRIMARY KEY("id");

-- create index
CREATE INDEX shakemap_{eqScenario}_xref_idx ON gmf.shakemap_{eqScenario}_xref (id);