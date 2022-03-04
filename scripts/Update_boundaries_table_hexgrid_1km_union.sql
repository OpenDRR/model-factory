-- union 1km hexgrid from P/T
DROP TABLE IF EXISTS boundaries."HexGrid_1km" CASCADE;

CREATE TABLE boundaries."HexGrid_1km" AS
SELECT * FROM boundaries."HexGrid_1km_AB"
UNION
SELECT * FROM boundaries."HexGrid_1km_BC"
UNION
SELECT * FROM boundaries."HexGrid_1km_MB"
UNION
SELECT * FROM boundaries."HexGrid_1km_NB"
UNION
SELECT * FROM boundaries."HexGrid_1km_NL"
UNION
SELECT * FROM boundaries."HexGrid_1km_NS"
UNION
SELECT * FROM boundaries."HexGrid_1km_NT"
UNION
SELECT * FROM boundaries."HexGrid_1km_NU"
UNION
SELECT * FROM boundaries."HexGrid_1km_ON"
UNION
SELECT * FROM boundaries."HexGrid_1km_PE"
UNION
SELECT * FROM boundaries."HexGrid_1km_QC"
UNION
SELECT * FROM boundaries."HexGrid_1km_SK"
UNION
SELECT * FROM boundaries."HexGrid_1km_YT";

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km" DROP CONSTRAINT IF EXISTS "HexGrid_1km_pkey";
ALTER TABLE boundaries."HexGrid_1km" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_idx ON boundaries."HexGrid_1km"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_idx ON boundaries."HexGrid_1km" using GIST(geom);



-- union 1km hexgrid from P/T
DROP TABLE IF EXISTS boundaries."HexGrid_1km_unclipped" CASCADE;

CREATE TABLE boundaries."HexGrid_1km_unclipped" AS
SELECT * FROM boundaries."HexGrid_1km_AB_unclipped"
UNION
SELECT * FROM boundaries."HexGrid_1km_BC_unclipped"
UNION
SELECT * FROM boundaries."HexGrid_1km_MB_unclipped"
UNION
SELECT * FROM boundaries."HexGrid_1km_NB_unclipped"
UNION
SELECT * FROM boundaries."HexGrid_1km_NL_unclipped"
UNION
SELECT * FROM boundaries."HexGrid_1km_NS_unclipped"
UNION
SELECT * FROM boundaries."HexGrid_1km_NT_unclipped"
UNION
SELECT * FROM boundaries."HexGrid_1km_NU_unclipped"
UNION
SELECT * FROM boundaries."HexGrid_1km_ON_unclipped"
UNION
SELECT * FROM boundaries."HexGrid_1km_PE_unclipped"
UNION
SELECT * FROM boundaries."HexGrid_1km_QC_unclipped"
UNION
SELECT * FROM boundaries."HexGrid_1km_SK_unclipped"
UNION
SELECT * FROM boundaries."HexGrid_1km_YT_unclipped";

-- change new PK / add indexes HexGrid_1km
ALTER TABLE boundaries."HexGrid_1km_unclipped" DROP CONSTRAINT IF EXISTS "HexGrid_1km_unclipped_pkey";
ALTER TABLE boundaries."HexGrid_1km_unclipped" ADD PRIMARY KEY ("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_gridid_1_unclipped_idx ON boundaries."HexGrid_1km_unclipped"("gridid_1");
CREATE INDEX IF NOT EXISTS hexgrid_1km_geom_unclipped_idx ON boundaries."HexGrid_1km_unclipped" using GIST(geom);