-- script to add geometry point field

-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE boundaries."Geometry_SAUID" ADD COLUMN geompoint geometry(Point,4326);
UPDATE boundaries."Geometry_SAUID" SET geompoint = st_setsrid(st_makepoint("Lon","Lat"),4326);

/*  -- fix already corrected at source geopackage
-- fix error geometries in Geometry_SAUID
UPDATE boundaries."Geometry_SAUID"
SET geom = ST_MakeValid(geom);
*/

-- change new PK 
ALTER TABLE boundaries."Geometry_SAUID" DROP CONSTRAINT IF EXISTS "Geometry_SAUID_pkey";
ALTER TABLE boundaries."Geometry_SAUID" ADD PRIMARY KEY ("SAUIDt");



-- create index on geometries tables
CREATE INDEX IF NOT EXISTS geometry_aduid_pruid_idx ON boundaries."Geometry_ADAUID"("ADAUID");

CREATE INDEX IF NOT EXISTS geometry_canada_fid_idx ON boundaries."Geometry_ADAUID"("fid");

CREATE INDEX IF NOT EXISTS geometry_cduid_cduid_idx ON boundaries."Geometry_CDUID"("CDUID");

CREATE INDEX IF NOT EXISTS geometry_csduid_csduid_idx ON boundaries."Geometry_CSDUID"("CSDUID");

CREATE INDEX IF NOT EXISTS geometry_dauid_dauid_idx ON boundaries."Geometry_DAUID"("DAUID");

CREATE INDEX IF NOT EXISTS geometry_eruid_eruid_idx ON boundaries."Geometry_ERUID"("ERUID");

CREATE INDEX IF NOT EXISTS geometry_fsauid_fsauid_idx ON boundaries."Geometry_FSAUID"("CFSAUID");

CREATE INDEX IF NOT EXISTS geometry_pruid_pruid_idx ON boundaries."Geometry_PRUID"("PRUID");

CREATE INDEX IF NOT EXISTS geometry_sauid_sauid_idx ON boundaries."Geometry_SAUID"("SAUIDt");
CREATE INDEX IF NOT EXISTS geometry_sauid_dauid_idx ON boundaries."Geometry_SAUID"("DAUIDt");
CREATE INDEX IF NOT EXISTS geometry_sauid_cfsauid_idx ON boundaries."Geometry_SAUID"("CFSAUID");
CREATE INDEX IF NOT EXISTS geometry_sauid_csduid_idx ON boundaries."Geometry_SAUID"("CSDUID");
CREATE INDEX IF NOT EXISTS geometry_sauid_adauid_idx ON boundaries."Geometry_SAUID"("ADAUID");
CREATE INDEX IF NOT EXISTS geometry_sauid_cduid_idx ON boundaries."Geometry_SAUID"("CDUID");
CREATE INDEX IF NOT EXISTS geometry_sauid_eruid_idx ON boundaries."Geometry_SAUID"("ERUID");
CREATE INDEX IF NOT EXISTS geometry_sauid_pruid_idx ON boundaries."Geometry_SAUID"("PRUID");