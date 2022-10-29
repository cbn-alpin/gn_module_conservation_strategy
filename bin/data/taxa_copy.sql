BEGIN;

\echo '-------------------------------------------------------------------------------'
\echo 'Copy CSV priority taxa into Conservation Strategy temp table.'
\echo 'Rights: db owner'
\echo 'GeoNature database compatibility : v2.4.1+'

SET client_encoding = 'UTF8';


\echo '-------------------------------------------------------------------------------'
\echo 'Remove temp priority taxa table if already exists'
DROP TABLE IF EXISTS :moduleSchema.:tmpTable ;


\echo '-------------------------------------------------------------------------------'
\echo 'Create temp priority taxa table from "t_priority_taxon" with additionnal fields'
CREATE TABLE :moduleSchema.:tmpTable AS
    SELECT
        NULL::INT AS gid,
        NULL::INT AS id_territory,
        NULL::VARCHAR(50) AS territory_code,
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
    FROM :moduleSchema.t_priority_taxon
WITH NO DATA ;


\echo '-------------------------------------------------------------------------------'
\echo 'Add primary key on temp priority taxa table'
\set importTablePk 'pk_':tmpTable
ALTER TABLE :moduleSchema.:tmpTable
	ALTER COLUMN gid ADD GENERATED ALWAYS AS IDENTITY,
	ADD CONSTRAINT :importTablePk PRIMARY KEY(gid);


\echo '-------------------------------------------------------------------------------'
\echo 'Attribute temp priority taxa table to GeoNature DB owner'
ALTER TABLE :moduleSchema.:tmpTable OWNER TO :gnDbOwner ;


\echo '-------------------------------------------------------------------------------'
\echo 'Copy CVS file to temp priority taxa table'
COPY :moduleSchema.:tmpTable (${columns})
FROM :'csvFilePath'
WITH CSV HEADER DELIMITER E'\t' NULL '\N' ;


\echo '-------------------------------------------------------------------------------'
\echo 'Insert territory id into temp priority taxa table'
UPDATE  :moduleSchema.:tmpTable AS tmp SET
    id_territory = t.id_territory
FROM (
    SELECT id_territory, code
    FROM :moduleSchema.t_territory
) AS t
WHERE t.code = tmp.territory_code ;


\echo '----------------------------------------------------------------------------'
\echo 'COMMIT if all is ok:'
COMMIT;
