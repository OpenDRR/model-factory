-- attach ruptures info to shakemap extents table
SELECT 
a.scenario,
--b.rupture_name,
b.magnitude,
CAST(b.rake AS NUMERIC),
CAST(b.lon AS NUMERIC),
CAST(b.lat AS NUMERIC),
CAST(b.depth AS NUMERIC),
a.geom

INTO gmf.shakemap_scenario_extents_tbl
FROM gmf.shakemap_scenario_extents_temp a
LEFT JOIN ruptures.rupture_table b on a.scenario = b.rupture_name;

/*
-- fix invalid projection
ALTER TABLE gmf.shakemap_scenario_extents_tbl
ALTER COLUMN geom TYPE geometry(POLYGON,4326) USING ST_SetSRID(geom,4326);
*/

-- create shakemap extents view
DROP VIEW IF EXISTS gmf.shakemap_scenario_extents CASCADE;
CREATE VIEW gmf.shakemap_scenario_extents AS 
SELECT * FROM gmf.shakemap_scenario_extents_tbl;

-- create index
CREATE INDEX IF NOT EXISTS shakemap_scenario_extents_idx ON gmf.shakemap_scenario_extents_tbl USING GIST(geom);

--DROP TABLE IF EXISTS gmf.shakemap_scenario_extents_temp;


-- create index on master dsra table
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_assetid_idx ON dsra.dsra_all_scenarios_tbl(assetid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_sauid_idx ON dsra.dsra_all_scenarios_tbl(sauid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_pruid_idx ON dsra.dsra_all_scenarios_tbl(pruid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_eruid_idx ON dsra.dsra_all_scenarios_tbl(eruid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_cduid_idx ON dsra.dsra_all_scenarios_tbl(cduid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_csduid_idx ON dsra.dsra_all_scenarios_tbl(csduid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_fsauid_idx ON dsra.dsra_all_scenarios_tbl(fsauid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_dauid_idx ON dsra.dsra_all_scenarios_tbl(dauid);
-- CREATE INDEX IF NOT EXISTS dsra_all_scenarios_geom_idx ON dsra.dsra_all_scenarios_tbl USING GIST(geom_point);

-- create master dsra building view
DROP VIEW IF EXISTS dsra.dsra_all_scenarios_building CASCADE;
CREATE VIEW dsra.dsra_all_scenarios_building AS 
SELECT * FROM dsra.dsra_all_scenarios_tbl ORDER BY assetid,sh_rupname;



-- create master dsra sauid view
DROP TABLE IF EXISTS dsra.dsra_all_scenarios_sauid_tbl_temp CASCADE;
CREATE TABLE dsra.dsra_all_scenarios_sauid_tbl_temp AS
(
SELECT
a.sauid,
a.dauid,
a.csduid,
a.csdname,
a.cduid,
a.cdname,
a.fsauid,
a.eruid,
a.ername,
a.pruid,
a.prname,
a.sh_rupname,
a.sh_mag,
a.sh_hypolon,
a.sh_hypolat,
a.sh_hypodepth,
a.sh_rake
FROM dsra.dsra_all_scenarios_tbl a
GROUP BY sauid,dauid,csduid,csdname,cduid,cdname,fsauid,eruid,ername,pruid,prname,sh_rupname,sh_mag,sh_hypolon,sh_hypolat,sh_hypodepth,sh_rake);

DROP TABLE IF EXISTS dsra.dsra_all_scenarios_sauid_tbl CASCADE;
CREATE TABLE dsra.dsra_all_scenarios_sauid_tbl AS
(
SELECT
a.sauid,
a.dauid,
a.csduid,
a.csdname,
a.cduid,
a.cdname,
a.fsauid,
a.eruid,
a.ername,
a.pruid,
a.prname,
a.sh_rupname,
a.sh_mag,
a.sh_hypolon,
a.sh_hypolat,
a.sh_hypodepth,
a.sh_rake
-- a.sh_rake,
-- b.geom
FROM dsra.dsra_all_scenarios_sauid_tbl_temp a
LEFT JOIN boundaries."Geometry_SAUID" b ON a.sauid = b."SAUIDt");

-- create index on master dsra sauid table
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_sauid_sauid_idx ON dsra.dsra_all_scenarios_sauid_tbl(sauid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_sauid_dauid_idx ON dsra.dsra_all_scenarios_sauid_tbl(dauid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_sauid_csduid_idx ON dsra.dsra_all_scenarios_sauid_tbl(csduid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_sauid_fsauid_idx ON dsra.dsra_all_scenarios_sauid_tbl(fsauid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_sauid_cduid_idx ON dsra.dsra_all_scenarios_sauid_tbl(cduid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_sauid_eruid_idx ON dsra.dsra_all_scenarios_sauid_tbl(eruid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_sauid_pruid_idx ON dsra.dsra_all_scenarios_sauid_tbl(pruid);
-- CREATE INDEX IF NOT EXISTS dsra_all_scenarios_sauid_geom_idx ON dsra.dsra_all_scenarios_sauid_tbl USING GIST(geom);

-- create master dsra sauid view
DROP VIEW IF EXISTS dsra.dsra_all_scenarios_sauid CASCADE;
CREATE VIEW dsra.dsra_all_scenarios_sauid AS 
SELECT * FROM dsra.dsra_all_scenarios_sauid_tbl ORDER BY sauid,sh_rupname;

DROP TABLE IF EXISTS dsra.dsra_all_scenarios_sauid_tbl_temp CASCADE;



-- create master dsra dauid view
DROP TABLE IF EXISTS dsra.dsra_all_scenarios_dauid_tbl_temp CASCADE;
CREATE TABLE dsra.dsra_all_scenarios_dauid_tbl_temp AS
(
SELECT
a.dauid,
a.csduid,
a.csdname,
a.cduid,
a.cdname,
a.eruid,
a.ername,
a.pruid,
a.prname,
a.sh_rupname,
a.sh_mag,
a.sh_hypolon,
a.sh_hypolat,
a.sh_hypodepth,
a.sh_rake
FROM dsra.dsra_all_scenarios_tbl a
LEFT JOIN boundaries."Geometry_DAUID" b ON a.dauid = b."DAUID"
GROUP BY dauid,csduid,csdname,cduid,cdname,eruid,ername,pruid,prname,sh_rupname,sh_mag,sh_hypolon,sh_hypolat,sh_hypodepth,sh_rake);



DROP TABLE IF EXISTS dsra.dsra_all_scenarios_dauid_tbl CASCADE;
CREATE TABLE dsra.dsra_all_scenarios_dauid_tbl AS
(
SELECT
a.dauid,
a.csduid,
a.csdname,
a.cduid,
a.cdname,
a.eruid,
a.ername,
a.pruid,
a.prname,
a.sh_rupname,
a.sh_mag,
a.sh_hypolon,
a.sh_hypolat,
a.sh_hypodepth,
a.sh_rake
-- a.sh_rake,
-- b.geom
FROM dsra.dsra_all_scenarios_dauid_tbl_temp a
LEFT JOIN boundaries."Geometry_DAUID" b ON a.dauid = b."DAUID");

-- create index on master dsra dauid table
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_dauid_dauid_idx ON dsra.dsra_all_scenarios_dauid_tbl(dauid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_dauid_csduid_idx ON dsra.dsra_all_scenarios_dauid_tbl(csduid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_dauid_cduid_idx ON dsra.dsra_all_scenarios_dauid_tbl(cduid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_dauid_eruid_idx ON dsra.dsra_all_scenarios_dauid_tbl(eruid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_dauid_pruid_idx ON dsra.dsra_all_scenarios_dauid_tbl(pruid);
-- CREATE INDEX IF NOT EXISTS dsra_all_scenarios_dauid_geom_idx ON dsra.dsra_all_scenarios_dauid_tbl USING GIST(geom);

-- create master dsra dauid view
DROP VIEW IF EXISTS dsra.dsra_all_scenarios_dauid CASCADE;
CREATE VIEW dsra.dsra_all_scenarios_dauid AS 
SELECT * FROM dsra.dsra_all_scenarios_dauid_tbl ORDER BY dauid,sh_rupname;

DROP TABLE IF EXISTS dsra.dsra_all_scenarios_dauid_tbl_temp CASCADE;



-- create master dsra csduid view
DROP TABLE IF EXISTS dsra.dsra_all_scenarios_csduid_tbl_temp CASCADE;
CREATE TABLE dsra.dsra_all_scenarios_csduid_tbl_temp AS
(
SELECT
a.csduid,
a.csdname,
a.cduid,
a.cdname,
a.eruid,
a.ername,
a.pruid,
a.prname,
a.sh_rupname,
a.sh_mag,
a.sh_hypolon,
a.sh_hypolat,
a.sh_hypodepth,
a.sh_rake
FROM dsra.dsra_all_scenarios_tbl a
GROUP BY csduid,csdname,cduid,cdname,eruid,ername,pruid,prname,sh_rupname,sh_mag,sh_hypolon,sh_hypolat,sh_hypodepth,sh_rake);



DROP TABLE IF EXISTS dsra.dsra_all_scenarios_csduid_tbl CASCADE;
CREATE TABLE dsra.dsra_all_scenarios_csduid_tbl AS
(
SELECT
a.csduid,
a.csdname,
a.cduid,
a.cdname,
a.eruid,
a.ername,
a.pruid,
a.prname,
a.sh_rupname,
a.sh_mag,
a.sh_hypolon,
a.sh_hypolat,
a.sh_hypodepth,
a.sh_rake
-- a.sh_rake,
-- b.geom
FROM dsra.dsra_all_scenarios_csduid_tbl_temp a
LEFT JOIN boundaries."Geometry_CSDUID" b ON a.csduid = b."CSDUID");

-- create index on master dsra csduid table
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_csduid_csduid_idx ON dsra.dsra_all_scenarios_csduid_tbl(csduid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_csduid_cduid_idx ON dsra.dsra_all_scenarios_csduid_tbl(cduid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_csduid_eruid_idx ON dsra.dsra_all_scenarios_csduid_tbl(eruid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_csduid_pruid_idx ON dsra.dsra_all_scenarios_csduid_tbl(pruid);
-- CREATE INDEX IF NOT EXISTS dsra_all_scenarios_csduid_geom_idx ON dsra.dsra_all_scenarios_csduid_tbl USING GIST(geom);




-- create master dsra csduid view
DROP VIEW IF EXISTS dsra.dsra_all_scenarios_csduid CASCADE;
CREATE VIEW dsra.dsra_all_scenarios_csduid AS 
SELECT * FROM dsra.dsra_all_scenarios_csduid_tbl ORDER BY csduid,sh_rupname;

DROP TABLE IF EXISTS dsra.dsra_all_scenarios_csduid_tbl_temp CASCADE;



-- create master dsra fsauid view
DROP TABLE IF EXISTS dsra.dsra_all_scenarios_fsauid_tbl_temp CASCADE;
CREATE TABLE dsra.dsra_all_scenarios_fsauid_tbl_temp AS
(
SELECT
a.fsauid,
a.pruid,
a.prname,
a.sh_rupname,
a.sh_mag,
a.sh_hypolon,
a.sh_hypolat,
a.sh_hypodepth,
a.sh_rake
FROM dsra.dsra_all_scenarios_tbl a
GROUP BY fsauid,pruid,prname,sh_rupname,sh_mag,sh_hypolon,sh_hypolat,sh_hypodepth,sh_rake);



DROP TABLE IF EXISTS dsra.dsra_all_scenarios_fsauid_tbl CASCADE;
CREATE TABLE dsra.dsra_all_scenarios_fsauid_tbl AS
(
SELECT
a.fsauid,
a.pruid,
a.prname,
a.sh_rupname,
a.sh_mag,
a.sh_hypolon,
a.sh_hypolat,
a.sh_hypodepth,
a.sh_rake
-- a.sh_rake,
-- b.geom
FROM dsra.dsra_all_scenarios_fsauid_tbl_temp a
LEFT JOIN boundaries."Geometry_FSAUID" b ON a.fsauid = b."CFSAUID");

-- create index on master dsra fsauid table
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_fsauid_fsauid_idx ON dsra.dsra_all_scenarios_fsauid_tbl(fsauid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_fsauid_pruid_idx ON dsra.dsra_all_scenarios_fsauid_tbl(pruid);
-- CREATE INDEX IF NOT EXISTS dsra_all_scenarios_fsauid_geom_idx ON dsra.dsra_all_scenarios_fsauid_tbl USING GIST(geom);




-- create master dsra fsauid view
DROP VIEW IF EXISTS dsra.dsra_all_scenarios_fsauid CASCADE;
CREATE VIEW dsra.dsra_all_scenarios_fsauid AS 
SELECT * FROM dsra.dsra_all_scenarios_fsauid_tbl ORDER BY fsauid,sh_rupname;

DROP TABLE IF EXISTS dsra.dsra_all_scenarios_fsauid_tbl_temp CASCADE;



-- create master dsra cduid view
DROP TABLE IF EXISTS dsra.dsra_all_scenarios_cduid_tbl_temp CASCADE;
CREATE TABLE dsra.dsra_all_scenarios_cduid_tbl_temp AS
(
SELECT
a.cduid,
a.cdname,
a.eruid,
a.ername,
a.pruid,
a.prname,
a.sh_rupname,
a.sh_mag,
a.sh_hypolon,
a.sh_hypolat,
a.sh_hypodepth,
a.sh_rake
FROM dsra.dsra_all_scenarios_tbl a
GROUP BY cduid,cdname,eruid,ername,pruid,prname,sh_rupname,sh_mag,sh_hypolon,sh_hypolat,sh_hypodepth,sh_rake);



DROP TABLE IF EXISTS dsra.dsra_all_scenarios_cduid_tbl CASCADE;
CREATE TABLE dsra.dsra_all_scenarios_cduid_tbl AS
(
SELECT
a.cduid,
a.cdname,
a.eruid,
a.ername,
a.pruid,
a.prname,
a.sh_rupname,
a.sh_mag,
a.sh_hypolon,
a.sh_hypolat,
a.sh_hypodepth,
a.sh_rake
-- a.sh_rake,
-- b.geom
FROM dsra.dsra_all_scenarios_cduid_tbl_temp a
LEFT JOIN boundaries."Geometry_CDUID" b ON a.cduid = b."CDUID");

-- create index on master dsra cduid table
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_cduid_cduid_idx ON dsra.dsra_all_scenarios_cduid_tbl(cduid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_cduid_eruid_idx ON dsra.dsra_all_scenarios_cduid_tbl(eruid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_cduid_pruid_idx ON dsra.dsra_all_scenarios_cduid_tbl(pruid);
-- CREATE INDEX IF NOT EXISTS dsra_all_scenarios_cduid_geom_idx ON dsra.dsra_all_scenarios_cduid_tbl USING GIST(geom);

-- create master dsra cduid view
DROP VIEW IF EXISTS dsra.dsra_all_scenarios_cduid CASCADE;
CREATE VIEW dsra.dsra_all_scenarios_cduid AS 
SELECT * FROM dsra.dsra_all_scenarios_cduid_tbl ORDER BY cduid,sh_rupname;

DROP TABLE IF EXISTS dsra.dsra_all_scenarios_cduid_tbl_temp CASCADE;



-- create master dsra eruid view
DROP TABLE IF EXISTS dsra.dsra_all_scenarios_eruid_tbl_temp CASCADE;
CREATE TABLE dsra.dsra_all_scenarios_eruid_tbl_temp AS
(
SELECT
a.eruid,
a.ername,
a.pruid,
a.prname,
a.sh_rupname,
a.sh_mag,
a.sh_hypolon,
a.sh_hypolat,
a.sh_hypodepth,
a.sh_rake
FROM dsra.dsra_all_scenarios_tbl a
GROUP BY eruid,ername,pruid,prname,sh_rupname,sh_mag,sh_hypolon,sh_hypolat,sh_hypodepth,sh_rake);



DROP TABLE IF EXISTS dsra.dsra_all_scenarios_eruid_tbl CASCADE;
CREATE TABLE dsra.dsra_all_scenarios_eruid_tbl AS
(
SELECT
a.eruid,
a.ername,
a.pruid,
a.prname,
a.sh_rupname,
a.sh_mag,
a.sh_hypolon,
a.sh_hypolat,
a.sh_hypodepth,
a.sh_rake
-- a.sh_rake,
-- b.geom
FROM dsra.dsra_all_scenarios_eruid_tbl_temp a
LEFT JOIN boundaries."Geometry_ERUID" b ON a.eruid = b."ERUID");

-- create index on master dsra eruid table
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_eruid_eruid_idx ON dsra.dsra_all_scenarios_eruid_tbl(eruid);
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_eruid_pruid_idx ON dsra.dsra_all_scenarios_eruid_tbl(pruid);
-- CREATE INDEX IF NOT EXISTS dsra_all_scenarios_eruid_geom_idx ON dsra.dsra_all_scenarios_eruid_tbl USING GIST(geom);

-- create master dsra eruid view
DROP VIEW IF EXISTS dsra.dsra_all_scenarios_eruid CASCADE;
CREATE VIEW dsra.dsra_all_scenarios_eruid AS 
SELECT * FROM dsra.dsra_all_scenarios_eruid_tbl ORDER BY eruid,sh_rupname;

DROP TABLE IF EXISTS dsra.dsra_all_scenarios_eruid_tbl_temp CASCADE;



-- create master dsra pruid view
DROP TABLE IF EXISTS dsra.dsra_all_scenarios_pruid_tbl_temp CASCADE;
CREATE TABLE dsra.dsra_all_scenarios_pruid_tbl_temp AS
(
SELECT
a.pruid,
a.prname,
a.sh_rupname,
a.sh_mag,
a.sh_hypolon,
a.sh_hypolat,
a.sh_hypodepth,
a.sh_rake
FROM dsra.dsra_all_scenarios_tbl a
GROUP BY pruid,prname,sh_rupname,sh_mag,sh_hypolon,sh_hypolat,sh_hypodepth,sh_rake);



DROP TABLE IF EXISTS dsra.dsra_all_scenarios_pruid_tbl CASCADE;
CREATE TABLE dsra.dsra_all_scenarios_pruid_tbl AS
(
SELECT
a.pruid,
a.prname,
a.sh_rupname,
a.sh_mag,
a.sh_hypolon,
a.sh_hypolat,
a.sh_hypodepth,
a.sh_rake
-- a.sh_rake,
-- b.geom
FROM dsra.dsra_all_scenarios_pruid_tbl_temp a
LEFT JOIN boundaries."Geometry_PRUID" b ON a.pruid = b."PRUID");

-- create index on master dsra pruid table
CREATE INDEX IF NOT EXISTS dsra_all_scenarios_pruid_pruid_idx ON dsra.dsra_all_scenarios_pruid_tbl(pruid);
-- CREATE INDEX IF NOT EXISTS dsra_all_scenarios_pruid_geom_idx ON dsra.dsra_all_scenarios_pruid_tbl USING GIST(geom);

-- create master dsra pruid view
DROP VIEW IF EXISTS dsra.dsra_all_scenarios_pruid CASCADE;
CREATE VIEW dsra.dsra_all_scenarios_pruid AS 
SELECT * FROM dsra.dsra_all_scenarios_pruid_tbl ORDER BY pruid,sh_rupname;

DROP TABLE IF EXISTS dsra.dsra_all_scenarios_pruid_tbl_temp CASCADE;