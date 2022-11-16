BEGIN;

--t_assessment

INSERT INTO pr_conservation_strategy.t_assessment(
	id_assessment,
	id_priority_taxon,
	date_min,
	date_max,
	assessment_date,
	threats,
	description,
	next_assessment_year,
	computed_data,
	meta_create_date,
	meta_create_by,
	meta_update_date,
	meta_update_by 
)
SELECT 
	o.id_assessment,
	tpt.id_priority_taxon,
	o.date_min,
	o.date_max,
	o.assessment_date,
	o.threats,
	o.description,
	o.next_assessment_year,
	o.computed_data,
	o.meta_create_date,
	o.meta_create_by,
	o.meta_update_date,
	o.meta_update_by	
FROM pr_conservation_strategy_old.t_assessment AS o
JOIN pr_conservation_strategy.t_priority_taxon AS tpt
	ON tpt.id_territory = o.id_territory
		AND tpt.cd_nom = o.cd_nom;

--t_action

INSERT INTO pr_conservation_strategy.t_action(
	id_action,
	id_assessment,
	creation_date,
	id_action_level,
	id_action_type,
	id_action_progress,
	plan_for,
	starting_date,
	implementation_date,
	description 
)
SELECT 
	o.id_action,
	o.id_assessment,
	o.creation_date,
	o.id_action_level,
	o.id_action_type,
	o.id_action_progress,
	o.plan_for,
	o.starting_date,
	o.implementation_date,
	o.description 
FROM pr_conservation_strategy_old.t_action AS o;

--cor_action_organism


INSERT INTO pr_conservation_strategy.cor_action_organism (
	id_organism,
	id_action
)
SELECT
	o.id_organism,
	o.id_action 
FROM pr_conservation_strategy_old.cor_action_organism AS o;

COMMIT;
