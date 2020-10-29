-- script to generate shakemap table
DROP TABLE IF EXISTS gmf.shakemap_{eqScenario};

-- create table
CREATE TABLE gmf.shakemap_{eqScenario}(
    site_id varchar,
    gmv_PGA float,
    "gmv_SA(0.1)" float,
    "gmv_SA(0.2)" float,
    "gmv_SA(0.3)" float,
    "gmv_SA(0.5)" float,
    "gmv_SA(0.6)" float,
    "gmv_SA(1.0)" float,
    "gmv_SA(2.0)" float,
    lon float,
    lat float
    
);

-- import exposure from csv
COPY gmf.shakemap_acm7p2_lrdmf (site_id,gmv_PGA,"gmv_SA(0.1)","gmv_SA(0.2)","gmv_SA(0.3)","gmv_SA(0.5)","gmv_SA(0.6)","gmv_SA(1.0)","gmv_SA(2.0)",lon,lat)
    FROM '/usr/src/app/s_shakemap_{eqScenario}_234.txt'
    --FROM '/usr/src/app/s_shakemap_ACM7p2_LRDMF_234.txt'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;

-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE gmf.shakemap_acm7p2_lrdmf ADD COLUMN geom geometry(Point,4326);
UPDATE gmf.shakemap_acm7p2_lrdmf SET geom = st_setsrid(st_makepoint(lon,lat),4326);

-- create spatial index
CREATE INDEX shakemap_acm7p2_lrdmf_idx
ON gmf.shakemap_acm7p2_lrdmf using GIST (geom);