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

-- -- create psra sauid national view
-- DROP VIEW IF EXISTS results_psra_national.psra_indicators_s CASCADE;
-- CREATE VIEW results_psra_national.psra_indicators_s AS SELECT * FROM results_psra_national.psra_indicators_s_tbl;



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