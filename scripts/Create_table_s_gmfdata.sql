
DROP TABLE IF EXISTS gmf.{eqScenario};


-- create table
CREATE TABLE gmf.{eqScenario}(
    event_id varchar,
    site_id varchar,
    gmv_PGA float,
    gmv_PGV float,
    "gmv_SA(0.1)" float,
    "gmv_SA(0.2)" float,
    "gmv_SA(0.3)" float,
    "gmv_SA(0.6)" float,
    "gmv_SA(1.0)" float
    
);

-- import exposure from csv
COPY gmf.{eqScenario} (event_id, site_id, gmv_pga, gmv_pgv, "gmv_SA(0.1)", "gmv_SA(0.2)", "gmv_SA(0.3)", "gmv_SA(0.6)", "gmv_SA(1.0)")
    FROM '/usr/arc/app/s_gmfdata_{eqScenario}.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;


-- add missing columns that does not exist in source sample data but should be included in future datasets.
ALTER TABLE gmf.{eqScenario} ADD COLUMN IF NOT EXISTS "gmv_SA(2.0)" float DEFAULT 0;