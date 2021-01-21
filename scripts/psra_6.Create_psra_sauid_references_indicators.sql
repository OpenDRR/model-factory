CREATE SCHEMA IF NOT EXISTS results_psra_{prov};


-- src loss values
DROP VIEW IF EXISTS results_psra_{prov}.psra_{prov}_src_loss CASCADE;
CREATE VIEW results_psra_{prov}.psra_{prov}_src_loss AS

SELECT 
source AS "src_zone",
trt AS "src_type",
region,
SUM(loss_value_b0)/(SELECT SUM(loss_value_b0) FROM psra_{prov}.psra_{prov}_src_loss ) AS "src_value_b0",
SUM(loss_value_r2)/(SELECT SUM(loss_value_r2) FROM psra_{prov}.psra_{prov}_src_loss ) AS "src_value_r2"
FROM psra_{prov}.psra_{prov}_src_loss
GROUP BY source,trt,region
ORDER BY source,trt,region ASC;



DROP VIEW IF EXISTS results_psra_{prov}.psra_{prov}_hcurves_pga,results_psra_{prov}.psra_{prov}_hcurves_sa0p1,results_psra_{prov}.psra_{prov}_hcurves_sa0p2,results_psra_{prov}.psra_{prov}_hcurves_sa0p3,results_psra_{prov}.psra_{prov}_hcurves_sa0p5,
results_psra_{prov}.psra_{prov}_hcurves_sa0p6,results_psra_{prov}.psra_{prov}_hcurves_sa1p0,results_psra_{prov}.psra_{prov}_hcurves_sa2p0,results_psra_{prov}.psra_{prov}_hmaps,results_psra_{prov}.psra_{prov}_uhs CASCADE;

CREATE VIEW results_psra_{prov}.psra_{prov}_hcurves_pga AS
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
FROM psra_{prov}.psra_{prov}_hcurves_pga
);



CREATE VIEW results_psra_{prov}.psra_{prov}_hcurves_sa0p1 AS
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
FROM psra_{prov}.psra_{prov}_hcurves_sa0p1
);



CREATE VIEW results_psra_{prov}.psra_{prov}_hcurves_sa0p2 AS
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
FROM psra_{prov}.psra_{prov}_hcurves_sa0p2
);



CREATE VIEW results_psra_{prov}.psra_{prov}_hcurves_sa0p3 AS
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
FROM psra_{prov}.psra_{prov}_hcurves_sa0p3
);



CREATE VIEW results_psra_{prov}.psra_{prov}_hcurves_sa0p5 AS
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
FROM psra_{prov}.psra_{prov}_hcurves_sa0p5
);



CREATE VIEW results_psra_{prov}.psra_{prov}_hcurves_sa0p6 AS
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
FROM psra_{prov}.psra_{prov}_hcurves_sa0p6
);



CREATE VIEW results_psra_{prov}.psra_{prov}_hcurves_sa1p0 AS
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
FROM psra_{prov}.psra_{prov}_hcurves_sa1p0
);



CREATE VIEW results_psra_{prov}.psra_{prov}_hcurves_sa2p0 AS
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
FROM psra_{prov}.psra_{prov}_hcurves_sa2p0
);



CREATE VIEW results_psra_{prov}.psra_{prov}_hmaps AS
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
FROM psra_{prov}.psra_{prov}_hmaps
);



CREATE VIEW results_psra_{prov}.psra_{prov}_uhs AS
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
"0.02_SA(10.0)"
"0.02_SA(2.0)",
"0.02_SA(5.0)"
"0.1_PGA",
"0.1_SA(0.1)",
"0.1_SA(0.2)",
"0.1_SA(0.3)",
"0.1_SA(0.5)",
"0.1_SA(0.6)",
"0.1_SA(1.0)",
"0.1_SA(10.0)"
"0.1_SA(2.0)",
"0.1_SA(5.0)"

FROM psra_{prov}.psra_{prov}_uhs
);