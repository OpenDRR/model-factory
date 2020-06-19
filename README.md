# model-factory
OpenQuake compilation and data manipulation scripts

![PyPI - Python Version](https://img.shields.io/pypi/pyversions/openquake.engine)


## Install dependencies
`$ pip install -r requirements.txt`

## Run Scripts With Keyword Arguments
Example:

```
$ python3 DSRA_outputs2postgres.py  --dsraModelDir="https://github.com/OpenDRR/openquake-models/tree/master/deterministic/outputs" --columnsINI="DSRA_outputs2postgres.ini"
```

Or ask scripts for help on how to run them:

```
$ python3 DSRA_outputs2postgres_lfs.py  --help
```
