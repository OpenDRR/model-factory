-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_nhsl_risk_dynamics;

-- create risk dynamic indicators
DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators AS 

-- 1.3 Risk Dynamics
-- 1.3.1 Population Growth
SELECT
ghslid AS "ghslID",
lon AS "ghs_lon",
lat AS "ghs_lat",
ghsl_km2,
ghsl_ha,
pop_2015 AS "ghs_Pop2015",
pop_2000 AS "ghs_Pop2000",
pop_1990 AS "ghs_Pop1990",
pop_1975 AS "ghs_Pop1975",

-- 1.3 Risk Dynamics
-- 1.3.2 Land Use Change
SMOD_2015 AS "ghs_LndUse2015",
SMOD_2000 AS "ghs_LndUse2000",
SMOD_1990 AS "ghs_LndUse1990",
SMOD_1975 AS "ghs_LndUse1975",


-- 1.2 Risk Dynamics
-- 1.2.2 Land Use Change
-- 1.2.3 Hazard Susceptibility
--pgv AS "ghs_PGV",
--pga AS "ghs_PGA",
--mmi7 AS "ghs_MMI7",
--tsunami AS "ghs_Tsunami",
--fld500 AS "ghs_Fld500",
--wildfire AS "ghs_Wildfire",
--lndsus AS "ghs_LndSus",
--cy500 AS "ghs_Cy500",
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
saccode,
sactype,

geom AS "geom_point"

FROM ghsl.ghsl_mh_intensity_ghsl;


--create views for province
DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_nl CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_nl AS 
SELECT * FROM results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators WHERE pruid ='10';

DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_pe CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_pe AS 
SELECT * FROM results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators WHERE pruid ='11';

DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_ns CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_ns AS 
SELECT * FROM results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators WHERE pruid ='12';

DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_nb CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_nb AS 
SELECT * FROM results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators WHERE pruid ='13';

DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_qc CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_qc AS 
SELECT * FROM results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators WHERE pruid ='24';

DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_on CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_on AS 
SELECT * FROM results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators WHERE pruid ='35';

DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_mb CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_mb AS 
SELECT * FROM results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators WHERE pruid ='46';

DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_sk CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_sk AS 
SELECT * FROM results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators WHERE pruid ='47';

DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_ab CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_ab AS 
SELECT * FROM results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators WHERE pruid ='48';

DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_bc CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_bc AS 
SELECT * FROM results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators WHERE pruid ='59';

DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_yt CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_yt AS 
SELECT * FROM results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators WHERE pruid ='60';

DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_nt CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_nt AS 
SELECT * FROM results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators WHERE pruid ='61';

DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_nu CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators_nu AS 
SELECT * FROM results_nhsl_risk_dynamics.nhsl_risk_dynamics_indicators WHERE pruid ='62';
