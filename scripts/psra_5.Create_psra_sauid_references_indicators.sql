CREATE SCHEMA IF NOT EXISTS results_psra_{prov};


-- src loss values
DROP TABLE IF EXISTS results_psra_{prov}.psra_{prov}_src_loss_temp CASCADE;
CREATE TABLE results_psra_{prov}.psra_{prov}_src_loss_temp AS
SELECT 
a.source AS "src_zone",
b.tectonicregion AS "src_type",
CASE 
	WHEN a.loss_type IN ('contents','nonstructural','structural') THEN 'building'
	WHEN a.loss_type IN ('occupants') THEN 'occupants'
	END AS "loss_type",
a.region,
SUM(a.loss_value_b0) AS "src_value_b0",
SUM(a.loss_value_r1) AS "src_value_r1"
--SUM(a.loss_value_b0)/(SELECT SUM(loss_value_b0) FROM psra_{prov}.psra_{prov}_src_loss ) AS "src_value_b0",
--SUM(a.loss_value_r1)/(SELECT SUM(loss_value_r1) FROM psra_{prov}.psra_{prov}_src_loss ) AS "src_value_r1"

FROM psra_{prov}.psra_{prov}_src_loss a
LEFT JOIN lut.psra_source_types b ON a.source = b.code
GROUP BY a.source,b.tectonicregion,a.loss_type,a.region
ORDER BY a.source ASC;



DROP TABLE IF EXISTS results_psra_{prov}.psra_{prov}_src_loss_tbl CASCADE;
CREATE TABLE results_psra_{prov}.psra_{prov}_src_loss_tbl AS
SELECT
src_zone,
src_type,
loss_type,
region,
CAST(CAST(ROUND(CAST(SUM(src_value_b0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "src_value_b0",
CAST(CAST(ROUND(CAST(SUM(src_value_r1) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "src_value_r1"

FROM results_psra_{prov}.psra_{prov}_src_loss_temp
GROUP BY src_zone,src_type,loss_type,region;


DROP VIEW IF EXISTS results_psra_{prov}.psra_{prov}_src_loss;

CREATE VIEW results_psra_{prov}.psra_{prov}_src_loss AS SELECT * FROM results_psra_{prov}.psra_{prov}_src_loss_tbl;

DROP TABLE IF EXISTS results_psra_{prov}.psra_{prov}_src_loss_temp,psra_{prov}.psra_{prov}_src_loss_b0, psra_{prov}.psra_{prov}_src_loss_r1 CASCADE;


/*
DROP VIEW IF EXISTS results_psra_{prov}.psra_{prov}_hcurves_pga,results_psra_{prov}.psra_{prov}_hcurves_sa0p1,results_psra_{prov}.psra_{prov}_hcurves_sa0p2,results_psra_{prov}.psra_{prov}_hcurves_sa0p3,
results_psra_{prov}.psra_{prov}_hcurves_sa0p5,results_psra_{prov}.psra_{prov}_hcurves_sa0p6,results_psra_{prov}.psra_{prov}_hcurves_sa1p0,results_psra_{prov}.psra_{prov}_hcurves_sa2p0,results_psra_{prov}.psra_{prov}_hmaps,
results_psra_{prov}.psra_{prov}_uhs,results_psra_{prov}.psra_{prov}_hmaps_xref CASCADE;


CREATE VIEW results_psra_{prov}.psra_{prov}_hcurves_pga AS SELECT FROM psra_{prov}.psra_{prov}_hcurves_pga;

CREATE VIEW results_psra_{prov}.psra_{prov}_hcurves_sa0p1 AS SELECT * FROM psra_{prov}.psra_{prov}_hcurves_sa0p1;

CREATE VIEW results_psra_{prov}.psra_{prov}_hcurves_sa0p2 AS SELECT * FROM psra_{prov}.psra_{prov}_hcurves_sa0p2;

CREATE VIEW results_psra_{prov}.psra_{prov}_hcurves_sa0p3 AS SELECT * FROM psra_{prov}.psra_{prov}_hcurves_sa0p3;

CREATE VIEW results_psra_{prov}.psra_{prov}_hcurves_sa0p5 AS SELECT * FROM psra_{prov}.psra_{prov}_hcurves_sa0p5;

CREATE VIEW results_psra_{prov}.psra_{prov}_hcurves_sa0p6 AS SELECT * FROM psra_{prov}.psra_{prov}_hcurves_sa0p6;

CREATE VIEW results_psra_{prov}.psra_{prov}_hcurves_sa1p0 AS SELECT * FROM psra_{prov}.psra_{prov}_hcurves_sa1p0;

CREATE VIEW results_psra_{prov}.psra_{prov}_hcurves_sa2p0 AS SELECT * FROM psra_{prov}.psra_{prov}_hcurves_sa2p0;

CREATE VIEW results_psra_{prov}.psra_{prov}_hmaps AS SELECT * FROM psra_{prov}.psra_{prov}_hmaps;

CREATE VIEW results_psra_{prov}.psra_{prov}_hmaps_xref AS SELECT * FROM psra_{prov}.psra_{prov}_hmaps_xref;



-- add geom to uhs
-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE psra_{prov}.psra_{prov}_uhs ADD COLUMN geom geometry(Point,4326);
UPDATE psra_{prov}.psra_{prov}_uhs SET geom = st_setsrid(st_makepoint(lon,lat),4326);

-- create spatial index
CREATE INDEX psra_{prov}_uhs_geom_idx ON psra_{prov}.psra_{prov}_uhs using GIST (geom);

CREATE VIEW results_psra_{prov}.psra_{prov}_uhs AS SELECT * FROM psra_{prov}.psra_{prov}_uhs;
*/