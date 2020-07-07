DROP TABLE IF EXISTS vs30.vs30_bc_site_model_xref;

-- attach vs30 value to assetid based on closest location
CREATE TABLE vs30.vs30_bc_site_model_xref AS
SELECT
a.id,
a.lon AS "asset_lon",
a.lat AS "asset_lat",
b.vs30,
b.z1pt0,
b.z2pt5,
b.lon AS "vs_lon",
b.lat AS "vs_lat",
ST_Distance(a.geom,b.geom) AS "distance"

FROM exposure.canada_exposure a
CROSS JOIN LATERAL 
(
SELECT vs30,
	z1pt0,
	z2pt5,
	geom,
	lon,
	lat
FROM vs30.vs30_bc_site_model
ORDER BY a.geom <-> geom
LIMIT 1
) AS b;