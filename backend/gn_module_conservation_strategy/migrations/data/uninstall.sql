-- Script to remove schema and all data linked in GeoNature DB
BEGIN;

\echo '--------------------------------------------------------------------------------'
\echo 'SHT schema'
\echo 'Delete cascade SHT schema'
DROP SCHEMA IF EXISTS :moduleSchema CASCADE ;

-- \echo '--------------------------------------------------------------------------------'
-- \echo 'Delete cascade all CS schema data'
-- TRUNCATE TABLE :moduleSchema.t_territory CASCADE ;

\echo '--------------------------------------------------------------------------------'
\echo 'REF_NOMENCLATURE'
\echo 'Delete "CS_ACTION" nomenclatures in t_nomenclatures'
DELETE FROM ref_nomenclatures.t_nomenclatures
    WHERE id_type = ref_nomenclatures.get_id_nomenclature_type('CS_ACTION') ;

\echo 'Delete "CS_ACTION" type in bib_nomenclatures_types'
DELETE FROM ref_nomenclatures.bib_nomenclatures_types
    WHERE mnemonique = 'CS_ACTION' ;

\echo 'Delete "CS_ACTION_GEO_LEVEL" nomenclatures in t_nomenclatures'
DELETE FROM ref_nomenclatures.t_nomenclatures
    WHERE id_type = ref_nomenclatures.get_id_nomenclature_type('CS_ACTION_GEO_LEVEL');

\echo 'Delete "CS_ACTION_GEO_LEVEL" type in bib_nomenclatures_types'
DELETE FROM ref_nomenclatures.bib_nomenclatures_types
    WHERE mnemonique = 'CS_ACTION_GEO_LEVEL' ;

\echo 'Delete "CS_ACTION_PROGRESS" nomenclatures in t_nomenclatures'
DELETE FROM ref_nomenclatures.t_nomenclatures
    WHERE id_type = ref_nomenclatures.get_id_nomenclature_type('CS_ACTION_PROGRESS');

\echo 'Delete "CS_ACTION_PROGRESS" type in bib_nomenclatures_types'
DELETE FROM ref_nomenclatures.bib_nomenclatures_types
    WHERE mnemonique = 'CS_ACTION_PROGRESS' ;

\echo '--------------------------------------------------------------------------------'
\echo 'GN_COMMONS'

\echo 'Unlink module from dataset'
DELETE FROM gn_commons.cor_module_dataset
    WHERE id_module = (
        SELECT id_module
        FROM gn_commons.t_modules
        WHERE module_code ILIKE :'moduleCode'
    ) ;

\echo 'Uninstall module (unlink this module of GeoNature)'
DELETE FROM gn_commons.t_modules
    WHERE module_code ILIKE :'moduleCode' ;

\echo '----------------------------------------------------------------------------'
\echo 'COMMIT if all is ok:'
COMMIT;
