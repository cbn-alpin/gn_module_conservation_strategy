BEGIN;

UPDATE
	pr_conservation_strategy.t_territory
SET
	id_area = 684083
WHERE
    code = 'AURA';


UPDATE
	pr_conservation_strategy.t_territory
SET
	id_area = 684084
WHERE
    code = 'PACA';

COMMIT;
