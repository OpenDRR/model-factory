-- script to add geometry point field

-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE boundaries."Geometry_SAUID" ADD COLUMN geompoint geometry(Point,4326);
UPDATE boundaries."Geometry_SAUID" SET geompoint = st_setsrid(st_makepoint("Lon","Lat"),4326);

-- fix error geometries
UPDATE boundaries."Geometry_SAUID"
SET geom = ST_MakeValid(geom);