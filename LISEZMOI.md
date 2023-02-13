# model-factory

model-factory est un dépôt utilisé en conjonction avec le dépôt [opendrr-api](https://github.com/OpenDRR/opendrr-api) (https://github.com/OpenDRR/opendrr-api).
Il contient de la documentation, et des scripts (python et sql) pour transformer les données sources d'opendrr (exposition, recensement, et sorties OpenQuake etc.) en indicateurs de profil de risque pour :

 - Couche nationale des établissements humains (https://github.com/OpenDRR/national-human-settlement)
		 - Exposition physique
		 - Tissu social
- Scénarios de tremblement de terre (https://github.com/OpenDRR/earthquake-scenarios)
- Risque sismique probabiliste (https://github.com/OpenDRR/seismic-risk-model)

Consultez la section des versions (https://github.com/OpenDRR/model-factory/releases) pour connaître les derniers changements de version.


![PyPI - Version Python](https://img.shields.io/pypi/pyversions/openquake.engine)

exigences.txt
- liste des modules et des versions à installer.
`$ pip install -r requirements.txt`

## documentation
- RiskProfileTaxonomy.xls
		- Documentation des indicateurs de profil de risque v1.0 pour examen et commentaires
- opendrr.drawio](https://github.com/OpenDRR/opendrr-data-store/blob/master/scripts/Diagrams/opendrr.drawio)
	- Diagramme de la base de données postgis actuelle d'opendrr, créé dans draw.io. 
	
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