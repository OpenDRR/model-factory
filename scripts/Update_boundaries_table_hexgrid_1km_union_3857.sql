-- union 1km hexgrid from P/T
DROP TABLE IF EXISTS boundaries."HexGrid_1km_3857" CASCADE;

CREATE TABLE boundaries."HexGrid_1km_3857" AS
SELECT * FROM boundaries."HexGrid_1km_AB_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_BC_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_MB_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_NB_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_NL_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_NS_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_NT_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_NU_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_ON_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_PE_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_QC_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_SK_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_YT_3857";

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_3857" DROP CONSTRAINT IF EXISTS "HexGrid_1km_3857_pkey";
ALTER TABLE boundaries."HexGrid_1km_3857" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_3857_gridid_1_idx ON boundaries."HexGrid_1km_3857"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_3857_geom_idx ON boundaries."HexGrid_1km_3857" using GIST(geom);

-- drop unused P/T tables
DROP TABLE IF EXISTS boundaries."HexGrid_1km_AB_3857",boundaries."HexGrid_1km_BC_3857",boundaries."HexGrid_1km_MB_3857",boundaries."HexGrid_1km_NB_3857",boundaries."HexGrid_1km_NL_3857",
boundaries."HexGrid_1km_NS_3857",boundaries."HexGrid_1km_NT_3857",boundaries."HexGrid_1km_NT_3857",boundaries."HexGrid_1km_NU_3857",boundaries."HexGrid_1km_ON_3857",boundaries."HexGrid_1km_PE_3857",
boundaries."HexGrid_1km_QC_3857",boundaries."HexGrid_1km_SK_3857",boundaries."HexGrid_1km_YT_3857";


-- union 1km hexgrid from P/T
DROP TABLE IF EXISTS boundaries."HexGrid_1km_unclipped_3857" CASCADE;

CREATE TABLE boundaries."HexGrid_1km_unclipped_3857" AS
SELECT * FROM boundaries."HexGrid_1km_AB_unclipped_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_BC_unclipped_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_MB_unclipped_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_NB_unclipped_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_NL_unclipped_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_NS_unclipped_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_NT_unclipped_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_NU_unclipped_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_ON_unclipped_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_PE_unclipped_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_QC_unclipped_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_SK_unclipped_3857"
UNION
SELECT * FROM boundaries."HexGrid_1km_YT_unclipped_3857";

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_unclipped_3857" DROP CONSTRAINT IF EXISTS "HexGrid_1km_unclipped_3857_pkey";
ALTER TABLE boundaries."HexGrid_1km_unclipped_3857" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_3857_gridid_1_unclipped_idx ON boundaries."HexGrid_1km_unclipped_3857"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_3857_geom_unclipped_idx ON boundaries."HexGrid_1km_unclipped_3857" using GIST(geom);

-- drop unused P/T tables
DROP TABLE IF EXISTS boundaries."HexGrid_1km_AB_unclipped_3857",boundaries."HexGrid_1km_BC_unclipped_3857",boundaries."HexGrid_1km_MB_unclipped_3857",boundaries."HexGrid_1km_NB_unclipped_3857",
boundaries."HexGrid_1km_NL_unclipped_3857",boundaries."HexGrid_1km_NS_unclipped_3857",boundaries."HexGrid_1km_NT_unclipped_3857",boundaries."HexGrid_1km_NU_unclipped_3857",
boundaries."HexGrid_1km_ON_unclipped_3857",boundaries."HexGrid_1km_PE_unclipped_3857",boundaries."HexGrid_1km_QC_unclipped_3857",boundaries."HexGrid_1km_SK_unclipped_3857",
boundaries."HexGrid_1km_YT_unclipped_3857";