# model-factory
![PyPI - Python Version](https://img.shields.io/pypi/pyversions/openquake.engine)

model-factory is a repository used in conjunction with [opendrr-api](https://github.com/OpenDRR/opendrr-api) repository.
It contains documentation, and scripts (python and sql) to transform opendrr source data (exposure, census, and OpenQuake outputs etc.) into risk profile indicators for:

 - [National Human Settlement Layer](https://github.com/OpenDRR/national-human-settlement) 
		 
	- [Physical Exposure](https://github.com/OpenDRR/national-human-settlement/tree/main/physical-exposure)
	- [Social Fabric](https://github.com/OpenDRR/national-human-settlement/tree/main/social-fabric)
- [Earthquake Scenarios](https://github.com/OpenDRR/earthquake-scenarios) 
- [Probabilistic Earthquake Risk](https://github.com/OpenDRR/seismic-risk-model)
- A detailed documentation on the SQL workflow can be found on either:
	- [OpenDRR Model Factory GitHub Page](https://opendrr.github.io/model-factory/)
	- [OpenDRR Model Factory Read the Docs Page](https://opendrr-model-factory.readthedocs.io/en/latest/)


 - **documentation/**
	 - RiskProfileTaxonomy.xls
		 -  Documentation of v1.0 risk profile indicators for review and comments.
	- 1_scenario-risk-schema_v1.1.xlsx
		- Excel spreadsheet where initial phase of indicators (seismic risk) were drafted.
	- 2_physical-exposure-schema.xlsx
		- Excel spreadsheet where initial phase of indicators (physical exposure) were drafted.
	- 2_risk-profile-indicators.xlsx
		- Excel spreadsheet containing indicators for each Physical Exposure, Social Fabric, Earthquake Scenarios (DSRA), and Seismic Risk Model (PSRA).
	- 3_multi-hazard-threat-schema.xlsx
		- Excel spreadsheet where initial phase of indicators (multi hazard) were drafted
	- 4_social-vulnerability-schema.xlsx
		- Excel spreadsheet where initial phase of indicators (social fabric) were drafted.
	- mapping Sendai Indicators DSRA_PSRA.xlsx
		- Excel spreadsheet with draft indicators.
	- opendrr.drawio
		- Breakdown of each schema and all the tables,table columns etc can be found in opendrr.drawio diagram.
- **scripts/**
	- Series of python and sql scripts that are used in opendrr-api repository to build the PostGIS database.
- requirements.txt
	- list of modules and versions required to be installed.  `$ pip install -r requirements.txt`

Refer to the [releases section](https://github.com/OpenDRR/model-factory/releases) for latest version changes.


### How the script works
- Most scripts in this repository are run with keyword arguments.

Example:
```
$ python3 DSRA_outputs2postgres.py --dsraModelDir="https://github.com/OpenDRR/openquake-models/tree/master/deterministic/outputs" --columnsINI="DSRA_outputs2postgres.ini"
```
Or ask scripts for help on how to run them:
```
$ python3 DSRA_outputs2postgres.py --help