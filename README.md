
# model-factory

model-factory is a repo used in conjunction with [opendrr-api](https://github.com/OpenDRR/opendrr-api) repository (https://github.com/OpenDRR/opendrr-api).
It contains documentation, and scripts (python and sql) to transform opendrr source data (exposure, census, and OpenQuake outputs etc.) into risk profile indicators for:

 - National Human Settlement Layer (https://github.com/OpenDRR/national-human-settlement)
		 - Physical Exposure
		 - Social Fabric
- Earthquake Scenarios (https://github.com/OpenDRR/earthquake-scenarios)
- Probabilistic Earthquake Risk (https://github.com/OpenDRR/seismic-risk-model)

Refer to the releases section (https://github.com/OpenDRR/model-factory/releases) for latest version changes.

![PyPI - Python Version](https://img.shields.io/pypi/pyversions/openquake.engine)

exigences.txt
- liste des modules et des versions à installer.
`$ pip install -r requirements.txt`

## scripts
- Série de scripts python et sql qui sont utilisés dans le repo opendrr-api.

### Comment le script fonctionne
- La plupart des scripts de ce dépôt sont exécutés avec des arguments sous forme de mots-clés.

Exemple :
```
$ python3 DSRA_outputs2postgres.py --dsraModelDir="https://github.com/OpenDRR/openquake-models/tree/master/deterministic/outputs" --columnsINI="DSRA_outputs2postgres.ini"
```
Ou demandez de l'aide aux scripts pour savoir comment les exécuter :
```
$ python3 DSRA_outputs2postgres.py --help