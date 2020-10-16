DROP TABLE IF EXISTS vs30.vs30_bc_site_model_metrovan_site_exposure_xref,vs30.vs30_bc_site_model_metrovan_building_exposure_xref,vs30.vs30_bc_site_model_metrovan_sauid_exposure_xref;

-- attach vs30 value to assetid based on closest location site level exposure
CREATE TABLE vs30.vs30_bc_site_model_metrovan_site_exposure_xref AS
SELECT
a.id,
a.sitelon AS "asset_lon",
a.sitelat AS "asset_lat",
b.vs30,
b.z1pt0,
b.z2pt5,
b.lon AS "vs_lon",
b.lat AS "vs_lat",
ST_Distance(a.geom_site,b.geom) AS "distance"

FROM exposure.metrovan_site_exposure a
CROSS JOIN LATERAL 
(
SELECT vs30,
	z1pt0,
	z2pt5,
	geom,
	lon,
	lat
FROM vs30.vs30_bc_site_model
ORDER BY a.geom_site <-> geom
LIMIT 1
) AS b;


-- attach vs30 value to assetid based on closest location building level exposure
CREATE TABLE vs30.vs30_bc_site_model_metrovan_building_exposure_xref AS
SELECT
a.id,
a.sauidlon AS "asset_lon",
a.sauidlat AS "asset_lat",
b.vs30,
b.z1pt0,
b.z2pt5,
b.lon AS "vs_lon",
b.lat AS "vs_lat",
ST_Distance(a.geom_site,b.geom) AS "distance"

FROM exposure.metrovan_building_exposure a
CROSS JOIN LATERAL 
(
SELECT vs30,
	z1pt0,
	z2pt5,
	geom,
	lon,
	lat
FROM vs30.vs30_bc_site_model
ORDER BY a.geom_site <-> geom
LIMIT 1
) AS b;


-- attach vs30 value to assetid based on closest location building level exposure
CREATE TABLE vs30.vs30_bc_site_model_metrovan_sauid_exposure_xref AS
SELECT
a.sauid,
a.sauidlon AS "asset_lon",
a.sauidlat AS "asset_lat",
b.vs30,
b.z1pt0,
b.z2pt5,
b.lon AS "vs_lon",
b.lat AS "vs_lat",
ST_Distance(a.geom_site,b.geom) AS "distance"

FROM exposure.metrovan_sauid_exposure a
CROSS JOIN LATERAL 
(
SELECT vs30,
	z1pt0,
	z2pt5,
	geom,
	lon,
	lat
FROM vs30.vs30_bc_site_model
ORDER BY a.geom_site <-> geom
LIMIT 1
) AS b;