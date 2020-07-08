CREATE OR REPLACE VIEW raepa.raepa_canalaep_l AS
SELECT
    pipe.id::text AS idcana , -- Identifiant de la canalisation (clé primaire)
    pipe.geometry AS geom , -- Géométrie
    distributor.name AS mouvrage , -- Maître d'ouvrage du réseau
    distributor.name AS gexploit , -- Maître d'ouvrage du réseau / TODO: ce n'est pas toujours le cas. À améliorer dans qwat_dr
    CASE WHEN pipe.fk_status = 1301 THEN
        'O'
    ELSE
        'N'
    END AS enservice , -- Canalisation en service / Canalisation abandonnée O / N
    CASE WHEN pipe.fk_function = 4108 THEN
        'N'
    ELSE
        'O'
    END AS branchement , -- Canalisation de branchement individuel: O Canalisation de transport ou de distribution: N
    CASE material.short_fr
    WHEN 'AC' THEN
        '01'
    WHEN 'ACG' THEN
        '28'
    WHEN 'ACI' THEN
        '01'
    WHEN 'ACPR' THEN
        '01'
    WHEN 'Autre' THEN
        '99'
    WHEN 'CU' THEN
        '07'
    WHEN 'F' THEN
        '12'
    WHEN 'FAE' THEN
        '11'
    WHEN 'Inc.' THEN
        '00' -- À vérifier
    WHEN 'PE' THEN
        '18'
    WHEN 'PE80' THEN
        '18'
    WHEN 'PEX' THEN
        '17'
    WHEN 'PL' THEN
        '21' -- ???
    WHEN 'PRV' THEN
        '23' -- ou '22'
    WHEN 'PVC' THEN
        '27' -- Il manque des distinctions dans QWAT
    WHEN 'TAC' THEN
        '02'
    WHEN 'TC' THEN
        '10' -- ou '08' ?
    WHEN 'à dét.' THEN
        '00'
    ELSE
        '99' -- autre
    END AS materiau , -- Matériau de la canalisation d'adduction d'eau potableCodes de la table VAL_RAEPA_MATERIAU
    material.diameter_nominal AS diametre , -- Diamètre nominal de la canalisation (en millimètres)
    pipe.year AS anfinpose , -- Année marquant la fin de la période de pose de la canalisation
    -- Il n'y a pas d'information sur la circulation dans QWAT
    '00' AS modecirc , -- Mode de circulation de l'eau à l'intérieur de la canalisation Codes de la table VAL_RAEPA_MODE_CIRCULATION
    CASE pipe.fk_watertype
    WHEN 1501 THEN
        '01' -- brute
    WHEN 1502 THEN
        '02' -- potable
    WHEN 102 THEN
        '00' -- inconnu -> inconnu
    WHEN 103 THEN
        '00' -- à déterminer -> inconnu
    ELSE
        '99' -- autre
    END AS contcanaep , -- Catégorie de la canalisation d'adduction d'eau potable Codesde la table VAL_RAEPA_CAT_CANAL_AE
    CASE pipe.fk_function
    WHEN 4101 THEN
        '01' -- conduite de transport
    WHEN 4105 THEN
        '02' -- conduite de distribution
    WHEN 102 THEN
        '00' -- inconnu -> inconnu
    WHEN 103 THEN
        '00' -- à déterminer -> inconnu
    ELSE
        '99' -- autre
    END AS fonccanaep , -- Fonction de la canalisation d'adduction d'eau potable Codesde la table VAL_RAEPA_FONC_CANAL_AE
    pipe.fk_node_a::varchar(254) AS idnini , -- Identifiant du nœud de début de la canalisation (clé étrangère)
    pipe.fk_node_b::varchar(254) AS idnterm , -- Identifiant du nœud de fin de la canalisation (clé étrangère)
    pipe.fk_parent::varchar(254) AS idcanppale , -- Identifiant de la canalisation principale (clé étrangère) Caractère (254)
    '0.00'::numeric(3 , 2) AS profgen , -- Profondeur moyenne de la génératrice supérieure de la canalisation Décimal (1,2) TODO
    pipe.year::varchar(4) AS andebpose , -- Année marquant le début de la période de pose de la canalisation Caractère (4)
    pipe._length2d::numeric(4) AS longcana , -- Longueur mesurée de canalisation (en mètres) Entier (4)
    'TBD' AS nbranche , -- Nombre de branchements individuels sur la canalisation d'adduction d'eau potable TODO
    CASE pipe.fk_precision
    WHEN 1104 THEN
        '01' -- Digitalisé -> Classe A
    WHEN 1103 THEN
        '02' -- Localisé -> Classe B
    ELSE
        '03' -- Classe C
    END AS qualglocxy , -- Qualité de la géolocalisation planimétrique (XY) Codes de la table VAL_RAEPA_QUALITE_GEOLOC Caractère (2)
    CASE pipe.fk_precision
    WHEN 1104 THEN
        '01' -- Digitalisé -> Classe A
    WHEN 1103 THEN
        '02' -- Localisé -> Classe B
    ELSE
        '03' -- Classe C
    END AS qualglocz , -- TODO N'existe pas pour 'pipe' dans QWAT. Qualité de la géolocalisation altimétrique (Z) Codes de la table VAL_RAEPA_QUALITE_GEOLOC Caractère (2)
    maj.lastmodif AS datemaj , -- Date de la dernière mise à jour des informations Date (10) 
    ''::varchar(100) AS sourmaj , -- TODO Source de la mise à jour Caractère (100)
    ''::varchar(2) AS qualannee , -- TODO Fiabilité, lorsque ANDEBPOSE = ANFINPOSE, de l'année de pose Codes de la table VAL_RAEPA_QUALITE_ANPOSE Caractère (2)
    ''::varchar(10) AS dategeoloc , -- TODO Date de la géolocalisation Date (10)
    ''::varchar(100) AS sourgeoloc , -- TODO Auteur de la géolocalisation Caractère (100)
    ''::varchar(100) AS sourattrib -- TODO SOURATTRIB Auteur de la saisie des données attributaires (lorsque différent de l'auteur de la géolocalisation) Caractère (100)
FROM
    qwat_od.pipe
    LEFT JOIN qwat_od.distributor distributor ON pipe.fk_distributor = distributor.id
    LEFT JOIN qwat_vl.pipe_material material ON pipe.fk_material = material.id
    LEFT JOIN qwat_vl. "precision" "precision" ON pipe.fk_precision = "precision".id
    LEFT JOIN (
        -- extract last updated row from logged actions tracked by audit triggers
        SELECT
			(row_data -> 'id')::integer as id,
			date(max(action_tstamp_clk)) as lastmodif
		FROM qwat_sys.logged_actions
		WHERE
		    schema_name = 'qwat_od' and table_name = 'pipe'
		GROUP BY  (row_data -> 'id') 

        ) maj ON pipe.id = maj.id
ORDER BY
    datemaj
