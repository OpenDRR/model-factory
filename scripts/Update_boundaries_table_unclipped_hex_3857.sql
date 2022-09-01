
-- change new PK / add indexes HexGrid_1km_unclipped_3857
ALTER TABLE boundaries."HexGrid_1km_AB_unclipped_3857" DROP CONSTRAINT IF EXISTS "HexGrid_1km_AB_unclipped_3857_pkey";
ALTER TABLE boundaries."HexGrid_1km_AB_unclipped_3857" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_AB_unclipped_3857_idx ON boundaries."HexGrid_1km_AB_unclipped_3857"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_AB_unclipped_3857_idx ON boundaries."HexGrid_1km_AB_unclipped_3857" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_unclipped_3857
ALTER TABLE boundaries."HexGrid_1km_BC_unclipped_3857" DROP CONSTRAINT IF EXISTS "HexGrid_1km_BC_unclipped_3857_pkey";
ALTER TABLE boundaries."HexGrid_1km_BC_unclipped_3857" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_BC_unclipped_3857_idx ON boundaries."HexGrid_1km_BC_unclipped_3857"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_BC_unclipped_3857_idx ON boundaries."HexGrid_1km_BC_unclipped_3857" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_unclipped_3857
ALTER TABLE boundaries."HexGrid_1km_MB_unclipped_3857" DROP CONSTRAINT IF EXISTS "HexGrid_1km_MB_unclipped_3857_pkey";
ALTER TABLE boundaries."HexGrid_1km_MB_unclipped_3857" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_MB_unclipped_3857_idx ON boundaries."HexGrid_1km_MB_unclipped_3857"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_MB_unclipped_3857_idx ON boundaries."HexGrid_1km_MB_unclipped_3857" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_unclipped_3857
ALTER TABLE boundaries."HexGrid_1km_NB_unclipped_3857" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NB_unclipped_3857_pkey";
ALTER TABLE boundaries."HexGrid_1km_NB_unclipped_3857" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_NB_unclipped_3857_idx ON boundaries."HexGrid_1km_NB_unclipped_3857"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_NB_unclipped_3857_idx ON boundaries."HexGrid_1km_NB_unclipped_3857" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_unclipped_3857
ALTER TABLE boundaries."HexGrid_1km_NL_unclipped_3857" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NL_unclipped_3857_pkey";
ALTER TABLE boundaries."HexGrid_1km_NL_unclipped_3857" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_NL_unclipped_3857_idx ON boundaries."HexGrid_1km_NL_unclipped_3857"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_NL_unclipped_3857_idx ON boundaries."HexGrid_1km_NL_unclipped_3857" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_unclipped_3857
ALTER TABLE boundaries."HexGrid_1km_NS_unclipped_3857" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NS_unclipped_3857_pkey";
ALTER TABLE boundaries."HexGrid_1km_NS_unclipped_3857" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_NS_unclipped_3857_idx ON boundaries."HexGrid_1km_NS_unclipped_3857"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_NS_unclipped_3857_idx ON boundaries."HexGrid_1km_NS_unclipped_3857" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_unclipped_3857
ALTER TABLE boundaries."HexGrid_1km_NT_unclipped_3857" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NT_unclipped_3857_pkey";
ALTER TABLE boundaries."HexGrid_1km_NT_unclipped_3857" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_NT_unclipped_3857_idx ON boundaries."HexGrid_1km_NT_unclipped_3857"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_NT_unclipped_3857_idx ON boundaries."HexGrid_1km_NT_unclipped_3857" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_unclipped_3857
ALTER TABLE boundaries."HexGrid_1km_NU_unclipped_3857" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NU_unclipped_3857_pkey";
ALTER TABLE boundaries."HexGrid_1km_NU_unclipped_3857" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_NU_unclipped_3857_idx ON boundaries."HexGrid_1km_NU_unclipped_3857"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_NU_unclipped_3857_idx ON boundaries."HexGrid_1km_NU_unclipped_3857" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_unclipped_3857
ALTER TABLE boundaries."HexGrid_1km_ON_unclipped_3857" DROP CONSTRAINT IF EXISTS "HexGrid_1km_ON_unclipped_3857_pkey";
ALTER TABLE boundaries."HexGrid_1km_ON_unclipped_3857" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_ON_unclipped_3857_idx ON boundaries."HexGrid_1km_ON_unclipped_3857"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_ON_unclipped_3857_idx ON boundaries."HexGrid_1km_ON_unclipped_3857" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_unclipped_3857
ALTER TABLE boundaries."HexGrid_1km_PE_unclipped_3857" DROP CONSTRAINT IF EXISTS "HexGrid_1km_PE_unclipped_3857_pkey";
ALTER TABLE boundaries."HexGrid_1km_PE_unclipped_3857" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_PE_unclipped_3857_idx ON boundaries."HexGrid_1km_PE_unclipped_3857"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_PE_unclipped_3857_idx ON boundaries."HexGrid_1km_PE_unclipped_3857" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_unclipped_3857
ALTER TABLE boundaries."HexGrid_1km_QC_unclipped_3857" DROP CONSTRAINT IF EXISTS "HexGrid_1km_QC_unclipped_3857_pkey";
ALTER TABLE boundaries."HexGrid_1km_QC_unclipped_3857" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_QC_unclipped_3857_idx ON boundaries."HexGrid_1km_QC_unclipped_3857"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_QC_unclipped_3857_idx ON boundaries."HexGrid_1km_QC_unclipped_3857" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_unclipped_3857
ALTER TABLE boundaries."HexGrid_1km_SK_unclipped_3857" DROP CONSTRAINT IF EXISTS "HexGrid_1km_SK_unclipped_3857_pkey";
ALTER TABLE boundaries."HexGrid_1km_SK_unclipped_3857" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_SK_unclipped_3857_idx ON boundaries."HexGrid_1km_SK_unclipped_3857"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_SK_unclipped_3857_idx ON boundaries."HexGrid_1km_SK_unclipped_3857" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_unclipped_3857
ALTER TABLE boundaries."HexGrid_1km_YT_unclipped_3857" DROP CONSTRAINT IF EXISTS "HexGrid_1km_YT_unclipped_3857_pkey";
ALTER TABLE boundaries."HexGrid_1km_YT_unclipped_3857" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_YT_unclipped_3857_idx ON boundaries."HexGrid_1km_YT_unclipped_3857"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_YT_unclipped_3857_idx ON boundaries."HexGrid_1km_YT_unclipped_3857" using GIST(geom);

-- change new PK / add indexes HexGrid_5km_unclipped_3857
ALTER TABLE boundaries."HexGrid_5km_unclipped_3857" DROP CONSTRAINT IF EXISTS "HexGrid_5km_unclipped_3857_pkey";
ALTER TABLE boundaries."HexGrid_5km_unclipped_3857" ADD PRIMARY KEY ("gridid_5");
CREATE INDEX IF NOT EXISTS hexgrid_5km_unclipped_3857_gridid_5_idx ON boundaries."HexGrid_5km_unclipped_3857"("gridid_5");
CREATE INDEX IF NOT EXISTS hexgrid_5km_unclipped_3857_geom_idx ON boundaries."HexGrid_5km_unclipped_3857" using GIST(geom);

-- change new PK / add indexes HexGrid_10km_unclipped_3857
ALTER TABLE boundaries."HexGrid_10km_unclipped_3857" DROP CONSTRAINT IF EXISTS "HexGrid_10km_unclipped_3857_pkey";
ALTER TABLE boundaries."HexGrid_10km_unclipped_3857" ADD PRIMARY KEY ("gridid_10");
CREATE INDEX IF NOT EXISTS hexgrid_10km_unclipped_3857_gridid_5_idx ON boundaries."HexGrid_10km_unclipped_3857"("gridid_10");
CREATE INDEX IF NOT EXISTS hexgrid_10km_unclipped_3857_geom_idx ON boundaries."HexGrid_10km_unclipped_3857" using GIST(geom);

-- change new PK / add indexes HexGrid_25km_unclipped_3857
ALTER TABLE boundaries."HexGrid_25km_unclipped_3857" DROP CONSTRAINT IF EXISTS "HexGrid_25km_unclipped_3857_pkey";
ALTER TABLE boundaries."HexGrid_25km_unclipped_3857" ADD PRIMARY KEY ("gridid_25");
CREATE INDEX IF NOT EXISTS hexgrid_25km_unclipped_3857_gridid_5_idx ON boundaries."HexGrid_25km_unclipped_3857"("gridid_25");
CREATE INDEX IF NOT EXISTS hexgrid_25km_unclipped_3857_geom_idx ON boundaries."HexGrid_25km_unclipped_3857" using GIST(geom);

-- change new PK / add indexes SAUID_5km_intersect_unclipped_3857
ALTER TABLE boundaries."SAUID_HexGrid_5km_intersect_unclipped_3857" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_5km_intersect_unclipped_3857_pkey";
ALTER TABLE boundaries."SAUID_HexGrid_5km_intersect_unclipped_3857" ADD PRIMARY KEY ("gridid_5","sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_5km_unclipped_3857_sauid_idx ON boundaries."SAUID_HexGrid_5km_intersect_unclipped_3857"("gridid_5","sauid");

-- change new PK / add indexes SAUID_10km_intersect_unclipped_3857
ALTER TABLE boundaries."SAUID_HexGrid_10km_intersect_unclipped_3857" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_10km_intersect_unclipped_3857_pkey";
ALTER TABLE boundaries."SAUID_HexGrid_10km_intersect_unclipped_3857" ADD PRIMARY KEY ("gridid_10","sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_10km_unclipped_3857_sauid_idx ON boundaries."SAUID_HexGrid_10km_intersect_unclipped_3857"("gridid_10","sauid");

-- change new PK / add indexes SAUID_25km_intersect_unclipped_3857
ALTER TABLE boundaries."SAUID_HexGrid_25km_intersect_unclipped_3857" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_25km_intersect_unclipped_3857_pkey";
ALTER TABLE boundaries."SAUID_HexGrid_25km_intersect_unclipped_3857" ADD PRIMARY KEY ("gridid_25","sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_25km_unclipped_3857_sauid_idx ON boundaries."SAUID_HexGrid_25km_intersect_unclipped_3857"("gridid_25","sauid");

-- change new PK / add indexes SAUID_50km_intersect_unclipped_3857
ALTER TABLE boundaries."SAUID_HexGrid_50km_intersect_unclipped_3857" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_50km_intersect_unclipped_3857_pkey";
ALTER TABLE boundaries."SAUID_HexGrid_50km_intersect_unclipped_3857" ADD PRIMARY KEY ("gridid_50","sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_50km_unclipped_3857_sauid_idx ON boundaries."SAUID_HexGrid_50km_intersect_unclipped_3857"("gridid_50","sauid");

-- change new PK / add indexes SAUID_100km_intersect_unclipped_3857
ALTER TABLE boundaries."SAUID_HexGrid_100km_intersect_unclipped_3857" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_100km_intersect_unclipped_3857_pkey";
ALTER TABLE boundaries."SAUID_HexGrid_100km_intersect_unclipped_3857" ADD PRIMARY KEY ("gridid_100","sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_100km_unclipped_3857_sauid_idx ON boundaries."SAUID_HexGrid_100km_intersect_unclipped_3857"("gridid_100","sauid");