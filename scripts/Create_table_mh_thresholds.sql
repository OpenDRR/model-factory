-- create lookup table for multi hazard thresholds value to be used
DROP TABLE IF EXISTS mh.mh_thresholds CASCADE;

-- create table
CREATE TABLE mh.mh_thresholds(
    PRIMARY KEY(threat),
    threat varchar,
    htt_exposure float,
    hti_pgv500 float,
    hti_pga500 float,
    hti_tsun500 float,
    hti_fld500 float,
    hti_wildfire float,
    hti_lndsus float,
    hti_cy500 float
);

/*
-- import exposure from csv
COPY mh.mh_thresholds(threat,htt_exposure,hti_pgv500,hti_pga500,hti_tsun500,hti_fld500,hti_wildfire,hti_lndsus,hti_cy500)
    FROM 'D:\Workspace\data\source datasets\mh\hazard-threat_thresholds.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;
*/