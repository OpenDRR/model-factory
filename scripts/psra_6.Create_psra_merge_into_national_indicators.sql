CREATE SCHEMA IF NOT EXISTS results_psra_national;

-- combine psra building indicators into national level
DROP TABLE IF EXISTS results_psra_national.psra_indicators_b_tbl CASCADE;

CREATE TABLE results_psra_national.psra_indicators_b_tbl AS 
SELECT * FROM results_psra_ab.psra_ab_indicators_b
UNION
SELECT * FROM results_psra_bc.psra_bc_indicators_b
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
SELECT * FROM results_psra_on.psra_on_indicators_b
UNION
SELECT * FROM results_psra_pe.psra_pe_indicators_b
UNION
SELECT * FROM results_psra_qc.psra_qc_indicators_b
UNION
SELECT * FROM results_psra_sk.psra_sk_indicators_b
UNION
SELECT * FROM results_psra_yt.psra_yt_indicators_b;

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
SELECT * FROM results_psra_bc.psra_bc_indicators_s
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
SELECT * FROM results_psra_on.psra_on_indicators_s
UNION
SELECT * FROM results_psra_pe.psra_pe_indicators_s
UNION
SELECT * FROM results_psra_qc.psra_qc_indicators_s
UNION
SELECT * FROM results_psra_sk.psra_sk_indicators_s
UNION
SELECT * FROM results_psra_yt.psra_yt_indicators_s;

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
SELECT * FROM results_psra_bc.psra_bc_eqriskindex
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
SELECT * FROM results_psra_on.psra_on_eqriskindex
UNION
SELECT * FROM results_psra_pe.psra_pe_eqriskindex
UNION
SELECT * FROM results_psra_qc.psra_qc_eqriskindex
UNION
SELECT * FROM results_psra_sk.psra_sk_eqriskindex
UNION
SELECT * FROM results_psra_yt.psra_yt_eqriskindex;

-- normalize norm scores between 0 and 100
UPDATE results_psra_national.psra_eqriskindex
SET eqri_norm_score_b0 = CAST(CAST(ROUND(CAST(((eqri_norm_score_b0 - (SELECT MIN(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex)) / ((SELECT MAX(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex) - 
(SELECT MIN(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex))*100) AS NUMERIC),6) AS FLOAT) AS NUMERIC),
 	eqri_norm_score_r1 = CAST(CAST(ROUND(CAST(((eqri_norm_score_r1 - (SELECT MIN(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex)) / ((SELECT MAX(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex) - 
	(SELECT MIN(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex))*100) AS NUMERIC),6) AS FLOAT) AS NUMERIC);


--create national threshold sauid lookup table for rating
DROP TABLE IF EXISTS results_psra_national.psra_eqri_thresholds CASCADE;
CREATE TABLE results_psra_national.psra_eqri_thresholds
(
percentile NUMERIC,
abs_score_threshold_b0 FLOAT DEFAULT 0,
abs_score_threshold_r1 FLOAT DEFAULT 0, 
norm_score_threshold_b0 FLOAT DEFAULT 0,
norm_score_threshold_r1 FLOAT DEFAULT 0,
rating VARCHAR
);


INSERT INTO results_psra_national.psra_eqri_thresholds (percentile,rating) VALUES
(0,'Within bottom 50% of communities'),
(0.50,'Within 50-75% of communities'),
(0.75,'Within 75-90% of communities'),
(0.90,'Within 90-95% of communities'),
(0.95,'Within top 5% of communities');


--update values with calculated percentiles
--0.50 percentile
UPDATE results_psra_national.psra_eqri_thresholds 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex) WHERE percentile = 0.50;

-- 0.75 percentile
UPDATE results_psra_national.psra_eqri_thresholds 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex) WHERE percentile = 0.75;
	
-- 0.90 percentile
UPDATE results_psra_national.psra_eqri_thresholds 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex) WHERE percentile = 0.90;
	
-- 0.95 percentile
UPDATE results_psra_national.psra_eqri_thresholds 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex) WHERE percentile = 0.95;


-- update percentilerank value for national sauid 
UPDATE results_psra_national.psra_eqriskindex
SET eqri_abs_rank_b0 =
	CASE 
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.50)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.75)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.90)
		WHEN eqri_abs_score_b0 > (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_abs_rank_r1 =
	CASE 
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.50)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.75)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.90)
		WHEN eqri_abs_score_r1 > (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_b0 =
	CASE 
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.50)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.75)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.90)
		WHEN eqri_norm_score_b0 > (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_r1 =
	CASE 
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.50)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.75)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.90)
		WHEN eqri_norm_score_r1 > (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds WHERE percentile = 0.95)
		ELSE 'null' END;


-- update percentilerank, normalized score on national sauid table
UPDATE results_psra_national.psra_indicators_s_tbl b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b."Sauid";


-- update percentilerank, normalized score on P/T eqriskindex sauid table
UPDATE results_psra_ab.psra_ab_eqriskindex b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_bc.psra_bc_eqriskindex b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_mb.psra_mb_eqriskindex b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_nb.psra_nb_eqriskindex b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_nl.psra_nl_eqriskindex b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_ns.psra_ns_eqriskindex b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_nt.psra_nt_eqriskindex b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_nu.psra_nu_eqriskindex b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_on.psra_on_eqriskindex b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_pe.psra_pe_eqriskindex b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_qc.psra_qc_eqriskindex b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_sk.psra_sk_eqriskindex b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;

UPDATE results_psra_yt.psra_yt_eqriskindex b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex a
WHERE a.sauid = b.sauid;


-- combine psra csd indicators into national level
DROP TABLE IF EXISTS results_psra_national.psra_indicators_csd_tbl CASCADE;


CREATE TABLE results_psra_national.psra_indicators_csd_tbl AS 
SELECT * FROM results_psra_ab.psra_ab_indicators_csd
UNION
SELECT * FROM results_psra_bc.psra_bc_indicators_csd
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
SELECT * FROM results_psra_on.psra_on_indicators_csd
UNION
SELECT * FROM results_psra_pe.psra_pe_indicators_csd
UNION
SELECT * FROM results_psra_qc.psra_qc_indicators_csd
UNION
SELECT * FROM results_psra_sk.psra_sk_indicators_csd
UNION
SELECT * FROM results_psra_yt.psra_yt_indicators_csd;

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
SELECT * FROM results_psra_bc.psra_bc_eqriskindex_csd
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
SELECT * FROM results_psra_on.psra_on_eqriskindex_csd
UNION
SELECT * FROM results_psra_pe.psra_pe_eqriskindex_csd
UNION
SELECT * FROM results_psra_qc.psra_qc_eqriskindex_csd
UNION
SELECT * FROM results_psra_sk.psra_sk_eqriskindex_csd
UNION
SELECT * FROM results_psra_yt.psra_yt_eqriskindex_csd;

-- normalize norm scores between 0 and 100
UPDATE results_psra_national.psra_eqriskindex_csd
SET eqri_norm_score_b0 = CAST(CAST(ROUND(CAST(((eqri_norm_score_b0 - (SELECT MIN(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_csd)) / ((SELECT MAX(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_csd) - 
(SELECT MIN(eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_csd))*100) AS NUMERIC),6) AS FLOAT) AS NUMERIC),
 	eqri_norm_score_r1 = CAST(CAST(ROUND(CAST(((eqri_norm_score_r1 - (SELECT MIN(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_csd)) / ((SELECT MAX(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_csd) - 
	(SELECT MIN(eqri_norm_score_r1) FROM results_psra_national.psra_eqriskindex_csd))*100) AS NUMERIC),6) AS FLOAT) AS NUMERIC);


--create national threshold csd lookup table for rating
DROP TABLE IF EXISTS results_psra_national.psra_eqri_thresholds_csd CASCADE;
CREATE TABLE results_psra_national.psra_eqri_thresholds_csd
(
percentile NUMERIC,
abs_score_threshold_b0 FLOAT DEFAULT 0,
abs_score_threshold_r1 FLOAT DEFAULT 0,
norm_score_threshold_b0 FLOAT DEFAULT 0,
norm_score_threshold_r1 FLOAT DEFAULT 0,
rating VARCHAR
);


INSERT INTO results_psra_national.psra_eqri_thresholds_csd (percentile,rating) VALUES
(0,'Within bottom 50% of communities'),
(0.50,'Within 50-75% of communities'),
(0.75,'Within 75-90% of communities'),
(0.90,'Within 90-95% of communities'),
(0.95,'Within top 5% of communities');


--update values with calculated percentiles
--0.50 percentile
UPDATE results_psra_national.psra_eqri_thresholds_csd 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_csd),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_csd),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_csd),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_csd) WHERE percentile = 0.50;

-- 0.75 percentile
UPDATE results_psra_national.psra_eqri_thresholds_csd 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_csd),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_csd),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_csd),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_csd) WHERE percentile = 0.75;
	
-- 0.90 percentile
UPDATE results_psra_national.psra_eqri_thresholds_csd 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_csd),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_csd),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_csd),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_csd) WHERE percentile = 0.90;
	
-- 0.95 percentile
UPDATE results_psra_national.psra_eqri_thresholds_csd 
SET abs_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_b0) FROM results_psra_national.psra_eqriskindex_csd),
	abs_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_abs_score_r1) FROM results_psra_national.psra_eqriskindex_csd),
	norm_score_threshold_b0 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_csd),
	norm_score_threshold_r1 = (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY eqri_norm_score_b0) FROM results_psra_national.psra_eqriskindex_csd) WHERE percentile = 0.95;


-- update percentilerank value for national sauid 
UPDATE results_psra_national.psra_eqriskindex_csd
SET eqri_abs_rank_b0 =
	CASE 
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.50)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.75)
		WHEN eqri_abs_score_b0 < (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.90)
		WHEN eqri_abs_score_b0 > (SELECT abs_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_abs_rank_r1 =
	CASE 
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.50)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.75)
		WHEN eqri_abs_score_r1 < (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.90)
		WHEN eqri_abs_score_r1 > (SELECT abs_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_b0 =
	CASE 
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.50)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.75)
		WHEN eqri_norm_score_b0 < (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.90)
		WHEN eqri_norm_score_b0 > (SELECT norm_score_threshold_b0 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95)
		ELSE 'null' END,
	eqri_norm_rank_r1 =
	CASE 
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.50) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.75) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.50)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.90) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.75)
		WHEN eqri_norm_score_r1 < (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.90)
		WHEN eqri_norm_score_r1 > (SELECT norm_score_threshold_r1 FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95) THEN (SELECT rating FROM results_psra_national.psra_eqri_thresholds_csd WHERE percentile = 0.95)
		ELSE 'null' END;


-- update percentilerank, normalized score on national csd table
UPDATE results_psra_national.psra_indicators_csd_tbl b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;


-- update percentilerank, normalized score on P/T eqriskindex csd table
UPDATE results_psra_ab.psra_ab_eqriskindex_csd b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_bc.psra_bc_eqriskindex_csd b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_mb.psra_mb_eqriskindex_csd b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_nb.psra_nb_eqriskindex_csd b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_nl.psra_nl_eqriskindex_csd b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_ns.psra_ns_eqriskindex_csd b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_nt.psra_nt_eqriskindex_csd b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_nu.psra_nu_eqriskindex_csd b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_on.psra_on_eqriskindex_csd b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_pe.psra_pe_eqriskindex_csd b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_qc.psra_qc_eqriskindex_csd b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_sk.psra_sk_eqriskindex_csd b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_yt.psra_yt_eqriskindex_csd b
SET eqri_abs_rank_b0 = a.eqri_abs_rank_b0,
	eqri_norm_score_b0 = a.eqri_norm_score_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rank_b0,
	eqri_abs_rank_r1 = a.eqri_abs_rank_r1,
	eqri_norm_score_r1 = a.eqri_norm_score_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rank_r1
FROM results_psra_national.psra_eqriskindex_csd a
WHERE a.csduid = b.csduid;


-- combine psra expected loss indicators into national level
DROP TABLE IF EXISTS results_psra_national.psra_expected_loss_fsa_tbl CASCADE;


CREATE TABLE results_psra_national.psra_expected_loss_fsa_tbl AS 
SELECT * FROM results_psra_ab.psra_ab_expected_loss_fsa
UNION
SELECT * FROM results_psra_bc.psra_bc_expected_loss_fsa
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
UNION
SELECT * FROM results_psra_pe.psra_pe_expected_loss_fsa
UNION
SELECT * FROM results_psra_qc.psra_qc_expected_loss_fsa
UNION
SELECT * FROM results_psra_sk.psra_sk_expected_loss_fsa
UNION
SELECT * FROM results_psra_yt.psra_yt_expected_loss_fsa;

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
SELECT * FROM results_psra_bc.psra_bc_agg_loss_fsa
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
SELECT * FROM results_psra_on.psra_on_agg_loss_fsa
UNION
SELECT * FROM results_psra_pe.psra_pe_agg_loss_fsa
UNION
SELECT * FROM results_psra_qc.psra_qc_agg_loss_fsa
UNION
SELECT * FROM results_psra_sk.psra_sk_agg_loss_fsa
UNION
SELECT * FROM results_psra_yt.psra_yt_agg_loss_fsa;

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
SELECT * FROM results_psra_bc.psra_bc_src_loss
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
SELECT * FROM results_psra_on.psra_on_src_loss
UNION
SELECT * FROM results_psra_pe.psra_pe_src_loss
UNION
SELECT * FROM results_psra_qc.psra_qc_src_loss
UNION
SELECT * FROM results_psra_sk.psra_sk_src_loss
UNION
SELECT * FROM results_psra_yt.psra_yt_src_loss;


-- add fid column
ALTER TABLE results_psra_national.psra_src_loss_tbl ADD COLUMN fid SERIAL;

-- create index
CREATE INDEX psra_src_loss_tbl_fid_idx ON results_psra_national.psra_src_loss_tbl("fid");

-- create psra src national view
DROP VIEW IF EXISTS results_psra_national.psra_src_loss CASCADE;
CREATE VIEW results_psra_national.psra_src_loss AS SELECT * FROM results_psra_national.psra_src_loss_tbl;



-- add canada views into psra_national
-- combine psra canada expected loss indicators 
DROP TABLE IF EXISTS results_psra_national.psra_canada_expected_loss_tbl CASCADE;

CREATE TABLE results_psra_national.psra_canada_expected_loss_tbl AS 
SELECT * FROM results_psra_canada.psra_canada_expected_loss;

-- add fid column
ALTER TABLE results_psra_national.psra_canada_expected_loss_tbl ADD COLUMN fid SERIAL;

-- create index
CREATE INDEX psra_canada_expected_loss_tbl_fid_idx ON results_psra_national.psra_canada_expected_loss_tbl("fid");

-- create view
DROP VIEW IF EXISTS results_psra_national.psra_canada_expected_loss CASCADE;
CREATE VIEW results_psra_national.psra_canada_expected_loss AS SELECT * FROM results_psra_national.psra_canada_expected_loss_tbl;


-- combine psra canada agg loss indicators 
DROP TABLE IF EXISTS results_psra_national.psra_canada_agg_loss_tbl CASCADE;

CREATE TABLE results_psra_national.psra_canada_agg_loss_tbl AS 
SELECT * FROM results_psra_canada.psra_canada_agg_loss;

-- add fid column
ALTER TABLE results_psra_national.psra_canada_agg_loss_tbl ADD COLUMN fid SERIAL;

-- create index
CREATE INDEX psra_canada_agg_loss_tbl_fid_idx ON results_psra_national.psra_canada_agg_loss_tbl("fid");

-- create psra pml national view
DROP VIEW IF EXISTS results_psra_national.psra_canada_agg_loss CASCADE;
CREATE VIEW results_psra_national.psra_canada_agg_loss AS SELECT * FROM results_psra_national.psra_canada_agg_loss_tbl;


-- add 50, 100, 250, 500, 1000, 2500 year psra canada-wide aggregate views
DROP VIEW IF EXISTS results_psra_national.psra_canada_expected_loss_50yr, results_psra_national.psra_canada_expected_loss_100yr, results_psra_national.psra_canada_expected_loss_250yr,
results_psra_national.psra_canada_expected_loss_500yr, results_psra_national.psra_canada_expected_loss_1000yr, results_psra_national.psra_canada_expected_loss_2500yr CASCADE;

CREATE VIEW results_psra_national.psra_canada_expected_loss_50yr AS SELECT * FROM results_psra_canada.psra_canada_expected_loss_50yr;
CREATE VIEW results_psra_national.psra_canada_expected_loss_100yr AS SELECT * FROM results_psra_canada.psra_canada_expected_loss_100yr;
CREATE VIEW results_psra_national.psra_canada_expected_loss_250yr AS SELECT * FROM results_psra_canada.psra_canada_expected_loss_250yr;
CREATE VIEW results_psra_national.psra_canada_expected_loss_500yr AS SELECT * FROM results_psra_canada.psra_canada_expected_loss_500yr;
CREATE VIEW results_psra_national.psra_canada_expected_loss_1000yr AS SELECT * FROM results_psra_canada.psra_canada_expected_loss_1000yr;
CREATE VIEW results_psra_national.psra_canada_expected_loss_2500yr AS SELECT * FROM results_psra_canada.psra_canada_expected_loss_2500yr;


-- combine psra canada src_loss indicators 
DROP TABLE IF EXISTS results_psra_national.psra_canada_src_loss_tbl CASCADE;

CREATE TABLE results_psra_national.psra_canada_src_loss_tbl AS 
SELECT * FROM results_psra_canada.psra_canada_src_loss;

-- add fid column
ALTER TABLE results_psra_national.psra_canada_src_loss_tbl ADD COLUMN fid SERIAL;

-- create index
CREATE INDEX psra_canada_src_loss_tbl_fid_idx ON results_psra_national.psra_canada_src_loss_tbl("fid");

-- create psra src national view
DROP VIEW IF EXISTS results_psra_national.psra_canada_src_loss CASCADE;
CREATE VIEW results_psra_national.psra_canada_src_loss AS SELECT * FROM results_psra_national.psra_canada_src_loss_tbl;