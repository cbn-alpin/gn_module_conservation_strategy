-- Create Conservation Strategy schema and tables
BEGIN;


\echo '--------------------------------------------------------------------------------'
\echo 'Set database variables'
SET client_encoding = 'UTF8' ;


\echo '--------------------------------------------------------------------------------'
\echo 'Create SFT schema'
CREATE SCHEMA pr_conservation_strategy ;


\echo '--------------------------------------------------------------------------------'
\echo 'Set new database variables'
SET search_path = pr_conservation_strategy, pg_catalog, public;


\echo '--------------------------------------------------------------------------------'
\echo 'TABLES'

\echo 'Table `t_territory`'
CREATE TABLE t_territory (
    id_territory SERIAL NOT NULL,
    id_area INTEGER,
    id_parent INTEGER,
    label VARCHAR(255) NOT NULL,
    code VARCHAR(25) NOT NULL,
    surface INTEGER,
    meshes_total INTEGER,
    PRIMARY KEY (id_territory)
) ;
COMMENT ON TABLE t_territory IS
    E'Table "specialisée" de ref_geo.l_areas contenant seulement la liste '
     'des territoire pris en compte par le module.' ;
COMMENT ON COLUMN t_territory.id_territory IS
    E'Identifiant du territoire (clé primaire).' ;
COMMENT ON COLUMN t_territory.id_area IS
    E'Identifiant de la zone géographique correspondant au territoire.'
     'Peut-être NULL si la géométrie n''est pas nécessaire.' ;
COMMENT ON COLUMN t_territory.id_parent IS
    E'Permet d''indiquer l''identifiant du territoire supérieur pris en '
     'compte pour le calcul des indices de priorité de conservation des '
     'taxons.' ;
COMMENT ON COLUMN t_territory.label IS
    E'Nom du territoire spécifique au module.' ;
COMMENT ON COLUMN t_territory.code IS
    E'Code du territoire spécifique au module.' ;
COMMENT ON COLUMN t_territory.surface IS
    E'Surface en km² du territoire arrondie à l''entier.' ;
COMMENT ON COLUMN t_territory.meshes_total IS
    E'Nombre total de mailles 5x5km INPN présente dans le territoire.' ;


\echo 'Table `cor_mesh_taxon`'
-- TODO: add constraint check on id_area must have an id_type = M5.
CREATE TABLE cor_mesh_taxon (
    mesh_code VARCHAR(16) NOT NULL,
    cd_nom INTEGER NOT NULL,
    id_area INTEGER,
    PRIMARY KEY (mesh_code, cd_nom)
) ;
COMMENT ON TABLE cor_mesh_taxon IS
    E'Table contenant les correspondances entre les taxons et les '
     'mailles INPN 5km où il est présent.' ;
COMMENT ON COLUMN cor_mesh_taxon.mesh_code IS
    E'Code de la maille 5x5km INPN dans laquelle le taxon est présent' ;
COMMENT ON COLUMN cor_mesh_taxon.cd_nom IS
    E'Identifiant du nom retenu du taxon.' ;
COMMENT ON COLUMN cor_mesh_taxon.id_area IS
    E'Identifiant de la zone géographique correspondant à la maile INPN 5km.'
     'Peut-être NULL si la géométrie n''est pas nécessaire.' ;


\echo 'Table `cor_territory_taxon`'
CREATE TABLE cor_territory_taxon (
    id_territory INTEGER NOT NULL,
    cd_nom INTEGER NOT NULL,
    presence_meshes_count INTEGER,
    small_isolated_population BOOLEAN DEFAULT FALSE,
    indigenousness VARCHAR(3),
    iucn_cotation VARCHAR(3),
    iucn_criteria VARCHAR(50),
    rarity FLOAT,
    rarity_class VARCHAR(2),
    computed_conservation_priority INTEGER,
    compute_date TIMESTAMP without time zone,
    revised_conservation_priority INTEGER,
    revision_date TIMESTAMP without time zone,
    revision_comment TEXT,
    min_prospect_zone_date TIMESTAMP without time zone,
    max_prospect_zone_date TIMESTAMP without time zone,
    presence_area_count INTEGER,
    PRIMARY KEY (id_territory, cd_nom)
) ;
COMMENT ON TABLE cor_territory_taxon IS
    E'Table contenant les correspondances entre les taxons et les '
     'territoires.' ;
COMMENT ON COLUMN cor_territory_taxon.id_territory IS
    E'Identifiant du territoire.' ;
COMMENT ON COLUMN cor_territory_taxon.cd_nom IS
    E'Identifiant du nom retenu du taxon.' ;
COMMENT ON COLUMN cor_territory_taxon.presence_meshes_count IS
    E'Nombre de mailles 5x5km INPN du territoire dans lesquelles '
     'le taxon est présent.' ;
COMMENT ON COLUMN cor_territory_taxon.small_isolated_population IS
    E'Indique (si TRUE) que le taxon est présent dans le territoire en petite population isolée.';
COMMENT ON COLUMN cor_territory_taxon.indigenousness IS
    E'Code d''indigénat du taxon sur le territoire. '
     'Valeurs : I, I?, E.' ;
COMMENT ON COLUMN cor_territory_taxon.iucn_cotation IS
    E'Cotation UICN du taxon pour le territoire concerné. '
     'Valeurs : EW, RE, CR*, CR, EN, VU, NT, LC, DD, NE.' ;
COMMENT ON COLUMN cor_territory_taxon.iucn_criteria IS
    E'Critère UICN utilisé pour la cotation du taxon sur le territoire '
     'concerné.' ;
COMMENT ON COLUMN cor_territory_taxon.rarity IS
    E'Pourcentage de rareté (Cr) du taxon dans ce territoire. '
     'Calcul : Cr = 100 - 100 x (Nb mailles présence sur territoire après 1990 / Nb total de mailles sur territoire).' ;
COMMENT ON COLUMN cor_territory_taxon.rarity_class IS
    E'Classe de rareté correspondant au pourcentage. ' ;
COMMENT ON COLUMN cor_territory_taxon.computed_conservation_priority IS
    E'Indice de priorité de conservation. '
     'Valeurs : 1 à 5.' ;
COMMENT ON COLUMN cor_territory_taxon.compute_date IS
    E'Date à laquelle le calcul de l''indice de priorité de conservation '
     'a été réalisé.' ;
COMMENT ON COLUMN cor_territory_taxon.revised_conservation_priority IS
    E'Indice de priorité de conservation révisé manuellement à dire '
     'd''expert. '
     'Valeurs : 1 à 5.' ;
COMMENT ON COLUMN cor_territory_taxon.revision_date IS
    E'Date à laquelle la valeur d''indice de priorité de conservation '
     'a été révisée.' ;
COMMENT ON COLUMN cor_territory_taxon.revision_comment IS
    E'Commentaire expliquant le choix révisé de l''indice de priorité '
     'de conservation.' ;
COMMENT ON COLUMN cor_territory_taxon.min_prospect_zone_date IS
    E'Date la plus ancienne d''inventaire de zone de prospection pour '
     'ce taxon dans ce territoire.' ;
COMMENT ON COLUMN cor_territory_taxon.max_prospect_zone_date IS
    E'Date la plus récente d''inventaire de zone de prospection pour '
     'ce taxon dans ce territoire.' ;
COMMENT ON COLUMN cor_territory_taxon.presence_area_count IS
    E'Nombre d''aire de présence total pour ce taxon dans ce territoire.' ;


\echo 'Table `t_assessment`'
CREATE TABLE t_assessment (
    id_assessment SERIAL NOT NULL,
    id_territory INTEGER NOT NULL,
    cd_nom INTEGER NOT NULL,
    date_min TIMESTAMP without time zone,
    date_max TIMESTAMP without time zone,
    assessment_date TIMESTAMP without time zone DEFAULT NOW(),
    threats TEXT,
    "description" TEXT,
    next_assessment_year INTERVAL YEAR,
    computed_data JSONB,
    meta_create_date TIMESTAMP without time zone DEFAULT NOW(),
    meta_create_by INTEGER,
    meta_update_date TIMESTAMP without time zone,
    meta_update_by INTEGER,
    PRIMARY KEY (id_assessment)
) ;
COMMENT ON TABLE t_assessment IS
    E'Table contenant les informations des bilans.' ;
COMMENT ON COLUMN t_assessment.id_assessment IS
    E'Identifiant numérique du bilan.' ;
COMMENT ON COLUMN t_assessment.id_territory IS
    E'Identifiant du territoire associé à ce bilan.' ;
COMMENT ON COLUMN t_assessment.cd_nom IS
    E'Identifiant du nom retenu du taxon.' ;
COMMENT ON COLUMN t_assessment.date_min IS
    E'Date de visite la plus ancienne pour la station la plus ancienne '
     'prise en compte pour ce bilan.' ;
COMMENT ON COLUMN t_assessment.date_max IS
    E'Date de visite la plus récente pour la station la plus récente '
     'prise en compte pour ce bilan' ;
COMMENT ON COLUMN t_assessment.assessment_date IS
    E'Date de création de ce bilan. '
     'Par défaut, correspond au jours de création du bilan.' ;
COMMENT ON COLUMN t_assessment.threats IS
    E'Texte permettant d''indiquer les menaces du taxon sur le territoire.' ;
COMMENT ON COLUMN t_assessment.description IS
    E'Texte permettant de décrire le bilan.' ;
COMMENT ON COLUMN t_assessment.next_assessment_year IS
    E'Indique le nombre d''année prévue avant le prochain bilan '
     'par rapport à la date de création de ce bilan.' ;
COMMENT ON COLUMN t_assessment.computed_data IS
    E'Ensemble des données calculé pour la réalisation de ce bilan.'
     'Ces données peuvent évoluer au cours du temps.' ;
COMMENT ON COLUMN t_assessment.meta_create_date IS
    E'Date et heure de création de l''enregistrement de ce bilan' ;
COMMENT ON COLUMN t_assessment.meta_create_by IS
    E'Identifiant de l''utilisateur ayant créé cet enregistrement de bilan.' ;
COMMENT ON COLUMN t_assessment.meta_update_date IS
    E'Date et heure de création de l''enregistrement de ce bilan' ;
COMMENT ON COLUMN t_assessment.meta_update_by IS
    E'Identifiant de l''utilisateur ayant mis jour cet enregistrement de bilan.' ;


\echo 'Table `t_action`'
CREATE TABLE t_action (
    id_action SERIAL NOT NULL,
    id_assessment INTEGER NOT NULL,
    creation_date TIMESTAMP without time zone,
    id_action_level INTEGER,
    id_action_type INTEGER,
    id_action_progress INTEGER,
    plan_for INTERVAL YEAR,
    starting_date TIMESTAMP without time zone,
    implementation_date TIMESTAMP without time zone,
    "description" TEXT,
    PRIMARY KEY (id_action)
) ;
COMMENT ON TABLE t_action IS
    E'Table contenant les actions à prévoir pour chaque bilan.' ;
COMMENT ON COLUMN t_action.id_action IS
    E'Identifiant numérique de l''action.' ;
COMMENT ON COLUMN t_action.id_assessment IS
    E'Identifiant numérique du bilan auquel l''action est associée.' ;
COMMENT ON COLUMN t_action.creation_date IS
    E'Date de création de l''action.' ;
COMMENT ON COLUMN t_action.id_action_level IS
    E'Identifiant de la nomenclature utilisée pour indiquer '
     'le type de niveau géographique de l''action.' ;
COMMENT ON COLUMN t_action.id_action_type IS
    E'Identifiant de la nomenclature utilisée pour indiquer '
     'le type d''action à réaliser.' ;
COMMENT ON COLUMN t_action.id_action_progress IS
    E'Identifiant de la nomenclature utilisée pour indiquer '
     'l''état de progression de l''action.' ;
COMMENT ON COLUMN t_action.plan_for IS
    E'Intervalle d''années entre dans la date de création '
     'de l''action et l''année à prévoir pour réaliser l''action.' ;
COMMENT ON COLUMN t_action.starting_date IS
    E'Date de démarrage de l''action.' ;
COMMENT ON COLUMN t_action.implementation_date IS
    E'Date de fin de réalisation de l''action.' ;
COMMENT ON COLUMN t_action.description IS
    E'Description de l''action (chantier prévu, détail de la mise en place, …).' ;

\echo 'Add nomenclature constraints on table `t_action`'
ALTER TABLE t_action ADD CONSTRAINT check_t_action_level
    CHECK (
        ref_nomenclatures.check_nomenclature_type_by_mnemonique(
            id_action_level,
            'CS_ACTION_GEO_LEVEL'::varchar
        )
    ) NOT VALID ;

ALTER TABLE t_action ADD CONSTRAINT check_t_action_type
    CHECK (
        ref_nomenclatures.check_nomenclature_type_by_mnemonique(
            id_action_type,
            'CS_ACTION'::varchar
        )
    ) NOT VALID ;

ALTER TABLE t_action ADD CONSTRAINT check_t_action_progress
    CHECK (
        ref_nomenclatures.check_nomenclature_type_by_mnemonique(
            id_action_progress,
            'CS_ACTION_PROGRESS'::varchar
        )
    ) NOT VALID ;


\echo 'Table `cor_action_organism`'
CREATE TABLE cor_action_organism (
    id_organism INTEGER NOT NULL,
    id_action INTEGER NOT NULL,
    PRIMARY KEY (id_ogranism, id_action)
) ;
COMMENT ON TABLE cor_action_organism IS
    E'Table contenant les actions à prévoir pour chaque bilan.' ;
COMMENT ON COLUMN cor_action_organism.id_organism IS
    E'Identifiant de l''organisme associé à l''action.' ;
COMMENT ON COLUMN cor_action_organism.id_action IS
    E'Identifiant de l''action à laquelle l''organisme est associé.' ;


\echo '--------------------------------------------------------------------------------'
\echo 'FOREING KEYS'
-- TODO: check if all DELETE CASCADE are necessary

ALTER TABLE ONLY t_territory ADD CONSTRAINT fk_t_territory_id_area
    FOREIGN KEY (id_area) REFERENCES ref_geo.l_areas (id_area)
    ON UPDATE CASCADE ON DELETE SET NULL ;

ALTER TABLE ONLY cor_mesh_taxon ADD CONSTRAINT fk_cor_mesh_taxon_id_area
    FOREIGN KEY (id_area) REFERENCES ref_geo.l_areas (id_area)
    ON UPDATE CASCADE ON DELETE SET NULL ;

ALTER TABLE ONLY cor_mesh_taxon ADD CONSTRAINT fk_cor_mesh_taxon_cd_nom
    FOREIGN KEY (cd_nom) REFERENCES taxonomie.taxref (cd_nom)
    ON UPDATE CASCADE ON DELETE CASCADE ;

ALTER TABLE ONLY cor_territory_taxon ADD CONSTRAINT fk_cor_territory_taxon_id_territory
    FOREIGN KEY (id_territory) REFERENCES t_territory (id_territory)
    ON UPDATE CASCADE ON DELETE CASCADE ;

ALTER TABLE ONLY cor_territory_taxon ADD CONSTRAINT fk_cor_territory_taxon_cd_nom
    FOREIGN KEY (cd_nom) REFERENCES taxonomie.taxref (cd_nom)
    ON UPDATE CASCADE ON DELETE CASCADE ;

ALTER TABLE ONLY t_assessment ADD CONSTRAINT fk_t_assessment_id_territory_cd_nom
    FOREIGN KEY (id_territory, cd_nom) REFERENCES cor_territory_taxon (id_territory, cd_nom)
    ON UPDATE CASCADE ON DELETE CASCADE ;

ALTER TABLE ONLY t_assessment ADD CONSTRAINT fk_t_assessment_cd_nom
    FOREIGN KEY (cd_nom) REFERENCES taxonomie.taxref (cd_nom)
    ON UPDATE CASCADE ON DELETE CASCADE ;

ALTER TABLE ONLY t_assessment ADD CONSTRAINT fk_t_assessment_meta_create_by
    FOREIGN KEY (meta_create_by) REFERENCES utilisateurs.t_roles (id_role)
    ON UPDATE CASCADE ON DELETE SET NULL ;

ALTER TABLE ONLY t_assessment ADD CONSTRAINT fk_t_assessment_meta_update_by
    FOREIGN KEY (meta_update_by) REFERENCES utilisateurs.t_roles (id_role)
    ON UPDATE CASCADE ON DELETE SET NULL ;

ALTER TABLE ONLY t_action ADD CONSTRAINT fk_t_action_id_assessment
    FOREIGN KEY (id_assessment) REFERENCES t_assessment (id_assessment)
    ON UPDATE CASCADE ON DELETE CASCADE ;

ALTER TABLE ONLY t_action ADD CONSTRAINT fk_t_action_id_action_level
    FOREIGN KEY (id_action_level) REFERENCES ref_nomenclatures.t_nomenclatures (id_nomenclature)
    ON UPDATE CASCADE ON DELETE SET NULL ;

ALTER TABLE ONLY t_action ADD CONSTRAINT fk_t_action_id_action_type
    FOREIGN KEY (id_action_type) REFERENCES ref_nomenclatures.t_nomenclatures (id_nomenclature)
    ON UPDATE CASCADE ON DELETE SET NULL ;

ALTER TABLE ONLY t_action ADD CONSTRAINT fk_t_action_id_action_progress
    FOREIGN KEY (id_action_progress) REFERENCES ref_nomenclatures.t_nomenclatures (id_nomenclature)
    ON UPDATE CASCADE ON DELETE SET NULL ;

ALTER TABLE ONLY cor_action_organism ADD CONSTRAINT fk_cor_action_organism_id_ogranism
    FOREIGN KEY (id_ogranism) REFERENCES utilisateurs.bib_organismes (id_organisme)
    ON UPDATE CASCADE ON DELETE SET NULL ;

ALTER TABLE ONLY cor_action_organism ADD CONSTRAINT fk_cor_action_organism_id_action
    FOREIGN KEY (id_action) REFERENCES t_action (id_action)
    ON UPDATE CASCADE ON DELETE CASCADE ;


\echo '--------------------------------------------------------------------------------'
\echo 'INDEXES'

CREATE UNIQUE INDEX idx_uniq_t_territory_id_area
    ON t_territory USING btree(id_area) ;

CREATE INDEX idx_uniq_t_territory_id_parent
    ON t_territory USING btree(id_parent) ;

CREATE INDEX idx_cor_mesh_taxon_mesh_code
    ON cor_mesh_taxon USING btree(mesh_code) ;

CREATE INDEX idx_cor_mesh_taxon_cd_nom
    ON cor_mesh_taxon USING btree(cd_nom) ;

CREATE INDEX idx_cor_mesh_taxon_id_area
    ON cor_mesh_taxon USING btree(id_area) ;

CREATE INDEX idx_cor_territory_taxon_id_territory
    ON cor_territory_taxon USING btree(id_territory) ;

CREATE INDEX idx_cor_territory_taxon_cd_nom
    ON cor_territory_taxon USING btree(cd_nom) ;

CREATE INDEX idx_t_assessment_cd_nom
    ON t_assessment USING btree(cd_nom) ;

CREATE INDEX idx_t_assessment_meta_create_by
    ON t_assessment USING btree(meta_create_by) ;

CREATE INDEX idx_t_assessment_meta_update_by
    ON t_assessment USING btree(meta_update_by) ;

CREATE INDEX idx_t_action_id_assessment
    ON t_action USING btree(id_assessment) ;

CREATE INDEX idx_t_action_id_action_level
    ON t_action USING btree(id_action_level) ;

CREATE INDEX idx_t_action_id_action_type
    ON t_action USING btree(id_action_type) ;

CREATE INDEX idx_t_action_id_action_progress
    ON t_action USING btree(id_action_progress) ;

CREATE INDEX idx_cor_action_organism_id_ogranism
    ON cor_action_organism USING btree(id_ogranism) ;

CREATE INDEX idx_cor_action_organism_id_action
    ON cor_action_organism USING btree(id_action) ;


\echo '----------------------------------------------------------------------------'
\echo 'COMMIT if all is ok:'
COMMIT ;
