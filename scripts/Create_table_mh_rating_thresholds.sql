-- create lookup table for multi hazard thresholds value to be used
DROP TABLE IF EXISTS mh.mh_ratings_thresholds CASCADE;

-- create table
CREATE TABLE mh.mh_ratings_thresholds(
    PRIMARY KEY(impact_potential),
    impact_potential varchar,
    rel_score float,
    exp_pp float,
    exp_frm float,
    exp_to float,
    pga_pp_frm float,
    pga_pp_to float,
    pga_bldg_asset_frm float,
    pga_bldg_asset_to float,
    fld_tsun_pp_frm float,
    fld_tsun_pp_to float,
    fld_tsun_bldg_asset_frm float,
    fld_tsun_bldg_asset_to float,
    wildfire_pp_frm float,
    wildfire_pp_to float,
    wildfire_bldg_asset_frm float,
    wildfire_bldg_asset_to float,
    cy_ppl_frm float,
    cy_ppl_to float,
    cy_bldg_asset_frm float,
	cy_bldg_asset_to float
);