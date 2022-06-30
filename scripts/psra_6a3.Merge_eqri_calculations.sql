CREATE SCHEMA IF NOT EXISTS results_psra_national;


-- join sri values to psra indicators
DROP VIEW IF EXISTS results_psra_national.psra_indicators_s CASCADE;
CREATE VIEW results_psra_national.psra_indicators_s AS
(
SELECT
a."Sauid",
a."eDt_Slight_b0",
a."eDtr_Slight_b0",
a."eDt_Moderate_b0",
a."eDtr_Moderate_b0",
a."eDt_Extensive_b0",
a."eDtr_Extensive_b0",
a."eDt_Complete_b0",
a."eDtr_Complete_b0",
a."eDt_Collapse_b0",
a."eDtr_Collapse_b0",
a."eDt_Fail_Collapse_b0",
a."eDt_Slight05_b0",
a."eDtr_Slight05_b0",
a."eDt_Moderate05_b0",
a."eDtr_Moderate05_b0",
a."eDt_Extensive05_b0",
a."eDtr_Extensive05_b0",
a."eDt_Complete05_b0",
a."eDtr_Complete05_b0",
a."eDt_Collapse05_b0",
a."eDtr_Collapse05_b0",
a."eDt_Fail_Collapse05_b0",
a."eDt_Slight95_b0",
a."eDtr_Slight95_b0",
a."eDt_Moderate95_b0",
a."eDtr_Moderate95_b0",
a."eDt_Extensive95_b0",
a."eDtr_Extensive95_b0",
a."eDt_Complete95_b0",
a."eDtr_Complete95_b0",
a."eDt_Collapse95_b0",
a."eDtr_Collapse95_b0",
a."eDt_Fail_Collapse95_b0",
a."eDt_Slight_r1",
a."eDtr_Slight_r1",
a."eDt_Moderate_r1",
a."eDtr_Moderate_r1",
a."eDt_Extensive_r1",
a."eDtr_Extensive_r1",
a."eDt_Complete_r1",
a."eDtr_Complete_r1",
a."eDt_Collapse_r1",
a."eDtr_Collapse_r1",
a."eDt_Fail_Collapse_r1",
a."eDt_Slight05_r1",
a."eDtr_Slight05_r1",
a."eDt_Moderate05_r1",
a."eDtr_Moderate05_r1",
a."eDt_Extensive05_r1",
a."eDtr_Extensive05_r1",
a."eDt_Complete05_r1",
a."eDtr_Complete05_r1",
a."eDt_Collapse05_r1",
a."eDtr_Collapse05_r1",
a."eDt_Fail_Collapse05_r1",
a."eDt_Slight95_r1",
a."eDtr_Slight95_r1",
a."eDt_Moderate95_r1",
a."eDtr_Moderate95_r1",
a."eDt_Extensive95_r1",
a."eDtr_Extensive95_r1",
a."eDt_Complete95_r1",
a."eDtr_Complete95_r1",
a."eDt_Collapse95_r1",
a."eDtr_Collapse95_r1",
a."eDt_Fail_Collapse95_r1",
a."eCt_Fatality_b0",
a."eCtr_Fatality_b0",
a."eCt_Fatality_r1",
a."eCtr_Fatality_r1",
a."eAALt_Asset_b0",
a."eAALm_Asset_b0",
a."eAALt_Bldg_b0",
a."eAALm_Bldg_b0",
a."eAALt_Str_b0",
a."eAALt_NStr_b0",
a."eAALt_Cont_b0",
a."eAALt_Asset_r1",
a."eAALm_Asset_r1",
a."eAALt_Bldg_r1",
a."eAALm_Bldg_r1",
a."eAALt_Str_r1",
a."eAALt_NStr_r1",
a."eAALt_Cont_r1",
CAST(CAST(ROUND(CAST(b.eqri_abs_cbrt_minmax_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eqri_abs_score_b0",
b.eqri_abs_rating_b0 AS "eqri_abs_rank_b0",
CAST(CAST(ROUND(CAST(b.eqri_norm_cbrt_minmax_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eqri_norm_score_b0",
b.eqri_norm_rating_b0 AS "eqri_norm_rank_b0",
CAST(CAST(ROUND(CAST(b.eqri_abs_cbrt_minmax_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eqri_abs_score_r1",
b.eqri_abs_rating_r1 AS "eqri_abs_rank_r1",
CAST(CAST(ROUND(CAST(b.eqri_norm_cbrt_minmax_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eqri_norm_score_r1",
b.eqri_norm_rating_r1 AS "eqri_norm_rank_r1",
a."pruid",
a."prname",
a."eruid",
a."cduid",
a."cdname",
a."csduid",
a."csdname",
a."fsauid",
a."dauid",
a."saccode",
a."sactype",
a."geom_poly"

FROM results_psra_national.psra_indicators_s_tbl a
LEFT JOIN results_psra_national.psra_sri_calc_sa b ON a."Sauid" = b."Sauid"
);



-- update percentilerank, normalized score on P/T eqriskindex sauid table
-- update percentilerank, normalized score on P/T eqriskindex sauid table
UPDATE results_psra_ab.psra_ab_eqriskindex b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_sa a
WHERE a."Sauid" = b.sauid;

UPDATE results_psra_bc.psra_bc_eqriskindex b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_sa a
WHERE a."Sauid" = b.sauid;

UPDATE results_psra_mb.psra_mb_eqriskindex b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_sa a
WHERE a."Sauid" = b.sauid;

UPDATE results_psra_nb.psra_nb_eqriskindex b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_sa a
WHERE a."Sauid" = b.sauid;

UPDATE results_psra_nl.psra_nl_eqriskindex b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_sa a
WHERE a."Sauid" = b.sauid;

UPDATE results_psra_ns.psra_ns_eqriskindex b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_sa a
WHERE a."Sauid" = b.sauid;

UPDATE results_psra_nt.psra_nt_eqriskindex b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_sa a
WHERE a."Sauid" = b.sauid;

UPDATE results_psra_nu.psra_nu_eqriskindex b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_sa a
WHERE a."Sauid" = b.sauid;

UPDATE results_psra_on.psra_on_eqriskindex b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_sa a
WHERE a."Sauid" = b.sauid;

UPDATE results_psra_pe.psra_pe_eqriskindex b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_sa a
WHERE a."Sauid" = b.sauid;

UPDATE results_psra_qc.psra_qc_eqriskindex b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_sa a
WHERE a."Sauid" = b.sauid;

UPDATE results_psra_sk.psra_sk_eqriskindex b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_sa a
WHERE a."Sauid" = b.sauid;

UPDATE results_psra_yt.psra_yt_eqriskindex b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_sa a
WHERE a."Sauid" = b.sauid;



-- create psra sauid national view, attach all csd for viewing even with no values
DROP VIEW IF EXISTS results_psra_national.psra_indicators_csd CASCADE;
CREATE VIEW results_psra_national.psra_indicators_csd AS 
SELECT 
a."CSDUID" AS "csduid",
a."CSDNAME" AS "csdname",
b."eDt_Slight_b0",
b."eDtr_Slight_b0",
b."eDt_Moderate_b0",
b."eDtr_Moderate_b0",
b."eDt_Extensive_b0",
b."eDtr_Extensive_b0",
b."eDt_Complete_b0",
b."eDtr_Complete_b0",
b."eDt_Collapse_b0",
b."eDtr_Collapse_b0",
b."eDt_Fail_Collapse_b0",
b."eDt_Slight05_b0",
b."eDtr_Slight05_b0",
b."eDt_Moderate05_b0",
b."eDtr_Moderate05_b0",
b."eDt_Extensive05_b0",
b."eDtr_Extensive05_b0",
b."eDt_Complete05_b0",
b."eDtr_Complete05_b0",
b."eDt_Collapse05_b0",
b."eDtr_Collapse05_b0",
b."eDt_Fail_Collapse05_b0",
b."eDt_Slight95_b0",
b."eDtr_Slight95_b0",
b."eDt_Moderate95_b0",
b."eDtr_Moderate95_b0",
b."eDt_Extensive95_b0",
b."eDtr_Extensive95_b0",
b."eDt_Complete95_b0",
b."eDtr_Complete95_b0",
b."eDt_Collapse95_b0",
b."eDtr_Collapse95_b0",
b."eDt_Fail_Collapse95_b0",
b."eDt_Slight_r1",
b."eDtr_Slight_r1",
b."eDt_Moderate_r1",
b."eDtr_Moderate_r1",
b."eDt_Extensive_r1",
b."eDtr_Extensive_r1",
b."eDt_Complete_r1",
b."eDtr_Complete_r1",
b."eDt_Collapse_r1",
b."eDtr_Collapse_r1",
b."eDt_Fail_Collapse_r1",
b."eDt_Slight05_r1",
b."eDtr_Slight05_r1",
b."eDt_Moderate05_r1",
b."eDtr_Moderate05_r1",
b."eDt_Extensive05_r1",
b."eDtr_Extensive05_r1",
b."eDt_Complete05_r1",
b."eDtr_Complete05_r1",
b."eDt_Collapse05_r1",
b."eDtr_Collapse05_r1",
b."eDt_Fail_Collapse05_r1",
b."eDt_Slight95_r1",
b."eDtr_Slight95_r1",
b."eDt_Moderate95_r1",
b."eDtr_Moderate95_r1",
b."eDt_Extensive95_r1",
b."eDtr_Extensive95_r1",
b."eDt_Complete95_r1",
b."eDtr_Complete_95r1",
b."eDt_Collapse95_r1",
b."eDtr_Collapse95_r1",
b."eDt_Fail_Collapse95_r1",
b."eC_Fatality_b0",
b."eCr_Fatality_b0",
b."eC_Fatality_r1",
b."eCr_Fatality_r1",
b."eAALt_Asset_b0",
b."eAALm_Asset_b0",
b."eAALt_Bldg_b0",
b."eAALm_Bldg_b0",
b."eAALt_Str_b0",
b."eAALt_NStr_b0",
b."eAALt_Cont_b0",
b."eAALt_Asset_r1",
b."eAALm_Asset_r1",
b."eAALt_Bldg_r1",
b."eAALm_Bldg_r1",
b."eAALt_Str_r1",
b."eAALt_NStr_r1",
b."eAALt_Cont_r1",
CAST(CAST(ROUND(CAST(c.eqri_abs_cbrt_minmax_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eqri_abs_score_b0",
c.eqri_abs_rating_b0 AS "eqri_abs_rank_b0",
CAST(CAST(ROUND(CAST(c.eqri_norm_cbrt_minmax_b0 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eqri_norm_score_b0",
c.eqri_norm_rating_b0 AS "eqri_norm_rank_b0",
CAST(CAST(ROUND(CAST(c.eqri_abs_cbrt_minmax_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eqri_abs_score_r1",
c.eqri_abs_rating_r1 AS "eqri_abs_rank_r1",
CAST(CAST(ROUND(CAST(c.eqri_norm_cbrt_minmax_r1 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "eqri_norm_score_r1",
c.eqri_norm_rating_r1 AS "eqri_norm_rank_r1",
a.geom

FROM boundaries."Geometry_CSDUID" a
LEFT JOIN results_psra_national.psra_indicators_csd_tbl  b ON a."CSDUID" = b.csduid
LEFT JOIN results_psra_national.psra_sri_calc_csd c ON b.csduid = c.csduid;



-- update percentilerank, normalized score on P/T eqriskindex csd table
UPDATE results_psra_ab.psra_ab_eqriskindex_csd b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_bc.psra_bc_eqriskindex_csd b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_mb.psra_mb_eqriskindex_csd b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_nb.psra_nb_eqriskindex_csd b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_nl.psra_nl_eqriskindex_csd b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_ns.psra_ns_eqriskindex_csd b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_nt.psra_nt_eqriskindex_csd b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_nu.psra_nu_eqriskindex_csd b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_on.psra_on_eqriskindex_csd b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_pe.psra_pe_eqriskindex_csd b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_qc.psra_qc_eqriskindex_csd b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_sk.psra_sk_eqriskindex_csd b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_csd a
WHERE a.csduid = b.csduid;

UPDATE results_psra_yt.psra_yt_eqriskindex_csd b
SET eqri_abs_score_b0 = a.eqri_abs_cbrt_minmax_b0,
	eqri_abs_rank_b0 = a.eqri_abs_rating_b0,
	eqri_norm_score_b0 = a.eqri_norm_cbrt_minmax_b0,
	eqri_norm_rank_b0 = a.eqri_norm_rating_b0,
	eqri_abs_score_r1 = a.eqri_abs_cbrt_minmax_r1,
	eqri_abs_rank_r1 = a.eqri_abs_rating_r1,
	eqri_norm_score_r1 = a.eqri_norm_cbrt_minmax_r1,
	eqri_norm_rank_r1 = a.eqri_norm_rating_r1
FROM results_psra_national.psra_sri_calc_csd a
WHERE a.csduid = b.csduid;