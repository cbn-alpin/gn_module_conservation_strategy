BEGIN;


\echo '--------------------------------------------------------------------------------'
\echo 'Insert or update territories'
INSERT INTO :moduleSchema.t_territory (label, code, surface, meshes_total, id_parent, id_area)
    SELECT
        :'label',
        :'code',
        :surface,
        :meshesTotal,
        (SELECT id_territory FROM :moduleSchema.t_territory WHERE code = :'codeParent'),
        (SELECT id_area FROM ref_geo.l_areas WHERE area_code = :'area_code' AND id_type = ref_geo.get_id_area_type(:'areaType'))
    WHERE NOT EXISTS (
        SELECT 'X'
        FROM :moduleSchema.t_territory AS te
        WHERE te.code = :'code'
    ) ;


\echo '--------------------------------------------------------------------------------'
\echo 'COMMIT if ALL is OK:'
COMMIT;
