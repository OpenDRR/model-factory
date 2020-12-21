CREATE SCHEMA IF NOT EXISTS results_psra_bc;

DROP VIEW IF EXISTS results_psra_bc.psra_bc_hcurves_pga CASCADE;
CREATE VIEW results_psra_bc.psra_bc_hcurves_pga AS 
(
SELECT
lon,
lat,
depth,
"poe_0.0500000",
"poe_0.0637137",
"poe_0.0811888",
"poe_0.1034569",
"poe_0.1318325",
"poe_0.1679909",
"poe_0.2140666",
"poe_0.2727797",
"poe_0.3475964",
"poe_0.4429334",
"poe_0.5644189",
"poe_0.7192249",
"poe_0.9164904",
"poe_1.1678607",
"poe_1.4881757",
"poe_1.8963451",
"poe_2.4164651",
"poe_3.0792411",
"poe_3.9237999",
"poe_5.0000000"

FROM psra_bc.psra_bc_hcurves_pga);


DROP VIEW IF EXISTS results_psra_bc.psra_bc_hcurves_sa0p1 CASCADE;
CREATE VIEW results_psra_bc.psra_bc_hcurves_sa0p1 AS
(
SELECT
lon,
lat,
depth,
"poe_0.0500000",
"poe_0.0637137",
"poe_0.0811888",
"poe_0.1034569",
"poe_0.1318325",
"poe_0.1679909",
"poe_0.2140666",
"poe_0.2727797",
"poe_0.3475964",
"poe_0.4429334",
"poe_0.5644189",
"poe_0.7192249",
"poe_0.9164904",
"poe_1.1678607",
"poe_1.4881757",
"poe_1.8963451",
"poe_2.4164651",
"poe_3.0792411",
"poe_3.9237999",
"poe_5.0000000"

FROM psra_bc.psra_bc_hcurves_sa0p1);


DROP VIEW IF EXISTS results_psra_bc.psra_bc_hcurves_sa0p3 CASCADE;
CREATE VIEW results_psra_bc.psra_bc_hcurves_sa0p3 AS
(
SELECT
lon,
lat,
depth,
"poe_0.0500000",
"poe_0.0637137",
"poe_0.0811888",
"poe_0.1034569",
"poe_0.1318325",
"poe_0.1679909",
"poe_0.2140666",
"poe_0.2727797",
"poe_0.3475964",
"poe_0.4429334",
"poe_0.5644189",
"poe_0.7192249",
"poe_0.9164904",
"poe_1.1678607",
"poe_1.4881757",
"poe_1.8963451",
"poe_2.4164651",
"poe_3.0792411",
"poe_3.9237999",
"poe_5.0000000"

FROM psra_bc.psra_bc_hcurves_sa0p3);


DROP VIEW IF EXISTS results_psra_bc.psra_bc_hcurves_sa0p5 CASCADE;
CREATE VIEW results_psra_bc.psra_bc_hcurves_sa0p5 AS
(
SELECT
lon,
lat,
depth,
"poe-0.0500000",
"poe-0.0658662",
"poe-0.0867671",
"poe-0.1143003",
"poe-0.1505706",
"poe-0.1983502",
"poe-0.2612914",
"poe-0.3442054",
"poe-0.4534299",
"poe-0.5973140",
"poe-0.7868559",
"poe-1.0365439",
"poe-1.3654639",
"poe-1.7987580",
"poe-2.3695466",
"poe-3.1214600",
"poe-4.1119734",
"poe-5.4168002",
"poe-7.1356795",
"poe-9.4000000"

FROM psra_bc.psra_bc_hcurves_sa0p5);


DROP VIEW IF EXISTS results_psra_bc.psra_bc_hcurves_sa0p6 CASCADE;
CREATE VIEW results_psra_bc.psra_bc_hcurves_sa0p6 AS
(
SELECT
lon,
lat,
depth,
"poe-0.0500000",
"poe-0.0658662",
"poe-0.0867671",
"poe-0.1143003",
"poe-0.1505706",
"poe-0.1983502",
"poe-0.2612914",
"poe-0.3442054",
"poe-0.4534299",
"poe-0.5973140",
"poe-0.7868559",
"poe-1.0365439",
"poe-1.3654639",
"poe-1.7987580",
"poe-2.3695466",
"poe-3.1214600",
"poe-4.1119734",
"poe-5.4168002",
"poe-7.1356795",
"poe-9.4000000"

FROM psra_bc.psra_bc_hcurves_sa0p6);



DROP VIEW IF EXISTS results_psra_bc.psra_bc_hcurves_sa1p0 CASCADE;
CREATE VIEW results_psra_bc.psra_bc_hcurves_sa1p0 AS
(
SELECT
lon,
lat,
depth,
"poe_0.0500000",
"poe_0.0637137",
"poe_0.0811888",
"poe_0.1034569",
"poe_0.1318325",
"poe_0.1679909",
"poe_0.2140666",
"poe_0.2727797",
"poe_0.3475964",
"poe_0.4429334",
"poe_0.5644189",
"poe_0.7192249",
"poe_0.9164904",
"poe_1.1678607",
"poe_1.4881757",
"poe_1.8963451",
"poe_2.4164651",
"poe_3.0792411",
"poe_3.9237999",
"poe_5.0000000"

FROM psra_bc.psra_bc_hcurves_sa1p0);



DROP VIEW IF EXISTS results_psra_bc.psra_bc_hcurves_sa2p0 CASCADE;
CREATE VIEW results_psra_bc.psra_bc_hcurves_sa2p0 AS
(
SELECT
lon,
lat,
depth,
"poe_0.0500000",
"poe_0.0637137",
"poe_0.0811888",
"poe_0.1034569",
"poe_0.1318325",
"poe_0.1679909",
"poe_0.2140666",
"poe_0.2727797",
"poe_0.3475964",
"poe_0.4429334",
"poe_0.5644189",
"poe_0.7192249",
"poe_0.9164904",
"poe_1.1678607",
"poe_1.4881757",
"poe_1.8963451",
"poe_2.4164651",
"poe_3.0792411",
"poe_3.9237999",
"poe_5.0000000"

FROM psra_bc.psra_bc_hcurves_sa2p0);



DROP VIEW IF EXISTS results_psra_bc.psra_bc_hcurves_sa5p0 CASCADE;
CREATE VIEW results_psra_bc.psra_bc_hcurves_sa5p0 AS
(
SELECT
lon,
lat,
depth,
"poe_0.0500000",
"poe_0.0637137",
"poe_0.0811888",
"poe_0.1034569",
"poe_0.1318325",
"poe_0.1679909",
"poe_0.2140666",
"poe_0.2727797",
"poe_0.3475964",
"poe_0.4429334",
"poe_0.5644189",
"poe_0.7192249",
"poe_0.9164904",
"poe_1.1678607",
"poe_1.4881757",
"poe_1.8963451",
"poe_2.4164651",
"poe_3.0792411",
"poe_3.9237999",
"poe_5.0000000"

FROM psra_bc.psra_bc_hcurves_sa5p0);



DROP VIEW IF EXISTS results_psra_bc.psra_bc_hcurves_sa10p0 CASCADE;
CREATE VIEW results_psra_bc.psra_bc_hcurves_sa10p0 AS
(
SELECT
lon,
lat,
depth,
"poe_0.0500000",
"poe_0.0637137",
"poe_0.0811888",
"poe_0.1034569",
"poe_0.1318325",
"poe_0.1679909",
"poe_0.2140666",
"poe_0.2727797",
"poe_0.3475964",
"poe_0.4429334",
"poe_0.5644189",
"poe_0.7192249",
"poe_0.9164904",
"poe_1.1678607",
"poe_1.4881757",
"poe_1.8963451",
"poe_2.4164651",
"poe_3.0792411",
"poe_3.9237999",
"poe_5.0000000"

FROM psra_bc.psra_bc_hcurves_sa10p0);



DROP VIEW IF EXISTS results_psra_bc.psra_bc_hcurves_sa10p0 CASCADE;
CREATE VIEW results_psra_bc.psra_bc_hcurves_sa10p0 AS
(
SELECT
lon,
lat,
depth,
"poe_0.0500000",
"poe_0.0637137",
"poe_0.0811888",
"poe_0.1034569",
"poe_0.1318325",
"poe_0.1679909",
"poe_0.2140666",
"poe_0.2727797",
"poe_0.3475964",
"poe_0.4429334",
"poe_0.5644189",
"poe_0.7192249",
"poe_0.9164904",
"poe_1.1678607",
"poe_1.4881757",
"poe_1.8963451",
"poe_2.4164651",
"poe_3.0792411",
"poe_3.9237999",
"poe_5.0000000"

FROM psra_bc.psra_bc_hcurves_sa10p0);



DROP VIEW IF EXISTS results_psra_bc.psra_bc_hmaps CASCADE;
CREATE VIEW results_psra_bc.psra_bc_hmaps AS
(
SELECT
lon,
lat,
"PGA_0.02",
"PGA_0.1",
"SA(0.1)_0.02",
"SA(0.1)_0.1",
"SA(0.2)_0.02",
"SA(0.2)_0.1",
"SA(0.3)_0.02",
"SA(0.3)_0.1",
"SA(0.5)_0.02",
"SA(0.5)_0.1",
"SA(0.6)_0.02",
"SA(0.6)_0.1",
"SA(1.0)_0.02",
"SA(1.0)_0.1",
"SA(10.0)_0.02",
"SA(10.0)_0.1",
"SA(2.0)_0.02",
"SA(2.0)_0.1",
"SA(5.0)_0.02",
"SA(5.0)_0.1",
geom

FROM psra_bc.psra_bc_hmaps);



DROP VIEW IF EXISTS results_psra_bc.psra_bc_uhs CASCADE;
CREATE VIEW results_psra_bc.psra_bc_uhs AS
(
SELECT
lon,
lat,
"0.02_PGA",
"0.02_SA(0.1)",
"0.02_SA(0.2)",
"0.02_SA(0.3)",
"0.02_SA(0.5)",
"0.02_SA(0.6)",
"0.02_SA(1.0)",
"0.02_SA(10.0)",
"0.02_SA(2.0)",
"0.02_SA(5.0)",
"0.1_PGA",
"0.1_SA(0.1)",
"0.1_SA(0.2)",
"0.1_SA(0.3)",
"0.1_SA(0.5)",
"0.1_SA(0.6)",
"0.1_SA(1.0)",
"0.1_SA(10.0)",
"0.1_SA(2.0)",
"0.1_SA(5.0)"

FROM psra_bc.psra_bc_uhs);