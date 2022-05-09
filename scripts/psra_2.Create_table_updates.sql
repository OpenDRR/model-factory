-- updates

/* psra_1.Create_table_chazard_ALL copy.sql */
-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE psra_{prov}.psra_{prov}_hmaps ADD COLUMN geom geometry(Point,4326);
UPDATE psra_{prov}.psra_{prov}_hmaps SET geom = st_setsrid(st_makepoint(lon,lat),4326);

-- create index
CREATE INDEX IF NOT EXISTS {prov}_hmaps_idx ON psra_{prov}.psra_{prov}_hmaps using GIST(geom);
CREATE INDEX IF NOT EXISTS psra_{prov}_hmaps_xref_id_idx ON psra_{prov}.psra_{prov}_hmaps_xref(id);


DROP TABLE IF EXISTS psra_{prov}.exposure_{prov};

/* psra_2.Create_table_dmg_mean.sql */
/*
-- combine cd b0 and r2 table
CREATE TABLE psra_{prov}.psra_{prov}_cd_dmg_mean AS
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

FROM psra_{prov}.psra_{prov}_cd_dmg_mean_b0 a
INNER JOIN psra_{prov}.psra_{prov}_cd_dmg_mean_r2 b ON a.asset_id = b.asset_id
);

ALTER TABLE psra_{prov}.psra_{prov}_cd_dmg_mean ADD PRIMARY KEY (asset_id);
*/


-- combine ed q05 b0 and r1 table
CREATE TABLE psra_{prov}.psra_{prov}_ed_dmg_q05 AS
(SELECT
a.asset_id,
a."BldEpoch",
a."BldgType",
a."EqDesLev",
a."GenOcc",
a."GenType",
a."LandUse",
a."OccClass",
a."OccType",
a."SAC",
a."SSC_Zone",
a."SS_Region",
a."Sauid_km2",
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
b.structural_no_damage AS "structural_no_damage_r1",
b.structural_slight AS "structural_slight_r1",
b.structural_moderate AS "structural_moderate_r1",
b.structural_extensive AS "structural_extensive_r1",
b.structural_complete AS "structural_complete_r1"

FROM psra_{prov}.psra_{prov}_ed_dmg_q05_b0 a
INNER JOIN psra_{prov}.psra_{prov}_ed_dmg_q05_r1 b ON a.asset_id = b.asset_id
);

ALTER TABLE psra_{prov}.psra_{prov}_ed_dmg_q05 ADD PRIMARY KEY (asset_id);



-- combine ed q95 b0 and r1 table
CREATE TABLE psra_{prov}.psra_{prov}_ed_dmg_q95 AS
(SELECT
a.asset_id,
a."BldEpoch",
a."BldgType",
a."EqDesLev",
a."GenOcc",
a."GenType",
a."LandUse",
a."OccClass",
a."OccType",
a."SAC",
a."SSC_Zone",
a."SS_Region",
a."Sauid_km2",
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
b.structural_no_damage AS "structural_no_damage_r1",
b.structural_slight AS "structural_slight_r1",
b.structural_moderate AS "structural_moderate_r1",
b.structural_extensive AS "structural_extensive_r1",
b.structural_complete AS "structural_complete_r1"

FROM psra_{prov}.psra_{prov}_ed_dmg_q95_b0 a
INNER JOIN psra_{prov}.psra_{prov}_ed_dmg_q95_r1 b ON a.asset_id = b.asset_id
);

ALTER TABLE psra_{prov}.psra_{prov}_ed_dmg_q95 ADD PRIMARY KEY (asset_id);



-- combine ed b0 and r1 table
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
a."OccType",
a."SAC",
a."SSC_Zone",
a."SS_Region",
a."Sauid_km2",
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
b.structural_no_damage AS "structural_no_damage_r1",
b.structural_slight AS "structural_slight_r1",
b.structural_moderate AS "structural_moderate_r1",
b.structural_extensive AS "structural_extensive_r1",
b.structural_complete AS "structural_complete_r1"

FROM psra_{prov}.psra_{prov}_ed_dmg_mean_b0 a
INNER JOIN psra_{prov}.psra_{prov}_ed_dmg_mean_r1 b ON a.asset_id = b.asset_id
);

ALTER TABLE psra_{prov}.psra_{prov}_ed_dmg_mean ADD PRIMARY KEY (asset_id);

-- create index
CREATE INDEX IF NOT EXISTS psra_{prov}_ed_dmg_mean_asset_id_idx ON psra_{prov}.psra_{prov}_ed_dmg_mean(asset_id);

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_cd_dmg_mean_b0, psra_{prov}.psra_{prov}_cd_dmg_mean_r2, psra_{prov}.psra_{prov}_ed_dmg_mean_b0, psra_{prov}.psra_{prov}_ed_dmg_mean_r1,
psra_{prov}.psra_{prov}_ed_dmg_q05_b0, psra_{prov}.psra_{prov}_ed_dmg_q05_r1, psra_{prov}.psra_{prov}_ed_dmg_q95_b0, psra_{prov}.psra_{prov}_ed_dmg_q95_r1 CASCADE;



/* psra_3.Create_table_agg_curves_stats.sql */

-- combine b0 and r1 tables - q05
CREATE TABLE psra_{prov}.psra_{prov}_agg_curves_q05 AS
(SELECT
a.return_period,
a.loss_type,
a.fsauid,
a."OccType",
a."GenType",
a.loss_value AS "loss_value_b0",
a.loss_ratio AS "loss_ratio_b0",
b.loss_value AS "loss_value_r1",
b.loss_ratio AS "loss_ratio_r1",
a.annual_frequency_of_exceedence
FROM psra_{prov}.psra_{prov}_agg_curves_q05_b0 a
LEFT JOIN psra_{prov}.psra_{prov}_agg_curves_q05_r1 b ON a.return_period = b.return_period AND a.loss_type = b.loss_type AND a.fsauid = b.fsauid AND a."OccType" = b."OccType" AND
a."GenType" = b."GenType" and a.annual_frequency_of_exceedence = b.annual_frequency_of_exceedence);

-- delete *total* rows from table
DELETE FROM psra_{prov}.psra_{prov}_agg_curves_q05 WHERE fsauid = '*total*';

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_agg_curves_q05_b0, psra_{prov}.psra_{prov}_agg_curves_q05_r1;

-- combine b0 and r1 tables - q95
CREATE TABLE psra_{prov}.psra_{prov}_agg_curves_q95 AS
(SELECT
a.return_period,
a.loss_type,
a.fsauid,
a."OccType",
a."GenType",
a.loss_value AS "loss_value_b0",
a.loss_ratio AS "loss_ratio_b0",
b.loss_value AS "loss_value_r1",
b.loss_ratio AS "loss_ratio_r1",
a.annual_frequency_of_exceedence
FROM psra_{prov}.psra_{prov}_agg_curves_q95_b0 a
LEFT JOIN psra_{prov}.psra_{prov}_agg_curves_q95_r1 b ON a.return_period = b.return_period AND a.loss_type = b.loss_type AND a.fsauid = b.fsauid AND a."OccType" = b."OccType" AND
a."GenType" = b."GenType" and a.annual_frequency_of_exceedence = b.annual_frequency_of_exceedence);

-- delete *total* rows from table
DELETE FROM psra_{prov}.psra_{prov}_agg_curves_q95 WHERE fsauid = '*total*';

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_agg_curves_q95_b0, psra_{prov}.psra_{prov}_agg_curves_q95_r1;


-- combine b0 and r1 tables
CREATE TABLE psra_{prov}.psra_{prov}_agg_curves_stats AS
(SELECT
a.return_period,
a.loss_type,
a.fsauid,
a."OccType",
a."GenType",
a.region,
a.loss_value AS "loss_value_b0",
a.loss_ratio AS "loss_ratio_b0",
b.loss_value AS "loss_value_r1",
b.loss_ratio AS "loss_ratio_r1",
a.annual_frequency_of_exceedence
FROM psra_{prov}.psra_{prov}_agg_curves_stats_b0 a
LEFT JOIN psra_{prov}.psra_{prov}_agg_curves_stats_r1 b ON a.return_period = b.return_period AND a.loss_type = b.loss_type AND a.fsauid = b.fsauid AND a."OccType" = b."OccType" AND
a."GenType" = b."GenType" and a.annual_frequency_of_exceedence = b.annual_frequency_of_exceedence);

-- delete *total* rows from table
DELETE FROM psra_{prov}.psra_{prov}_agg_curves_stats WHERE fsauid = '*total*';

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_agg_curves_stats_b0, psra_{prov}.psra_{prov}_agg_curves_stats_r1;



-- agg losses
-- combine b0 and r1 tables - q05
CREATE TABLE psra_{prov}.psra_{prov}_agg_losses_q05 AS
SELECT
a.loss_type,
a.fsauid,
a."OccType",
a."GenType",
a.loss_value AS "loss_value_b0",
a.exposed_value AS "exposed_value_b0",
a.loss_ratio AS "loss_ratio_b0",
b.loss_value AS "loss_value_r1",
b.exposed_value AS "exposed_value_r1",
b.loss_ratio AS "loss_ratio_r1"

FROM psra_{prov}.psra_{prov}_agg_losses_q05_b0 a
LEFT JOIN psra_{prov}.psra_{prov}_agg_losses_q05_r1 b ON a.loss_type = b.loss_type AND a.fsauid = b.fsauid AND a."OccType" = b."OccType" AND a."GenType" = b."GenType";

-- delete *total* rows from table
DELETE FROM psra_{prov}.psra_{prov}_agg_losses_q05 WHERE fsauid = '*total*';

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_agg_losses_q05_b0, psra_{prov}.psra_{prov}_agg_losses_q05_r1 CASCADE;



-- combine b0 and r1 tables - q95
CREATE TABLE psra_{prov}.psra_{prov}_agg_losses_q95 AS
SELECT
a.loss_type,
a.fsauid,
a."OccType",
a."GenType",
a.loss_value AS "loss_value_b0",
a.exposed_value AS "exposed_value_b0",
a.loss_ratio AS "loss_ratio_b0",
b.loss_value AS "loss_value_r1",
b.exposed_value AS "exposed_value_r1",
b.loss_ratio AS "loss_ratio_r1"

FROM psra_{prov}.psra_{prov}_agg_losses_q95_b0 a
LEFT JOIN psra_{prov}.psra_{prov}_agg_losses_q95_r1 b ON a.loss_type = b.loss_type AND a.fsauid = b.fsauid AND a."OccType" = b."OccType" AND a."GenType" = b."GenType";

-- delete *total* rows from table
DELETE FROM psra_{prov}.psra_{prov}_agg_losses_q95 WHERE fsauid = '*total*';

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_agg_losses_q95_b0, psra_{prov}.psra_{prov}_agg_losses_q95_r1 CASCADE;



CREATE TABLE psra_{prov}.psra_{prov}_agg_losses_stats AS
SELECT
a.loss_type,
a.fsauid,
a."OccType",
a."GenType",
a.region,
a.loss_value AS "loss_value_b0",
a.exposed_value AS "exposed_value_b0",
a.loss_ratio AS "loss_ratio_b0",
b.loss_value AS "loss_value_r1",
b.exposed_value AS "exposed_value_r1",
b.loss_ratio AS "loss_ratio_r1"

FROM psra_{prov}.psra_{prov}_agg_losses_stats_b0 a
LEFT JOIN psra_{prov}.psra_{prov}_agg_losses_stats_r1 b ON a.loss_type = b.loss_type AND a.fsauid = b.fsauid AND a."OccType" = b."OccType" AND a."GenType" = b."GenType";

-- delete *total* rows from table
DELETE FROM psra_{prov}.psra_{prov}_agg_losses_stats WHERE fsauid = '*total*';

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_agg_losses_stats_b0, psra_{prov}.psra_{prov}_agg_losses_stats_r1 CASCADE;



/* psra_3.Create_table_avg_losses_stats.sql */
-- combine b0 and r1 table
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
a."OccType",
a."SAC",
a."SSC_Zone",
a."SS_Region",
a."Sauid_km2",
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
a.occupants AS "occupants_b0",
a.structural AS "structural_b0",
b.contents AS "contents_r1",
b.nonstructural AS "nonstructural_r1",
b.occupants AS "occupants_r1",
b.structural AS "structural_r1"

FROM psra_{prov}.psra_{prov}_avg_losses_stats_b0 a
INNER JOIN psra_{prov}.psra_{prov}_avg_losses_stats_r1 b ON a.asset_id = b.asset_id);

-- create index
CREATE INDEX IF NOT EXISTS psra_{prov}_avg_losses_stats_asset_id_idx ON psra_{prov}.psra_{prov}_avg_losses_stats(asset_id);

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_avg_losses_stats_b0, psra_{prov}.psra_{prov}_avg_losses_stats_r1;



 /* psra_3.Create_table_src_loss_table.sql */
DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_src_loss CASCADE;
CREATE TABLE psra_{prov}.psra_{prov}_src_loss AS
(
SELECT a.source,
a.loss_type,
a.region,
a.loss_value AS "loss_value_b0",
b.loss_value AS "loss_value_r1"

FROM psra_{prov}.psra_{prov}_src_loss_b0 a
INNER JOIN psra_{prov}.psra_{prov}_src_loss_r1 b ON a.source = b.source AND a.loss_type = b.loss_type AND a.region = b.region
);