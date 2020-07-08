
-- listes de valeurs

 -- support réparation : table non crée, ne concerne que les conduites via les fuites dans QWAT

    -- drop table if exists raepa.val_raepa_support_reparation ;

    -- create table raepa.val_raepa_support_reparation (
    --     code varchar(2) CONSTRAINT pk_val_raepa_support_reparation PRIMARY KEY,
    --     libelle varchar(254), 
    --     "definition" varchar(254) 
    -- ) ; 

    -- INSERT into raepa.val_raepa_support_reparation ( code, libelle, definition) VALUES 
    --     ('01',	'Canalisation',	'Réparation sur une canalisation'),
    --     ('02',	'Appareillage',	'Réparation d''un appareillage'),
    --     ('03',	'Ouvrage',	'Réparation d''un ouvrage');

--- Défaillances : table non créée cardinalités qui ne matchent pas. On bascule en case when 
-- drop table if exists raepa.val_raepa_type_defaillance ;

--     create table raepa.val_raepa_type_defaillance (
--         code varchar(2) CONSTRAINT pk_val_raepa_type_defaillancen PRIMARY KEY,
--         libelle varchar(254), 
--         "definition" varchar(254), 
--     ) ; 

--     INSERT into raepa.val_raepa_type_defaillance ( code, libelle, definition) VALUES 
/*
('99',	'Autre',	'Défaillance dont le type ne figure pas dans la liste ci-dessus'), -- 101 (autre) + 9104 (corrosion) + 9103 (arrachée) + 9105 (pièce non étanche)
('01',	'Casse', 'longitudinale	Canalisation fendue sur sa longueur'), --9102 (longitudinale)
('05',	'Joint', 'Joint défectueux'), -- 9105 (raccordement non étanche)
('06',	'Percement', 'Canalisation percée', ), -- ?  ? 
('03',	'Déboîtement', 'Déboîtement de tuyau(x) de la canalisation'), -- pas d'équivalent
('04',	'Fissure', 'Canalisation fissurée'), --9102
('02',	'Casse nette', 'Canalisation cassée'), --9101
('00',	'Indéterminé', 'Défaillance de type inconnu', 102);  -- 102  + 103
*/

-- View: qwat_od.vw_export_leak
CREATE VIEW raepa.raepa_reparaep_p AS (
 SELECT leak.id::varchar(254) as idrepar ,
    st_x(leak.geometry)::numeric(10 , 3) as x,
    st_y(leak.geometry)::numeric(10 , 3) as y,
    '01'::varchar(2) as supprepare, -- Type de support de la réparation - concerne uniquement les canalisations dans QWAT 
    CASE 
        WHEN leak.fk_cause IN (101, 9104, 9103, 9105) THEN  '99'
        WHEN leak.fk_cause = 9102 THEN '01'
        WHEN leak.fk_cause = 9105 THEN '05'
        -- WHEN leak.fk_cause =  THEN '06' -- jamais affecté, 
        -- WHEN leak.fk_cause =  THEN '03' -- jamais affecté, 
        WHEN leak.fk_cause = 9102 THEN '04'
        WHEN leak.fk_cause = 9101 THEN '02'
        WHEN leak.fk_cause IN (102, 103) THEN '00'               
    END::varchar(2) as defreparee, -- definition de la réparation
    -- leak.fk_cause,    
    leak.fk_pipe::text as idsuprepar,-- support de la réparation - identifiant de l'objet (ici id canalisation)
    leak.repair_date::date as daterepar,     -- date reparation,
    distributor.name::text as mouvrage, -- Maître d'ouvrage de la réparation
    st_transform(leak.geometry, 2154)::geometry(Point , 2154) as geom -- conversion en 2154 (est-ce une bonne idée de le faire en dur)
    
   FROM qwat_od.leak
     LEFT JOIN qwat_vl.leak_cause cause ON leak.fk_cause = cause.id
     LEFT JOIN qwat_od.vw_export_pipe pipe ON leak.fk_pipe = pipe.id
     LEFT JOIN qwat_od.distributor  ON (distributor.id = pipe.fk_distributor) 

);

COMMENT ON VIEW raepa.raepa_reparaep_p IS 'Lieu d''une intervention sur le réseau effectuée suite à une défaillance dudit réseau. Pour édition';

COMMENT ON COLUMN raepa.raepa_reparaep_p.idrepar IS 'Identifiant de la réparation effectuée';

COMMENT ON COLUMN raepa.raepa_reparaep_p.x IS 'Coordonnée X Lambert 93 (en mètres)';

COMMENT ON COLUMN raepa.raepa_reparaep_p.y IS 'Coordonnée X Lambert 93 (en mètres)';

COMMENT ON COLUMN raepa.raepa_reparaep_p.supprepare IS 'Type de support de la réparation';

COMMENT ON COLUMN raepa.raepa_reparaep_p.defreparee IS 'Type de défaillance';

COMMENT ON COLUMN raepa.raepa_reparaep_p.idsuprepar IS 'Identifiant du support de la réparation';

COMMENT ON COLUMN raepa.raepa_reparaep_p.daterepar IS 'Date de l''intervention en réparation';

COMMENT ON COLUMN raepa.raepa_reparaep_p.mouvrage IS 'Maître d''ouvrage de la réparation';

COMMENT ON COLUMN raepa.raepa_reparaep_p.geom IS 'Géométrie ponctuelle de l''objet';



