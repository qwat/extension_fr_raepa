# Synthèse des problèmes de mapping QWAT- COVADIS rencontrés

- les vues ont codé en dur des listes de valeurs possibles. Il pourrait être plus élégant de faire des tables de recodification pour alléger les définitions de vues, mais cela demanderait les tables VALUE_RAPEA + Relation_RAEPA_QWAT pour gérer les regroupements de classification nécessaire. POur l'instant on laisse ça sous forme de commentaires dans le code et d'expressions conditionnelles.



## Champs


ouvrages et canalisations :

- Année de début de pose / Année de fin de pose : QWAT a les informations Année, année de réhabilitation (pipe uniquement) et année de fin 

ouvrages :

- les id de canalisation amont et aval peuvent se requêter pour les pompes uniquement via le modèle. Une requête sur les tronçons via le noeud est possible, mais on à alors potentiellement plusieurs amonts et aval, sous forme de liste. On laisse donc uniquement la valeur pour les pompes, seuls ouvrages pour lesquels cela semble avoir du sens. 


Les champs suivant ne sont pas remplis actuellement :

-   sourmaj , -- champ non disponibel dans QWAT
-   qualannee , -- Fiabilité, à remplir seulement si ANDEBPOSE = ANFINPOSE. Info non disponible dans QWAT (01	Certaine /00 Indéterrminée / 02	Récolement	/ 04	Mémoire	Année issue de souvenir(s) individuel(s)/ 	Projet	AnnÚe reprise sur plans de projet) 

-    dategeoloc , -- TODO Date de la géolocalisation Date (10) -- on pourrait détecter une partie de l'info en analysant les audit logs, mais non disponible en attributaire (surqualité?) 
-    sourgeoloc , -- TODO Auteur de la géolocalisation Caractère (100)
-    sourattrib -- TODO SOURATTRIB Auteur de la saisie des données attributaires (lorsque différent de l'auteur de la géolocalisation) Caractère (100) - Surqualité?


Réparations :

 - QWAT ne gère pas les réparations, mais les réparations de fuites uniquement. Celles ci sont positionnée librement et référençables sur une canalisation uniquement. Les ouvrages, pièces d'installation et vannes ont un statut et une date de pose. On pourrait imaginer trackers le mises à jour dans l'audit log et analyser les arrivées de nouveaux ouvrages / changement de statuts d'ouvrage pour reconstituer des réparations d'ouvrages. Cela reste une approche approximative. 
 
 -   


