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
        'dbs', 
        'diffuserBilanStationnel', 
        'Diffuser Bilan Stationnel', 
        'Diffuser le bilan stationnel.', 
        'Diffuser Bilan Stationnel', 
        'Diffuser le bilan stationnel.', 
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
        'rsa', 
        'realiserSuiviAdapte', 
        'Réaliser Suivi Adapté', 
        'Mettre en place un protocole de suivi adapté à la situation.', 
        'Réaliser Suivi Adapté', 
        'Mettre en place un protocole de suivi adapté à la situation.', 
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
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION')::varchar, '.009')
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
        'À prévoir', 
        'À prévoir.', 
        'À prévoir', 
        'À prévoir.', 
        0, 
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION_PROGRESS')::varchar, '.001')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION_PROGRESS'), 
        'c', 
        'enCours', 
        'En cours', 
        'En cours.', 
        'En cours', 
        'En cours.', 
        0, 
        CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION_PROGRESS')::varchar, '.002')
    ),
    (
        ref_nomenclatures.get_id_nomenclature_type('CS_ACTION_PROGRESS'), 
        'pl', 
        'enPlace', 
        'En place', 
        'En place.', 
        'En place', 
        'En place.', 
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

\echo '----------------------------------------------------------------------------'
\echo 'COMMIT if all is ok:'
COMMIT ;
