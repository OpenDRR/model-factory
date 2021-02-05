-- updates

/* psra_1.Create_table_chazard_ALL copy.sql */
-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE psra_{prov}.psra_{prov}_hmaps ADD COLUMN geom geometry(Point,4326);
UPDATE psra_{prov}.psra_{prov}_hmaps SET geom = st_setsrid(st_makepoint(lon,lat),4326);

-- create spatial index
CREATE INDEX {prov}_hmaps_idx
ON psra_{prov}.psra_{prov}_hmaps using GIST (geom);



-- attach assetID to hazard mean map based on closest location, comment out section after processed xrefs are pushed on github
DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_hmaps_xref CASCADE;

CREATE TABLE psra_{prov}.psra_{prov}_hmaps_xref AS
SELECT
a.id,
a.sauid,
a.sauidlon AS "asset_lon",
a.sauidlat AS "asset_lat",
b.lon,
b.lat,
ST_Distance(a.geom,b.geom) AS "distance",
b."PGA_0.02",
b."PGA_0.1",
b."SA(0.1)_0.02",
b."SA(0.1)_0.1",
b."SA(0.2)_0.02",
b."SA(0.2)_0.1",
b."SA(0.3)_0.02",
b."SA(0.3)_0.1",
b."SA(0.5)_0.02",
b."SA(0.5)_0.1",
b."SA(0.6)_0.02",
b."SA(0.6)_0.1",
b."SA(1.0)_0.02",
b."SA(1.0)_0.1",
b."SA(10.0)_0.02",
b."SA(10.0)_0.1",
b."SA(2.0)_0.02",
b."SA(2.0)_0.1",
b."SA(5.0)_0.02",
b."SA(5.0)_0.1"

--FROM psra_{prov}.exposure_{prov} a
FROM exposure.canada_exposure a
CROSS JOIN LATERAL 
(
SELECT 
lon,
lat,
"PGA_0.02",
"PGA_0.1",
"SA(0.1)_0.02",
"SA(0.1)_0.1",
"SA(0.2)_0.02",
"SA(0.2)_0.1",
"SA(0.3)_0.02",
"SA(0.3)_0.1",
"SA(0.5)_0.02",
"SA(0.5)_0.1",
"SA(0.6)_0.02",
"SA(0.6)_0.1",
"SA(1.0)_0.02",
"SA(1.0)_0.1",
"SA(10.0)_0.02",
"SA(10.0)_0.1",
"SA(2.0)_0.02",
"SA(2.0)_0.1",
"SA(5.0)_0.02",
"SA(5.0)_0.1",
geom

FROM psra_{prov}.psra_{prov}_hmaps
ORDER BY a.geom <-> geom
LIMIT 1
) AS b;

-- create index
CREATE INDEX psra_{prov}_hmaps_xref_idx ON psra_{prov}.psra_{prov}_hmaps_xref(id);

DROP TABLE IF EXISTS psra_{prov}.exposure_{prov};



/* psra_2.Create_table_dmg_mean.sql */
-- combine ed b0 and r2 table
CREATE TABLE psra_{prov}.psra_{prov}_ed_dmg_mean AS
(SELECT
a.asset_id,
a."BldEpoch",
a."BldgType",
a."EqDesLev",
a."GenOcc",
a."GenType",
a."LandUse",
a."OccClass",
a."SAC",
a."SSC_Zone",
a."SauidID",
a.adauid,
a.cdname,
a.cduid,
a.csdname,
a.csduid,
a.dauid,
a.ername,
a.eruid,
a.fsauid,
a.prname,
a.pruid,
a.sauid,
a.taxonomy,
a.lon,
a.lat,
a.structural_no_damage AS "structural_no_damage_b0",
a.structural_slight AS "structural_slight_b0",
a.structural_moderate AS "structural_moderate_b0",
a.structural_extensive AS "structural_extensive_b0",
a.structural_complete AS "structural_complete_b0",
b.structural_no_damage AS "structural_no_damage_r2",
b.structural_slight AS "structural_slight_r2",
b.structural_moderate AS "structural_moderate_r2",
b.structural_extensive AS "structural_extensive_r2",
b.structural_complete AS "structural_complete_r2"

FROM psra_{prov}.psra_{prov}_ed_dmg_mean_b0 a
INNER JOIN psra_{prov}.psra_{prov}_ed_dmg_mean_r2 b ON a.asset_id = b.asset_id
);

ALTER TABLE psra_{prov}.psra_{prov}_ed_dmg_mean ADD PRIMARY KEY (asset_id);

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_cd_dmg_mean_b0, psra_{prov}.psra_{prov}_cd_dmg_mean_r2, psra_{prov}.psra_{prov}_ed_dmg_mean_b0, psra_{prov}.psra_{prov}_ed_dmg_mean_r2 CASCADE;



/* psra_3.Create_table_agg_curves_stats.sql */
-- combine b0 and r2 tables
CREATE TABLE psra_{prov}.psra_{prov}_agg_curves_stats AS
(SELECT
a.return_period,
a.stat,
a.loss_type,
a.fsauid,
a."GenOcc",
a."GenType",
a.loss_value AS "loss_value_b0",
a.loss_ratio AS "loss_ratio_b0",
b.loss_value AS "loss_value_r2",
b.loss_ratio AS "loss_ratio_r2",
a.annual_frequency_of_exceedence
FROM psra_{prov}.psra_{prov}_agg_curves_stats_b0 a
LEFT JOIN psra_{prov}.psra_{prov}_agg_curves_stats_r2 b ON a.return_period = b.return_period AND a.stat = b.stat AND a.loss_type = b.loss_type AND a.fsauid = b.fsauid AND a."GenOcc" = b."GenOcc" AND
a."GenType" = b."GenType" and a.annual_frequency_of_exceedence = b.annual_frequency_of_exceedence);

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_agg_curves_stats_b0, psra_{prov}.psra_{prov}_agg_curves_stats_r2;



/* psra_3.Create_table_avg_losses_stats.sql */
-- combine b0 and r2 table
CREATE TABLE psra_{prov}.psra_{prov}_avg_losses_stats AS
(SELECT
a.asset_id,
a."BldEpoch",
a."BldgType",
a."EqDesLev",
a."GenOcc",
a."GenType",
a."LandUse",
a."OccClass",
a."SAC",
a."SSC_Zone",
a."SauidID",
a.adauid,
a.cdname,
a.cduid,
a.csdname,
a.csduid,
a.dauid,
a.ername,
a.eruid,
a.fsauid,
a.prname,
a.pruid,
a.sauid,
a.taxonomy,
a.lon,
a.lat,
a.contents AS "contents_b0",
a.nonstructural AS "nonstructural_b0",
a.structural AS "structural_b0",
b.contents AS "contents_r2",
b.nonstructural AS "nonstructural_r2",
b.structural AS "structural_r2"

FROM psra_{prov}.psra_{prov}_avg_losses_stats_b0 a
INNER JOIN psra_{prov}.psra_{prov}_avg_losses_stats_r2 b ON a.asset_id = b.asset_id);

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_avg_losses_stats_b0, psra_{prov}.psra_{prov}_avg_losses_stats_r2;



 /* psra_3.Create_table_src_loss_table.sql */
 -- create temp table for agg
CREATE TABLE psra_{prov}.psra_{prov}_src_loss_b0_temp AS
(
SELECT
source,
loss_type,
trt,
SUM(loss_value) AS "loss_value",
region

FROM psra_{prov}.psra_{prov}_src_loss_b0
GROUP BY source,loss_type,trt,region);

-- create temp table for agg
CREATE TABLE psra_{prov}.psra_{prov}_src_loss_r2_temp AS
(
SELECT
source,
loss_type,
trt,
SUM(loss_value) AS "loss_value",
region


FROM psra_{prov}.psra_{prov}_src_loss_r2
GROUP BY source,loss_type,trt,region);

-- combine src tables into one
CREATE TABLE psra_{prov}.psra_{prov}_src_loss AS
(
SELECT a.source,
a.loss_type,
a.trt,
a.region,
a.loss_value AS "loss_value_b0",
b.loss_value AS "loss_value_r2"

FROM psra_{prov}.psra_{prov}_src_loss_b0_temp a
INNER JOIN psra_{prov}.psra_{prov}_src_loss_r2_temp b ON a.source = b.source AND a.loss_type = b.loss_type AND a.trt = b.trt AND a.region = b.region
);

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_src_loss_b0_temp, psra_{prov}.psra_{prov}_src_loss_r2_temp CASCADE;