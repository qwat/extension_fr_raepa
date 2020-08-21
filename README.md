# QWAT extension for French COVADIS RAEPA extension

This extension adds views in a QWAT data structure to expose QWAT datasets to the [RAEPA standard](http://www.geoinformations.developpement-durable.gouv.fr/geostandard-reseaux-d-adduction-d-eau-potable-et-d-a3478.html). 

## Usage

First have a QWAT database somewhere. See QWAT's doc for a [full install from sources for developpers](https://qwat.github.io/docs/master/en/html/installation-guide/index.html) or a classical [dump-restore for testing purposes](https://qwat.github.io/docs/master/en/html/demo-guide/index.html)

The clone or download this repository on a work directory your server :

`git clone git@github.com:qwat/extension_fr_raepa.git`

Then enter the directory

`cd extension_fr_rapea`

And run the init script, passing the SRID argument (here 3946 for some French locations) and the pg_service file containing your QWAT database connection information :

`./init.sh -s 3946 -p $SERVICE  `

## Known issues

This extension only adds read only views. Having those views being editable will require a lot of work so that local administrator have reclassification tables to judge which values tables the exchange datasets should be mapped to.  

Mapping issues have been listed in the file synthese_anomalies_mapping.md. 

--- 

# Extension QWAT pour l'ajout de vues COVADIS RAEPA

Cette extension ajoute des vues dans une base de données QWAT qui permet d'exposer les données au format [RAEPA standard](http://www.geoinformations.developpement-durable.gouv.fr/geostandard-reseaux-d-adduction-d-eau-potable-et-d-a3478.html). 


## Problèmes connus

Cette extension ne permet pas d'importer pour l'instant des données RAEPA dans QWAT. Il est possible de rendre ces vues éditables pour cet usage, mais il faudra ajouter des tables de reclassification d'objets et de listes de valeurs pour permettre à un administrateur d'arbitrer vers quelles classes de QWAT renvoyer les enregistrements. 

Les problèmes de conversion de modèle rencontrés ont été listés dans le fichier `synthese_anomalies_mapping.md`
