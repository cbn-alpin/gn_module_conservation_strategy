BEGIN;

UPDATE
	pr_conservation_strategy.t_territory
SET
	id_area = (
        SELECT id_area
        FROM ref_geo.l_areas
        WHERE area_code = '84'
            AND id_type = ref_geo.get_id_area_type('REG')
    )
WHERE
    code = 'AURA';


UPDATE
	pr_conservation_strategy.t_territory
SET
	id_area = (
        SELECT id_area
        FROM ref_geo.l_areas
        WHERE area_code = '93'
            AND id_type = ref_geo.get_id_area_type('REG')
    )
WHERE
    code = 'PACA';

COMMIT;
