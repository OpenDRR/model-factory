
-- change new PK / add indexes HexGrid_1km_900913
ALTER TABLE boundaries."HexGrid_1km_AB_900913" DROP CONSTRAINT IF EXISTS "HexGrid_1km_AB_900913_pkey";
ALTER TABLE boundaries."HexGrid_1km_AB_900913" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_AB_900913_idx ON boundaries."HexGrid_1km_AB_900913"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_AB_900913_idx ON boundaries."HexGrid_1km_AB_900913" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_900913
ALTER TABLE boundaries."HexGrid_1km_BC_900913" DROP CONSTRAINT IF EXISTS "HexGrid_1km_BC_900913_pkey";
ALTER TABLE boundaries."HexGrid_1km_BC_900913" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_BC_900913_idx ON boundaries."HexGrid_1km_BC_900913"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_BC_900913_idx ON boundaries."HexGrid_1km_BC_900913" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_900913
ALTER TABLE boundaries."HexGrid_1km_MB_900913" DROP CONSTRAINT IF EXISTS "HexGrid_1km_MB_900913_pkey";
ALTER TABLE boundaries."HexGrid_1km_MB_900913" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_MB_900913_idx ON boundaries."HexGrid_1km_MB_900913"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_MB_900913_idx ON boundaries."HexGrid_1km_MB_900913" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_900913
ALTER TABLE boundaries."HexGrid_1km_NB_900913" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NB_900913_pkey";
ALTER TABLE boundaries."HexGrid_1km_NB_900913" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_NB_900913_idx ON boundaries."HexGrid_1km_NB_900913"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_NB_900913_idx ON boundaries."HexGrid_1km_NB_900913" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_900913
ALTER TABLE boundaries."HexGrid_1km_NL_900913" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NL_900913_pkey";
ALTER TABLE boundaries."HexGrid_1km_NL_900913" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_NL_900913_idx ON boundaries."HexGrid_1km_NL_900913"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_NL_900913_idx ON boundaries."HexGrid_1km_NL_900913" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_900913
ALTER TABLE boundaries."HexGrid_1km_NS_900913" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NS_900913_pkey";
ALTER TABLE boundaries."HexGrid_1km_NS_900913" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_NS_900913_idx ON boundaries."HexGrid_1km_NS_900913"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_NS_900913_idx ON boundaries."HexGrid_1km_NS_900913" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_900913
ALTER TABLE boundaries."HexGrid_1km_NT_900913" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NT_900913_pkey";
ALTER TABLE boundaries."HexGrid_1km_NT_900913" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_NT_900913_idx ON boundaries."HexGrid_1km_NT_900913"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_NT_900913_idx ON boundaries."HexGrid_1km_NT_900913" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_900913
ALTER TABLE boundaries."HexGrid_1km_NU_900913" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NU_900913_pkey";
ALTER TABLE boundaries."HexGrid_1km_NU_900913" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_NU_900913_idx ON boundaries."HexGrid_1km_NU_900913"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_NU_900913_idx ON boundaries."HexGrid_1km_NU_900913" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_900913
ALTER TABLE boundaries."HexGrid_1km_ON_900913" DROP CONSTRAINT IF EXISTS "HexGrid_1km_ON_900913_pkey";
ALTER TABLE boundaries."HexGrid_1km_ON_900913" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_ON_900913_idx ON boundaries."HexGrid_1km_ON_900913"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_ON_900913_idx ON boundaries."HexGrid_1km_ON_900913" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_900913
ALTER TABLE boundaries."HexGrid_1km_PE_900913" DROP CONSTRAINT IF EXISTS "HexGrid_1km_PE_900913_pkey";
ALTER TABLE boundaries."HexGrid_1km_PE_900913" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_PE_900913_idx ON boundaries."HexGrid_1km_PE_900913"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_PE_900913_idx ON boundaries."HexGrid_1km_PE_900913" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_900913
ALTER TABLE boundaries."HexGrid_1km_QC_900913" DROP CONSTRAINT IF EXISTS "HexGrid_1km_QC_900913_pkey";
ALTER TABLE boundaries."HexGrid_1km_QC_900913" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_QC_900913_idx ON boundaries."HexGrid_1km_QC_900913"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_QC_900913_idx ON boundaries."HexGrid_1km_QC_900913" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_900913
ALTER TABLE boundaries."HexGrid_1km_SK_900913" DROP CONSTRAINT IF EXISTS "HexGrid_1km_SK_900913_pkey";
ALTER TABLE boundaries."HexGrid_1km_SK_900913" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_SK_900913_idx ON boundaries."HexGrid_1km_SK_900913"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_SK_900913_idx ON boundaries."HexGrid_1km_SK_900913" using GIST(geom);

-- change new PK / add indexes HexGrid_1km_900913
ALTER TABLE boundaries."HexGrid_1km_YT_900913" DROP CONSTRAINT IF EXISTS "HexGrid_1km_YT_900913_pkey";
ALTER TABLE boundaries."HexGrid_1km_YT_900913" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_YT_900913_idx ON boundaries."HexGrid_1km_YT_900913"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_YT_900913_idx ON boundaries."HexGrid_1km_YT_900913" using GIST(geom);

-- change new PK / add indexes HexGrid_5km_900913
ALTER TABLE boundaries."HexGrid_5km_900913" DROP CONSTRAINT IF EXISTS "HexGrid_5km_900913_pkey";
ALTER TABLE boundaries."HexGrid_5km_900913" ADD PRIMARY KEY ("gridid_5");
CREATE INDEX IF NOT EXISTS hexgrid_5km_900913_gridid_5_idx ON boundaries."HexGrid_5km_900913"("gridid_5");
CREATE INDEX IF NOT EXISTS hexgrid_5km_900913_geom_idx ON boundaries."HexGrid_5km_900913" using GIST(geom);

-- change new PK / add indexes HexGrid_10km_900913
ALTER TABLE boundaries."HexGrid_10km_900913" DROP CONSTRAINT IF EXISTS "HexGrid_10km_900913_pkey";
ALTER TABLE boundaries."HexGrid_10km_900913" ADD PRIMARY KEY ("gridid_10");
CREATE INDEX IF NOT EXISTS hexgrid_10km_900913_gridid_5_idx ON boundaries."HexGrid_10km_900913"("gridid_10");
CREATE INDEX IF NOT EXISTS hexgrid_10km_900913_geom_idx ON boundaries."HexGrid_10km_900913" using GIST(geom);

-- change new PK / add indexes HexGrid_25km_900913
ALTER TABLE boundaries."HexGrid_25km_900913" DROP CONSTRAINT IF EXISTS "HexGrid_25km_900913_pkey";
ALTER TABLE boundaries."HexGrid_25km_900913" ADD PRIMARY KEY ("gridid_25");
CREATE INDEX IF NOT EXISTS hexgrid_25km_900913_gridid_5_idx ON boundaries."HexGrid_25km_900913"("gridid_25");
CREATE INDEX IF NOT EXISTS hexgrid_25km_900913_geom_idx ON boundaries."HexGrid_25km_900913" using GIST(geom);

-- change new PK / add indexes SAUID_5km_intersect_900913
ALTER TABLE boundaries."SAUID_HexGrid_5km_intersect_900913" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_5km_intersect_900913_pkey";
ALTER TABLE boundaries."SAUID_HexGrid_5km_intersect_900913" ADD PRIMARY KEY ("gridid_5","sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_5km_900913_sauid_idx ON boundaries."SAUID_HexGrid_5km_intersect_900913"("gridid_5","sauid");

-- change new PK / add indexes SAUID_10km_intersect_900913
ALTER TABLE boundaries."SAUID_HexGrid_10km_intersect_900913" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_10km_intersect_900913_pkey";
ALTER TABLE boundaries."SAUID_HexGrid_10km_intersect_900913" ADD PRIMARY KEY ("gridid_10","sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_10km_900913_sauid_idx ON boundaries."SAUID_HexGrid_10km_intersect_900913"("gridid_10","sauid");

-- change new PK / add indexes SAUID_25km_intersect_900913
ALTER TABLE boundaries."SAUID_HexGrid_25km_intersect_900913" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_25km_intersect_900913_pkey";
ALTER TABLE boundaries."SAUID_HexGrid_25km_intersect_900913" ADD PRIMARY KEY ("gridid_25","sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_25km_900913_sauid_idx ON boundaries."SAUID_HexGrid_25km_intersect_900913"("gridid_25","sauid");