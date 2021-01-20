-- script to agg losses stats
DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_avg_losses_stats_b0, psra_{prov}.psra_{prov}_avg_losses_stats_r2, psra_{prov}.psra_{prov}_avg_losses_stats CASCADE;

-- create table
CREATE TABLE psra_{prov}.psra_{prov}_avg_losses_stats_b0(
PRIMARY KEY(asset_id),
asset_id varchar,
"BldEpoch" varchar,
"BldgType" varchar,
"EqDesLev" varchar,
"GenOcc" varchar,
"GenType" varchar,
"LandUse" varchar,
"OccClass" varchar,
"SAC" varchar,
"SSC_Zone" varchar,
"SauidID" varchar,
adauid varchar,
cdname varchar,
cduid varchar,
csdname varchar,
csduid varchar,
dauid varchar,
ername varchar,
eruid varchar,
fsauid varchar,
prname varchar,
pruid varchar,
sauid varchar,
taxonomy varchar,
lon float,
lat float,
contents float,
nonstructural float,
structural float
);

-- import exposure from csv
COPY psra_{prov}.psra_{prov}_avg_losses_stats_b0(asset_id,"BldEpoch","BldgType","EqDesLev","GenOcc","GenType","LandUse","OccClass","SAC","SSC_Zone","SauidID",adauid,cdname,cduid,csdname,csduid,dauid,ername,eruid,fsauid,prname,pruid,sauid,taxonomy,lon,lat,contents,nonstructural,structural)
    FROM '/usr/src/app/ebRisk/{prov}/ebR_{prov}_avg_losses-stats_b0.csv'
        WITH 
          DELIMITER AS ','
          CSV ;



-- create table
CREATE TABLE psra_{prov}.psra_{prov}_avg_losses_stats_r2(
PRIMARY KEY(asset_id),
asset_id varchar,
"BldEpoch" varchar,
"BldgType" varchar,
"EqDesLev" varchar,
"GenOcc" varchar,
"GenType" varchar,
"LandUse" varchar,
"OccClass" varchar,
"SAC" varchar,
"SSC_Zone" varchar,
"SauidID" varchar,
adauid varchar,
cdname varchar,
cduid varchar,
csdname varchar,
csduid varchar,
dauid varchar,
ername varchar,
eruid varchar,
fsauid varchar,
prname varchar,
pruid varchar,
sauid varchar,
taxonomy varchar,
lon float,
lat float,
contents float,
nonstructural float,
structural float
);

-- import exposure from csv
COPY psra_{prov}.psra_{prov}_avg_losses_stats_r2(asset_id,"BldEpoch","BldgType","EqDesLev","GenOcc","GenType","LandUse","OccClass","SAC","SSC_Zone","SauidID",adauid,cdname,cduid,csdname,csduid,dauid,ername,eruid,fsauid,prname,pruid,sauid,taxonomy,lon,lat,contents,nonstructural,structural)
    FROM '/usr/src/app/ebRisk/{prov}/ebR_{prov}_avg_losses-stats_r2.csv'
        WITH 
          DELIMITER AS ','
          CSV ;


-- combine b0 and r2 table
CREATE TABLE psra_{prov}.psra_{prov}_avg_losses_stats AS
(SELECT
a.asset_id,
a."BldEpoch",
a."BldgType",
a."EqDesLev",
a."GenOcc",
a."GenType",
a."LandUse",
a."OccClass",
a."SAC",
a."SSC_Zone",
a."SauidID",
a.adauid,
a.cdname,
a.cduid,
a.csdname,
a.csduid,
a.dauid,
a.ername,
a.eruid,
a.fsauid,
a.prname,
a.pruid,
a.sauid,
a.taxonomy,
a.lon,
a.lat,
a.contents AS "contents_b0",
a.nonstructural AS "nonstructural_b0",
a.structural AS "structural_b0",
b.contents AS "contents_r2",
b.nonstructural AS "nonstructural_r2",
b.structural AS "structural_r2"

FROM psra_{prov}.psra_{prov}_avg_losses_stats_b0 a
INNER JOIN psra_{prov}.psra_{prov}_avg_losses_stats_r2 b ON a.asset_id = b.asset_id);

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_avg_losses_stats_b0, psra_{prov}.psra_{prov}_avg_losses_stats_r2;