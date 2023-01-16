import logging

from sqlalchemy import func

from geonature.utils.env import DB
from pypnnomenclature.repository import get_nomenclature_id_term
from pypnusershub.db.models import Organisme

from .models import (
    CorActionOrganism,
    TPriorityTaxon,
    TAction,
    TAssessment,
    TTerritory,
)
from .utils import remove_entries


log = logging.getLogger(__name__)


class AssessmentRepository:
    def get_one(self, assessment_id):
        # Build query
        query = (
            DB.session.query(TAssessment)
            .join(TPriorityTaxon, TPriorityTaxon.id == TAssessment.id_priority_taxon)
            .filter(TAssessment.id == assessment_id)
        )
        # Execute query
        results = query.first()
        # Manage output
        return self._buildOutput(results) if results != None else {}

    def _buildOutput(self, assessment):
        item = assessment.as_dict(exclude=["meta_create_by"])
        item["meta_create_by"] = assessment.create_by.nom_role
        item["actions"] = []
        for action in assessment.actions:
            action_dict = action.as_dict(
                exclude=["id_assessment", "id_action_level", "id_action_type", "id_action_progress"]
            )
            if action.action_level:
                action_dict["level"] = action.action_level.label_default
                action_dict["level_code"] = action.action_level.cd_nomenclature
            if action.action_type:
                action_dict["type"] = action.action_type.label_default
                action_dict["type_code"] = action.action_type.cd_nomenclature
                action_dict["type_definition"] = action.action_type.definition_default
            if action.action_progress:
                action_dict["progress"] = action.action_progress.label_default
                action_dict["progress_code"] = action.action_progress.cd_nomenclature
            action_dict["partners"] = []
            for partner in action.partners:
                action_dict["partners"].append(partner.organism.as_dict())
            item["actions"].append(action_dict)
        return item

    def get_all(self, priority_taxon_id, limit, page):
        # Build query
        query = (
            DB.session.query(TAssessment)
            .join(TPriorityTaxon, TPriorityTaxon.id == TAssessment.id_priority_taxon)
        )

        if priority_taxon_id:
            query = query.filter(TPriorityTaxon.id == priority_taxon_id)

        # Execute query
        count = query.count()
        results = query.limit(limit).offset(page * limit).all()
        # Manage output
        items = []
        for (assessment) in results:
            item = assessment.as_dict(exclude=["meta_create_by"])
            item["meta_create_by"] = assessment.create_by.nom_role
            items.append(item)
        return (count, items)

    def create(self, data):
        assessment_data = data["assessment"]
        actions_data = data["actions"] if "actions" in data else None
        self._prepare_assessment(assessment_data, actions_data)

    def update(self, data):
        assessment_data = data["assessment"]
        actions_data = data["actions"] if "actions" in data else None
        self._prepare_assessment(assessment_data, actions_data)

    def _prepare_assessment(self, assessment_data: dict, actions_data: dict):
        assessment = TAssessment(**assessment_data)
        if actions_data:
            self._prepare_actions(assessment, actions_data)

        # Update or insert
        DB.session.merge(assessment) if "id" in assessment_data else DB.session.add(assessment)

    def _prepare_actions(self, assessment: TAssessment, actions_data: dict):
        for action_data in actions_data:
            cleaned_action_data = remove_entries(
                action_data, ["uuid", "level", "type", "progress", "partners"]
            )
            action = TAction(**cleaned_action_data)

            if "level" in action_data:
                action.id_action_level = self.get_action_geo_level(action_data.get("level"))
            if "type" in action_data:
                action.id_action_type = self.get_action_type(action_data.get("type"))
            if "progress" in action_data:
                action.id_action_progress = self.get_action_progress(action_data.get("progress"))
            if "partners" in action_data:
                self._prepare_partners(action, action_data.get("partners"))

            assessment.actions.append(action)

    def get_action_geo_level(self, code):
        return get_nomenclature_id_term("CS_ACTION_GEO_LEVEL", code)

    def get_action_type(self, code):
        return get_nomenclature_id_term("CS_ACTION", code)

    def get_action_progress(self, code):
        return get_nomenclature_id_term("CS_ACTION_PROGRESS", code)

    def _prepare_partners(self, action: TAction, partners_uuid: list):
        organisms_ids = self.get_id_organisms(partners_uuid)
        for organism_id in organisms_ids:
            partner = CorActionOrganism(
                id_action=action.id,
                id_organism=organism_id,
            )
            action.partners.append(partner)

    def get_id_organisms(self, uuid_list: list):
        return (
            DB.session.query(Organisme.id_organisme)
            .filter(Organisme.uuid_organisme.in_(uuid_list))
            .all()
        )
