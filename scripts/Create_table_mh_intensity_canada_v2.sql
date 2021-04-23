
-- version 3 replaces previous version, methodology and data changes.  Name kept the same to keep scripts from running.
DROP TABLE IF EXISTS mh.mh_intensity_canada CASCADE;

-- create table
CREATE TABLE mh.mh_intensity_canada(
PRIMARY KEY(sauidt),
sauidt varchar,
sauidi integer,
lon float,
lat float,
pgv2500 float,
pgv500 float,
pga2500 float,
pga500 float,
vs30 float,
mmi6 float,
mmi7 float,
mmi8 float,
tsun500 float,
fld50_jrc float,
fld100_jrc float,
fld200_jrc float,
fld500_jrc float,
fld200_unep float,
fld500_unep float,
fld1000_unep float,
wildfire float,
wui_type varchar,
lndsus float,
cy100 float,
cy250 float,
cy500 float,
cy1000 float,
svlt_score integer

);