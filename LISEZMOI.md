# model-factory
![PyPI - Version Python](https://img.shields.io/pypi/pyversions/openquake.engine)

model-factory est un référentiel utilisé en conjonction avec le référentiel [opendrr-api](https://github.com/OpenDRR/opendrr-api).
Il contient de la documentation, et des scripts (python et sql) pour transformer les données sources d'opendrr (exposition, recensement, et sorties OpenQuake etc.) en indicateurs de profil de risque pour :

 - [Couche nationale des établissements humains](https://github.com/OpenDRR/national-human-settlement) 

	- [Exposition physique](https://github.com/OpenDRR/national-human-settlement/tree/main/physical-exposure)

	- [Tissu social](https://github.com/OpenDRR/national-human-settlement/tree/main/social-fabric)
- [Scénarios de tremblement de terre](https://github.com/OpenDRR/earthquake-scenarios) 
- [Risque sismique probabiliste](https://github.com/OpenDRR/seismic-risk-model)


- **documentation/**
	 - RiskProfileTaxonomy.xls
		 - Documentation des indicateurs de profil de risque v1.0 pour examen et commentaires.
	- 1_scenario-risk-schema_v1.1.xlsx
		- Feuille de calcul Excel dans laquelle la phase initiale des indicateurs (risque sismique) a été rédigée.
	- 2_physical-exposure-schema.xlsx
		- Feuille de calcul Excel dans laquelle la phase initiale des indicateurs (exposition physique) a été rédigée.
	- 2_risk-profile-indicators.xlsx
		- Feuille de calcul Excel contenant des indicateurs pour chaque exposition physique, tissu social, scénarios de tremblement de terre (DSRA) et modèle de risque sismique (PSRA).
	- 3_multi-hazard-threat-schema.xlsx
		- Feuille de calcul Excel dans laquelle la phase initiale des indicateurs (multirisques) a été rédigée
	- 4_social-vulnerability-schema.xlsx
		- Feuille de calcul Excel dans laquelle la phase initiale des indicateurs (tissu social) a été rédigée.
	- mapping Sendai Indicators DSRA_PSRA.xlsx
		- Feuille de calcul Excel avec les projets d'indicateurs.
	- opendrr.drawio
		- La décomposition de chaque schéma et de toutes les tables, colonnes de table, etc. peut être trouvée dans le diagramme opendrr.drawio.
- **scripts/**
	- Série de scripts python et sql qui sont utilisés dans le référentiel opendrr-api pour construire la base de données PostGIS.
- exigences.txt
	- liste des modules et des versions à installer.  `$ pip install -r requirements.txt`

Consultez la [section des versions](https://github.com/OpenDRR/model-factory/releases) pour connaître les derniers changements de version.


### Comment fonctionne le script
- La plupart des scripts de ce référentiel sont exécutés avec des arguments sous forme de mots-clés.

Exemple :
```
$ python3 DSRA_outputs2postgres.py --dsraModelDir="https://github.com/OpenDRR/openquake-models/tree/master/deterministic/outputs" --columnsINI="DSRA_outputs2postgres.ini"
```
Ou demandez de l'aide aux scripts pour savoir comment les exécuter :
```
$ python3 DSRA_outputs2postgres.py --help