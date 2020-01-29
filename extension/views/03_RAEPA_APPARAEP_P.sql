CREATE OR REPLACE VIEW raepa.raepa_apparaep_p AS
--
-- DÉBUT DE qwat_od.vw_export_hydrant
--

(
    SELECT
        hydrant.id::varchar(254) AS idappareil , -- Identifiant de l'appareillage (clé primaire)
        hydrant.geometry AS geom , -- Géométrie
        ST_X (ST_Transform (hydrant.geometry
                , 2154))::Numeric(10 , 3) AS x , -- Coordonnée X Lambert 93 (en mètres)
        ST_Y (ST_Transform (hydrant.geometry
                , 2154))::Numeric(10 , 3) AS y , -- Coordonnée X Lambert 93 (en mètres)
        hydrant.distributor_name AS mouvrage , -- Maître d'ouvrage du réseau
        hydrant.distributor_name AS gexploit , -- TODO Gestionnaire exploitant du réseau
        '06' AS fnappaep
        , NULL AS diametre -- Diamètre nominal de l'appareillage (en millimètres) / TODO
        , hydrant.year_end::varchar(4) AS anfinpose -- Année marquant la fin de la période de mise en service de l'appareillage
        , NULL::varchar(254) AS idcanamont -- Identifiants des canalisations d'amont de l'ouvrage (clés étrangères) / TODO intersection ?
        , NULL::varchar(254) AS idcanaval -- Identifiants des canalisations d'aval de l'ouvrage (clés étrangères) / TODO intersection ?
        , NULL::varchar(254) AS idcanppale -- Identifiant de la canalisation principale (clé étrangère) / TODO intersection ?
        , NULL::varchar(254) AS idouvrage -- Identifiant de l'ouvrage d'accueil (clé étrangère) / TODO : Est-ce bien NULL ?
        , hydrant.altitude::Numeric(10 , 3) AS z -- Altitude (en mètres, référentiel NGF-IGN69)
        , hydrant.year::varchar(4) AS andebpose , -- Année marquant le début de la période de mise en service de l'ouvrage
        CASE hydrant.fk_precision
        WHEN 1104 THEN
            '01' -- Digitalisé -> Classe A
        WHEN 1103 THEN
            '02' -- Localisé -> Classe B
        ELSE
            '03' -- Classe C
        END AS qualglocxy , -- Qualité de la géolocalisation planimétrique (XY) Codes de la table VAL_RAEPA_QUALITE_GEOLOC
        CASE hydrant.fk_precisionalti
        WHEN 1123 THEN
            '01' -- TODO : c'est une erreur (précision 40cm) Inférieure à 50 cm -> Classe A
        WHEN 1124 THEN
            '01' -- Inférieure à 10 cm -> Classe A
        WHEN 1125 THEN
            '01' -- Inférieure à 5 cm -> Classe A
        WHEN 1122 THEN
            '02' -- Inférieure à 100 cm -> Classe B
            -- Les classes de QWAT ne sont pas adaptées pour le RAEPA
        ELSE
            '03' -- Classe C
        END AS qualglocz , -- Qualité de la géolocalisation altimétrique (Z) Codes de la table VAL_RAEPA_QUALITE_GEOLOC
        maj.lastmodif AS datemaj , -- Date de la dernière mise à jour des informations Date (10) TODO nécessite track_commit_timestamp = on dans postgresql.conf
        ''::varchar(100) AS sourmaj , -- TODO Source de la mise à jour Caractère (100)
        ''::varchar(2) AS qualannee , -- TODO Fiabilité, lorsque ANDEBPOSE = ANFINPOSE, de l'année de pose Codes de la table VAL_RAEPA_QUALITE_ANPOSE Caractère (2)
        ''::varchar(10) AS dategeoloc , -- TODO Date de la géolocalisation Date (10)
        ''::varchar(100) AS sourgeoloc , -- TODO Auteur de la géolocalisation Caractère (100)
        ''::varchar(100) AS sourattrib -- TODO SOURATTRIB Auteur de la saisie des données attributaires (lorsque différent de l'auteur de la géolocalisation) Caractère (100)
    FROM
        qwat_od.vw_export_hydrant hydrant
    LEFT JOIN (
        SELECT
            date(pg_xact_commit_timestamp(xmin)) lastmodif
            , *
        FROM
            qwat_od.hydrant) maj ON hydrant.id = maj.id)
--
-- FIN DE qwat_od.vw_export_hydrant
--
UNION
--
-- DÉBUT DE qwat_od.network_element / pressure_control
--
(
    SELECT
        element.id::varchar(254) AS idappareil , -- Identifiant de l'ouvrage (clé primaire)
        element.geometry AS geom , -- Géométrie
        ST_X (ST_Transform (element.geometry
                , 2154))::Numeric(10 , 3) AS x , -- Coordonnée X Lambert 93 (en mètres)
        ST_Y (ST_Transform (element.geometry
                , 2154))::Numeric(10 , 3) AS y , -- Coordonnée X Lambert 93 (en mètres)
        (
            SELECT
                name FROM qwat_od.distributor
            WHERE
                id = element.fk_distributor)::varchar(100) AS mouvrage , -- Maître d'ouvrage du réseau
        (
            SELECT
                name FROM qwat_od.distributor
            WHERE
                id = element.fk_distributor)::varchar(100) AS gexploit , -- TODO Gestionnaire exploitant du réseau
        CASE installation.installation_type
        WHEN 'pressurecontrol' THEN
            '05' -- Régulateur de pression / Régulateur de pression
        END AS fnappaep , -- Fonction de l'ouvrage d'adduction d'eau potable Codes de la table VAL_RAEPA_FONC_OUV_AE
        NULL::Numeric(5) AS diameter , element.year_end::varchar(4) AS anfinpose , -- Année marquant la fin de la période de mise en service de l'ouvrage
        installation.fk_pipe_in::varchar(254) AS idcanamont , -- Identifiants des canalisations d'amont de l'ouvrage (clés étrangères)
        installation.fk_pipe_out::varchar(254) AS idcanaval , -- Identifiants des canalisations d'aval de l'ouvrage (clés étrangères)
        installation.fk_parent::varchar(254) AS idcanppale , -- Identifiant de la canalisation principale (clé étrangère)
        NULL::varchar(254) AS idouvrage , -- Identifiant de l'ouvrage d'accueil (clé étrangère) / TODO : Est-ce bien NULL ?
        element.altitude::Numeric(10 , 3) AS z , -- Altitude (en mètres, référentiel NGF-IGN69)
        element.year::varchar(4) AS andebpose , -- Année marquant le début de la période de mise en service de l'ouvrage
        CASE element.fk_precision
        WHEN 1104 THEN
            '01' -- Digitalisé -> Classe A
        WHEN 1103 THEN
            '02' -- Localisé -> Classe B
        ELSE
            '03' -- Classe C
        END AS qualglocxy , -- Qualité de la géolocalisation planimétrique (XY) Codes de la table VAL_RAEPA_QUALITE_GEOLOC
        CASE element.fk_precisionalti
        WHEN 1123 THEN
            '01' -- TODO : c'est une erreur (précision 40cm) Inférieure à 50 cm -> Classe A
        WHEN 1124 THEN
            '01' -- Inférieure à 10 cm -> Classe A
        WHEN 1125 THEN
            '01' -- Inférieure à 5 cm -> Classe A
        WHEN 1122 THEN
            '02' -- Inférieure à 100 cm -> Classe B
            -- Les classes de QWAT ne sont pas adaptées pour le RAEPA
        ELSE
            '03' -- Classe C
        END AS qualglocz , -- Qualité de la géolocalisation altimétrique (Z) Codes de la table VAL_RAEPA_QUALITE_GEOLOC
        maj.lastmodif AS datemaj , -- Date de la dernière mise à jour des informations Date (10) TODO nécessite track_commit_timestamp = on dans postgresql.conf
        ''::varchar(100) AS sourmaj , -- TODO Source de la mise à jour Caractère (100)
        ''::varchar(2) AS qualannee , -- TODO Fiabilité, lorsque ANDEBPOSE = ANFINPOSE, de l'année de pose Codes de la table VAL_RAEPA_QUALITE_ANPOSE Caractère (2)
        ''::varchar(10) AS dategeoloc , -- TODO Date de la géolocalisation Date (10)
        ''::varchar(100) AS sourgeoloc , -- TODO Auteur de la géolocalisation Caractère (100)
        ''::varchar(100) AS sourattrib -- TODO SOURATTRIB Auteur de la saisie des données attributaires (lorsque différent de l'auteur de la géolocalisation) Caractère (100)
    FROM
        qwat_od.vw_qwat_installation installation
        JOIN qwat_od.vw_node_element element ON installation.id = element.id
        LEFT JOIN (
            SELECT
                date(pg_xact_commit_timestamp(xmin)) lastmodif , *
            FROM
                qwat_od.network_element) maj ON element.id = maj.id)
    --
    -- FIN DE qwat_od.network_element / pressure_control
    --
UNION
--
-- DÉBUT DE qwat_od.vw_export_valve
--
(
    SELECT
        valve.id::varchar(254) AS idappareil , -- Identifiant de l'appareillage (clé primaire)
        valve.geometry AS geom , -- Géométrie
        ST_X (ST_Transform (valve.geometry
                , 2154))::Numeric(10 , 3) AS x , -- Coordonnée X Lambert 93 (en mètres)
        ST_Y (ST_Transform (valve.geometry
                , 2154))::Numeric(10 , 3) AS y , -- Coordonnée X Lambert 93 (en mètres)
        valve.distributor_name AS mouvrage , -- Maître d'ouvrage du réseau
        valve.distributor_name AS gexploit , -- TODO Gestionnaire exploitant du réseau
        CASE valve.fk_valve_type
        WHEN 102 THEN
            '00' -- Inconnu / à déterminer  - > Indéterminé / Type d'appareillage inconnu
        WHEN 6101 THEN
            '03' -- Vanne -> Vanne / Vanne d'adduction d'eau
        WHEN 6110 THEN
            '04' -- Vidange -> Vidange / Vidange d'adduction d'eau
        WHEN 6105 THEN
            '01' -- Branchement -> Point de branchement / Piquage de branchement individuel
        WHEN 6102 THEN
            '02' -- Ventouse -> Ventouse / Ventouse d'adduction d'eau
        ELSE
            '99' -- Autre / Appareillage dont le type ne figure pas dans la liste ci-dessus
        END AS fnappaep
        , vl_valve_diameter.value_fr::Numeric(5) AS diametre -- Diamètre nominal de l'appareillage (en millimètres) / TODO conversion si nécessaire
        , valve.year_end::varchar(4) AS anfinpose -- Année marquant la fin de la période de mise en service de l'appareillage
        , valve.fk_pipe::varchar(254) AS idcanamont -- Identifiants des canalisations d'amont de l'ouvrage (clés étrangères)
        , valve.fk_pipe::varchar(254) AS idcanaval -- Identifiants des canalisations d'aval de l'ouvrage (clés étrangères) / TODO est-ce pertinent ? NULL possible ?
        , valve.fk_pipe::varchar(254) AS idcanppale -- Identifiant de la canalisation principale (clé étrangère)
        , NULL::varchar(254) AS idouvrage -- Identifiant de l'ouvrage d'accueil (clé étrangère) / TODO : Est-ce bien NULL ?
        , valve.altitude::Numeric(10 , 3) AS z -- Altitude (en mètres, référentiel NGF-IGN69)
        , valve.year::varchar(4) AS andebpose , -- Année marquant le début de la période de mise en service de l'ouvrage
        CASE valve.fk_precision
        WHEN 1104 THEN
            '01' -- Digitalisé -> Classe A
        WHEN 1103 THEN
            '02' -- Localisé -> Classe B
        ELSE
            '03' -- Classe C
        END AS qualglocxy , -- Qualité de la géolocalisation planimétrique (XY) Codes de la table VAL_RAEPA_QUALITE_GEOLOC
        CASE valve.fk_precisionalti
        WHEN 1123 THEN
            '01' -- TODO : c'est une erreur (précision 40cm) Inférieure à 50 cm -> Classe A
        WHEN 1124 THEN
            '01' -- Inférieure à 10 cm -> Classe A
        WHEN 1125 THEN
            '01' -- Inférieure à 5 cm -> Classe A
        WHEN 1122 THEN
            '02' -- Inférieure à 100 cm -> Classe B
            -- Les classes de QWAT ne sont pas adaptées pour le RAEPA
        ELSE
            '03' -- Classe C
        END AS qualglocz , -- Qualité de la géolocalisation altimétrique (Z) Codes de la table VAL_RAEPA_QUALITE_GEOLOC
        maj.lastmodif AS datemaj , -- Date de la dernière mise à jour des informations Date (10) TODO nécessite track_commit_timestamp = on dans postgresql.conf
        ''::varchar(100) AS sourmaj , -- TODO Source de la mise à jour Caractère (100)
        ''::varchar(2) AS qualannee , -- TODO Fiabilité, lorsque ANDEBPOSE = ANFINPOSE, de l'année de pose Codes de la table VAL_RAEPA_QUALITE_ANPOSE Caractère (2)
        ''::varchar(10) AS dategeoloc , -- TODO Date de la géolocalisation Date (10)
        ''::varchar(100) AS sourgeoloc , -- TODO Auteur de la géolocalisation Caractère (100)
        ''::varchar(100) AS sourattrib -- TODO SOURATTRIB Auteur de la saisie des données attributaires (lorsque différent de l'auteur de la géolocalisation) Caractère (100)
    FROM
        qwat_od.vw_export_valve valve
    LEFT JOIN qwat_vl.nominal_diameter vl_valve_diameter ON (valve.fk_nominal_diameter = vl_valve_diameter.id)
    LEFT JOIN (
        SELECT
            date(pg_xact_commit_timestamp(xmin)) lastmodif
            , *
        FROM
            qwat_od.valve) maj ON valve.id = maj.id)
--
-- FIN DE qwat_od.vw_export_valve
--
UNION
--
-- DÉBUT DE qwat_od.vw_export_part
--
(
    SELECT
        part.id::varchar(254) AS idappareil , -- Identifiant de l'appareillage (clé primaire)
        part.geometry AS geom , -- Géométrie
        ST_X (ST_Transform (part.geometry
                , 2154))::Numeric(10 , 3) AS x , -- Coordonnée X Lambert 93 (en mètres)
        ST_Y (ST_Transform (part.geometry
                , 2154))::Numeric(10 , 3) AS y , -- Coordonnée X Lambert 93 (en mètres)
        part.distributor_name AS mouvrage , -- Maître d'ouvrage du réseau
        part.distributor_name AS gexploit , -- TODO Gestionnaire exploitant du réseau
        CASE part.fk_part_type
        WHEN 9200 THEN
            '07' -- compteur abonné -> Compteur / Appareil de mesure des volumes transités
            -- WHEN 9220 THEN '07' -- compteur de chantier -> Compteur / Appareil de mesure des volumes transités
        WHEN 9210 THEN
            '08' -- débitmètre
        ELSE
            '99' -- Autre / Appareillage dont le type ne figure pas dans la liste ci-dessus
        END AS fnappaep
        , 0::Numeric(5) AS diametre -- Diamètre nominal de l'appareillage (en millimètres) / TODO
        , part.year_end::varchar(4) AS anfinpose -- Année marquant la fin de la période de mise en service de l'appareillage
        , part.fk_pipe::varchar(254) AS idcanamont -- Identifiants des canalisations d'amont de l'ouvrage (clés étrangères)
        , part.fk_pipe::varchar(254) AS idcanaval -- Identifiants des canalisations d'aval de l'ouvrage (clés étrangères) / TODO est-ce pertinent ? NULL possible ?
        , part.fk_pipe::varchar(254) AS idcanppale -- Identifiant de la canalisation principale (clé étrangère)
        , NULL::varchar(254) AS idouvrage -- Identifiant de l'ouvrage d'accueil (clé étrangère) / TODO : Est-ce bien NULL ?
        , part.altitude::Numeric(10 , 3) AS z -- Altitude (en mètres, référentiel NGF-IGN69)
        , part.year::varchar(4) AS andebpose , -- Année marquant le début de la période de mise en service de l'ouvrage
        CASE part.fk_precision
        WHEN 1104 THEN
            '01' -- Digitalisé -> Classe A
        WHEN 1103 THEN
            '02' -- Localisé -> Classe B
        ELSE
            '03' -- Classe C
        END AS qualglocxy , -- Qualité de la géolocalisation planimétrique (XY) Codes de la table VAL_RAEPA_QUALITE_GEOLOC
        CASE part.fk_precisionalti
        WHEN 1123 THEN
            '01' -- TODO : c'est une erreur (précision 40cm) Inférieure à 50 cm -> Classe A
        WHEN 1124 THEN
            '01' -- Inférieure à 10 cm -> Classe A
        WHEN 1125 THEN
            '01' -- Inférieure à 5 cm -> Classe A
        WHEN 1122 THEN
            '02' -- Inférieure à 100 cm -> Classe B
            -- Les classes de QWAT ne sont pas adaptées pour le RAEPA
        ELSE
            '03' -- Classe C
        END AS qualglocz , -- Qualité de la géolocalisation altimétrique (Z) Codes de la table VAL_RAEPA_QUALITE_GEOLOC
        maj.lastmodif AS datemaj , -- Date de la dernière mise à jour des informations Date (10) TODO nécessite track_commit_timestamp = on dans postgresql.conf
        ''::varchar(100) AS sourmaj , -- TODO Source de la mise à jour Caractère (100)
        ''::varchar(2) AS qualannee , -- TODO Fiabilité, lorsque ANDEBPOSE = ANFINPOSE, de l'année de pose Codes de la table VAL_RAEPA_QUALITE_ANPOSE Caractère (2)
        ''::varchar(10) AS dategeoloc , -- TODO Date de la géolocalisation Date (10)
        ''::varchar(100) AS sourgeoloc , -- TODO Auteur de la géolocalisation Caractère (100)
        ''::varchar(100) AS sourattrib -- TODO SOURATTRIB Auteur de la saisie des données attributaires (lorsque différent de l'auteur de la géolocalisation) Caractère (100)
    FROM
        qwat_od.vw_export_part part
    LEFT JOIN (
        SELECT
            date(pg_xact_commit_timestamp(xmin)) lastmodif
            , *
        FROM
            qwat_od.node) maj ON part.id = maj.id)
--
-- FIN DE qwat_od.vw_export_part
--
