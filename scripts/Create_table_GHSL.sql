-- script to generate GHSL table

DROP TABLE IF EXISTS ghsl.ghsl_mh_intensity_ghsl CASCADE;

-- create table
CREATE TABLE ghsl.ghsl_mh_intensity_ghsl(
    ghslID varchar,
    lon float,
    lat float,
    ghsl_km2 float,
    ghsl_ha float,
    Pop_2015 float,
    Pop_2000 float,
    Pop_1990 float,
    Pop_1975 float,
    SMOD_2015 float,
    SMOD_2000 float,
    SMOD_1990 float,
    SMOD_1975 float,
    PGV float,
    PGA float,
    MMI7 float,
    Tsunami float,
    Fld500 float,
    Wildfire float,
    LndSus float,
    Cy500 float,
    CSDUID varchar,
    CSDNAME varchar,
    CSDTYPE varchar,
    PRUID varchar,
    PRNAME varchar,
    CDUID varchar,
    CDNAME varchar,
    CDTYPE varchar,
    CCSUID varchar,
    CCSNAME varchar,
    ERUID varchar,
    ERNAME varchar,
    SACCODE varchar,
    SACTYPE varchar,
    NEAR_FID varchar
);
