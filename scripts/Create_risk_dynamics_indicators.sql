-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_nhsl_risk_dynamics;

-- create risk dynamic indicators
DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_population_growth CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_population_growth AS 

-- 1.2 Risk Dynamics
-- 1.2.1 Population Growth
SELECT
ghslid AS "ghslID",
pruid,
prname,
eruid,
ername,
cduid,
cdname,
csduid,
csdname,
lon AS "ghs_lon",
lat AS "ghs_lat",
ghsl_km2,
ghsl_ha,
pop_2015 AS "ghs_Pop2015",
pop_2000 AS "ghs_Pop2000",
pop_1990 AS "ghs_Pop1990",
pop_1975 AS "ghs_Pop1975",
geom AS "geom_point"

FROM ghsl.ghsl_mh_intensity_ghsl;



-- create risk dynamic indicators
DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_land_use_change CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_land_use_change AS 

-- 1.2 Risk Dynamics
-- 1.2.2 Land Use Change
SELECT
ghslid AS "ghslID",
pruid,
prname,
eruid,
ername,
cduid,
cdname,
csduid,
csdname,
SMOD_2015,
SMOD_2000,
SMOD_1990,
SMOD_1975,
geom AS "geom_point"

FROM ghsl.ghsl_mh_intensity_ghsl;



-- create risk dynamic indicators
DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_hazard_susceptibility CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_hazard_susceptibility AS 

-- 1.2 Risk Dynamics
-- 1.2.2 Land Use Change
-- 1.2.3 Hazard Susceptibility

SELECT
ghslid AS "ghslID",
pgv AS "ghs_PGV",
pga AS "ghs_PGA",
mmi7 AS "ghs_MMI7",
tsunami AS "ghs_Tsunami",
fld500 AS "ghs_Fld500",
wildfire AS "ghs_Wildfire",
lndsus AS "ghs_LndSus",
cy500 AS "ghs_Cy500",
csduid,
csdname,
csdtype,
pruid,
prname,
cduid,
cdname,
cdtype,
ccsuid,
ccsname,
eruid,
ername,
saccode AS "SACCODE",
sactype AS "SACTYPE",
geom AS "geom_point"

FROM ghsl.ghsl_mh_intensity_ghsl;