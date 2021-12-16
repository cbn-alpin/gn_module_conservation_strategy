-- Insert Conservation Strategy default data (nomenclatures, module)
BEGIN ;

\echo '--------------------------------------------------------------------------------'
\echo 'NOMENCLATURE'

\echo 'Create the "CS_ACTION_GEO_LEVEL" nomenclature type'
INSERT INTO ref_nomenclatures.bib_nomenclatures_types (
    mnemonique, label_default, definition_default, label_fr, definition_fr, source
) VALUES
    (
        'CS_ACTION_GEO_LEVEL',
        'Type de niveau géographique d''action',
        'Nomenclature des types de niveau géographique des actions de stratégie de la conservation.',
        'Type de niveau géographique d''action',
        'Nomenclature des types de niveau géographique des actions de stratégie de la conservation.',
        'CBNA'
    ) ;

\echo 'Add nomenclature values for "CS_ACTION_GEO_LEVEL"'
INSERT INTO ref_nomenclatures.t_nomenclatures (
    id_type, cd_nomenclature, mnemonique, label_default, definition_default, label_fr, definition_fr, id_broader, hierarchy
) VALUES
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION_GEO_LEVEL'),
        't',
        'territoriale',
        'Territoriale',
        'Action territoriale.',
        'Territoriale',
        'Action territoriale.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION_GEO_LEVEL')::varchar, '.001')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION_GEO_LEVEL'),
        'l',
        'locale',
        'Locale',
        'Action locale.',
        'Locale',
        'Action locale.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION_GEO_LEVEL')::varchar, '.002')
    ) ;


\echo 'Create the "CS_ACTION" nomenclature type'
INSERT INTO ref_nomenclatures.bib_nomenclatures_types (
    mnemonique, label_default, definition_default, label_fr, definition_fr, source
) VALUES
    (
        'CS_ACTION',
        'Type d''action',
        'Nomenclature des types d''actions de stratégie de la conservation.',
        'Type d''action',
        'Nomenclature des types d''actions de stratégie de la conservation.',
        'CBNA'
    ) ;

\echo 'Add nomenclature values for "CS_ACTION"'
INSERT INTO ref_nomenclatures.t_nomenclatures (
    id_type, cd_nomenclature, mnemonique, label_default, definition_default, label_fr, definition_fr, id_broader, hierarchy
) VALUES
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
        'rbs',
        'realiserBilanStationnel',
        'Réaliser Bilan Stationnel',
        'Réaliser un bilan stationnel.',
        'Réaliser Bilan stationnel',
        'Réaliser un bilan stationnel.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION')::varchar, '.001')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
        'dfbs',
        'diffuserFicheBilanStationnel',
        'Diffuser Fiche Bilan Stationnel',
        'Diffuser la fiche bilan stationnel.',
        'Diffuser Fiche Bilan Stationnel',
        'Diffuser la fiche bilan stationnel.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION')::varchar, '.002')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
        'rss',
        'realiserSuiviStation',
        'Réaliser Suivi Station',
        'Réaliser un suivi station.',
        'Réaliser Suivi Station',
        'Réaliser un suivi station.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION')::varchar, '.003')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
        'rst',
        'realiserSuiviTerritoire',
        'Réaliser Suivi Territoire',
        'Réaliser un suivi territoire.',
        'Réaliser Suivi Territoire',
        'Réaliser un suivi territoire.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION')::varchar, '.004')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
        'rpc',
        'realiserPlanDeConservation',
        'Réaliser Plan Conservation',
        'Réaliser un plan de conservation.',
        'Réaliser Plan Conservation',
        'Réaliser un plan de conservation.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION')::varchar, '.005')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
        'mf',
        'maitriserFoncier',
        'Maitriser Foncier',
        'Maitriser le foncier.',
        'Maitriser Foncier',
        'Maitriser le foncier.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION')::varchar, '.006')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
        'pr',
        'protegerReglementairement',
        'Protéger réglementairement',
        'Protéger réglementairement.',
        'Protéger réglementairement',
        'Protéger réglementairement.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION')::varchar, '.007')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
        'pac',
        'porterAConnaissance',
        'Porter à Connaissance',
        'Porter à connaissance.',
        'Porter à Connaissance',
        'Porter à connaissance.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION')::varchar, '.008')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
        's',
        'sensibiliser',
        'Sensibiliser',
        'Sensibiliser le public.',
        'Sensibiliser',
        'Sensibiliser le public.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION')::varchar, '.009')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
        'emg',
        'etablirMesureGestion',
        'Établir Mesures Gestion',
        'Établir des mesures de gestion.',
        'Établir Mesures Gestion',
        'Établir des mesures de gestion.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION')::varchar, '.010')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
        'rp',
        'renforcerPopulation',
        'Renforcer Population',
        'Renforcer les populations.',
        'Renforcer Population',
        'Renforcer les populations.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION')::varchar, '.011')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
        'ir',
        'introduireReintroduire',
        'Introduire / Réintroduire',
        'Introduire ou réintroduire le taxon.',
        'Introduire / Réintroduire',
        'Introduire ou réintroduire le taxon.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION')::varchar, '.012')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
        'rpr',
        'realiserProgrammeRecherche',
        'Réaliser Programme Recherche',
        'Réaliser un programme de recherche.',
        'Réaliser Programme Recherche',
        'Réaliser un programme de recherche.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION')::varchar, '.013')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
        'c',
        'concerter',
        'Concerter',
        'Se concerter.',
        'Concerter',
        'Se concerter.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION')::varchar, '.014')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
        'rsic',
        'realiserSuiviIndividuCentre',
        'Réaliser Suivi Individu-Centré',
        'Réaliser un suivi individu-centré.',
        'Réaliser Suivi Individu-Centré',
        'Réaliser un suivi individu-centré.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION')::varchar, '.015')
    ) ;


\echo 'Create the "CS_ACTION_PROGRESS" nomenclature type'
INSERT INTO ref_nomenclatures.bib_nomenclatures_types (
    mnemonique, label_default, definition_default, label_fr, definition_fr, source
) VALUES
    (
        'CS_ACTION_PROGRESS',
        'Type d''avancement de l''action',
        'Nomenclature des types d''avancement des actions de stratégie de la conservation.',
        'Type d''avancement de l''action',
        'Nomenclature des types d''avancement des actions de stratégie de la conservation.',
        'CBNA'
    ) ;

\echo 'Add nomenclature values for "CS_ACTION_PROGRESS"'
INSERT INTO ref_nomenclatures.t_nomenclatures (
    id_type, cd_nomenclature, mnemonique, label_default, definition_default, label_fr, definition_fr, id_broader, hierarchy
) VALUES
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION_PROGRESS'),
        'pr',
        'aPrevoir',
        'À mettre en place',
        'À mettre en place.',
        'À mettre en place',
        'À mettre en place.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION_PROGRESS')::varchar, '.001')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION_PROGRESS'),
        'c',
        'enCours',
        'En cours de mise en place',
        'En cours de mise en place.',
        'En cours de mise en place',
        'En cours de mise en place.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION_PROGRESS')::varchar, '.002')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION_PROGRESS'),
        'pl',
        'enPlace',
        'Mise en place',
        'Mise en place.',
        'Mise en place',
        'Mise en place.',
        0,
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION_PROGRESS')::varchar, '.003')
    ) ;

\echo '--------------------------------------------------------------------------------'
\echo 'COMMONS'

\echo 'Update module infos'
UPDATE gn_commons.t_modules
SET
    module_label = 'Stratégie Conservation',
    module_picto = 'fa-leaf',
    module_desc = 'Module d''aide à la décision des actions de la stratégie de conservation à mettre en place pour les taxons prioritaires d''un territoire.'
WHERE module_code ILIKE :'moduleCode' ;


\echo '--------------------------------------------------------------------------------'
\echo 'TAXONOMY'

\echo 'Update TaxHub attributes themes'
INSERT INTO taxonomie.bib_themes(nom_theme, desc_theme, ordre, id_droit)
    SELECT
        'Strat. Conservation',
        'Informations relative à la stratégie de conservation du taxon',
        (SELECT MAX(ordre) + 1 FROM taxonomie.bib_themes),
        4 -- TODO : Voir à quoi cela correspond
    WHERE NOT EXISTS (
        SELECT 'X'
        FROM taxonomie.bib_themes AS bt
        WHERE bt.nom_theme = 'Strat. Conservation'
    ) ;

\echo 'Update TaxHub attributes'
INSERT INTO taxonomie.bib_attributs(
    nom_attribut,
    label_attribut,
    liste_valeur_attribut,
    obligatoire,
    desc_attribut,
    type_attribut,
    type_widget,
    id_theme,
    ordre
)
    SELECT
        'cs_recommended_monitoring_method',
        'Méthode de suivi préconisée',
        '{}',
        False,
        'Méthode de suivi préconisé du taxon dans le cadre de la Stratégie de Conservation',
        'text',
        'textarea',
        (SELECT id_theme FROM taxonomie.bib_themes WHERE nom_theme = 'Strat. Conservation'),
        (SELECT COALESCE(MAX(ordre) + 1, 1) FROM taxonomie.bib_attributs WHERE id_theme = (
            SELECT id_theme FROM taxonomie.bib_themes WHERE nom_theme = 'Strat. Conservation'
        ))
    WHERE NOT EXISTS(
        SELECT 'X'
        FROM taxonomie.bib_attributs AS ba
        WHERE ba.nom_attribut = 'cs_recommended_monitoring_method'
    ) ;

INSERT INTO taxonomie.bib_attributs(
    nom_attribut,
    label_attribut,
    liste_valeur_attribut,
    obligatoire,
    desc_attribut,
    type_attribut,
    type_widget,
    id_theme,
    ordre
)
    SELECT
        'atlas_ecology',
        'Écologie',
        '{}',
        False,
        'Texte présentant l''écologie du taxon.',
        'text',
        'textarea',
        (SELECT id_theme FROM taxonomie.bib_themes WHERE nom_theme = 'Atlas'),
        (SELECT COALESCE(MAX(ordre) + 1, 1) FROM taxonomie.bib_attributs WHERE id_theme = (
            SELECT id_theme FROM taxonomie.bib_themes WHERE nom_theme = 'Atlas'
        ))
    WHERE NOT EXISTS(
        SELECT 'X'
        FROM taxonomie.bib_attributs AS ba
        WHERE ba.nom_attribut = 'atlas_ecology'
    ) ;

INSERT INTO taxonomie.bib_attributs(
    nom_attribut,
    label_attribut,
    liste_valeur_attribut,
    obligatoire,
    desc_attribut,
    type_attribut,
    type_widget,
    id_theme,
    ordre
)
    SELECT
        'atlas_chorology_description',
        'Chorologie texte',
        '{}',
        False,
        'Texte présentant la chorologie du taxon.',
        'text',
        'textarea',
        (SELECT id_theme FROM taxonomie.bib_themes WHERE nom_theme = 'Atlas'),
        (SELECT COALESCE(MAX(ordre) + 1, 1) FROM taxonomie.bib_attributs WHERE id_theme = (
            SELECT id_theme FROM taxonomie.bib_themes WHERE nom_theme = 'Atlas'
        ))
    WHERE NOT EXISTS(
        SELECT 'X'
        FROM taxonomie.bib_attributs AS ba
        WHERE ba.nom_attribut = 'atlas_chorology_description'
    ) ;

\echo '----------------------------------------------------------------------------'
\echo 'COMMIT if all is ok:'
COMMIT ;
