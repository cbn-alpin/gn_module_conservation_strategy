import logging

from flask import Blueprint, request
from sqlalchemy import desc, func, or_, exc, case, String
from sqlalchemy.sql.expression import cast
from sqlalchemy.orm import aliased
from sqlalchemy.sql import literal_column

from geonature.core.gn_permissions import decorators as permissions
from geonature.utils.env import DB
from utils_flask_sqla.response import json_resp

from apptax.taxonomie.models import BibNoms, BibAttributs, TMedias, Taxref, CorTaxonAttribut
from pypnusershub.db.models import Organisme
from pypnnomenclature.models import TNomenclatures

from .models import (
    TAction,
    TPriorityTaxon,
    TAssessment,
    TTerritory,
)
from .repositories import AssessmentRepository
from .utils import prepare_input, prepare_output


blueprint = Blueprint("pr_conservation_strategy", __name__)
log = logging.getLogger(__name__)

@blueprint.route("/territories", methods=["GET"])
@permissions.check_cruved_scope('R', module_code="CONSERVATION_STRATEGY")
@json_resp
def get_territories():
    """
    Liste des territoires.

    :returns: une liste de dictionnaires contenant les infos d'un territoire.
    """
    q = DB.session.query(TTerritory)
    data = q.all()
    output = [d.as_dict() for d in data]
    return prepare_output(output, remove_in_key="territory")


@blueprint.route("/territories/<territory>", methods=["GET"])
@permissions.check_cruved_scope('R', module_code="CONSERVATION_STRATEGY")
@json_resp
def get_territory(territory):
    """
    Fourni les infos d'un territoire.

    :returns: un dictionnaire contenant les infos d'un territoire.
    """
    q = DB.session.query(TTerritory).filter(func.lower(TTerritory.code) == territory.lower())
    result = q.first()
    output = None if not result else result.as_dict()
    return prepare_output(output, remove_in_key="territory")


@blueprint.route("/taxons/search", methods=["GET"])
@permissions.check_cruved_scope('R', module_code="CONSERVATION_STRATEGY")
@json_resp
def search_taxons_by_territory():
    """
    Liste des noms de taxons pour un territoire donné.

    Paramètres de la chaine de requête de l'URL :
    :query str q: le nom à rechercher.
    :query str territory-code: code du territoire concerné.
    :query int limit: le nombre de noms max à retourner.
    :query int page: premier élément à prendre à compte pour le retour.

    :returns: une liste de dictionnaires contenant les infos d'un nom.
    """
    # Get request parameters
    search_name = request.args.get("q")
    territory = request.args.get("territory-code")
    limit = int(request.args.get("limit", 20))
    page = int(request.args.get("page", 0))

    # Execute query
    query = (DB.session
        .query(
            TPriorityTaxon.cd_nom,
            Taxref.cd_ref,
            Taxref.lb_nom.label("search_name"),
            Taxref.nom_valide,
        )
        .join(Taxref, Taxref.cd_nom == TPriorityTaxon.cd_nom)
    )
    if territory:
        query = (query
            .join(TTerritory, TTerritory.id_territory == TPriorityTaxon.id_territory)
            .filter(func.lower(TTerritory.code) == territory.lower())
        )

    if search_name:
        ilike_search_name = f"%{search_name.replace(' ', '%')}%"
        query = (query
            .filter(Taxref.lb_nom.ilike(ilike_search_name))
            .add_columns(func.similarity(Taxref.lb_nom, search_name).label("idx_trgm"))
            .order_by(desc("idx_trgm"))
        )

    data = (query
        .limit(limit)
        .offset(page * limit)
        .all()
    )

    # Manage output
    output = [d._asdict() for d in data]
    return prepare_output(output)

@blueprint.route("/taxons", methods=["GET"])
@permissions.check_cruved_scope('R', module_code="CONSERVATION_STRATEGY")
@json_resp
def get_taxons_by_territory():
    """
    Liste des infos des taxons prioritaires pour un territoire donné.

    Paramètres de la chaine de requête de l'URL :
    :query territory-code: code du territoire concerné.
    :query str taxon-name-code: filtre sur le code du nom d'un taxon (=cd_nom).
    :query str with-assessment: filtre sur la présence d'au moins un bilan
        stationnel associé au taxon sur le territoire.
    :query str cpi: filtre sur l'indice de priorité de conservation.
        Valeurs : 1, 2 ou 3.
    :query int sort: trie les résultats en fonction d'une colonne.
        Format : <nom-colonne>:<direction>.
        <Nom colonne> peut prendre les valeurs : fullName, cpi, dateMin,
            dateMax, areaPresenceCount.
        <direction> peut prendre les valeurs : asc, desc.
    :query int limit: le nombre d'item max à retourner.
        Par défaut : 20.
    :query int page: Numéro de la page de résultat à afficher.
        Par défaut : 0.

    :returns: une liste de dictionnaires contenant les infos d'un taxon
        prioritaire.
    """
    # Get request parameters
    territory = request.args.get("territory-code")
    cd_nom = request.args.get("taxon-name-code")
    with_assessment = request.args.get("with-assessment")
    cpi = request.args.get("cpi")
    sort = request.args.get("sort")
    limit = int(request.args.get("limit", 20))
    page = int(request.args.get("page", 0))

    # Execute query
    fields = [
        Taxref.cd_ref.label("ref_name_code"),
        Taxref.nom_complet.label("full_name"),
        Taxref.nom_complet_html.label("display_full_name"),
        Taxref.lb_nom.label("short_name"),
        TPriorityTaxon.id,
        TPriorityTaxon.cd_nom.label("name_code"),
        TPriorityTaxon.revised_conservation_priority.label("revised_cpi"),
        TPriorityTaxon.computed_conservation_priority.label("computed_cpi"),
        TPriorityTaxon.min_prospect_zone_date.label("date_min"),
        TPriorityTaxon.max_prospect_zone_date.label("date_max"),
        TPriorityTaxon.presence_area_count,
    ]
    query = (DB.session
        .query(
            *fields,
            func.count(TAssessment.id).label("assessment_count")
        )
        .join(Taxref, Taxref.cd_nom == TPriorityTaxon.cd_nom)
        .outerjoin(TAssessment, TAssessment.id_priority_taxon == TPriorityTaxon.id)
    )

    if territory:
        query = (query
            .join(TTerritory, TTerritory.id_territory == TPriorityTaxon.id_territory)
            .filter(func.lower(TTerritory.code) == territory.lower())
        )
    else:
        column_to_add = TTerritory.code.label("territory_code")
        fields.append(column_to_add)
        query = (query
            .add_column(column_to_add)
            .join(TTerritory, TTerritory.id_territory == TPriorityTaxon.id_territory)
        )

    if cd_nom:
        query = query.filter(TPriorityTaxon.cd_nom == cd_nom)

    if cpi:
        query = query.filter(
            or_(
                TPriorityTaxon.revised_conservation_priority == cpi,
                TPriorityTaxon.computed_conservation_priority == cpi,
            )
        )

    if with_assessment:
        query = query.having(func.count(TAssessment.id) > 0)

    if sort:
        try:
            (column, direction) = sort.split(':')

            available_sort = {
                'fullName': [Taxref.nom_complet],
                'cpi': [
                    TPriorityTaxon.revised_conservation_priority,
                    TPriorityTaxon.computed_conservation_priority
                ],
                'dateMin': [TPriorityTaxon.min_prospect_zone_date],
                'dateMax': [TPriorityTaxon.max_prospect_zone_date],
                'areaPresenceCount': [TPriorityTaxon.presence_area_count],
                'assessmentCount': [func.count(TAssessment.id)],
            }
            order_fields = available_sort.get(column, Taxref.nom_valide)
            if direction == 'desc':
                desc_fieds = map(desc, order_fields)
                query = query.order_by(*desc_fieds)
            elif direction == 'asc':
                query = query.order_by(*order_fields)
            else:
                msg = f"Unknown sort direction '{direction}'. Use only: asc, desc."
                log.error(msg)
                return {"message": msg, "status": "error"}, 400
        except NotImplementedError:
            values = ', '.join(list(available_sort.keys()))
            msg = f"Unknown sort column '{column}'. Use only: {values}."
            log.error(msg)
            return {"message": msg, "status": "error"}, 400

    query = query.group_by(*fields)
    count = query.count()
    items = (query
        .limit(limit)
        .offset(page * limit)
        .all()
    )

    # Manage output
    output = {
        "total_count": count,
        "incomplete_results": (limit < count),
        "items": [d._asdict() for d in items],
    }
    return prepare_output(output)


@blueprint.route("/taxons/<int:priority_taxon_id>", methods=["GET"])
@permissions.check_cruved_scope('R', module_code="CONSERVATION_STRATEGY")
@json_resp
def get_priority_taxon_infos(priority_taxon_id):
    """
    Fourni les infos d'un taxon prioritaire pour un territoire donné.

    Paramètres du chemin de l'URL :
    :param priority_taxon_id: identifiant du taxon prioritaire. Obligatoire.

    :returns: un dictionnaire contenant les infos du taxon prioritaire.
    """
    # Get request parameters
    with_taxhub_attributs = request.args.get("with-taxhub-attributs")
    with_medias = request.args.get("with-medias")

    # Execute query
    fields = [
        Taxref.cd_ref.label("ref_name_code"),
        Taxref.nom_complet.label("full_name"),
        Taxref.nom_complet_html.label("display_full_name"),
        Taxref.lb_nom.label("short_name"),
        BibNoms.id_nom.label("taxhub_record_id"),
        TPriorityTaxon.revised_conservation_priority.label("revised_cpi"),
        TPriorityTaxon.computed_conservation_priority.label("computed_cpi"),
        TPriorityTaxon.min_prospect_zone_date.label("date_min"),
        TPriorityTaxon.max_prospect_zone_date.label("date_max"),
        TPriorityTaxon.presence_area_count,
    ]
    query = (DB.session
        .query(
            *fields,
            func.count(TAssessment.id).label("assessment_count")
        )
        .join(Taxref, Taxref.cd_nom == TPriorityTaxon.cd_nom)
        .outerjoin(BibNoms, BibNoms.cd_nom == Taxref.cd_nom)
        .outerjoin(TAssessment, TAssessment.id_priority_taxon == TPriorityTaxon.id)
        .filter(TPriorityTaxon.id == priority_taxon_id)
        .group_by(*fields)
    )

    data = query.one()._asdict()

    # Manage medias
    if with_medias:
        query = (DB.session
            .query(
                TMedias.titre.label("title"),
                TMedias.url,
                TMedias.chemin.label("path"),
                TMedias.auteur.label("author"),
                TMedias.desc_media.label("description"),
                #TMedias.date_media.label("date"),
                TMedias.source,
                TMedias.licence,
                # TODO: get media type value in GN v2.8.0+
            )
            .join(Taxref, Taxref.cd_ref == TMedias.cd_ref)
            .join(TPriorityTaxon, TPriorityTaxon.cd_nom == Taxref.cd_nom)
            .filter(TPriorityTaxon.id == priority_taxon_id)
            .filter(TMedias.is_public == True)
            .filter(TMedias.supprime == False)
        )
        medias = query.all()
        data["medias"] = [media._asdict() for media in medias]

    # Manage TaxHub Attributs
    if with_taxhub_attributs:
        query = (DB.session
            .query(
                CorTaxonAttribut.valeur_attribut.label("content"),
                BibAttributs.nom_attribut.label("code"),
            )
            .join(BibAttributs, BibAttributs.id_attribut == CorTaxonAttribut.id_attribut)
            .join(Taxref, Taxref.cd_ref == CorTaxonAttribut.cd_ref)
            .join(TPriorityTaxon, TPriorityTaxon.cd_nom == Taxref.cd_nom)
            .filter(TPriorityTaxon.id == priority_taxon_id)
        )
        attributs = query.all()
        data["attributs"] = {}
        for attribut in attributs:
            data["attributs"][attribut.code] = attribut.content

    # Manage output
    return prepare_output(data)


@blueprint.route("/organisms", methods=["GET"])
@permissions.check_cruved_scope('R', module_code="CONSERVATION_STRATEGY")
@json_resp
def get_organisms():
    """
    Liste tous les organismes partenaires.

    :returns: une liste de dictionnaires contenant les infos des organismes
        partenaires.
    """
    # Get request parameters
    order_by = request.args.get("order-by", "nom_organisme")

    # Prepare query
    query = (DB.session
        .query(Organisme)
        .filter(Organisme.id_organisme > 0)

    )
    if order_by:
        try:
            order_column = getattr(Organisme.__table__.columns, order_by)
            query = query.order_by(order_column)
        except AttributeError:
            columns = ", ".join(list(Organisme.__table__.columns.keys()))
            msg = f"Unknown order-by parameter '{order_by}'. Use only : {columns}"
            log.error(msg)
            return {"message": msg, "status": "error"}, 400

    # Execute query
    organisms = query.all()

    # Manage output
    data = [organism.as_dict() for organism in organisms]
    return prepare_output(data)


@blueprint.route("/assessments", methods=["POST"])
@permissions.check_cruved_scope("C", get_role=True, module_code="CONSERVATION_STRATEGY")
@json_resp
def create_assessment(info_role):
    """
    Ajouter une fiche bilan stationnel.

    :returns: un objet réponse contenant un "message" et un "status". Le
        "status" prend la valeur "success" si tout s'est bien passé
        (code HTTP 200) et "error" en cas de problème (code HTTP 500).
    """
    # Transform received data
    data = prepare_input(dict(request.get_json()))
    data["assessment"]["meta_create_by"] = int(getattr(info_role, 'id_role'))
    exception = None

    try:
        assessment_repo = AssessmentRepository()
        # Create assessment
        assessment_repo.create(data)
        # Write in database
        DB.session.commit()
        DB.session.flush()
    except exc.SQLAlchemyError as e:
        log.error("Error SQLAlchemy %s", e)
        exception = e
    except Exception as e:
        log.error("Error %s", e)
        exception = e

    # Return response
    if exception:
        response = {
            "message": f"An error occurred while adding the assessment : {exception} .",
            "status": "error"
        }
        code = 500
    else:
        response = {
            "message": "Success of adding the assessment.",
            "status": "success"
        }
        code = 200
    return response, code


@blueprint.route("/assessments", methods=["GET"])
@permissions.check_cruved_scope('R', module_code="CONSERVATION_STRATEGY")
@json_resp
def get_assessments():
    """
    Liste des infos des fiches bilan stationnel d'un taxon prioritaire
    pour un territoire donné.

    Paramètres du chemin de l'URL :

    Paramètres de la chaine de requête de l'URL :
    :query string territory-code: filtre sur le code d'un territoire.
    :query int priority-taxon-id: filtre sur l'identifiant d'un taxon prioritaire.
    :query int limit: le nombre d'item max à retourner.
    :query int page: premier item à prendre à compte pour le retour.

    :returns: une liste de dictionnaires contenant les infos des fiches
    bilan stationnel.
    """
    # Get request parameters
    territory = request.args.get("territory-code")
    priority_taxon_id = request.args.get("priority-taxon-id")
    limit = int(request.args.get("limit", 20))
    page = int(request.args.get("page", 0))

    # Find data
    assessment_repo = AssessmentRepository()
    count, items = assessment_repo.get_all(territory, priority_taxon_id, limit, page)

    # Manage output
    output = {
        "total_count": count,
        "incomplete_results": (limit < count),
        "items": items,
    }
    return prepare_output(output)

@blueprint.route("/assessments/<int:assessment_id>", methods=["GET"])
@permissions.check_cruved_scope('R', module_code="CONSERVATION_STRATEGY")
@json_resp
def get_assessment_details(assessment_id):
    """
    Fourni les infos d'un rapport de bilan.

    Paramètres du chemin de l'URL :
    :param assessment_id: identifiant de la fiche bilan stationnel. Obligatoire.

    :returns: un dictionnaire contenant les infos d'un rapport de bilan.
    """
    assessment_repo = AssessmentRepository()
    output = assessment_repo.get_one(assessment_id)
    return prepare_output(output)

@blueprint.route("/assessments/<int:assessment_id>", methods=["PUT"])
@permissions.check_cruved_scope("U", get_role=True, module_code="CONSERVATION_STRATEGY")
@json_resp
def update_assessment(info_role, assessment_id):
    """
    Mettre à jour une fiche bilan stationnel.

    Paramètres du chemin de l'URL :
    :param assessment_id: identifiant de la fiche bilan stationnel. Obligatoire.

    :returns: un objet réponse contenant un "message" et un "status". Le
        "status" prend la valeur "success" si tout s'est bien passé
        (code HTTP 200) et "error" en cas de problème (code HTTP 500).
    """
    # Transform received data
    data = prepare_input(dict(request.get_json()))
    data["assessment"]["id"] = assessment_id
    data["assessment"]["meta_update_by"] = int(getattr(info_role, 'id_role'))
    exception = None

    try:
        assessment_repo = AssessmentRepository()
        # Create assessment
        assessment_repo.update(data)
        # Write in database
        DB.session.commit()
        DB.session.flush()
    except exc.SQLAlchemyError as e:
        log.error("Error SQLAlchemy %s", e)
        exception = e
    except Exception as e:
        log.error("Error %s", e)
        exception = e

    # Return response
    if exception:
        response = {
            "message": f"An error occurred while updating the assessment : {exception} .",
            "status": "error"
        }
        code = 500
    else:
        response = {
            "message": "Success of updating the assessment.",
            "status": "success"
        }
        code = 200
    return response, code

@blueprint.route("/tasks", methods=["GET"])
@permissions.check_cruved_scope('R', module_code="CONSERVATION_STRATEGY")
@json_resp
def get_tasks():


    # Get request parameters
    # organism = request.args.get("organism_id")
    # type_task = request.args.get("type_task")
    # progress_task = request.args.get("progress_task")
    limit = int(request.args.get("limit", 20))
    page = int(request.args.get("page", 0))

     # Execute actions query

    TNomenclaturesT = aliased(TNomenclatures)
    TNomenclaturesP = aliased(TNomenclatures)

    task_date_action = case([
                    (TNomenclaturesP.cd_nomenclature == "pl", TAction.implementation_date),
                    (TNomenclaturesP.cd_nomenclature == "c", TAction.starting_date),
                    ],
                    else_= func.to_date(cast(TAction.plan_for, String), 'YYYY')
                )

    fields_action = [
        TAction.id.label("id"),
        TAction.id_assessment.label("assessment_id"),
        Taxref.lb_nom.label("taxon_name"),
        TTerritory.label.label("territory_name"),
        task_date_action.label("task_date"),
        literal_column("'Action'").label("task_type"),
        TNomenclaturesT.label_default.label("task_label"),
        TNomenclaturesP.label_default.label("progress_status"),
        TTerritory.code.label("territory_code"),
        TPriorityTaxon.id.label("priority_taxon_id"),
    ]

    query_action = (DB.session
        .query(*fields_action)
        .join(TAssessment, TAssessment.id == TAction.id_assessment)
        .outerjoin(TPriorityTaxon, TPriorityTaxon.id == TAssessment.id_priority_taxon)
        .outerjoin(Taxref, Taxref.cd_nom == TPriorityTaxon.cd_nom)
        .outerjoin(TTerritory, TTerritory.id_territory == TPriorityTaxon.id_territory)
        .outerjoin(TNomenclaturesT, TNomenclaturesT.id_nomenclature == TAction.id_action_type)
        .outerjoin(TNomenclaturesP, TNomenclaturesP.id_nomenclature == TAction.id_action_progress)
    )

# Execute assessments query

    task_date_assessment = func.to_date(cast(TAssessment.next_assessment_year, String), 'YYYY')

    fields_assessment = [
        TAssessment.id.label("id"),
        TAssessment.id.label("assessment_id"),
        Taxref.lb_nom.label("taxon_Name"),
        TTerritory.label.label("territory_name"),
        task_date_assessment.label("task_date"),
        literal_column("'Assessment'").label("task_type"),
        literal_column("'Réaliser fiche Bilan Stationnel'").label("task_label"),
        literal_column("'A mettre en place'").label("progress_status"),
        TTerritory.code.label("territory_code"),
        TAssessment.id_priority_taxon.label("priority_taxon_id"),
    ]

    query_assessment = (DB.session
        .query(*fields_assessment)
        .outerjoin(TPriorityTaxon, TPriorityTaxon.id == TAssessment.id_priority_taxon)
        .outerjoin(Taxref, Taxref.cd_nom == TPriorityTaxon.cd_nom)
        .outerjoin(TTerritory, TTerritory.id_territory == TPriorityTaxon.id_territory)
    )
    

    # if organism:
    #     query = (query
    #         .filter(func.lower(TTerritory.code) == territory.lower())
    #     )
    

# Execute final query
    query = query_action.union(query_assessment)
    count = query.count()
    items = (query
        .limit(limit)
        .offset(page * limit)
        .all()
    )

    # Manage output
    output = {
        "total_count": count,
        "incomplete_results": (limit < count),
        "items": [d._asdict() for d in items],
    }
    return prepare_output(output)
