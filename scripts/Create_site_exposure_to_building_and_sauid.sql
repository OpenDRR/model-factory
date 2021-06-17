-- script to generate building level exposure from site level
DROP TABLE IF EXISTS exposure.metrovan_building_exposure,exposure.metrovan_site_exposure_id_building,exposure.metrovan_building_exposure_temp,exposure.metrovan_sauid_exposure CASCADE;


CREATE TABLE exposure.metrovan_building_exposure AS (
SELECT sauid,
sauidid,
sauidlat,
sauidlon,
sauid_km2,
sauid_ha,
landuse,
taxonomy,
SUM(number) AS "number",
SUM(structural) AS "structural",
SUM(nonstructural) AS "nonstructural",
SUM(contents) AS "contents",
business,
"limit",
deductible,
AVG(retrofitting) AS "retrofitting",
SUM(day) AS "day",
SUM(night) AS "night",
SUM(transit) AS "transit",
genocc,
occclass1,
occclass2,
AVG(popdu) AS "popdu",
gentype,
bldgtype,
ROUND(AVG(numfloors)) AS "numfloors",
SUM(bldg_ft2) AS "bldg_ft2",
ROUND(AVG(bldyear)) AS "bldyear",
bldepoch,
ssc_zone,
eqdeslev,
dauid,
adauid,
fsauid,
csduid,
csdname,
cduid,
cdname,
sac,
eruid,
ername,
pruid,
prname,
st_centroid(st_union(geom_site)) AS "geom_site"

FROM exposure.metrovan_site_exposure
GROUP BY sauid,sauidid,sauidlat,sauidlon,sauid_km2,sauid_ha,landuse,taxonomy,business,"limit",deductible,genocc,occclass1,occclass2,gentype,bldgtype,bldepoch,ssc_zone,
eqdeslev,dauid,adauid,fsauid,csduid,csdname,cduid,cdname,sac,eruid,ername,pruid,prname
ORDER BY sauid,taxonomy ASC);


-- add missing columns
ALTER TABLE exposure.metrovan_building_exposure
ADD COLUMN id varchar,
ADD COLUMN rowid int,
ADD COLUMN objid serial;


-- create new id from rowid / taxonomy
UPDATE exposure.metrovan_building_exposure
SET id = sauid||'-'||taxonomy;


-- create indexes
CREATE INDEX IF NOT EXISTS metrovan_building_exposure_idx ON exposure.metrovan_building_exposure USING GIST (geom_site);
CREATE INDEX IF NOT EXISTS metrovan_building_exposure_sauid_idx ON exposure.metrovan_building_exposure("sauid");
CREATE INDEX IF NOT EXISTS metrovan_building_exposure_id_idx ON exposure.metrovan_building_exposure("id");

-- create temp table to create partition by id
SELECT id,
objid,
ROW_NUMBER() OVER(PARTITION BY id) as rowid

INTO exposure.metrovan_building_exposure_temp

FROM exposure.metrovan_building_exposure;


-- update rowid to site level aggegrate table
UPDATE exposure.metrovan_building_exposure t1
SET  rowid = t2.rowid
FROM exposure.metrovan_building_exposure_temp t2
WHERE t1.id = t2.id AND t1.objid = t2.objid;

DROP TABLE IF EXISTS exposure.metrovan_building_exposure_temp;

-- update id to incorporate rowid
UPDATE exposure.metrovan_building_exposure
SET id = rowid||'-'||id;


-- add PK
ALTER TABLE exposure.metrovan_building_exposure ADD PRIMARY KEY(id);


-- create temp table to reference newly generated id at the building level exposure to site level exposure for aggregation
CREATE TABLE exposure.metrovan_site_exposure_id_building AS (
SELECT a.id,
b.id AS "id_building",
a.sauid,
a.landuse,
a.taxonomy,
--a.business,
--a."limit",
--a.deductable
a.genocc,
a.occclass1,
a.occclass2,
a.gentype,
a.bldgtype,
a.bldepoch,
a.ssc_zone,
a.eqdeslev,
a.dauid,
a.adauid,
a.fsauid,
a.csduid,
a.csdname,
a.cduid,
a.cdname,
a.sac,
a.eruid,
a.ername,
a.pruid,
a.prname
from exposure.metrovan_site_exposure a
LEFT JOIN exposure.metrovan_building_exposure b ON a.sauid = b.sauid 
AND a.sauidid = b.sauidid 
AND a.sauidlat = b.sauidlat 
AND a.sauidlon = b.sauidlon
AND a.sauid_km2 = b.sauid_km2 
AND a.sauid_ha = b.sauid_ha 
AND a.landuse = b.landuse 
AND a.taxonomy = b.taxonomy 
--AND a.business = b.business 
--AND a."limit" = b."limit"
--AND a.deductible = b.deductible 
AND a.genocc = b.genocc 
AND a.occclass1 = b.occclass1
AND a.occclass2 = b.occclass2
AND a.gentype = b.gentype
AND a.bldgtype = b.bldgtype
AND a.bldepoch = b.bldepoch
AND a.ssc_zone = b.ssc_zone
AND a.eqdeslev = b.eqdeslev
AND a.dauid = b.dauid
AND a.adauid = b.adauid
AND a.fsauid = b.fsauid
AND a.csduid = b.csduid
AND a.cduid = b.cduid
AND a.sac = b.sac
AND a.eruid = b.eruid
AND a.pruid = b.pruid

ORDER BY a.sauid ASC);


-- add id_building column to site level for aggregation to building level
ALTER TABLE exposure.metrovan_site_exposure
ADD COLUMN IF NOT EXISTS id_building varchar;


-- update id_building column
UPDATE exposure.metrovan_site_exposure t1
SET id_building = t2.id_building
FROM exposure.metrovan_site_exposure_id_building t2
WHERE t1.id = t2.id;

-- add index
CREATE INDEX IF NOT EXISTS metrovan_site_exposure_id_building_idx ON exposure.metrovan_site_exposure("id_building");

DROP TABLE IF EXISTS exposure.metrovan_site_exposure_id_building CASCADE;


-- aggregate exposure to sauid level
CREATE TABLE exposure.metrovan_sauid_exposure AS (
SELECT sauid,
sauidlat,
sauidlon,
SUM(number) AS "number",
SUM(structural) AS "structural",
SUM(nonstructural) AS "nonstructural",
SUM(contents) AS "contents",
AVG(retrofitting) AS "retrofitting",
SUM(day) AS "day",
SUM(night) AS "night",
SUM(transit) AS "transit",
AVG(popdu) AS "popdu",
ROUND(AVG(numfloors)) AS "numfloors",
SUM(bldg_ft2) AS "bldg_ft2",
ROUND(AVG(bldyear)) AS "bldyear",
st_centroid(st_union(geom_site)) AS "geom_site"

FROM exposure.metrovan_building_exposure
GROUP BY sauid,sauidlat,sauidlon);

-- create indexes
CREATE INDEX IF NOT EXISTS metrovan_sauid_exposure_sauid_idx ON exposure.metrovan_sauid_exposure("sauid");
CREATE INDEX IF NOT EXISTS metrovan_sauid_exposure_geom_site_idx ON exposure.metrovan_sauid_exposure USING gist("geom_site");