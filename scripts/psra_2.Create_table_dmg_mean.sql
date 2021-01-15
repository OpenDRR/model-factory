-- script to generate cd/ed structural mean - b0, r2
DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_cd_dmg_mean_b0, psra_{prov}.psra_{prov}_cd_dmg_mean_r2, psra_{prov}.psra_{prov}_cd_dmg_mean, psra_{prov}.psra_{prov}_ed_dmg_mean_b0, psra_{prov}.psra_{prov}_ed_dmg_mean_r2,
psra_{prov}.psra_{prov}_ed_dmg_mean CASCADE;

-- create cd table b0
CREATE TABLE psra_{prov}.psra_{prov}_cd_dmg_mean_b0(
PRIMARY KEY (asset_id),
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
structural_no_damage float, 
structural_slight float, 
structural_moderate float, 
structural_extensive float, 
structural_complete float
);

-- import exposure from csv
COPY psra_{prov}.psra_{prov}_cd_dmg_mean_b0(asset_id,"BldEpoch","BldgType","EqDesLev","GenOcc","GenType","LandUse","OccClass","SAC","SSC_Zone","SauidID",adauid,cdname,cduid,csdname,csduid,dauid,ername,eruid,fsauid,prname,
pruid,sauid,taxonomy,lon,lat,structural_no_damage,structural_slight,structural_moderate,structural_extensive,structural_complete)
    FROM '/usr/src/app/cDamage/{prov}/cD_{prov}_dmg-mean_b0.csv'
        WITH 
          DELIMITER AS ','
          CSV ;


-- create cd table r2
CREATE TABLE psra_{prov}.psra_{prov}_cd_dmg_mean_r2(
PRIMARY KEY (asset_id),
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
structural_no_damage float, 
structural_slight float, 
structural_moderate float, 
structural_extensive float, 
structural_complete float
);

-- import exposure from csv
COPY psra_{prov}.psra_{prov}_cd_dmg_mean_r2(asset_id,"BldEpoch","BldgType","EqDesLev","GenOcc","GenType","LandUse","OccClass","SAC","SSC_Zone","SauidID",adauid,cdname,cduid,csdname,csduid,dauid,ername,eruid,fsauid,prname,
pruid,sauid,taxonomy,lon,lat,structural_no_damage,structural_slight,structural_moderate,structural_extensive,structural_complete)
    FROM '/usr/src/app/cDamage/{prov}/cD_{prov}_dmg-mean_r2.csv'
        WITH 
          DELIMITER AS ','
          CSV ;


-- combine cd b0 and r2 table
CREATE TABLE psra_{prov}.psra_{prov}_cd_dmg_mean AS
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
a.structural_no_damage AS "structural_no_damage_b0",
a.structural_slight AS "structural_slight_b0",
a.structural_moderate AS "structural_moderate_b0",
a.structural_extensive AS "structural_extensive_b0",
a.structural_complete AS "structural_complete_b0",
b.structural_no_damage AS "structural_no_damage_r2",
b.structural_slight AS "structural_slight_r2",
b.structural_moderate AS "structural_moderate_r2",
b.structural_extensive AS "structural_extensive_r2",
b.structural_complete AS "structural_complete_r2"

FROM psra_{prov}.psra_{prov}_cd_dmg_mean_b0 a
INNER JOIN psra_{prov}.psra_{prov}_cd_dmg_mean_r2 b ON a.asset_id = b.asset_id
);

ALTER TABLE psra_{prov}.psra_{prov}_cd_dmg_mean ADD PRIMARY KEY (asset_id);


-- create ed table b0
CREATE TABLE psra_{prov}.psra_{prov}_ed_dmg_mean_b0(
PRIMARY KEY (asset_id),
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
structural_no_damage float, 
structural_slight float, 
structural_moderate float, 
structural_extensive float, 
structural_complete float
);

-- import exposure from csv
COPY psra_{prov}.psra_{prov}_ed_dmg_mean_b0(asset_id,"BldEpoch","BldgType","EqDesLev","GenOcc","GenType","LandUse","OccClass","SAC","SSC_Zone","SauidID",adauid,cdname,cduid,csdname,csduid,dauid,ername,eruid,fsauid,prname,
pruid,sauid,taxonomy,lon,lat,structural_no_damage,structural_slight,structural_moderate,structural_extensive,structural_complete)
    FROM '/usr/src/app/eDamage/{prov}/eD_{prov}_damages-mean_b0.csv'
        WITH 
          DELIMITER AS ','
          CSV ;


-- create cd table r2
CREATE TABLE psra_{prov}.psra_{prov}_ed_dmg_mean_r2(
PRIMARY KEY (asset_id),
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
structural_no_damage float, 
structural_slight float, 
structural_moderate float, 
structural_extensive float, 
structural_complete float
);

-- import exposure from csv
COPY psra_{prov}.psra_{prov}_ed_dmg_mean_r2(asset_id,"BldEpoch","BldgType","EqDesLev","GenOcc","GenType","LandUse","OccClass","SAC","SSC_Zone","SauidID",adauid,cdname,cduid,csdname,csduid,dauid,ername,eruid,fsauid,prname,
pruid,sauid,taxonomy,lon,lat,structural_no_damage,structural_slight,structural_moderate,structural_extensive,structural_complete)
    FROM '/usr/src/app/eDamage/{prov}/eD_{prov}_damages-mean_r2.csv'
        WITH 
          DELIMITER AS ','
          CSV ;


-- combine ed b0 and r2 table
CREATE TABLE psra_{prov}.psra_{prov}_ed_dmg_mean AS
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
a.structural_no_damage AS "structural_no_damage_b0",
a.structural_slight AS "structural_slight_b0",
a.structural_moderate AS "structural_moderate_b0",
a.structural_extensive AS "structural_extensive_b0",
a.structural_complete AS "structural_complete_b0",
b.structural_no_damage AS "structural_no_damage_r2",
b.structural_slight AS "structural_slight_r2",
b.structural_moderate AS "structural_moderate_r2",
b.structural_extensive AS "structural_extensive_r2",
b.structural_complete AS "structural_complete_r2"

FROM psra_{prov}.psra_{prov}_ed_dmg_mean_b0 a
INNER JOIN psra_{prov}.psra_{prov}_ed_dmg_mean_r2 b ON a.asset_id = b.asset_id
);

ALTER TABLE psra_{prov}.psra_{prov}_ed_dmg_mean ADD PRIMARY KEY (asset_id);

DROP TABLE IF EXISTS psra_{prov}.psra_{prov}_cd_dmg_mean_b0, psra_{prov}.psra_{prov}_cd_dmg_mean_r2, psra_{prov}.psra_{prov}_ed_dmg_mean_b0, psra_{prov}.psra_{prov}_ed_dmg_mean_r2 CASCADE;