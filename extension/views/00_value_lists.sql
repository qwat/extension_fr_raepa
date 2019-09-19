-- SCHEMA
DROP SCHEMA IF EXISTS raepa;

CREATE SCHEMA raepa;

COMMENT ON SCHEMA raepa IS 'Réseaux humides au standard RAEPA';

-- TABLES
-- GENERIQUES

CREATE TABLE raepa.val_raepa_materiau (
    code character varying(2) NOT NULL
    , valeur character varying(80) NOT NULL
    , definition character varying(255)
    , CONSTRAINT raepa_materiau_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE raepa.val_raepa_materiau IS 'Matériau constitutif des tuyaux composant une canalisation';

COMMENT ON COLUMN raepa.val_raepa_materiau.code IS 'Code de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';

COMMENT ON COLUMN raepa.val_raepa_materiau.valeur IS 'Valeur de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';

COMMENT ON COLUMN raepa.val_raepa_materiau.definition IS 'Définition de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';

INSERT INTO raepa.val_raepa_materiau (code
    , valeur
    , definition)
    VALUES ('00'
        , 'Indéterminé'
        , 'Canalisation composée de tuyaux dont le matériau est inconnu')
    , ('01'
        , 'Acier'
        , 'Canalisation composée de tuyaux d''acier')
    , ('02'
        , 'Amiante-ciment'
        , 'Canalisation composée de tuyaux d''amiante-ciment')
    , ('03'
        , 'Béton âme tôle'
        , 'Canalisation composée de tuyaux de béton âme tôle')
    , ('04'
        , 'Béton armé'
        , 'Canalisation composée de tuyaux de béton armé')
    , ('05'
        , 'Béton fibré'
        , 'Canalisation composée de tuyaux de béton fibré')
    , ('06'
        , 'Béton non armé'
        , 'Canalisation composée de tuyaux de béton non armé')
    , ('07'
        , 'Cuivre'
        , 'Canalisation composée de tuyaux de cuivre')
    , ('08'
        , 'Fibre ciment'
        , 'Canalisation composée de tuyaux de fibre ciment')
    , ('09'
        , 'Fibre de verre'
        , 'Canalisation composée de tuyaux de fibre de verre')
    , ('10'
        , 'Fibrociment'
        , 'Canalisation composée de tuyaux de fibrociment')
    , ('11'
        , 'Fonte ductile'
        , 'Canalisation composée de tuyaux de fonte ductile')
    , ('12'
        , 'Fonte grise'
        , 'Canalisation composée de tuyaux de fonte grise')
    , ('13'
        , 'Grès'
        , 'Canalisation composée de tuyaux de grès')
    , ('14'
        , 'Maçonné'
        , 'Canalisation maçonnée')
    , ('15'
        , 'Meulière'
        , 'Canalisation construite en pierre meulière')
    , ('16'
        , 'PEBD'
        , 'Canalisation composée de tuyaux de polyéthylène basse densité')
    , ('17'
        , 'PEHD annelé'
        , 'Canalisation composée de tuyaux de polyéthylène haute densité annelés')
    , ('18'
        , 'PEHD lisse'
        , 'Canalisation composée de tuyaux de polyéthylène haute densité lisses')
    , ('19'
        , 'Plomb'
        , 'Canalisation composée de tuyaux de plomb')
    , ('20'
        , 'PP annelé'
        , 'Canalisation composée de tuyaux de polypropylène annelés')
    , ('21'
        , 'PP lisse'
        , 'Canalisation composée de tuyaux de polypropylène lisses')
    , ('22'
        , 'PRV A'
        , 'Canalisation composée de polyester renforcé de fibre de verre (série A)')
    , ('23'
        , 'PRV B'
        , 'Canalisation composée de polyester renforcé de fibre de verre (série B)')
    , ('24'
        , 'PVC ancien'
        , 'Canalisation composée de tuyaux de polychlorure de vinyle posés avant 1980')
    , ('25'
        , 'PVC BO'
        , 'Canalisation composée de tuyaux de polychlorure de vinyle bi-orienté')
    , ('26'
        , 'PVC U annelé'
        , 'Canalisation composée de tuyaux de polychlorure de vinyle rigide annelés')
    , ('27'
        , 'PVC U lisse'
        , 'Canalisation composée de tuyaux de polychlorure de vinyle rigide lisses')
    , ('28'
        , 'Tôle galvanisée'
        , 'Canalisation construite en tôle galvanisée')
    , ('99'
        , 'Autre'
        , 'Canalisation composée de tuyaux dont le matériau ne figure pas dans la liste ci-dessus');

CREATE TABLE raepa.val_raepa_mode_circulation (
    code character varying(2) NOT NULL
    , valeur character varying(80) NOT NULL
    , definition character varying(255)
    , CONSTRAINT raepa_mode_circulation_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE raepa.val_raepa_mode_circulation IS 'Modalité de circulation de l''eau dans une canalisation';

COMMENT ON COLUMN raepa.val_raepa_mode_circulation.code IS 'Code de la liste énumérée relative au mode de circualtion de l''eau dans une canalisation';

COMMENT ON COLUMN raepa.val_raepa_mode_circulation.valeur IS 'Valeur de la liste énumérée relative au mode de circualtion de l''eau dans une canalisation';

COMMENT ON COLUMN raepa.val_raepa_mode_circulation.definition IS 'Définition de la liste énumérée relative au mode de circualtion de l''eau dans une canalisation';

INSERT INTO raepa.val_raepa_mode_circulation (code
    , valeur
    , definition)
    VALUES ('00'
        , 'Indéterminé'
        , 'Mode de circulation inconnu')
    , ('01'
        , 'Gravitaire'
        , 'L''eau s''écoule par l''effet de la pesanteur dans la canalisation en pente')
    , ('02'
        , 'Forcé'
        , 'L''eau circule sous pression dans la canalisation grâce à un système de pompage')
    , ('03'
        , 'Sous-vide'
        , 'L''eau circule par l''effet de la mise sous vide de la canalisation par une centrale d''aspiration')
    , ('99'
        , 'Autre'
        , 'L''eau circule tantôt dans un des modes ci-dessus tantôt dans un autre');

CREATE TABLE raepa.val_raepa_qualite_anpose (
    code character varying(2) NOT NULL
    , valeur character varying(80) NOT NULL
    , definition character varying(255)
    , CONSTRAINT raepa_qualite_anpose_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE raepa.val_raepa_qualite_anpose IS 'Qualité de l''information "année de pose" ou "année de mise en service" d''un équipement';

COMMENT ON COLUMN raepa.val_raepa_qualite_anpose.code IS 'Code de la liste énumérée relative à la qualité de l''information "année de pose" ou "année de mise en service" d''un équipement';

COMMENT ON COLUMN raepa.val_raepa_qualite_anpose.valeur IS 'Valeur de la liste énumérée relative à la qualité de l''information "année de pose" ou "année de mise en service" d''un équipement';

COMMENT ON COLUMN raepa.val_raepa_qualite_anpose.definition IS 'Définition de la liste énumérée relative à la qualité de l''information "année de pose" ou "année de mise en service" d''un équipement';

INSERT INTO raepa.val_raepa_qualite_anpose (code
    , valeur
    , definition)
    VALUES ('00'
        , 'Indéterminé'
        , 'Information ou qualité de l''information inconnue')
    , ('01'
        , 'Certaine'
        , 'Année constatée durant les travaux de pose')
    , ('02'
        , 'Récolement'
        , 'Année reprise sur plans de récolement')
    , ('03'
        , 'Projet'
        , 'Année reprise sur plans de projet')
    , ('04'
        , 'Mémoire'
        , 'Année issue de souvenir(s) individuel(s)')
    , ('05'
        , 'Déduite'
        , 'Année déduite du matériau ou de l''état de l''équipement');

CREATE TABLE raepa.val_raepa_defaillance (
    code character varying(2) NOT NULL
    , valeur character varying(80) NOT NULL
    , definition character varying(255)
    , CONSTRAINT raepa_defaillance_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE raepa.val_raepa_defaillance IS 'Type de défaillance ayant rendu nécessaire une réparation';

COMMENT ON COLUMN raepa.val_raepa_defaillance.code IS 'Code de la liste énumérée relative au type de défaillance';

COMMENT ON COLUMN raepa.val_raepa_defaillance.valeur IS 'Valeur de la liste énumérée relative au type de défaillance';

COMMENT ON COLUMN raepa.val_raepa_defaillance.definition IS 'Définition de la liste énumérée relative au type de défaillance';

INSERT INTO raepa.val_raepa_defaillance (code
    , valeur
    , definition)
    VALUES ('00'
        , 'Indéterminé'
        , 'Défaillance de type inconnu')
    , ('01'
        , 'Casse longitudinale'
        , 'Canalisation fendue sur sa longueur')
    , ('02'
        , 'Casse nette'
        , 'Canalisation cassée')
    , ('03'
        , 'Déboîtement'
        , 'Déboîtement de tuyau(x) de la canalisation')
    , ('04'
        , 'Fissure'
        , 'Canalisation fissurée')
    , ('05'
        , 'Joint'
        , 'Joint défectueux')
    , ('06'
        , 'Percement'
        , 'Canalisation percée')
    , ('99'
        , 'Autre'
        , 'Défaillance dont le type ne figure pas dans la liste ci-dessus');

CREATE TABLE raepa.val_raepa_qualite_geoloc (
    code character varying(2) NOT NULL
    , valeur character varying(80) NOT NULL
    , definition character varying(255)
    , CONSTRAINT raepa_qualite_geoloc_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE raepa.val_raepa_qualite_geoloc IS 'Classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';

COMMENT ON COLUMN raepa.val_raepa_qualite_geoloc.code IS 'Code de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';

COMMENT ON COLUMN raepa.val_raepa_qualite_geoloc.valeur IS 'Valeur de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';

COMMENT ON COLUMN raepa.val_raepa_qualite_geoloc.definition IS 'Définition de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';

INSERT INTO raepa.val_raepa_qualite_geoloc (code
    , valeur
    , definition)
    VALUES ('01'
        , 'Classe A'
        , 'Classe de précision inférieure 40 cm')
    , ('02'
        , 'Classe B'
        , 'Classe de précision supérieure à 40 cm et inférieure à 1,50 m')
    , ('03'
        , 'Classe C'
        , 'Classe de précision supérieure à 1,50 m');

CREATE TABLE raepa.val_raepa_support_incident (
    code character varying(2) NOT NULL
    , valeur character varying(80) NOT NULL
    , definition character varying(255)
    , CONSTRAINT raepa_support_incident_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE raepa.val_raepa_support_incident IS 'Type d''élément de réseau concerné par un incident';

COMMENT ON COLUMN raepa.val_raepa_support_incident.code IS 'Code de la liste énumérée relative au type d''élément de réseau concerné par une réparation';

COMMENT ON COLUMN raepa.val_raepa_support_incident.valeur IS 'Valeur de la liste énumérée relative au type d''élément de réseau concerné par une réparation';

COMMENT ON COLUMN raepa.val_raepa_support_incident.definition IS 'Définition de la liste énumérée relative au type d''élément de réseau concerné par une réparation';

INSERT INTO raepa.val_raepa_support_incident (code
    , valeur
    , definition)
    VALUES ('01'
        , 'Canalisation'
        , 'Réparation sur une canalisation')
    , ('02'
        , 'Appareillage'
        , 'Réparation d''un appareillage')
    , ('03'
        , 'Ouvrage'
        , 'Réparation d''un ouvrage');

-- AEP
CREATE TABLE raepa.val_raepa_cat_canal_ae (
    code character varying(2) NOT NULL
    , valeur character varying(80) NOT NULL
    , definition character varying(255)
    , CONSTRAINT raepa_cat_canal_ae_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE raepa.val_raepa_cat_canal_ae IS 'Nature des eaux véhiculées par une canalisation d''adduction d''eau';

COMMENT ON COLUMN raepa.val_raepa_cat_canal_ae.code IS 'Code de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''adduction d''eau';

COMMENT ON COLUMN raepa.val_raepa_cat_canal_ae.valeur IS 'Valeur de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''adduction d''eau';

COMMENT ON COLUMN raepa.val_raepa_cat_canal_ae.definition IS 'Définition de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''adduction d''eau';

INSERT INTO raepa.val_raepa_cat_canal_ae (code
    , valeur
    , definition)
    VALUES ('00'
        , 'Indéterminée'
        , 'Nature des eaux véhiculées par la canalisation inconnue')
    , ('01'
        , 'Eau brute'
        , 'Canalisation véhiculant de l''eau brute')
    , ('02'
        , 'Eau potable'
        , 'Canalisation véhiculant de l''eau potable')
    , ('99'
        , 'Autre'
        , 'Canalisation véhiculant tantôt de l''eau brute, tantôt de l''eau potable');

CREATE TABLE raepa.val_raepa_fonc_canal_ae (
    code character varying(2) NOT NULL
    , valeur character varying(80) NOT NULL
    , definition character varying(255)
    , CONSTRAINT raepa_fonc_canal_ae_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE raepa.val_raepa_fonc_canal_ae IS 'Fonction dans le réseau d''une canalisation d''adduction d''eau';

COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ae.code IS 'Code de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''adduction d''eau';

COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ae.valeur IS 'Valeur de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''adduction d''eau';

COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ae.definition IS 'Définition de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''adduction d''eau';

INSERT INTO raepa.val_raepa_fonc_canal_ae (code
    , valeur
    , definition)
    VALUES ('00'
        , 'Indéterminée'
        , 'Fonction de la canalisation dans le réseau inconnue')
    , ('01'
        , 'Transport'
        , 'Canalisation de transport')
    , ('02'
        , 'Distribution'
        , 'Canalisation de distribution')
    , ('99'
        , 'Autre'
        , 'Canalisation dont la fonction dans le réseau ne figure pas dans la liste ci-dessus');

CREATE TABLE raepa.val_raepa_cat_app_ae (
    code character varying(2) NOT NULL
    , valeur character varying(80) NOT NULL
    , definition character varying(255)
    , CONSTRAINT raepa_cat_app_ae_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE raepa.val_raepa_cat_app_ae IS 'Type d''un appareillage d''adduction d''eau';

COMMENT ON COLUMN raepa.val_raepa_cat_app_ae.code IS 'Code de la liste énumérée relative au type d''un appareillage d''adduction d''eau';

COMMENT ON COLUMN raepa.val_raepa_cat_app_ae.valeur IS 'Valeur de la liste énumérée relative au type d''un appareillage d''adduction d''eau';

COMMENT ON COLUMN raepa.val_raepa_cat_app_ae.definition IS 'Définition de la liste énumérée relative au type d''un appareillage d''adduction d''eau';

INSERT INTO raepa.val_raepa_cat_app_ae (code
    , valeur
    , definition)
    VALUES ('00'
        , 'Indéterminé'
        , 'Type d''appareillage inconnu')
    , ('01'
        , 'Point de branchement'
        , 'Piquage de branchement individuel')
    , ('02'
        , 'Ventouse'
        , 'Ventouse d''adduction d''eau')
    , ('03'
        , 'Vanne'
        , 'Vanne d''adduction d''eau')
    , ('04'
        , 'Vidange'
        , 'Vidange d''adduction d''eau')
    , ('05'
        , 'Régulateur de pression'
        , 'Régulateur de pression')
    , ('06'
        , 'Hydrant'
        , 'Poteau de défense contre l''incendie')
    , ('07'
        , 'Compteur'
        , 'Appareil de mesure des volumes transités')
    , ('08'
        , 'Débitmètre'
        , 'Appareil de mesure des débits transit')
    , ('99'
        , 'Autre'
        , 'Appareillage dont le type ne figure pas dans la liste ci-dessus');

CREATE TABLE raepa.val_raepa_cat_ouv_ae (
    code character varying(2) NOT NULL
    , valeur character varying(80) NOT NULL
    , definition character varying(255)
    , CONSTRAINT raepa_cat_ouv_ae_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE raepa.val_raepa_cat_ouv_ae IS 'Type d''un ouvrage d''adduction d''eau';

COMMENT ON COLUMN raepa.val_raepa_cat_ouv_ae.code IS 'Code de la liste énumérée relative au type d''un ouvrage d''adduction d''eau';

COMMENT ON COLUMN raepa.val_raepa_cat_ouv_ae.valeur IS 'Valeur de la liste énumérée relative au type d''un ouvrage d''adduction d''eau';

COMMENT ON COLUMN raepa.val_raepa_cat_ouv_ae.definition IS 'Définition de la liste énumérée relative au type d''un ouvrage d''adduction d''eau';

INSERT INTO raepa.val_raepa_cat_ouv_ae (code
    , valeur
    , definition)
    VALUES ('00'
        , 'Indéterminé'
        , 'Type d''ouvrage inconnu')
    , ('01'
        , 'Station de pompage'
        , 'Station de pompage d''eau potable')
    , ('02'
        , 'Station de traitement'
        , 'Station de traitement d''eau potable')
    , ('03'
        , 'Réservoir'
        , 'Réservoir d''eau potable')
    , ('04'
        , 'Chambre de comptage'
        , 'Chambre de comptage')
    , ('05'
        , 'Captage'
        , 'Captage')
    , ('99'
        , 'Autre'
        , 'Ouvrage dont le type ne figure pas dans la liste ci-dessus');

-- ASS
CREATE TABLE raepa.val_raepa_cat_reseau_ass (
    code character varying(2) NOT NULL
    , valeur character varying(80) NOT NULL
    , definition character varying(255)
    , CONSTRAINT raepa_cat_reseau_ass_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE raepa.val_raepa_cat_reseau_ass IS 'Type de réseau d''assainissement collectif';

COMMENT ON COLUMN raepa.val_raepa_cat_reseau_ass.code IS 'Code de la liste énumérée relative au type de réseau d''assainissement collectif';

COMMENT ON COLUMN raepa.val_raepa_cat_reseau_ass.valeur IS 'Valeur de la liste énumérée relative au type de réseau d''assainissement collectif';

COMMENT ON COLUMN raepa.val_raepa_cat_reseau_ass.definition IS 'Définition de la liste énumérée relative au type de réseau d''assainissement collectif';

INSERT INTO raepa.val_raepa_cat_reseau_ass (code
    , valeur
    , definition)
    VALUES ('01'
        , 'Pluvial'
        , 'Réseau de collecte de seules eaux pluviales')
    , ('02'
        , 'Eaux usées'
        , 'Réseau de collecte de seules eaux usées')
    , ('03'
        , 'Unitaire'
        , 'Réseau de collecte des eaux usées et des eaux pluviales');

CREATE TABLE raepa.val_raepa_cat_canal_ass (
    code character varying(2) NOT NULL
    , valeur character varying(80) NOT NULL
    , definition character varying(255)
    , CONSTRAINT raepa_cat_canal_ass_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE raepa.val_raepa_cat_canal_ass IS 'Nature des eaux véhiculées par une canalisation d''assainissement collectif';

COMMENT ON COLUMN raepa.val_raepa_cat_canal_ass.code IS 'Code de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''assainissement collectif';

COMMENT ON COLUMN raepa.val_raepa_cat_canal_ass.valeur IS 'Valeur de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''assainissement collectif';

COMMENT ON COLUMN raepa.val_raepa_cat_canal_ass.definition IS 'Définition de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''assainissement collectif';

INSERT INTO raepa.val_raepa_cat_canal_ass (code
    , valeur
    , definition)
    VALUES ('00'
        , 'Indéterminée'
        , 'Nature des eaux véhiculées par la canalisation inconnue')
    , ('01'
        , 'Eaux pluviales'
        , 'Canalisation véhiculant des eaux pluviales')
    , ('02'
        , 'Eaux usées'
        , 'Canalisation véhiculant des eaux usées')
    , ('03'
        , 'Unitaire'
        , 'Canalisation véhiculant des eaux usées et pluviales en fonctionnement normal')
    , ('99'
        , 'Autre'
        , 'Canalisation véhiculant tantôt des eaux pluviales, tantôt des eaux usées');

CREATE TABLE raepa.val_raepa_fonc_canal_ass (
    code character varying(2) NOT NULL
    , valeur character varying(80) NOT NULL
    , definition character varying(255)
    , CONSTRAINT raepa_fonc_canal_ass_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE raepa.val_raepa_fonc_canal_ass IS 'Fonction dans le réseau d''une canalisation d''assainissement collectif';

COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ass.code IS 'Code de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''assainissement collectif';

COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ass.valeur IS 'Valeur de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''assainissement collectif';

COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ass.definition IS 'Définition de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''assainissement collectif';

INSERT INTO raepa.val_raepa_fonc_canal_ass (code
    , valeur
    , definition)
    VALUES ('00'
        , 'Indéterminée'
        , 'Fonction de la canalisation dans le réseau inconnue')
    , ('01'
        , 'Transport'
        , 'Canalisation de transport')
    , ('02'
        , 'Collecte'
        , 'Canalisation de collecte')
    , ('99'
        , 'Autre'
        , 'Canalisation dont la fonction dans le réseau ne figure pas dans la liste ci-dessus');

CREATE TABLE raepa.val_raepa_cat_app_ass (
    code character varying(2) NOT NULL
    , valeur character varying(80) NOT NULL
    , definition character varying(255)
    , CONSTRAINT raepa_cat_app_ass_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE raepa.val_raepa_cat_app_ass IS 'Type d''un appareillage d''assainissement collectif';

COMMENT ON COLUMN raepa.val_raepa_cat_app_ass.code IS 'Code de la liste énumérée relative au type d''un appareillage d''assainissement collectif';

COMMENT ON COLUMN raepa.val_raepa_cat_app_ass.valeur IS 'Valeur de la liste énumérée relative au type d''un appareillage d''assainissement collectif';

COMMENT ON COLUMN raepa.val_raepa_cat_app_ass.definition IS 'Définition de la liste énumérée relative au type d''un appareillage d''assainissement collectif';

INSERT INTO raepa.val_raepa_cat_app_ass (code
    , valeur
    , definition)
    VALUES ('00'
        , 'Indéterminé'
        , 'Type d''appareillage inconnu')
    , ('01'
        , 'Point de branchement'
        , 'Piquage de branchement individuel')
    , ('02'
        , 'Ventouse'
        , 'Ventouse d''assainissement')
    , ('03'
        , 'Vanne'
        , 'Vanne d''assainissement')
    , ('04'
        , 'Débitmètre'
        , 'Appareil de mesure des débits transités')
    , ('99'
        , 'Autre'
        , 'Appareillage dont le type ne figure pas dans la liste ci-dessus');

CREATE TABLE raepa.val_raepa_cat_ouv_ass (
    code character varying(2) NOT NULL
    , valeur character varying(80) NOT NULL
    , definition character varying(255)
    , CONSTRAINT raepa_cat_ouv_ass_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE raepa.val_raepa_cat_ouv_ass IS 'Type d''un ouvrage d''assainissement collectif';

COMMENT ON COLUMN raepa.val_raepa_cat_ouv_ass.code IS 'Code de la liste énumérée relative au type d''un ouvrage d''assainissement collectif';

COMMENT ON COLUMN raepa.val_raepa_cat_ouv_ass.valeur IS 'Valeur de la liste énumérée relative au type d''un ouvrage d''assainissement collectif';

COMMENT ON COLUMN raepa.val_raepa_cat_ouv_ass.definition IS 'Définition de la liste énumérée relative au type d''un ouvrage d''assainissement collectif';

INSERT INTO raepa.val_raepa_cat_ouv_ass (code
    , valeur
    , definition)
    VALUES ('00'
        , 'Indéterminé'
        , 'Type d''ouvrage inconnu')
    , ('01'
        , 'Station de pompage'
        , 'Station de pompage d''eaux usées et/ou pluviales')
    , ('02'
        , 'Station d''épuration'
        , 'Station de traitement d''eaux usées')
    , ('03'
        , 'Bassin de stockage'
        , 'Ouvrage de stockage d''eaux usées et/ou pluviales')
    , ('04'
        , 'Déversoir d''orage'
        , 'Ouvrage de décharge du trop-plein d''effluents d''une canalisation d''assainissement collectif  vers un milieu naturel récepteur')
    , ('05'
        , 'Rejet'
        , 'Rejet (exutoire) dans le milieu naturel d''eaux usées et/ou pluviales')
    , ('06'
        , 'Regard'
        , 'Regard')
    , ('07'
        , 'Avaloir'
        , 'Avaloir')
    , ('99'
        , 'Autre'
        , 'Ouvrage dont le type ne figure pas dans la liste ci-dessus');
