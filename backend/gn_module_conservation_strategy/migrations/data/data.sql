-- Insert Conservation Strategy default data (nomenclatures, module)
-- NOMENCLATURE

-- Create the "CS_ACTION_GEO_LEVEL" nomenclature type
INSERT INTO ref_nomenclatures.bib_nomenclatures_types (
    mnemonique, label_default, definition_default, label_fr, definition_fr, source
) VALUES (
    'CS_ACTION_GEO_LEVEL',
    'Type de niveau géographique d''action',
    'Nomenclature des types de niveau géographique des actions de stratégie de la conservation.',
    'Type de niveau géographique d''action',
    'Nomenclature des types de niveau géographique des actions de stratégie de la conservation.',
    'CBNA'
) ;


-- Create the "CS_ACTION" nomenclature type
INSERT INTO ref_nomenclatures.bib_nomenclatures_types (
    mnemonique, label_default, definition_default, label_fr, definition_fr, source
) VALUES (
    'CS_ACTION',
    'Type d''action',
    'Nomenclature des types d''actions de stratégie de la conservation.',
    'Type d''action',
    'Nomenclature des types d''actions de stratégie de la conservation.',
    'CBNA'
) ;


-- Create the "CS_ACTION_PROGRESS" nomenclature type
INSERT INTO ref_nomenclatures.bib_nomenclatures_types (
    mnemonique, label_default, definition_default, label_fr, definition_fr, source
) VALUES (
    'CS_ACTION_PROGRESS',
    'Type d''avancement de l''action',
    'Nomenclature des types d''avancement des actions de stratégie de la conservation.',
    'Type d''avancement de l''action',
    'Nomenclature des types d''avancement des actions de stratégie de la conservation.',
    'CBNA'
) ;

-- --------------------------------------------------------------------------------
-- COMMONS

-- Update module infos
UPDATE gn_commons.t_modules
SET
    module_label = 'Strat. Conservation',
    module_desc = 'Module d''aide à la décision des actions de la stratégie de conservation à mettre en place pour les taxons prioritaires d''un territoire.',
    module_doc_url = 'https://github.com/cbn-alpin/gn_module_conservation_strategy'
WHERE module_code = :moduleCode ;


-- --------------------------------------------------------------------------------
-- TAXONOMY

-- Update TaxHub attributes themes
INSERT INTO taxonomie.bib_themes (
    nom_theme,
    desc_theme,
    ordre,
    id_droit
) VALUES (
    'Strat. Conservation',
    'Informations relative à la stratégie de conservation du taxon',
    (SELECT MAX(ordre) + 1 FROM taxonomie.bib_themes LIMIT 1),
    4 -- TODO : Voir à quoi cela correspond
) ;

INSERT INTO taxonomie.bib_themes (
    nom_theme,
    desc_theme,
    ordre,
    id_droit
) VALUES (
    'Atlas',
    'Informations relatives à GeoNature-atlas',
    (SELECT MAX(ordre) + 1 FROM taxonomie.bib_themes LIMIT 1),
    3 -- TODO : Voir à quoi cela correspond
) ON CONFLICT DO NOTHING
;

-- Update TaxHub attributes
INSERT INTO taxonomie.bib_attributs (
    nom_attribut,
    label_attribut,
    liste_valeur_attribut,
    obligatoire,
    desc_attribut,
    type_attribut,
    type_widget,
    id_theme,
    ordre
) VALUES (
    'cs_recommended_monitoring_method',
    'Méthode de suivi préconisée',
    '{}',
    False,
    'Méthode de suivi préconisé du taxon dans le cadre de la Stratégie de Conservation',
    'text',
    'textarea',
    (SELECT id_theme FROM taxonomie.bib_themes WHERE nom_theme = 'Strat. Conservation' LIMIT 1),
    (SELECT COALESCE(MAX(ordre) + 1, 1) FROM taxonomie.bib_attributs WHERE id_theme = (
        SELECT id_theme FROM taxonomie.bib_themes WHERE nom_theme = 'Strat. Conservation' LIMIT 1
    ) LIMIT 1)
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
) VALUES (
    'atlas_ecology',
    'Écologie',
    '{}',
    False,
    'Texte présentant l''écologie du taxon.',
    'text',
    'textarea',
    (SELECT id_theme FROM taxonomie.bib_themes WHERE nom_theme = 'Atlas' LIMIT 1),
    (SELECT COALESCE(MAX(ordre) + 1, 1) FROM taxonomie.bib_attributs WHERE id_theme = (
        SELECT id_theme FROM taxonomie.bib_themes WHERE nom_theme = 'Atlas' LIMIT 1
    ) LIMIT 1)
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
) VALUES (
    'atlas_chorology_description',
    'Chorologie texte',
    '{}',
    False,
    'Texte présentant la chorologie du taxon.',
    'text',
    'textarea',
    (SELECT id_theme FROM taxonomie.bib_themes WHERE nom_theme = 'Atlas' LIMIT 1),
    (SELECT COALESCE(MAX(ordre) + 1, 1) FROM taxonomie.bib_attributs WHERE id_theme = (
        SELECT id_theme FROM taxonomie.bib_themes WHERE nom_theme = 'Atlas' LIMIT 1
    ) LIMIT 1)
) ;
