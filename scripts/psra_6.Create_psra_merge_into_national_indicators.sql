CREATE SCHEMA IF NOT EXISTS results_psra_national;

-- combine psra building indicators into national level
DROP TABLE IF EXISTS results_psra_national.psra_indicators_b_tbl CASCADE;

CREATE TABLE results_psra_national.psra_indicators_b_tbl AS 
SELECT * FROM results_psra_ab.psra_ab_indicators_b
UNION
SELECT * FROM results_psra_mb.psra_mb_indicators_b
UNION
SELECT * FROM results_psra_nb.psra_nb_indicators_b
UNION
SELECT * FROM results_psra_nl.psra_nl_indicators_b
UNION
SELECT * FROM results_psra_ns.psra_ns_indicators_b
UNION
SELECT * FROM results_psra_nt.psra_nt_indicators_b
UNION
SELECT * FROM results_psra_nu.psra_nu_indicators_b
UNION
SELECT * FROM results_psra_on.psra_on_indicators_b;

-- CREATE TABLE results_psra_national.psra_indicators_b_tbl AS 
-- SELECT * FROM results_psra_ab.psra_ab_indicators_b
-- UNION
-- SELECT * FROM results_psra_bc.psra_bc_indicators_b
-- UNION
-- SELECT * FROM results_psra_mb.psra_mb_indicators_b
-- UNION
-- SELECT * FROM results_psra_nb.psra_nb_indicators_b
-- UNION
-- SELECT * FROM results_psra_nl.psra_nl_indicators_b
-- UNION
-- SELECT * FROM results_psra_ns.psra_ns_indicators_b
-- UNION
-- SELECT * FROM results_psra_nt.psra_nt_indicators_b
-- UNION
-- SELECT * FROM results_psra_nu.psra_nu_indicators_b
-- UNION
-- SELECT * FROM results_psra_on.psra_on_indicators_b
-- UNION
-- SELECT * FROM results_psra_pe.psra_pe_indicators_b
-- UNION
-- SELECT * FROM results_psra_qc.psra_qc_indicators_b
-- UNION
-- SELECT * FROM results_psra_sk.psra_sk_indicators_b
-- UNION
-- SELECT * FROM results_psra_yt.psra_yt_indicators_b;

-- create index
CREATE INDEX psra_indicators_b_tbl_idx ON results_psra_national.psra_indicators_b_tbl("AssetID");
CREATE INDEX psra_indicators_b_tbl_sauid_idx ON results_psra_national.psra_indicators_b_tbl("Sauid");
CREATE INDEX psra_indicators_b_tbl_pruid_idx ON results_psra_national.psra_indicators_b_tbl(pruid);
CREATE INDEX psra_indicators_b_tbl_prname_idx ON results_psra_national.psra_indicators_b_tbl(prname);
CREATE INDEX psra_indicators_b_tbl_eruid_idx ON results_psra_national.psra_indicators_b_tbl(eruid);
CREATE INDEX psra_indicators_b_tbl_cduid_idx ON results_psra_national.psra_indicators_b_tbl(cdname);
CREATE INDEX psra_indicators_b_tbl_cdname_idx ON results_psra_national.psra_indicators_b_tbl(cdname);
CREATE INDEX psra_indicators_b_tbl_csduid_idx ON results_psra_national.psra_indicators_b_tbl(csduid);
CREATE INDEX psra_indicators_b_tbl_csdname_idx ON results_psra_national.psra_indicators_b_tbl(csdname);
CREATE INDEX psra_indicators_b_tbl_fsauid_idx ON results_psra_national.psra_indicators_b_tbl(fsauid);
CREATE INDEX psra_indicators_b_tbl_dauid_idx ON results_psra_national.psra_indicators_b_tbl(dauid);
CREATE INDEX psra_indicators_b_tbl_geom_idx ON results_psra_national.psra_indicators_b_tbl USING GIST(geom_point);

-- add pk
ALTER TABLE results_psra_national.psra_indicators_b_tbl ADD PRIMARY KEY("AssetID");

-- create psra building national view
DROP VIEW IF EXISTS results_psra_national.psra_indicators_b CASCADE;
CREATE VIEW results_psra_national.psra_indicators_b AS SELECT * FROM results_psra_national.psra_indicators_b_tbl;



-- combine psra sauid indicators into national level
DROP TABLE IF EXISTS results_psra_national.psra_indicators_s_tbl CASCADE;

CREATE TABLE results_psra_national.psra_indicators_s_tbl AS 
SELECT * FROM results_psra_ab.psra_ab_indicators_s
UNION
SELECT * FROM results_psra_mb.psra_mb_indicators_s
UNION
SELECT * FROM results_psra_nb.psra_nb_indicators_s
UNION
SELECT * FROM results_psra_nl.psra_nl_indicators_s
UNION
SELECT * FROM results_psra_ns.psra_ns_indicators_s
UNION
SELECT * FROM results_psra_nt.psra_nt_indicators_s
UNION
SELECT * FROM results_psra_nu.psra_nu_indicators_s
UNION
SELECT * FROM results_psra_on.psra_on_indicators_s;

-- CREATE TABLE results_psra_national.psra_indicators_s_tbl AS 
-- SELECT * FROM results_psra_ab.psra_ab_indicators_s
-- UNION
-- SELECT * FROM results_psra_bc.psra_bc_indicators_s
-- UNION
-- SELECT * FROM results_psra_mb.psra_mb_indicators_s
-- UNION
-- SELECT * FROM results_psra_nb.psra_nb_indicators_s
-- UNION
-- SELECT * FROM results_psra_nl.psra_nl_indicators_s
-- UNION
-- SELECT * FROM results_psra_ns.psra_ns_indicators_s
-- UNION
-- SELECT * FROM results_psra_nt.psra_nt_indicators_s
-- UNION
-- SELECT * FROM results_psra_nu.psra_nu_indicators_s
-- UNION
-- SELECT * FROM results_psra_on.psra_on_indicators_s
-- UNION
-- SELECT * FROM results_psra_pe.psra_pe_indicators_s
-- UNION
-- SELECT * FROM results_psra_qc.psra_qc_indicators_s
-- UNION
-- SELECT * FROM results_psra_sk.psra_sk_indicators_s
-- UNION
-- SELECT * FROM results_psra_yt.psra_yt_indicators_s;

-- create index
CREATE INDEX psra_indicators_s_tbl_sauid_idx ON results_psra_national.psra_indicators_s_tbl("Sauid");
CREATE INDEX psra_indicators_s_tbl_pruid_idx ON results_psra_national.psra_indicators_s_tbl(pruid);
CREATE INDEX psra_indicators_s_tbl_prname_idx ON results_psra_national.psra_indicators_s_tbl(prname);
CREATE INDEX psra_indicators_s_tbl_eruid_idx ON results_psra_national.psra_indicators_s_tbl(eruid);
CREATE INDEX psra_indicators_s_tbl_cduid_idx ON results_psra_national.psra_indicators_s_tbl(cdname);
CREATE INDEX psra_indicators_s_tbl_cdname_idx ON results_psra_national.psra_indicators_s_tbl(cdname);
CREATE INDEX psra_indicators_s_tbl_csduid_idx ON results_psra_national.psra_indicators_s_tbl(csduid);
CREATE INDEX psra_indicators_s_tbl_csdname_idx ON results_psra_national.psra_indicators_s_tbl(csdname);
CREATE INDEX psra_indicators_s_tbl_fsauid_idx ON results_psra_national.psra_indicators_s_tbl(fsauid);
CREATE INDEX psra_indicators_s_tbl_dauid_idx ON results_psra_national.psra_indicators_s_tbl(dauid);
CREATE INDEX psra_indicators_s_tbl_geom_idx ON results_psra_national.psra_indicators_s_tbl USING GIST(geom_poly);

-- add pk
ALTER TABLE results_psra_national.psra_indicators_s_tbl ADD PRIMARY KEY("Sauid");

-- create psra sauid national view
DROP VIEW IF EXISTS results_psra_national.psra_indicators_s CASCADE;
CREATE VIEW results_psra_national.psra_indicators_s AS SELECT * FROM results_psra_national.psra_indicators_s_tbl;



-- combine eqriskindex sauid tables into national level
DROP TABLE IF EXISTS results_psra_national.psra_eqriskindex CASCADE;

CREATE TABLE results_psra_national.psra_eqriskindex AS 
SELECT * FROM results_psra_ab.psra_ab_eqriskindex
UNION
SELECT * FROM results_psra_mb.psra_mb_eqriskindex
UNION
SELECT * FROM results_psra_nb.psra_nb_eqriskindex
UNION
SELECT * FROM results_psra_nl.psra_nl_eqriskindex
UNION
SELECT * FROM results_psra_ns.psra_ns_eqriskindex
UNION
SELECT * FROM results_psra_nt.psra_nt_eqriskindex
UNION
SELECT * FROM results_psra_nu.psra_nu_eqriskindex
UNION
SELECT * FROM results_psra_on.psra_on_eqriskindex;

-- UNION
-- SELECT * FROM results_psra_bc.psra_bc_eqriskindex
-- UNION
-- SELECT * FROM results_psra_mb.psra_mb_eqriskindex
-- UNION
-- SELECT * FROM results_psra_nb.psra_nb_eqriskindex
-- UNION
-- SELECT * FROM results_psra_nl.psra_nl_eqriskindex
-- UNION
-- SELECT * FROM results_psra_ns.psra_ns_eqriskindex
-- UNION
-- SELECT * FROM results_psra_nt.psra_nt_eqriskindex
-- UNION
-- SELECT * FROM results_psra_nu.psra_nu_eqriskindex
-- UNION
-- SELECT * FROM results_psra_on.psra_on_eqriskindex
-- UNION
-- SELECT * FROM results_psra_pe.psra_pe_eqriskindex
-- UNION
-- SELECT * FROM results_psra_qc.psra_qc_eqriskindex
-- UNION
-- SELECT * FROM results_psra_sk.psra_sk_eqriskindex
-- UNION
-- SELECT * FROM results_psra_yt.psra_yt_eqriskindex;


--create national threshold sauid lookup table for rating
DROP TABLE IF EXISTS results_psra_national.psra_eqri_thresholds CASCADE;
CREATE TABLE results_psra_national.psra_eqri_thresholds
(
percentile NUMERIC,
abs_score_threshold_b0 FLOAT DEFAULT 0,
abs_score_threshold_r1 FLOAT DEFAULT 0, 
rel_score_threshold_b0 FLOAT DEFAULT 0,
rel_score_threshold_r1 FLOAT DEFAULT 0,
rating VARCHAR
);


INSERT INTO results_psra_national.psra_eqri_thresholds (percentile,rating) VALUES
(0,'Very Low'),
(0.35,'Relatively Low'),
(0.60,'Relatively Moderate'),
(0.80,'Relatively High'),
(0.95,'Very High');


--update values with calculated percentiles
--0.35 percentile
UPDATE results_psra_national.psra_eqri_thresholds 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.35) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.35) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex),
	rel_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.35) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_national.psra_eqriskindex),
	rel_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.35) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_national.psra_eqriskindex) WHERE percentile = 0.35;

-- 0.60 percentile
UPDATE results_psra_national.psra_eqri_thresholds 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.60) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.60) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex),
	rel_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.60) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_national.psra_eqriskindex),
	rel_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.60) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_national.psra_eqriskindex) WHERE percentile = 0.60;
	
-- 0.80 percentile
UPDATE results_psra_national.psra_eqri_thresholds 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex),
	rel_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_national.psra_eqriskindex),
	rel_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_national.psra_eqriskindex) WHERE percentile = 0.80;
	
-- 0.95 percentile
UPDATE results_psra_national.psra_eqri_thresholds 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex),
	rel_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_national.psra_eqriskindex),
	rel_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_national.psra_eqriskindex) WHERE percentile = 0.95;


-- update percentilerank value for national sauid 
UPDATE results_psra_national.psra_eqriskindex
SET eqri_abs_percentilerank_b0 =
	CASE 
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.35) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.60) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.35)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.80) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.6)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.8)
		WHEN eqri_abs_score_b0 > (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95)
		ELSE 0 END,
	eqri_abs_percentilerank_r1 =
	CASE 
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.35) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.60) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.35)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.80) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.6)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.8)
		WHEN eqri_abs_score_r1 > (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95)
		ELSE 0 END,
	eqri_rel_percentilerank_b0 =
	CASE 
		WHEN eqri_rel_score_b0 < (SELECT rel_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.35) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0)
		WHEN eqri_rel_score_b0 < (SELECT rel_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.60) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.35)
		WHEN eqri_rel_score_b0 < (SELECT rel_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.80) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.6)
		WHEN eqri_rel_score_b0 < (SELECT rel_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.8)
		WHEN eqri_rel_score_b0 > (SELECT rel_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95)
		ELSE 0 END,
	eqri_rel_percentilerank_r1 =
	CASE 
		WHEN eqri_rel_score_r1 < (SELECT rel_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.35) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0)
		WHEN eqri_rel_score_r1 < (SELECT rel_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.60) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.35)
		WHEN eqri_rel_score_r1 < (SELECT rel_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.80) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.6)
		WHEN eqri_rel_score_r1 < (SELECT rel_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.8)
		WHEN eqri_rel_score_r1 > (SELECT rel_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95)
		ELSE 0 END;


-- update percentilerank on national sauid table
UPDATE results_psra_national.psra_indicators_s_tbl b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b."Sauid";


-- update percentilerank on P/T eqriskindex sauid table
UPDATE results_psra_ab.psra_ab_eqriskindex b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_mb.psra_mb_eqriskindex b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_nb.psra_nb_eqriskindex b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_nl.psra_nl_eqriskindex b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_ns.psra_ns_eqriskindex b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_nt.psra_nt_eqriskindex b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_nu.psra_nu_eqriskindex b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_on.psra_on_eqriskindex b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;


/*
UPDATE results_psra_bc.psra_bc_eqriskindex b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_pe.psra_pe_eqriskindex b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_qc.psra_qc_eqriskindex b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_sk.psra_sk_eqriskindex b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_yt.psra_yt_eqriskindex b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;
*/


-- combine psra csd indicators into national level
DROP TABLE IF EXISTS results_psra_national.psra_indicators_csd_tbl CASCADE;

CREATE TABLE results_psra_national.psra_indicators_csd_tbl AS 
SELECT * FROM results_psra_ab.psra_ab_indicators_csd
UNION
SELECT * FROM results_psra_mb.psra_mb_indicators_csd
UNION
SELECT * FROM results_psra_nb.psra_nb_indicators_csd
UNION
SELECT * FROM results_psra_nl.psra_nl_indicators_csd
UNION
SELECT * FROM results_psra_ns.psra_ns_indicators_csd
UNION
SELECT * FROM results_psra_nt.psra_nt_indicators_csd
UNION
SELECT * FROM results_psra_nu.psra_nu_indicators_csd
UNION
SELECT * FROM results_psra_on.psra_on_indicators_csd;

-- CREATE TABLE results_psra_national.psra_indicators_csd_tbl AS 
-- SELECT * FROM results_psra_ab.psra_ab_indicators_csd
-- UNION
-- SELECT * FROM results_psra_bc.psra_bc_indicators_csd
-- UNION
-- SELECT * FROM results_psra_mb.psra_mb_indicators_csd
-- UNION
-- SELECT * FROM results_psra_nb.psra_nb_indicators_csd
-- UNION
-- SELECT * FROM results_psra_nl.psra_nl_indicators_csd
-- UNION
-- SELECT * FROM results_psra_ns.psra_ns_indicators_csd
-- UNION
-- SELECT * FROM results_psra_nt.psra_nt_indicators_csd
-- UNION
-- SELECT * FROM results_psra_nu.psra_nu_indicators_csd
-- UNION
-- SELECT * FROM results_psra_on.psra_on_indicators_csd
-- UNION
-- SELECT * FROM results_psra_pe.psra_pe_indicators_csd
-- UNION
-- SELECT * FROM results_psra_qc.psra_qc_indicators_csd
-- UNION
-- SELECT * FROM results_psra_sk.psra_sk_indicators_csd
-- UNION
-- SELECT * FROM results_psra_yt.psra_yt_indicators_csd;

-- create index
CREATE INDEX psra_indicators_csd_tbl_csduid_idx ON results_psra_national.psra_indicators_csd_tbl(csduid);
CREATE INDEX psra_indicators_csd_tbl_csdname_idx ON results_psra_national.psra_indicators_csd_tbl(csdname);
CREATE INDEX psra_indicators_csd_tbl_geom_idx ON results_psra_national.psra_indicators_csd_tbl USING GIST(geom);

-- add pk
ALTER TABLE results_psra_national.psra_indicators_csd_tbl ADD PRIMARY KEY(csduid);

-- create psra sauid national view
DROP VIEW IF EXISTS results_psra_national.psra_indicators_csd CASCADE;
CREATE VIEW results_psra_national.psra_indicators_csd AS SELECT * FROM results_psra_national.psra_indicators_csd_tbl;



-- combine eqriskindex csd tables into national level
DROP TABLE IF EXISTS results_psra_national.psra_eqriskindex_csd CASCADE;

CREATE TABLE results_psra_national.psra_eqriskindex_csd AS 
SELECT * FROM results_psra_ab.psra_ab_eqriskindex_csd
UNION
SELECT * FROM results_psra_mb.psra_mb_eqriskindex_csd
UNION
SELECT * FROM results_psra_nb.psra_nb_eqriskindex_csd
UNION
SELECT * FROM results_psra_nl.psra_nl_eqriskindex_csd
UNION
SELECT * FROM results_psra_ns.psra_ns_eqriskindex_csd
UNION
SELECT * FROM results_psra_nt.psra_nt_eqriskindex_csd
UNION
SELECT * FROM results_psra_nu.psra_nu_eqriskindex_csd
UNION
SELECT * FROM results_psra_on.psra_on_eqriskindex_csd;


-- UNION
-- SELECT * FROM results_psra_bc.psra_bc_eqriskindex_csd
-- UNION
-- SELECT * FROM results_psra_mb.psra_mb_eqriskindex_csd
-- UNION
-- SELECT * FROM results_psra_nb.psra_nb_eqriskindex_csd
-- UNION
-- SELECT * FROM results_psra_nl.psra_nl_eqriskindex_csd
-- UNION
-- SELECT * FROM results_psra_ns.psra_ns_eqriskindex_csd
-- UNION
-- SELECT * FROM results_psra_nt.psra_nt_eqriskindex_csd
-- UNION
-- SELECT * FROM results_psra_nu.psra_nu_eqriskindex_csd
-- UNION
-- SELECT * FROM results_psra_on.psra_on_eqriskindex_csd
-- UNION
-- SELECT * FROM results_psra_pe.psra_pe_eqriskindex_csd
-- UNION
-- SELECT * FROM results_psra_qc.psra_qc_eqriskindex_csd
-- UNION
-- SELECT * FROM results_psra_sk.psra_sk_eqriskindex_csd
-- UNION
-- SELECT * FROM results_psra_yt.psra_yt_eqriskindex_csd;


--create national threshold csd lookup table for rating
DROP TABLE IF EXISTS results_psra_national.psra_eqri_thresholds_csd CASCADE;
CREATE TABLE results_psra_national.psra_eqri_thresholds_csd
(
percentile NUMERIC,
abs_score_threshold_b0 FLOAT DEFAULT 0,
abs_score_threshold_r1 FLOAT DEFAULT 0,
rel_score_threshold_b0 FLOAT DEFAULT 0,
rel_score_threshold_r1 FLOAT DEFAULT 0,
rating VARCHAR
);


INSERT INTO results_psra_national.psra_eqri_thresholds_csd (percentile,rating) VALUES
(0,'Very Low'),
(0.35,'Relatively Low'),
(0.60,'Relatively Moderate'),
(0.80,'Relatively High'),
(0.95,'Very High');


--update values with calculated percentiles
--0.35 percentile
UPDATE results_psra_national.psra_eqri_thresholds_csd 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.35) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_csd),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.35) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_csd),
	rel_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.35) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_national.psra_eqriskindex_csd),
	rel_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.35) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_national.psra_eqriskindex_csd) WHERE percentile = 0.35;

-- 0.60 percentile
UPDATE results_psra_national.psra_eqri_thresholds_csd 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.60) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_csd),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.60) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_csd),
	rel_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.60) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_national.psra_eqriskindex_csd),
	rel_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.60) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_national.psra_eqriskindex_csd) WHERE percentile = 0.60;
	
-- 0.80 percentile
UPDATE results_psra_national.psra_eqri_thresholds_csd 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_csd),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_csd),
	rel_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_national.psra_eqriskindex_csd),
	rel_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_national.psra_eqriskindex_csd) WHERE percentile = 0.80;
	
-- 0.95 percentile
UPDATE results_psra_national.psra_eqri_thresholds_csd 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_csd),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_csd),
	rel_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_national.psra_eqriskindex_csd),
	rel_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_rel_score_b0) FROM results_psra_national.psra_eqriskindex_csd) WHERE percentile = 0.95;


-- update percentilerank value for national sauid 
UPDATE results_psra_national.psra_eqriskindex_csd
SET eqri_abs_percentilerank_b0 =
	CASE 
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.35) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.60) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.35)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.80) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.6)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.8)
		WHEN eqri_abs_score_b0 > (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95)
		ELSE 0 END,
	eqri_abs_percentilerank_r1 =
	CASE 
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.35) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.60) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.35)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.80) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.6)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.8)
		WHEN eqri_abs_score_r1 > (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95)
		ELSE 0 END,
	eqri_rel_percentilerank_b0 =
	CASE 
		WHEN eqri_rel_score_b0 < (SELECT rel_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.35) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0)
		WHEN eqri_rel_score_b0 < (SELECT rel_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.60) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.35)
		WHEN eqri_rel_score_b0 < (SELECT rel_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.80) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.6)
		WHEN eqri_rel_score_b0 < (SELECT rel_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.8)
		WHEN eqri_rel_score_b0 > (SELECT rel_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95)
		ELSE 0 END,
	eqri_rel_percentilerank_r1 =
	CASE 
		WHEN eqri_rel_score_r1 < (SELECT rel_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.35) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0)
		WHEN eqri_rel_score_r1 < (SELECT rel_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.60) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.35)
		WHEN eqri_rel_score_r1 < (SELECT rel_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.80) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.6)
		WHEN eqri_rel_score_r1 < (SELECT rel_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.8)
		WHEN eqri_rel_score_r1 > (SELECT rel_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95) THEN (SELECT percentile FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95)
		ELSE 0 END;


-- update percentilerank on national csd table
UPDATE results_psra_national.psra_indicators_csd_tbl b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;


-- update percentilerank on P/T eqriskindex csd table
UPDATE results_psra_ab.psra_ab_eqriskindex_csd b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_mb.psra_mb_eqriskindex_csd b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_nb.psra_nb_eqriskindex_csd b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_nl.psra_nl_eqriskindex_csd b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_ns.psra_ns_eqriskindex_csd b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_nt.psra_nt_eqriskindex_csd b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_nu.psra_nu_eqriskindex_csd b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_on.psra_on_eqriskindex_csd b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

/*
UPDATE results_psra_bc.psra_bc_eqriskindex_csd b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_pe.psra_pe_eqriskindex_csd b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_qc.psra_qc_eqriskindex_csd b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_sk.psra_sk_eqriskindex_csd b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_yt.psra_yt_eqriskindex_csd b
SET eqri_abs_percentilerank_b0 = a.eqri_abs_percentilerank_b0,
	eqri_rel_percentilerank_b0 = a.eqri_rel_percentilerank_b0,
	eqri_abs_percentilerank_r1 = a.eqri_abs_percentilerank_r1,
	eqri_rel_percentilerank_r1 = a.eqri_rel_percentilerank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;
*/


-- combine psra expected loss indicators into national level
DROP TABLE IF EXISTS results_psra_national.psra_expected_loss_fsa_tbl CASCADE;

CREATE TABLE results_psra_national.psra_expected_loss_fsa_tbl AS 
SELECT * FROM results_psra_ab.psra_ab_expected_loss_fsa
UNION
SELECT * FROM results_psra_mb.psra_mb_expected_loss_fsa
UNION
SELECT * FROM results_psra_nb.psra_nb_expected_loss_fsa
UNION
SELECT * FROM results_psra_nl.psra_nl_expected_loss_fsa
UNION
SELECT * FROM results_psra_ns.psra_ns_expected_loss_fsa
UNION
SELECT * FROM results_psra_nt.psra_nt_expected_loss_fsa
UNION
SELECT * FROM results_psra_nu.psra_nu_expected_loss_fsa
UNION
SELECT * FROM results_psra_on.psra_on_expected_loss_fsa
;

-- CREATE TABLE results_psra_national.psra_expected_loss_fsa_tbl AS 
-- SELECT * FROM results_psra_ab.psra_ab_expected_loss_fsa
-- UNION
-- SELECT * FROM results_psra_bc.psra_bc_expected_loss_fsa
-- UNION
-- SELECT * FROM results_psra_mb.psra_mb_expected_loss_fsa
-- UNION
-- SELECT * FROM results_psra_nb.psra_nb_expected_loss_fsa
-- UNION
-- SELECT * FROM results_psra_nl.psra_nl_expected_loss_fsa
-- UNION
-- SELECT * FROM results_psra_ns.psra_ns_expected_loss_fsa
-- UNION
-- SELECT * FROM results_psra_nt.psra_nt_expected_loss_fsa
-- UNION
-- SELECT * FROM results_psra_nu.psra_nu_expected_loss_fsa
-- UNION
-- SELECT * FROM results_psra_on.psra_on_expected_loss_fsa
-- UNION
-- SELECT * FROM results_psra_pe.psra_pe_expected_loss_fsa
-- UNION
-- SELECT * FROM results_psra_qc.psra_qc_expected_loss_fsa
-- UNION
-- SELECT * FROM results_psra_sk.psra_sk_expected_loss_fsa
-- UNION
-- SELECT * FROM results_psra_yt.psra_yt_expected_loss_fsa;

-- add fid column
ALTER TABLE results_psra_national.psra_expected_loss_fsa_tbl ADD COLUMN fid SERIAL;

-- create index
CREATE INDEX psra_expected_loss_fsa_tbl_fsauid_idx ON results_psra_national.psra_expected_loss_fsa_tbl("eEL_FSAUID");
CREATE INDEX psra_expected_loss_fsa_tbl_fid_idx ON results_psra_national.psra_expected_loss_fsa_tbl("fid");


-- create psra pml national view
DROP VIEW IF EXISTS results_psra_national.psra_expected_loss_fsa CASCADE;
CREATE VIEW results_psra_national.psra_expected_loss_fsa AS SELECT * FROM results_psra_national.psra_expected_loss_fsa_tbl;



-- combine psra agg loss indicators into national level
DROP TABLE IF EXISTS results_psra_national.psra_agg_loss_fsa_tbl CASCADE;

CREATE TABLE results_psra_national.psra_agg_loss_fsa_tbl AS 
SELECT * FROM results_psra_ab.psra_ab_agg_loss_fsa
UNION
SELECT * FROM results_psra_mb.psra_mb_agg_loss_fsa
UNION
SELECT * FROM results_psra_nb.psra_nb_agg_loss_fsa
UNION
SELECT * FROM results_psra_nl.psra_nl_agg_loss_fsa
UNION
SELECT * FROM results_psra_ns.psra_ns_agg_loss_fsa
UNION
SELECT * FROM results_psra_nt.psra_nt_agg_loss_fsa
UNION
SELECT * FROM results_psra_nu.psra_nu_agg_loss_fsa
UNION
SELECT * FROM results_psra_on.psra_on_agg_loss_fsa;

-- CREATE TABLE results_psra_national.psra_agg_loss_fsa_tbl AS 
-- SELECT * FROM results_psra_ab.psra_ab_agg_loss_fsa
-- UNION
-- SELECT * FROM results_psra_bc.psra_bc_agg_loss_fsa
-- UNION
-- SELECT * FROM results_psra_mb.psra_mb_agg_loss_fsa
-- UNION
-- SELECT * FROM results_psra_nb.psra_nb_agg_loss_fsa
-- UNION
-- SELECT * FROM results_psra_nl.psra_nl_agg_loss_fsa
-- UNION
-- SELECT * FROM results_psra_ns.psra_ns_agg_loss_fsa
-- UNION
-- SELECT * FROM results_psra_nt.psra_nt_agg_loss_fsa
-- UNION
-- SELECT * FROM results_psra_nu.psra_nu_agg_loss_fsa
-- UNION
-- SELECT * FROM results_psra_on.psra_on_agg_loss_fsa
-- UNION
-- SELECT * FROM results_psra_pe.psra_pe_agg_loss_fsa
-- UNION
-- SELECT * FROM results_psra_qc.psra_qc_agg_loss_fsa
-- UNION
-- SELECT * FROM results_psra_sk.psra_sk_agg_loss_fsa
-- UNION
-- SELECT * FROM results_psra_yt.psra_yt_agg_loss_fsa;

-- add fid column
ALTER TABLE results_psra_national.psra_agg_loss_fsa_tbl ADD COLUMN fid SERIAL;

-- create index
CREATE INDEX psra_agg_loss_fsa_tbl_fsauid_idx ON results_psra_national.psra_agg_loss_fsa_tbl("e_FSAUID");
CREATE INDEX psra_agg_loss_fsa_tbl_fid_idx ON results_psra_national.psra_agg_loss_fsa_tbl("fid");

-- create psra pml national view
DROP VIEW IF EXISTS results_psra_national.psra_agg_loss_fsa CASCADE;
CREATE VIEW results_psra_national.psra_agg_loss_fsa AS SELECT * FROM results_psra_national.psra_agg_loss_fsa_tbl;



-- combine psra src_loss indicators into national level
DROP TABLE IF EXISTS results_psra_national.psra_src_loss_tbl CASCADE;

CREATE TABLE results_psra_national.psra_src_loss_tbl AS 
SELECT * FROM results_psra_ab.psra_ab_src_loss
UNION
SELECT * FROM results_psra_mb.psra_mb_src_loss
UNION
SELECT * FROM results_psra_nb.psra_nb_src_loss
UNION
SELECT * FROM results_psra_nl.psra_nl_src_loss
UNION
SELECT * FROM results_psra_ns.psra_ns_src_loss
UNION
SELECT * FROM results_psra_nt.psra_nt_src_loss
UNION
SELECT * FROM results_psra_nu.psra_nu_src_loss
UNION
SELECT * FROM results_psra_on.psra_on_src_loss;

-- CREATE TABLE results_psra_national.psra_src_loss_tbl AS 
-- SELECT * FROM results_psra_ab.psra_ab_src_loss
-- UNION
-- SELECT * FROM results_psra_bc.psra_bc_src_loss
-- UNION
-- SELECT * FROM results_psra_mb.psra_mb_src_loss
-- UNION
-- SELECT * FROM results_psra_nb.psra_nb_src_loss
-- UNION
-- SELECT * FROM results_psra_nl.psra_nl_src_loss
-- UNION
-- SELECT * FROM results_psra_ns.psra_ns_src_loss
-- UNION
-- SELECT * FROM results_psra_nt.psra_nt_src_loss
-- UNION
-- SELECT * FROM results_psra_nu.psra_nu_src_loss
-- UNION
-- SELECT * FROM results_psra_on.psra_on_src_loss
-- UNION
-- SELECT * FROM results_psra_pe.psra_pe_src_loss
-- UNION
-- SELECT * FROM results_psra_qc.psra_qc_src_loss
-- UNION
-- SELECT * FROM results_psra_sk.psra_sk_src_loss
-- UNION
-- SELECT * FROM results_psra_yt.psra_yt_src_loss;


-- add fid column
ALTER TABLE results_psra_national.psra_src_loss_tbl ADD COLUMN fid SERIAL;

-- create psra src national view
DROP VIEW IF EXISTS results_psra_national.psra_src_loss CASCADE;
CREATE VIEW results_psra_national.psra_src_loss AS SELECT * FROM results_psra_national.psra_src_loss_tbl;