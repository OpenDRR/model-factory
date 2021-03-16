CREATE SCHEMA IF NOT EXISTS results_psra_national;

-- combine psra building indicators into national level
DROP TABLE IF EXISTS results_psra_national.psra_all_indicators_b_tbl CASCADE;

CREATE TABLE results_psra_national.psra_all_indicators_b_tbl AS 
SELECT * FROM results_psra_ab.psra_ab_all_indicators_b
UNION
SELECT * FROM results_psra_bc.psra_bc_all_indicators_b
UNION
SELECT * FROM results_psra_mb.psra_mb_all_indicators_b
UNION
SELECT * FROM results_psra_nb.psra_nb_all_indicators_b
UNION
SELECT * FROM results_psra_nl.psra_nl_all_indicators_b
UNION
SELECT * FROM results_psra_ns.psra_ns_all_indicators_b
UNION
SELECT * FROM results_psra_nt.psra_nt_all_indicators_b
UNION
SELECT * FROM results_psra_nu.psra_nu_all_indicators_b
UNION
SELECT * FROM results_psra_on.psra_on_all_indicators_b
UNION
SELECT * FROM results_psra_pe.psra_pe_all_indicators_b
UNION
SELECT * FROM results_psra_qc.psra_qc_all_indicators_b
UNION
SELECT * FROM results_psra_sk.psra_sk_all_indicators_b
UNION
SELECT * FROM results_psra_yt.psra_yt_all_indicators_b;


-- create index
CREATE INDEX psra_all_indicators_b_tbl_idx ON results_psra_national.psra_all_indicators_b_tbl("AssetID");
CREATE INDEX psra_all_indicators_b_tbl_sauid_idx ON results_psra_national.psra_all_indicators_b_tbl("Sauid");
CREATE INDEX psra_all_indicators_b_tbl_pruid_idx ON results_psra_national.psra_all_indicators_b_tbl(pruid);
CREATE INDEX psra_all_indicators_b_tbl_prname_idx ON results_psra_national.psra_all_indicators_b_tbl(prname);
CREATE INDEX psra_all_indicators_b_tbl_eruid_idx ON results_psra_national.psra_all_indicators_b_tbl(eruid);
CREATE INDEX psra_all_indicators_b_tbl_ername_idx ON results_psra_national.psra_all_indicators_b_tbl(ername);
CREATE INDEX psra_all_indicators_b_tbl_cduid_idx ON results_psra_national.psra_all_indicators_b_tbl(cdname);
CREATE INDEX psra_all_indicators_b_tbl_cdname_idx ON results_psra_national.psra_all_indicators_b_tbl(cdname);
CREATE INDEX psra_all_indicators_b_tbl_csduid_idx ON results_psra_national.psra_all_indicators_b_tbl(csduid);
CREATE INDEX psra_all_indicators_b_tbl_csdname_idx ON results_psra_national.psra_all_indicators_b_tbl(csdname);
CREATE INDEX psra_all_indicators_b_tbl_fsauid_idx ON results_psra_national.psra_all_indicators_b_tbl(fsauid);
CREATE INDEX psra_all_indicators_b_tbl_dauid_idx ON results_psra_national.psra_all_indicators_b_tbl(dauid);
CREATE INDEX psra_all_indicators_b_tbl_geom_idx ON results_psra_national.psra_all_indicators_b_tbl USING GIST(geom_point);

-- add pk
ALTER TABLE results_psra_national.psra_all_indicators_b_tbl ADD PRIMARY KEY("AssetID");


-- create psra building national view
DROP VIEW IF EXISTS results_psra_national.psra_all_indicators_b CASCADE;
CREATE VIEW results_psra_national.psra_all_indicators_b AS
SELECT * FROM results_psra_national.psra_all_indicators_b_tbl;



-- combine psra sauid indicators into national level
DROP TABLE IF EXISTS results_psra_national.psra_all_indicators_s_tbl CASCADE;

CREATE TABLE results_psra_national.psra_all_indicators_s_tbl AS 
SELECT * FROM results_psra_ab.psra_ab_all_indicators_s
UNION
SELECT * FROM results_psra_bc.psra_bc_all_indicators_s
UNION
SELECT * FROM results_psra_mb.psra_mb_all_indicators_s
UNION
SELECT * FROM results_psra_nb.psra_nb_all_indicators_s
UNION
SELECT * FROM results_psra_nl.psra_nl_all_indicators_s
UNION
SELECT * FROM results_psra_ns.psra_ns_all_indicators_s
UNION
SELECT * FROM results_psra_nt.psra_nt_all_indicators_s
UNION
SELECT * FROM results_psra_nu.psra_nu_all_indicators_s
UNION
SELECT * FROM results_psra_on.psra_on_all_indicators_s
UNION
SELECT * FROM results_psra_pe.psra_pe_all_indicators_s
UNION
SELECT * FROM results_psra_qc.psra_qc_all_indicators_s
UNION
SELECT * FROM results_psra_sk.psra_sk_all_indicators_s
UNION
SELECT * FROM results_psra_yt.psra_yt_all_indicators_s;

-- create index
CREATE INDEX psra_all_indicators_s_tbl_sauid_idx ON results_psra_national.psra_all_indicators_s_tbl("Sauid");
CREATE INDEX psra_all_indicators_s_tbl_pruid_idx ON results_psra_national.psra_all_indicators_s_tbl(pruid);
CREATE INDEX psra_all_indicators_s_tbl_prname_idx ON results_psra_national.psra_all_indicators_s_tbl(prname);
CREATE INDEX psra_all_indicators_s_tbl_eruid_idx ON results_psra_national.psra_all_indicators_s_tbl(eruid);
CREATE INDEX psra_all_indicators_s_tbl_ername_idx ON results_psra_national.psra_all_indicators_s_tbl(ername);
CREATE INDEX psra_all_indicators_s_tbl_cduid_idx ON results_psra_national.psra_all_indicators_s_tbl(cdname);
CREATE INDEX psra_all_indicators_s_tbl_cdname_idx ON results_psra_national.psra_all_indicators_s_tbl(cdname);
CREATE INDEX psra_all_indicators_s_tbl_csduid_idx ON results_psra_national.psra_all_indicators_s_tbl(csduid);
CREATE INDEX psra_all_indicators_s_tbl_csdname_idx ON results_psra_national.psra_all_indicators_s_tbl(csdname);
CREATE INDEX psra_all_indicators_s_tbl_fsauid_idx ON results_psra_national.psra_all_indicators_s_tbl(fsauid);
CREATE INDEX psra_all_indicators_s_tbl_dauid_idx ON results_psra_national.psra_all_indicators_s_tbl(dauid);
CREATE INDEX psra_all_indicators_s_tbl_geom_idx ON results_psra_national.psra_all_indicators_s_tbl USING GIST(geom_poly);

-- add pk
ALTER TABLE results_psra_national.psra_all_indicators_s_tbl ADD PRIMARY KEY("Sauid");



-- create psra sauid national view
DROP VIEW IF EXISTS results_psra_national.psra_all_indicators_s CASCADE;
CREATE VIEW results_psra_national.psra_all_indicators_s AS
SELECT * FROM results_psra_national.psra_all_indicators_s_tbl;



-- combine psra pml indicators into national level
DROP TABLE IF EXISTS results_psra_national.psra_pml_s_tbl CASCADE;

CREATE TABLE results_psra_national.psra_pml_s_tbl AS 
SELECT * FROM results_psra_ab.psra_ab_pml_s
UNION
SELECT * FROM results_psra_bc.psra_bc_pml_s
UNION
SELECT * FROM results_psra_mb.psra_mb_pml_s
UNION
SELECT * FROM results_psra_nb.psra_nb_pml_s
UNION
SELECT * FROM results_psra_nl.psra_nl_pml_s
UNION
SELECT * FROM results_psra_ns.psra_ns_pml_s
UNION
SELECT * FROM results_psra_nt.psra_nt_pml_s
UNION
SELECT * FROM results_psra_nu.psra_nu_pml_s
UNION
SELECT * FROM results_psra_on.psra_on_pml_s
UNION
SELECT * FROM results_psra_pe.psra_pe_pml_s
UNION
SELECT * FROM results_psra_qc.psra_qc_pml_s
UNION
SELECT * FROM results_psra_sk.psra_sk_pml_s
UNION
SELECT * FROM results_psra_yt.psra_yt_pml_s;

-- create index
CREATE INDEX psra_pml_s_tbl_sauid_idx ON results_psra_national.psra_pml_s_tbl("ePML_FSAUID");

-- create psra pml national view
DROP VIEW IF EXISTS results_psra_national.psra_pml_s CASCADE;
CREATE VIEW results_psra_national.psra_pml_s AS
SELECT * FROM results_psra_national.psra_pml_s_tbl;