BEGIN;

\echo '-------------------------------------------------------------------------------'
\echo 'Copy CSV priority taxa into Conservation Strategy cor_territory_taxon table.'
\echo 'Rights: db owner'
\echo 'GeoNature database compatibility : v2.4.1+'

\echo '-------------------------------------------------------------------------------'
\echo 'Insert priority taxa to cor_territory_taxon table'
INSERT INTO :moduleSchema.cor_territory_taxon (
    id_territory,
    cd_nom,
    presence_meshes_count,
    small_isolated_population,
    indigenousness,
    iucn_cotation,
    iucn_criteria,
    rarity,
    rarity_class,
    revised_conservation_priority,
    revision_date,
    revision_comment
)
    SELECT
        id_territory,
        cd_nom,
        presence_meshes_count,
        small_isolated_population,
        indigenousness,
        iucn_cotation,
        iucn_criteria,
        rarity,
        rarity_class,
        revised_conservation_priority,
        revision_date,
        revision_comment
    FROM :moduleSchema.:tmpTable AS tmp
    WHERE NOT EXISTS (
        SELECT 'X'
        FROM :moduleSchema.cor_territory_taxon AS ctt
        WHERE ctt.cd_nom = tmp.cd_nom
            AND ctt.id_territory = tmp.id_territory
    ) ;

\echo '----------------------------------------------------------------------------'
\echo 'COMMIT if all is ok:'
COMMIT;
