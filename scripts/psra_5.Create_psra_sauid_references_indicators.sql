CREATE SCHEMA IF NOT EXISTS results_psra_{prov};


-- src loss values
DROP VIEW IF EXISTS results_psra_{prov}.psra_{prov}_src_loss CASCADE;
CREATE VIEW results_psra_{prov}.psra_{prov}_src_loss AS

SELECT 
source AS "src_zone",
SUM(loss_value_b0)/(SELECT SUM(loss_value_b0) FROM psra_{prov}.psra_{prov}_src_loss ) AS "src_value_b0",
SUM(loss_value_r1)/(SELECT SUM(loss_value_r1) FROM psra_{prov}.psra_{prov}_src_loss ) AS "src_value_r1"
FROM psra_{prov}.psra_{prov}_src_loss
GROUP BY source
ORDER BY source ASC;



DROP VIEW IF EXISTS  results_psra_{prov}.psra_{prov}_agg_curves_stats,results_psra_{prov}.psra_{prov}_agg_curves_q05,results_psra_{prov}.psra_{prov}_agg_curves_q95,results_psra_{prov}.psra_{prov}_hcurves_pga,
results_psra_{prov}.psra_{prov}_hcurves_sa0p1,results_psra_{prov}.psra_{prov}_hcurves_sa0p2,results_psra_{prov}.psra_{prov}_hcurves_sa0p3,results_psra_{prov}.psra_{prov}_hcurves_sa0p5,results_psra_{prov}.psra_{prov}_hcurves_sa0p6,
results_psra_{prov}.psra_{prov}_hcurves_sa1p0,results_psra_{prov}.psra_{prov}_hcurves_sa2p0,results_psra_{prov}.psra_{prov}_hmaps,results_psra_{prov}.psra_{prov}_uhs,
results_psra_{prov}.psra_{prov}_hmaps_xref CASCADE;

CREATE VIEW results_psra_{prov}.psra_{prov}_agg_curves_stats AS SELECT * FROM psra_{prov}.psra_{prov}_agg_curves_stats;


CREATE VIEW results_psra_{prov}.psra_{prov}_agg_curves_q05 AS SELECT * FROM psra_{prov}.psra_{prov}_agg_curves_q05;

CREATE VIEW results_psra_{prov}.psra_{prov}_agg_curves_q95 AS SELECT * FROM psra_{prov}.psra_{prov}_agg_curves_q95;

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