-- script to generate Canada site level exposure table
DROP TABLE IF EXISTS exposure.canada_site_exposure_agg,exposure.canada_site_exposure_agg_temp;


CREATE TABLE exposure.canada_site_exposure_agg AS (
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
ROUND(AVG(bldyear)) AS "bldgyear",
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

FROM exposure.canada_site_exposure
GROUP BY sauid,sauidid,sauidlat,sauidlon,sauid_km2,sauid_ha,landuse,taxonomy,business,"limit",deductible,genocc,occclass1,occclass2,gentype,bldgtype,bldepoch,ssc_zone,
eqdeslev,dauid,adauid,fsauid,csduid,csdname,cduid,cdname,sac,eruid,ername,pruid,prname
ORDER BY sauid,taxonomy ASC);


-- create spatial index
CREATE INDEX canada_site_exposure_agg_idx
ON exposure.canada_site_exposure_agg USING GIST (geom_site);


-- add missing columns
ALTER TABLE exposure.canada_site_exposure_agg
ADD COLUMN id varchar,
ADD COLUMN rowid int,
ADD COLUMN objid serial;


-- create new id from rowid / taxonomy
UPDATE exposure.canada_site_exposure_agg
SET id = sauid||'-'||taxonomy;


-- create temp table to create partition by id
SELECT id,
objid,
ROW_NUMBER() OVER(PARTITION BY id) as rowid

INTO exposure.canada_site_exposure_agg_temp

FROM exposure.canada_site_exposure_agg;


-- update rowid to site level aggegrate table
UPDATE exposure.canada_site_exposure_agg t1
SET  rowid = t2.rowid
FROM exposure.canada_site_exposure_agg_temp t2
WHERE t1.id = t2.id AND t1.objid = t2.objid;

DROP TABLE IF EXISTS exposure.canada_site_exposure_agg_temp;

-- update id to incorporate rowid
UPDATE exposure.canada_site_exposure_agg
SET id = rowid||'-'||id;


-- add PK
ALTER TABLE exposure.canada_site_exposure_agg ADD PRIMARY KEY(id);


-- erase building level exposure rows with the same sauid from site level aggregation
DELETE FROM exposure.canada_exposure
WHERE sauid IN (SELECT DISTINCT(sauid) FROM exposure.canada_site_exposure_agg);


-- insert into building level data with aggregated site level data
INSERT INTO exposure.canada_exposure(OBJECTID,id,SauidID,SauidLat,SauidLon,Sauid_km2,Sauid_ha,LandUse,taxonomy,number,structural,nonstructural,contents,
business,"limit",deductible,retrofitting,day,night,transit,GenOcc,OccClass1,OccClass2,PopDU,GenType,BldgType,NumFloors,Bldg_ft2,BldYear,BldEpoch,
SSC_Zone,EqDesLev,sauid,dauid,adauid,fsauid,csduid,csdname,cduid,cdname,SAC,eruid,ername,pruid,prname,ObjID,geom)
SELECT rowid,
id,
sauidid,
sauidlat,
sauidlon,
sauid_km2,
sauid_ha,
landuse,
taxonomy,
number,
structural,
nonstructural,
contents,
business,
"limit",
deductible,
retrofitting,
day,
night,
transit,
genocc,
occclass1,
occclass2,
popdu,
gentype,
bldgtype,
numfloors,
bldg_ft2,
bldgyear,
bldepoch,
ssc_zone,
eqdeslev,
sauidid,
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
rowid,
geom_site
FROM exposure.canada_site_exposure_agg;

DROP TABLE IF EXISTS exposure.canada_site_exposure_agg;