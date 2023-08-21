# model-factory
![PyPI - Python Version](https://img.shields.io/pypi/pyversions/openquake.engine)

model-factory is a repository used in conjunction with [opendrr-api](https://github.com/OpenDRR/opendrr-api) repository.
It contains documentation, and scripts (python and sql) to transform opendrr source data (exposure, census, and OpenQuake outputs etc.) into risk profile indicators for:

 - [National Human Settlement Layer](https://github.com/OpenDRR/national-human-settlement) 
		 - [Physical Exposure](https://github.com/OpenDRR/national-human-settlement/tree/main/physical-exposure)
		 - [Social Fabric](https://github.com/OpenDRR/national-human-settlement/tree/main/social-fabric)
- [Earthquake Scenarios](https://github.com/OpenDRR/earthquake-scenarios) 
- [Probabilistic Earthquake Risk](https://github.com/OpenDRR/seismic-risk-model)


 - **documentation/**
	 - RiskProfileTaxonomy.xls
		 -  Documentation of v1.0 risk profile indicators for review and comments.
	- [opendrr.drawio](https://github.com/OpenDRR/opendrr-data-store/blob/master/scripts/Diagrams)
		- diagram of current opendrr postgis database, created in draw.io 
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


<!-- # Welcome to MkDocs

For full documentation visit [mkdocs.org](https://www.mkdocs.org).

## Commands

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs -h` - Print help message and exit.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files. -->
