BEGIN;

\echo '-------------------------------------------------------------------------------'
\echo 'Delete CSV priority taxa into Conservation Strategy cor_territory_taxon table.'
\echo 'Rights: db owner'
\echo 'GeoNature database compatibility : v2.4.1+'

\echo '-------------------------------------------------------------------------------'
\echo 'Delete priority taxa into cor_territory_taxon table'
DELETE FROM :moduleSchema.cor_territory_taxon AS ctt
WHERE EXISTS (
    SELECT 'X'
    FROM :moduleSchema.:tmpTable AS tmp
    WHERE ctt.cd_nom = tmp.cd_nom
        AND ctt.id_territory = tmp.id_territory
) ;

\echo '----------------------------------------------------------------------------'
\echo 'COMMIT if all is ok:'
COMMIT;
