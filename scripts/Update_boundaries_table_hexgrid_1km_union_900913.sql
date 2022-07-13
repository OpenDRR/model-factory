-- union 1km hexgrid from P/T
DROP TABLE IF EXISTS boundaries."HexGrid_1km_900913" CASCADE;

CREATE TABLE boundaries."HexGrid_1km_900913" AS
SELECT * FROM boundaries."HexGrid_1km_AB_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_BC_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_MB_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_NB_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_NL_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_NS_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_NT_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_NU_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_ON_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_PE_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_QC_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_SK_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_YT_900913";

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_900913" DROP CONSTRAINT IF EXISTS "HexGrid_1km_900913_pkey";
ALTER TABLE boundaries."HexGrid_1km_900913" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_900913_gridid_1_idx ON boundaries."HexGrid_1km_900913"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_900913_geom_idx ON boundaries."HexGrid_1km_900913" using GIST(geom);

-- drop unused P/T tables
DROP TABLE IF EXISTS boundaries."HexGrid_1km_AB_900913",boundaries."HexGrid_1km_BC_900913",boundaries."HexGrid_1km_MB_900913",boundaries."HexGrid_1km_NB_900913",boundaries."HexGrid_1km_NL_900913",
boundaries."HexGrid_1km_NS_900913",boundaries."HexGrid_1km_NT_900913",boundaries."HexGrid_1km_NT_900913",boundaries."HexGrid_1km_NU_900913",boundaries."HexGrid_1km_ON_900913",boundaries."HexGrid_1km_PE_900913",
boundaries."HexGrid_1km_QC_900913",boundaries."HexGrid_1km_SK_900913",boundaries."HexGrid_1km_YT_900913";


-- union 1km hexgrid from P/T
DROP TABLE IF EXISTS boundaries."HexGrid_1km_unclipped_900913" CASCADE;

CREATE TABLE boundaries."HexGrid_1km_unclipped_900913" AS
SELECT * FROM boundaries."HexGrid_1km_AB_unclipped_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_BC_unclipped_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_MB_unclipped_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_NB_unclipped_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_NL_unclipped_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_NS_unclipped_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_NT_unclipped_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_NU_unclipped_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_ON_unclipped_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_PE_unclipped_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_QC_unclipped_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_SK_unclipped_900913"
UNION
SELECT * FROM boundaries."HexGrid_1km_YT_unclipped_900913";

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_unclipped_900913" DROP CONSTRAINT IF EXISTS "HexGrid_1km_unclipped_900913_pkey";
ALTER TABLE boundaries."HexGrid_1km_unclipped_900913" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_900913_gridid_1_unclipped_idx ON boundaries."HexGrid_1km_unclipped_900913"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_900913_geom_unclipped_idx ON boundaries."HexGrid_1km_unclipped_900913" using GIST(geom);

-- drop unused P/T tables
DROP TABLE IF EXISTS boundaries."HexGrid_1km_AB_unclipped_900913",boundaries."HexGrid_1km_BC_unclipped_900913",boundaries."HexGrid_1km_MB_unclipped_900913",boundaries."HexGrid_1km_NB_unclipped_900913",
boundaries."HexGrid_1km_NL_unclipped_900913",boundaries."HexGrid_1km_NS_unclipped_900913",boundaries."HexGrid_1km_NT_unclipped_900913",boundaries."HexGrid_1km_NU_unclipped_900913",
boundaries."HexGrid_1km_ON_unclipped_900913",boundaries."HexGrid_1km_PE_unclipped_900913",boundaries."HexGrid_1km_QC_unclipped_900913",boundaries."HexGrid_1km_SK_unclipped_900913",
boundaries."HexGrid_1km_YT_unclipped_900913";