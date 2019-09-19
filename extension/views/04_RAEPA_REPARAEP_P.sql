DROP TABLE IF EXISTS raepa.raepa_repar_g CASCADE;

CREATE TABLE raepa.raepa_repar_g (
    idrepar character varying(254) NOT NULL
    , x numeric(10 , 3) NOT NULL
    , y numeric(10 , 3) NOT NULL
    , supprepare character varying(2) NOT NULL DEFAULT '00'
    , defreparee character varying(2) NOT NULL DEFAULT '00'
    , idsuprepar character varying(254) NOT NULL
    , daterepar date
    , mouvrage character varying(100)
    , rsx text CHECK (rsx IN ('AEP'
            , 'ASS'))
    , geom geometry(Point , 2154)
    , CONSTRAINT raepa_repar_pkey PRIMARY KEY (idrepar)
);

COMMENT ON TABLE raepa.raepa_repar_g IS 'Lieu d''une intervention sur le réseau effectuée suite à une défaillance dudit réseau. Pour édition';

COMMENT ON COLUMN raepa.raepa_repar_g.idrepar IS 'Identifiant de la réparation effectuée';

COMMENT ON COLUMN raepa.raepa_repar_g.x IS 'Coordonnée X Lambert 93 (en mètres)';

COMMENT ON COLUMN raepa.raepa_repar_g.y IS 'Coordonnée X Lambert 93 (en mètres)';

COMMENT ON COLUMN raepa.raepa_repar_g.supprepare IS 'Type de support de la réparation';

COMMENT ON COLUMN raepa.raepa_repar_g.defreparee IS 'Type de défaillance';

COMMENT ON COLUMN raepa.raepa_repar_g.idsuprepar IS 'Identifiant du support de la réparation';

COMMENT ON COLUMN raepa.raepa_repar_g.daterepar IS 'Date de l''intervention en réparation';

COMMENT ON COLUMN raepa.raepa_repar_g.mouvrage IS 'Maître d''ouvrage de la réparation';

COMMENT ON COLUMN raepa.raepa_repar_g.geom IS 'Géométrie ponctuelle de l''objet';

COMMENT ON COLUMN raepa.raepa_repar_g.rsx IS 'Type de réseaux. AEP ou ASS';

ALTER TABLE raepa.raepa_repar_g
    ALTER COLUMN idrepar SET DEFAULT nextval('raepa.raepa_repar_g'::regclass);

ALTER TABLE raepa.raepa_repar_g
    ADD CONSTRAINT val_raepa_support_incident_fkey FOREIGN KEY (supprepare) REFERENCES raepa.val_raepa_support_incident (code) MATCH SIMPLE ON
    UPDATE
        NO ACTION ON DELETE NO ACTION ,
        ADD CONSTRAINT val_raepa_defaillance_fkey FOREIGN KEY (defreparee) REFERENCES raepa.val_raepa_defaillance (code) MATCH SIMPLE ON
        UPDATE
            NO ACTION ON DELETE NO ACTION ,
            ADD CONSTRAINT val_raepa_mouvrage_fkey FOREIGN KEY (mouvrage) REFERENCES qwat_od.distributor (name) MATCH SIMPLE ON
            UPDATE
                NO ACTION ON DELETE NO ACTION;

CREATE OR REPLACE VIEW raepa.raepa_reparaep AS
SELECT
    g.idrepar
    , g.x
    , g.y
    , g.supprepare
    , g.defreparee
    , g.idsuprepar
    , g.daterepar
    , g.mouvrage
    , g.geom
FROM
    raepa.raepa_repar_g g
ORDER BY
    g.idrepar;

COMMENT ON TABLE raepa.raepa_repar_g IS 'Lieu d''une intervention sur le réseau effectuée suite à une défaillance dudit réseau. Pour lecture et conformité au RAEPA';

CREATE OR REPLACE VIEW raepa.raepa_reparaep_p AS
SELECT
    g.idrepar
    , g.x
    , g.y
    , g.supprepare
    , g.defreparee
    , g.idsuprepar
    , g.daterepar
    , g.mouvrage
    , g.geom
FROM
    raepa.raepa_repar_g g
WHERE
    g.rsx = 'AEP'
ORDER BY
    g.idrepar;

COMMENT ON VIEW raepa.raepa_reparaep_p IS 'Reparation du réseau d''adduction d''eau';
