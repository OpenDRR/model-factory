CREATE SCHEMA IF NOT EXISTS results_psra_national;

-- combine psra building indicators into national level
DROP TABLE IF EXISTS results_psra_national.psra_indicators_b_tbl CASCADE;

CREATE TABLE results_psra_national.psra_indicators_b_tbl AS 
SELECT * FROM results_psra_nb.psra_nb_indicators_b
UNION
SELECT * FROM results_psra_nl.psra_nl_indicators_b
UNION
SELECT * FROM results_psra_ns.psra_ns_indicators_b
UNION
SELECT * FROM results_psra_pe.psra_pe_indicators_b;

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
CREATE INDEX psra_indicators_b_tbl_ername_idx ON results_psra_national.psra_indicators_b_tbl(ername);
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
SELECT * FROM results_psra_nb.psra_nb_indicators_s
UNION
SELECT * FROM results_psra_nl.psra_nl_indicators_s
UNION
SELECT * FROM results_psra_ns.psra_ns_indicators_s
UNION
SELECT * FROM results_psra_pe.psra_pe_indicators_s;

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
CREATE INDEX psra_indicators_s_tbl_ername_idx ON results_psra_national.psra_indicators_s_tbl(ername);
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



-- combine psra csd indicators into national level
DROP TABLE IF EXISTS results_psra_national.psra_indicators_csd_tbl CASCADE;

CREATE TABLE results_psra_national.psra_indicators_csd_tbl AS 
SELECT * FROM results_psra_nb.psra_nb_indicators_csd
UNION
SELECT * FROM results_psra_nl.psra_nl_indicators_csd
UNION
SELECT * FROM results_psra_ns.psra_ns_indicators_csd
UNION
SELECT * FROM results_psra_pe.psra_pe_indicators_csd;

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



-- combine psra expected loss indicators into national level
DROP TABLE IF EXISTS results_psra_national.psra_expected_loss_fsa_tbl CASCADE;

CREATE TABLE results_psra_national.psra_expected_loss_fsa_tbl AS 
SELECT * FROM results_psra_nb.psra_nb_expected_loss_fsa
UNION
SELECT * FROM results_psra_nl.psra_nl_expected_loss_fsa
UNION
SELECT * FROM results_psra_ns.psra_ns_expected_loss_fsa
UNION
SELECT * FROM results_psra_pe.psra_pe_expected_loss_fsa;

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
CREATE INDEX psra_expected_loss_fsa_tbl_sauid_idx ON results_psra_national.psra_expected_loss_fsa_tbl("ePML_FSAUID");
CREATE INDEX psra_expected_loss_fsa_tbl_fid_idx ON results_psra_national.psra_expected_loss_fsa_tbl("fid");


-- create psra pml national view
DROP VIEW IF EXISTS results_psra_national.psra_pml_s CASCADE;
CREATE VIEW results_psra_national.psra_pml_s AS SELECT * FROM results_psra_national.psra_pml_s_tbl;



-- combine psra uhs indicators into national level
DROP TABLE IF EXISTS results_psra_national.psra_uhs_tbl CASCADE;

CREATE TABLE results_psra_national.psra_uhs_tbl AS 
SELECT * FROM results_psra_nb.psra_nb_uhs
UNION
SELECT * FROM results_psra_nl.psra_nl_uhs
UNION
SELECT * FROM results_psra_ns.psra_ns_uhs
UNION
SELECT * FROM results_psra_pe.psra_pe_uhs;

-- CREATE TABLE results_psra_national.psra_uhs_tbl AS 
-- SELECT * FROM results_psra_ab.psra_ab_uhs
-- UNION
-- SELECT * FROM results_psra_bc.psra_bc_uhs
-- UNION
-- SELECT * FROM results_psra_mb.psra_mb_uhs
-- UNION
-- SELECT * FROM results_psra_nb.psra_nb_uhs
-- UNION
-- SELECT * FROM results_psra_nl.psra_nl_uhs
-- UNION
-- SELECT * FROM results_psra_ns.psra_ns_uhs
-- UNION
-- SELECT * FROM results_psra_nt.psra_nt_uhs
-- UNION
-- SELECT * FROM results_psra_nu.psra_nu_uhs
-- UNION
-- SELECT * FROM results_psra_on.psra_on_uhs
-- UNION
-- SELECT * FROM results_psra_pe.psra_pe_uhs
-- UNION
-- SELECT * FROM results_psra_qc.psra_qc_uhs
-- UNION
-- SELECT * FROM results_psra_sk.psra_sk_uhs
-- UNION
-- SELECT * FROM results_psra_yt.psra_yt_uhs;

-- add fid column
ALTER TABLE results_psra_national.psra_uhs_tbl ADD COLUMN fid SERIAL;

-- create index
CREATE INDEX psra_uhs_tbl_geom_idx ON results_psra_national.psra_uhs_tbl USING GIST(geom);
CREATE INDEX psra_uhs_tbl_fid_idx ON results_psra_national.psra_uhs_tbl("fid");

-- create psra pml national view
DROP VIEW IF EXISTS results_psra_national.psra_uhs CASCADE;
CREATE VIEW results_psra_national.psra_uhs AS SELECT * FROM results_psra_national.psra_uhs_tbl;



-- combine psra src_loss indicators into national level
DROP TABLE IF EXISTS results_psra_national.psra_src_loss_tbl CASCADE;

CREATE TABLE results_psra_national.psra_src_loss_tbl AS 
SELECT * FROM results_psra_nb.psra_nb_src_loss
UNION
SELECT * FROM results_psra_nl.psra_nl_src_loss
UNION
SELECT * FROM results_psra_ns.psra_ns_src_loss
UNION
SELECT * FROM results_psra_pe.psra_pe_src_loss;

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



-- combine psra hmaps into national level
DROP TABLE IF EXISTS results_psra_national.psra_hmaps_tbl CASCADE;

CREATE TABLE results_psra_national.psra_hmaps_tbl AS 
SELECT * FROM results_psra_nb.psra_nb_hmaps
UNION
SELECT * FROM results_psra_nl.psra_nl_hmaps
UNION
SELECT * FROM results_psra_ns.psra_ns_hmaps
UNION
SELECT * FROM results_psra_pe.psra_pe_hmaps;

-- CREATE TABLE results_psra_national.psra_hmaps_tbl AS 
-- SELECT * FROM results_psra_ab.psra_ab_hmaps
-- UNION
-- SELECT * FROM results_psra_bc.psra_bc_hmaps
-- UNION
-- SELECT * FROM results_psra_mb.psra_mb_hmaps
-- UNION
-- SELECT * FROM results_psra_nb.psra_nb_hmaps
-- UNION
-- SELECT * FROM results_psra_nl.psra_nl_hmaps
-- UNION
-- SELECT * FROM results_psra_ns.psra_ns_hmaps
-- UNION
-- SELECT * FROM results_psra_nt.psra_nt_hmaps
-- UNION
-- SELECT * FROM results_psra_nu.psra_nu_hmaps
-- UNION
-- SELECT * FROM results_psra_on.psra_on_hmaps
-- UNION
-- SELECT * FROM results_psra_pe.psra_pe_hmaps
-- UNION
-- SELECT * FROM results_psra_qc.psra_qc_hmaps
-- UNION
-- SELECT * FROM results_psra_sk.psra_sk_hmaps
-- UNION
-- SELECT * FROM results_psra_yt.psra_yt_hmaps;

-- add fid column
ALTER TABLE results_psra_national.psra_hmaps_tbl ADD COLUMN fid SERIAL;

-- create psra hmaps national view
DROP VIEW IF EXISTS results_psra_national.psra_hmaps CASCADE;
CREATE VIEW results_psra_national.psra_hmaps AS SELECT * FROM results_psra_national.psra_hmaps_tbl;