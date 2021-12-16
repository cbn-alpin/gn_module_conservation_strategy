import logging
from datetime import date, datetime, timedelta

from sqlalchemy import and_, cast, func, Interval
from sqlalchemy.orm import joinedload

from geonature.utils.env import DB
from pypnnomenclature.repository import get_nomenclature_id_term, get_nomenclature_list
from pypnnomenclature.models import TNomenclatures

from .models import (
    BibOrganisms,
    CorActionOrganism,
    TPriorityTaxon,
    TAction,
    TAssessment,
    TTerritory,
)

log = logging.getLogger(__name__)


class AssessmentRepository:

    def get_one(self, assessment_id):
        # Build query
        query = (DB.session
            .query(TAssessment)
            .join(TPriorityTaxon, TPriorityTaxon.id == TAssessment.id_priority_taxon)
            .join(TTerritory, TTerritory.id_territory == TPriorityTaxon.id_territory)
            .filter(TAssessment.id == assessment_id)
        )
        # Execute query
        results = query.first()
        # Manage output
        return self._buildOutput(results) if results != None else {}

    def _buildOutput(self, assessment):
        item = assessment.as_dict(exclude=['id_territory', 'meta_create_by'])
        #item['territory_code'] = assessment.territory.code
        item['meta_create_by'] = assessment.create_by.get_full_name()
        item['actions'] = []
        for action in assessment.actions:
            action_dict = action.as_dict(exclude=[
                'id_assessment', 'id_action_level', 'id_action_type', 'id_action_progress'
            ])
            if action.action_level:
                action_dict['level'] = action.action_level.label_default
                action_dict['level_code'] = action.action_level.cd_nomenclature
            if action.action_type:
                action_dict['type'] = action.action_type.label_default
                action_dict['type_code'] = action.action_type.cd_nomenclature
                action_dict['type_definition'] = action.action_type.definition_default
            if action.action_progress:
                action_dict['progress'] = action.action_progress.label_default
                action_dict['progress_code'] = action.action_progress.cd_nomenclature
            action_dict['partners'] = []
            for partner in action.partners:
                action_dict['partners'].append(partner.organism.as_dict())
            item['actions'].append(action_dict)
        return item

    def get_all(self, territory_code, taxon_name_code, limit, page):
        # Build query
        query = (DB.session
            .query(TAssessment)
            .join(TPriorityTaxon, TPriorityTaxon.id == TAssessment.id_priority_taxon)
            .join(TTerritory, TTerritory.id_territory == TPriorityTaxon.id_territory)
            .filter(func.lower(TTerritory.code) == territory_code.lower())
            .filter(TPriorityTaxon.cd_nom == taxon_name_code)
        )
        # Execute query
        count = query.count()
        results = (query
            .limit(limit)
            .offset(page * limit)
            .all()
        )
        # Manage output
        items = []
        for assessment in results:
            item = assessment.as_dict(exclude=['id_territory', 'meta_create_by'])
            item['territory_code'] = territory_code
            item['meta_create_by'] = assessment.create_by.get_full_name()
            items.append(item)
        return (count, items)

    def create(self, data):
        assessment_data = data["assessment"]
        actions_data = data["actions"]

        assessment = self._prepare_assessment(assessment_data, actions_data)
        DB.session.add(assessment)

    def _prepare_assessment(self, assessment, actions):
        id_priority_taxon = self.get_taxon_priority_id(
            assessment.get("territory_code"),
            assessment.get("taxon_name_code")
        )
        assessment_model = TAssessment(
            id=assessment.get("id"),
            id_priority_taxon=id_priority_taxon,
            description=assessment.get("description"),
            next_assessment_year=assessment.get("next_assessment_year"),
            threats=assessment.get("threats"),
            actions=self._prepare_actions(actions)
        )
        if assessment.get("meta_create_by"):
            assessment_model.meta_create_by = assessment.get("meta_create_by")
        if assessment.get("meta_update_by"):
            assessment_model.meta_update_by = assessment.get("meta_update_by")

        return assessment_model

    def get_taxon_priority_id(self, territory_code, taxon_name_code):
        return (DB.session
            .query(TPriorityTaxon.id)
            .join(TTerritory, TTerritory.id_territory == TPriorityTaxon.id_territory)
            .filter(func.lower(TTerritory.code) == territory_code.lower())
            .filter(TPriorityTaxon.cd_nom == taxon_name_code)
            .scalar()
        )

    def get_territory_id(self, territory_code):
        return (DB.session
            .query(TTerritory.id_territory)
            .filter(func.lower(TTerritory.code) == territory_code.lower())
            .scalar()
        )

    def _prepare_actions(self, actions):
        action_models = list()
        for action in actions:
            action = TAction(
                id=action.get("id"),
                id_action_level=self.get_action_geo_level(action.get("level")),
                id_action_type=self.get_action_type(action.get("type")),
                id_action_progress=self.get_action_progress(action.get("progress")),
                plan_for=action.get("plan_for"),
                starting_date=action.get("starting_date"),
                implementation_date=action.get("implementation_date"),
                description=action.get("description"),
                partners=self._prepare_partners(action.get("id"), action.get("partners")),
            )
            action_models.append(action)
        return action_models

    def get_action_geo_level(self, code):
        return get_nomenclature_id_term("CS_ACTION_GEO_LEVEL", code)

    def get_action_type(self, code):
        return get_nomenclature_id_term("CS_ACTION", code)

    def get_action_progress(self, code):
        return get_nomenclature_id_term("CS_ACTION_PROGRESS", code)

    def _prepare_partners(self, action_id, partners_uuid):
        partners_models = list()
        organisms_ids = self.get_id_organisms(partners_uuid)
        for organism_id in organisms_ids:
            partner = CorActionOrganism(
                id_action=action_id,
                id_organism=organism_id,
            )
            partners_models.append(partner)
        return partners_models

    def get_id_organisms(self, uuid_list: list):
        return (DB.session
            .query(BibOrganisms.id)
            .filter(BibOrganisms.uuid.in_(uuid_list))
            .all()
        )

    def update(self, data):
        assessment_data = data["assessment"]
        actions_data = data["actions"]

        assessment = self._prepare_assessment(assessment_data, actions_data)
        DB.session.merge(assessment)
