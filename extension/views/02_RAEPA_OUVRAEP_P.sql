CREATE OR REPLACE VIEW raepa.raepa_ouvraep_p AS
SELECT
    element.id::varchar(254) AS idouvrage , -- Identifiant de l'ouvrage (clé primaire)
    -- TODO element.id ou element.identification ?
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
WHEN 'chamber' THEN
    '04' -- Chambre de comptage / Chambre de comptage
    -- WHEN 'pressurecontrol' THEN '99' -- dans RAEPA_APPARAEP_P
WHEN 'pump' THEN
    '01' -- Station de pompage / Station de pompage d'eau potable
WHEN 'source' THEN
    '05' -- Captage / Captage
WHEN 'tank' THEN
    '03' -- Réservoir / Réservoir d'eau potable
WHEN 'treatment' THEN
    '02 ' -- Station de traitement / Station de traitement d'eau potable
WHEN 'installation' THEN
    '99' -- TODO ? Autre / Ouvrage dont le type ne figure pas dans la liste ci-dessus
END AS fnouvaep , -- Fonction de l'ouvrage d'adduction d'eau potable Codes de la table VAL_RAEPA_FONC_OUV_AE
element.year_end AS anfinpose , -- Année marquant la fin de la période de mise en service de l'ouvrage
installation.fk_pipe_in AS idcanamont , -- Identifiants des canalisations d'amont de l'ouvrage (clés étrangères)
installation.fk_pipe_out AS idcanaval , -- Identifiants des canalisations d'aval de l'ouvrage (clés étrangères)
element.altitude::Numeric(10 , 3) AS z , -- Altitude (en mètres, référentiel NGF-IGN69)
element.year AS andebpose , -- Année marquant le début de la période de mise en service de l'ouvrage
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
installation.fk_parent AS idcanppale , -- Identifiant de la canalisation principale (clé étrangère)
maj.lastmodif AS datemaj , -- Date de la dernière mise à jour des informations Date (10)
''::varchar(100) AS sourmaj , -- TODO Source de la mise à jour Caractère (100)
''::varchar(2) AS qualannee , -- TODO Fiabilité, lorsque ANDEBPOSE = ANFINPOSE, de l'année de pose Codes de la table VAL_RAEPA_QUALITE_ANPOSE Caractère (2)
''::varchar(10) AS dategeoloc , -- TODO Date de la géolocalisation Date (10)
''::varchar(100) AS sourgeoloc , -- TODO Auteur de la géolocalisation Caractère (100)
''::varchar(100) AS sourattrib -- TODO SOURATTRIB Auteur de la saisie des données attributaires (lorsque différent de l'auteur de la géolocalisation) Caractère (100)
FROM
    qwat_od.vw_qwat_installation installation
    JOIN qwat_od.vw_node_element element ON installation.id = element.id
    LEFT JOIN (
            -- get latest logged date for installations 
            SELECT
                (row_data -> 'id')::integer as id,
                date(max(action_tstamp_clk)) as lastmodif
            FROM qwat_sys.logged_actions
            WHERE
                schema_name = 'qwat_od'
                AND table_name = 'vw_element_installation'
            GROUP BY  (row_data -> 'id')
            ) maj ON element.id = maj.id;
