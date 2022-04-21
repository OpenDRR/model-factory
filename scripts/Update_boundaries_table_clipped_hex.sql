-- add additional geometries field to enable PostGIS point (WGS1984 SRID = 4326)
ALTER TABLE boundaries."Geometry_SAUID" ADD COLUMN IF NOT EXISTS geompoint geometry(Point,4326);
UPDATE boundaries."Geometry_SAUID" SET geompoint = st_setsrid(st_makepoint("Lon","Lat"),4326);

-- change new PK / add indexes Geometry_SAUID
ALTER TABLE boundaries."Geometry_SAUID" DROP CONSTRAINT IF EXISTS "Geometry_SAUID_pkey";
ALTER TABLE boundaries."Geometry_SAUID" ADD PRIMARY KEY ("SAUIDt");
CREATE INDEX IF NOT EXISTS geometry_sauid_sauid_idx ON boundaries."Geometry_SAUID"("SAUIDt");
CREATE INDEX IF NOT EXISTS geometry_sauid_geom_idx ON boundaries."Geometry_SAUID" using GIST(geom);
CREATE INDEX IF NOT EXISTS geometry_sauid_geom_point_idx ON boundaries."Geometry_SAUID" using GIST(geompoint);

-- change new PK / add indexes Geometry_ADAUID
ALTER TABLE boundaries."Geometry_ADAUID" DROP CONSTRAINT IF EXISTS "Geometry_ADAUID_pkey";
ALTER TABLE boundaries."Geometry_ADAUID" ADD PRIMARY KEY ("ADAUID");
CREATE INDEX IF NOT EXISTS geometry_adauid_adauid_idx ON boundaries."Geometry_ADAUID"("ADAUID");
CREATE INDEX IF NOT EXISTS geometry_adauid_geom_idx ON boundaries."Geometry_ADAUID" using GIST(geom);

-- change new PK / add indexes Geometry_CANADA
ALTER TABLE boundaries."Geometry_CANADA" DROP CONSTRAINT IF EXISTS "Geometry_CANADA_pkey";
ALTER TABLE boundaries."Geometry_CANADA" ADD PRIMARY KEY ("Country");
CREATE INDEX IF NOT EXISTS geometry_canada_fid_idx ON boundaries."Geometry_CANADA"("Country");
CREATE INDEX IF NOT EXISTS geometry_canada_geom_idx ON boundaries."Geometry_CANADA" using GIST(geom);

-- change new PK / add indexes Geometry_CDUID
ALTER TABLE boundaries."Geometry_CDUID" DROP CONSTRAINT IF EXISTS "Geometry_CDUID_pkey";
ALTER TABLE boundaries."Geometry_CDUID" ADD PRIMARY KEY ("CDUID");
CREATE INDEX IF NOT EXISTS geometry_cduid_cduid_idx ON boundaries."Geometry_CDUID"("CDUID");
CREATE INDEX IF NOT EXISTS geometry_cduid_geom_idx ON boundaries."Geometry_CDUID" using GIST(geom);

-- change new PK / add indexes Geometry_CSDUID
ALTER TABLE boundaries."Geometry_CSDUID" DROP CONSTRAINT IF EXISTS "Geometry_CSDUID_pkey";
ALTER TABLE boundaries."Geometry_CSDUID" ADD PRIMARY KEY ("CSDUID");
CREATE INDEX IF NOT EXISTS geometry_csduid_csduid_idx ON boundaries."Geometry_CSDUID"("CSDUID");
CREATE INDEX IF NOT EXISTS geometry_csduid_geom_idx ON boundaries."Geometry_CSDUID" using GIST(geom);

-- change new PK / add indexes Geometry_DAUID
ALTER TABLE boundaries."Geometry_DAUID" DROP CONSTRAINT IF EXISTS "Geometry_DAUID_pkey";
ALTER TABLE boundaries."Geometry_DAUID" ADD PRIMARY KEY ("DAUID");
CREATE INDEX IF NOT EXISTS geometry_dauid_dauid_idx ON boundaries."Geometry_DAUID"("DAUID");
CREATE INDEX IF NOT EXISTS geometry_dauid_geom_idx ON boundaries."Geometry_DAUID" using GIST(geom);

-- change new PK / add indexes Geometry_ERUID
ALTER TABLE boundaries."Geometry_ERUID" DROP CONSTRAINT IF EXISTS "Geometry_ERUID_pkey";
ALTER TABLE boundaries."Geometry_ERUID" ADD PRIMARY KEY ("ERUID");
CREATE INDEX IF NOT EXISTS geometry_eruid_eruid_idx ON boundaries."Geometry_ERUID"("ERUID");
CREATE INDEX IF NOT EXISTS geometry_eruid_geom_idx ON boundaries."Geometry_ERUID" using GIST(geom);

-- change new PK / add indexes Geometry_FSAUID
ALTER TABLE boundaries."Geometry_FSAUID" DROP CONSTRAINT IF EXISTS "Geometry_FSAUID_pkey";
ALTER TABLE boundaries."Geometry_FSAUID" ADD PRIMARY KEY ("CFSAUID");
CREATE INDEX IF NOT EXISTS geometry_fsauid_fsauid_idx ON boundaries."Geometry_FSAUID"("CFSAUID");
CREATE INDEX IF NOT EXISTS geometry_fsauid_geom_idx ON boundaries."Geometry_FSAUID" using GIST(geom);

-- change new PK / add indexes Geometry_PRUID
ALTER TABLE boundaries."Geometry_PRUID" DROP CONSTRAINT IF EXISTS "Geometry_PRUID_pkey";
ALTER TABLE boundaries."Geometry_PRUID" ADD PRIMARY KEY ("PRUID");
CREATE INDEX IF NOT EXISTS geometry_pruid_pruid_idx ON boundaries."Geometry_PRUID"("PRUID");
CREATE INDEX IF NOT EXISTS geometry_prauid_geom_idx ON boundaries."Geometry_PRUID" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_AB" DROP CONSTRAINT IF EXISTS "HexGrid_1km_AB_pkey";
ALTER TABLE boundaries."HexGrid_1km_AB" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_ab_idx ON boundaries."HexGrid_1km_AB"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_ab_idx ON boundaries."HexGrid_1km_AB" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_BC" DROP CONSTRAINT IF EXISTS "HexGrid_1km_BC_pkey";
ALTER TABLE boundaries."HexGrid_1km_BC" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_bc_idx ON boundaries."HexGrid_1km_BC"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_bc_idx ON boundaries."HexGrid_1km_BC" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_MB" DROP CONSTRAINT IF EXISTS "HexGrid_1km_MB_pkey";
ALTER TABLE boundaries."HexGrid_1km_MB" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_mb_idx ON boundaries."HexGrid_1km_MB"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_mb_idx ON boundaries."HexGrid_1km_MB" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_NB" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NB_pkey";
ALTER TABLE boundaries."HexGrid_1km_NB" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_nb_idx ON boundaries."HexGrid_1km_NB"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_nb_idx ON boundaries."HexGrid_1km_NB" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_NL" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NL_pkey";
ALTER TABLE boundaries."HexGrid_1km_NL" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_nl_idx ON boundaries."HexGrid_1km_NL"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_nl_idx ON boundaries."HexGrid_1km_NL" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_NS" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NS_pkey";
ALTER TABLE boundaries."HexGrid_1km_NS" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_ns_idx ON boundaries."HexGrid_1km_NS"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_ns_idx ON boundaries."HexGrid_1km_NS" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_NT" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NT_pkey";
ALTER TABLE boundaries."HexGrid_1km_NT" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_nt_idx ON boundaries."HexGrid_1km_NT"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_nt_idx ON boundaries."HexGrid_1km_NT" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_NU" DROP CONSTRAINT IF EXISTS "HexGrid_1km_NU_pkey";
ALTER TABLE boundaries."HexGrid_1km_NU" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_nu_idx ON boundaries."HexGrid_1km_NU"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_nu_idx ON boundaries."HexGrid_1km_NU" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_ON" DROP CONSTRAINT IF EXISTS "HexGrid_1km_ON_pkey";
ALTER TABLE boundaries."HexGrid_1km_ON" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_on_idx ON boundaries."HexGrid_1km_ON"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_on_idx ON boundaries."HexGrid_1km_ON" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_PE" DROP CONSTRAINT IF EXISTS "HexGrid_1km_PE_pkey";
ALTER TABLE boundaries."HexGrid_1km_PE" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_pe_idx ON boundaries."HexGrid_1km_PE"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_pe_idx ON boundaries."HexGrid_1km_PE" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_QC" DROP CONSTRAINT IF EXISTS "HexGrid_1km_QC_pkey";
ALTER TABLE boundaries."HexGrid_1km_QC" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_qc_idx ON boundaries."HexGrid_1km_QC"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_qc_idx ON boundaries."HexGrid_1km_QC" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_SK" DROP CONSTRAINT IF EXISTS "HexGrid_1km_SK_pkey";
ALTER TABLE boundaries."HexGrid_1km_SK" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_sk_idx ON boundaries."HexGrid_1km_SK"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_sk_idx ON boundaries."HexGrid_1km_SK" using GIST(geom);

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_YT" DROP CONSTRAINT IF EXISTS "HexGrid_1km_YT_pkey";
ALTER TABLE boundaries."HexGrid_1km_YT" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_yt_idx ON boundaries."HexGrid_1km_YT"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_yt_idx ON boundaries."HexGrid_1km_YT" using GIST(geom);

-- change new PK / add indexes HexGrid_5km
ALTER TABLE boundaries."HexGrid_5km" DROP CONSTRAINT IF EXISTS "HexGrid_5km_pkey";
ALTER TABLE boundaries."HexGrid_5km" ADD PRIMARY KEY ("gridid_5");
CREATE INDEX IF NOT EXISTS hexgrid_5km_gridid_5_idx ON boundaries."HexGrid_5km"("gridid_5");
CREATE INDEX IF NOT EXISTS hexgrid_5km_geom_idx ON boundaries."HexGrid_5km" using GIST(geom);

-- change new PK / add indexes HexGrid_10km
ALTER TABLE boundaries."HexGrid_10km" DROP CONSTRAINT IF EXISTS "HexGrid_10km_pkey";
ALTER TABLE boundaries."HexGrid_10km" ADD PRIMARY KEY ("gridid_10");
CREATE INDEX IF NOT EXISTS hexgrid_10km_gridid_5_idx ON boundaries."HexGrid_10km"("gridid_10");
CREATE INDEX IF NOT EXISTS hexgrid_10km_geom_idx ON boundaries."HexGrid_10km" using GIST(geom);

-- change new PK / add indexes HexGrid_25km
ALTER TABLE boundaries."HexGrid_25km" DROP CONSTRAINT IF EXISTS "HexGrid_25km_pkey";
ALTER TABLE boundaries."HexGrid_25km" ADD PRIMARY KEY ("gridid_25");
CREATE INDEX IF NOT EXISTS hexgrid_25km_gridid_5_idx ON boundaries."HexGrid_25km"("gridid_25");
CREATE INDEX IF NOT EXISTS hexgrid_25km_geom_idx ON boundaries."HexGrid_25km" using GIST(geom);

-- change new PK / add indexes SAUID_HexGrid
ALTER TABLE boundaries."SAUID_HexGrid" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_pkey";
ALTER TABLE boundaries."SAUID_HexGrid" ADD PRIMARY KEY ("sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_sauid_idx ON boundaries."SAUID_HexGrid"("sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_geom_idx ON boundaries."SAUID_HexGrid" using GIST(geom);

-- change new PK / add indexes SAUID_5km_intersect
ALTER TABLE boundaries."SAUID_HexGrid_5km_intersect" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_5km_intersect_pkey";
ALTER TABLE boundaries."SAUID_HexGrid_5km_intersect" ADD PRIMARY KEY ("gridid_5","sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_5km_sauid_idx ON boundaries."SAUID_HexGrid_5km_intersect"("gridid_5","sauid");

-- change new PK / add indexes SAUID_10km_intersect
ALTER TABLE boundaries."SAUID_HexGrid_10km_intersect" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_10km_intersect_pkey";
ALTER TABLE boundaries."SAUID_HexGrid_10km_intersect" ADD PRIMARY KEY ("gridid_10","sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_10km_sauid_idx ON boundaries."SAUID_HexGrid_10km_intersect"("gridid_10","sauid");

-- change new PK / add indexes SAUID_25km_intersect
ALTER TABLE boundaries."SAUID_HexGrid_25km_intersect" DROP CONSTRAINT IF EXISTS "SAUID_HexGrid_25km_intersect_pkey";
ALTER TABLE boundaries."SAUID_HexGrid_25km_intersect" ADD PRIMARY KEY ("gridid_25","sauid");
CREATE INDEX IF NOT EXISTS sauid_hexgrid_25km_sauid_idx ON boundaries."SAUID_HexGrid_25km_intersect"("gridid_25","sauid");