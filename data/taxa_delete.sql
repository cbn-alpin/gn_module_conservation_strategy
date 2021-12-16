BEGIN;

\echo '-------------------------------------------------------------------------------'
\echo 'Delete CSV priority taxa into Conservation Strategy t_priority_taxon table.'
\echo 'Rights: db owner'
\echo 'GeoNature database compatibility : v2.4.1+'

\echo '-------------------------------------------------------------------------------'
\echo 'Delete priority taxa into t_priority_taxon table'
DELETE FROM :moduleSchema.t_priority_taxon AS tpt
WHERE EXISTS (
    SELECT 'X'
    FROM :moduleSchema.:tmpTable AS tmp
    WHERE tpt.cd_nom = tmp.cd_nom
        AND tpt.id_territory = tmp.id_territory
) ;

\echo '----------------------------------------------------------------------------'
\echo 'COMMIT if all is ok:'
COMMIT;
