-- unclipped 
-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_AB_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_1km_AB_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_1km_AB_unclipped" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_ab_unclipped_idx ON boundaries."HexGrid_1km_AB_unclipped"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_ab_unclipped_idx ON boundaries."HexGrid_1km_AB_unclipped" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_BC_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_1km_BC_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_1km_BC_unclipped" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_bc_unclipped_idx ON boundaries."HexGrid_1km_BC_unclipped"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_bc_unclipped_idx ON boundaries."HexGrid_1km_BC_unclipped" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_MB_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_1km_MB_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_1km_MB_unclipped" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_mb_unclipped_idx ON boundaries."HexGrid_1km_MB_unclipped"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_mb_unclipped_idx ON boundaries."HexGrid_1km_MB_unclipped" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_NB_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NB_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_1km_NB_unclipped" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_nb_unclipped_idx ON boundaries."HexGrid_1km_NB_unclipped"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_nb_unclipped_idx ON boundaries."HexGrid_1km_NB_unclipped" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_NL_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NL_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_1km_NL_unclipped" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_nl_unclipped_idx ON boundaries."HexGrid_1km_NL_unclipped"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_nl_unclipped_idx ON boundaries."HexGrid_1km_NL_unclipped" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_NS_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NS_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_1km_NS_unclipped" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_ns_unclipped_idx ON boundaries."HexGrid_1km_NS_unclipped"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_ns_unclipped_idx ON boundaries."HexGrid_1km_NS_unclipped" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_NT_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NT_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_1km_NT_unclipped" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_nt_unclipped_idx ON boundaries."HexGrid_1km_NT_unclipped"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_nt_unclipped_idx ON boundaries."HexGrid_1km_NT_unclipped" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_NU_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NU_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_1km_NU_unclipped" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_nu_unclipped_idx ON boundaries."HexGrid_1km_NU_unclipped"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_nu_unclipped_idx ON boundaries."HexGrid_1km_NU_unclipped" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_ON_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_1km_ON_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_1km_ON_unclipped" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_on_unclipped_idx ON boundaries."HexGrid_1km_ON_unclipped"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_on_unclipped_idx ON boundaries."HexGrid_1km_ON_unclipped" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_PE_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_1km_PE_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_1km_PE_unclipped" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_pe_unclipped_idx ON boundaries."HexGrid_1km_PE_unclipped"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_pe_unclipped_idx ON boundaries."HexGrid_1km_PE_unclipped" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_QC_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_1km_QC_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_1km_QC_unclipped" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_qc_unclipped_idx ON boundaries."HexGrid_1km_QC_unclipped"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_qc_unclipped_idx ON boundaries."HexGrid_1km_QC_unclipped" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_SK_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_1km_SK_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_1km_SK_unclipped" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_sk_unclipped_idx ON boundaries."HexGrid_1km_SK_unclipped"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_sk_unclipped_idx ON boundaries."HexGrid_1km_SK_unclipped" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_YT_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_1km_YT_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_1km_YT_unclipped" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_yt_unclipped_idx ON boundaries."HexGrid_1km_YT_unclipped"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_yt_unclipped_idx ON boundaries."HexGrid_1km_YT_unclipped" using GIST(geom);

-- change new PK / add indexes HexGrid_5km
ALTER TABLE boundaries."HexGrid_5km_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_5km_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_5km_unclipped" ADD PRIMARY KEY ("gridid_5");
CREATE INDEX IF NOT EXISTS hexgrid_5km_gridid_5_unclipped_idx ON boundaries."HexGrid_5km_unclipped"("gridid_5");
CREATE INDEX IF NOT EXISTS hexgrid_5km_geom_unclipped_idx ON boundaries."HexGrid_5km_unclipped" using GIST(geom);

-- change new PK / add indexes HexGrid_10km
ALTER TABLE boundaries."HexGrid_10km_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_10km_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_10km_unclipped" ADD PRIMARY KEY ("gridid_10");
CREATE INDEX IF NOT EXISTS hexgrid_10km_gridid_5_unclipped_idx ON boundaries."HexGrid_10km_unclipped"("gridid_10");
CREATE INDEX IF NOT EXISTS hexgrid_10km_geom_unclipped_idx ON boundaries."HexGrid_10km_unclipped" using GIST(geom);

-- change new PK / add indexes HexGrid_25km
ALTER TABLE boundaries."HexGrid_25km_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_25km_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_25km_unclipped" ADD PRIMARY KEY ("gridid_25");
CREATE INDEX IF NOT EXISTS hexgrid_25km_gridid_5_unclipped_idx ON boundaries."HexGrid_25km_unclipped"("gridid_25");
CREATE INDEX IF NOT EXISTS hexgrid_25km_geom_unclipped_idx ON boundaries."HexGrid_25km_unclipped" using GIST(geom);

-- change new PK / add indexes HexGrid_50km
ALTER TABLE boundaries."HexGrid_50km_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_50km_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_50km_unclipped" ADD PRIMARY KEY ("gridid_50");
CREATE INDEX IF NOT EXISTS hexgrid_50km_gridid_5_unclipped_idx ON boundaries."HexGrid_50km_unclipped"("gridid_50");
CREATE INDEX IF NOT EXISTS hexgrid_50km_geom_unclipped_idx ON boundaries."HexGrid_50km_unclipped" using GIST(geom);

-- change new PK / add indexes HexGrid_100km
ALTER TABLE boundaries."HexGrid_100km_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_100km_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_100km_unclipped" ADD PRIMARY KEY ("gridid_100");
CREATE INDEX IF NOT EXISTS hexgrid_100km_gridid_5_unclipped_idx ON boundaries."HexGrid_100km_unclipped"("gridid_100");
CREATE INDEX IF NOT EXISTS hexgrid_100km_geom_unclipped_idx ON boundaries."HexGrid_100km_unclipped" using GIST(geom);

-- change new PK / add indexes SAUID_HexGrid
ALTER TABLE boundaries."SAUID_HexGrid_unclipped" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_unclipped_pkey";
ALTER TABLE boundaries."SAUID_HexGrid_unclipped" ADD PRIMARY KEY ("sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_sauid_unclipped_idx ON boundaries."SAUID_HexGrid_unclipped"("sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_geom_unclipped_idx ON boundaries."SAUID_HexGrid_unclipped" using GIST(geom);

-- change new PK / add indexes SAUID_5km_intersect
ALTER TABLE boundaries."SAUID_HexGrid_5km_intersect_unclipped" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_5km_intersect_unclipped_pkey";
ALTER TABLE boundaries."SAUID_HexGrid_5km_intersect_unclipped" ADD PRIMARY KEY ("gridid_5","sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_5km_sauid_unclipped_idx ON boundaries."SAUID_HexGrid_5km_intersect_unclipped"("gridid_5","sauid");

-- change new PK / add indexes SAUID_10km_intersect
ALTER TABLE boundaries."SAUID_HexGrid_10km_intersect_unclipped" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_10km_intersect_unclipped_pkey";
ALTER TABLE boundaries."SAUID_HexGrid_10km_intersect_unclipped" ADD PRIMARY KEY ("gridid_10","sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_10km_sauid_unclipped_idx ON boundaries."SAUID_HexGrid_10km_intersect_unclipped"("gridid_10","sauid");

-- change new PK / add indexes SAUID_25km_intersect
ALTER TABLE boundaries."SAUID_HexGrid_25km_intersect_unclipped" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_25km_intersect_unclipped_pkey";
ALTER TABLE boundaries."SAUID_HexGrid_25km_intersect_unclipped" ADD PRIMARY KEY ("gridid_25","sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_25km_sauid_unclipped_idx ON boundaries."SAUID_HexGrid_25km_intersect_unclipped"("gridid_25","sauid");

-- change new PK / add indexes SAUID_50km_intersect
ALTER TABLE boundaries."SAUID_HexGrid_50km_intersect_unclipped" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_50km_intersect_unclipped_pkey";
ALTER TABLE boundaries."SAUID_HexGrid_50km_intersect_unclipped" ADD PRIMARY KEY ("gridid_50","sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_50km_sauid_unclipped_idx ON boundaries."SAUID_HexGrid_50km_intersect_unclipped"("gridid_50","sauid");

-- change new PK / add indexes SAUID_100km_intersect
ALTER TABLE boundaries."SAUID_HexGrid_100km_intersect_unclipped" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_100km_intersect_unclipped_pkey";
ALTER TABLE boundaries."SAUID_HexGrid_100km_intersect_unclipped" ADD PRIMARY KEY ("gridid_100","sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_100km_sauid_unclipped_idx ON boundaries."SAUID_HexGrid_100km_intersect_unclipped"("gridid_100","sauid");