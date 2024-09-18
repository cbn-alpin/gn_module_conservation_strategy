import logging

from flask import Blueprint, request, g
from sqlalchemy import and_, desc, func, or_, exc, case, String, select, union, distinct
from sqlalchemy.sql.expression import cast
from sqlalchemy.orm import aliased
from sqlalchemy.sql import literal_column

from geonature.core.gn_permissions import decorators as permissions
from ref_geo.models import LAreas, BibAreasTypes
from geonature.utils.env import DB
from utils_flask_sqla.response import json_resp

from apptax.taxonomie.models import (
    BibNoms,
    BibAttributs,
    TMedias,
    Taxref,
    CorTaxonAttribut,
)
from pypnnomenclature.models import TNomenclatures

from .models import (
    CorActionOrganism,
    TAction,
    TPriorityTaxon,
    TAssessment,
    TTerritory,
)
from .repositories import AssessmentRepository, OrganismRepository
from .utils import prepare_input, prepare_output


blueprint = Blueprint("pr_conservation_strategy", __name__)
log = logging.getLogger(__name__)


@blueprint.route("/territories", methods=["GET"])
@permissions.check_cruved_scope("R", module_code="CONSERVATION_STRATEGY")
@json_resp
def get_territories():
    """
    Liste des territoires.

    :returns: une liste de dictionnaires contenant les infos d'un territoire.
    """
    q = select(TTerritory)
    data = DB.session.scalars(q).unique().all()
    output = [d.as_dict() for d in data]
    return prepare_output(output, remove_in_key="territory")


@blueprint.route("/territories/<int:territory_id>", methods=["GET"])
@permissions.check_cruved_scope("R", module_code="CONSERVATION_STRATEGY")
@json_resp
def get_territory(territory_id):
    query = (
        select(
            TTerritory.id_territory.label("territory_id"),
            LAreas.area_code.label("area_code"),
            BibAreasTypes.type_code.label("area_type"),
        )
        .outerjoin(LAreas, LAreas.id_area == TTerritory.id_area)
        .outerjoin(BibAreasTypes, BibAreasTypes.id_type == LAreas.id_type)
        .where(TTerritory.id_territory == territory_id)
    )

    data = DB.session.execute(query).first()
    output = (
        None
        if data == None
        else {
            "territory_id": data[0],
            "area_code": data[1],
            "area_type": data[2],
        }
    )
    return prepare_output(output)


@blueprint.route("/taxons/search", methods=["GET"])
@permissions.check_cruved_scope("R", module_code="CONSERVATION_STRATEGY")
@json_resp
def search_taxons():
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
    limit = int(request.args.get("limit", 20))
    page = int(request.args.get("page", 0))

    # Execute query
    query = select(
        TPriorityTaxon.cd_nom,
        Taxref.cd_ref,
        Taxref.lb_nom.label("search_name"),
        Taxref.nom_valide,
    ).join(Taxref, Taxref.cd_nom == TPriorityTaxon.cd_nom)

    if search_name:
        ilike_search_name = f"%{search_name.replace(' ', '%')}%"
        query = (
            query.where(Taxref.lb_nom.ilike(ilike_search_name))
            .add_columns(func.similarity(Taxref.lb_nom, search_name).label("idx_trgm"))
            .order_by(desc("idx_trgm"))
        )

    data = DB.session.execute(query.limit(limit).offset(page * limit)).unique().all()

    # Manage output
    output = [d._asdict() for d in data]
    return prepare_output(output)


@blueprint.route("/taxons", methods=["GET"])
@permissions.check_cruved_scope("R", module_code="CONSERVATION_STRATEGY")
@json_resp
def get_taxons():
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
        Taxref.cd_ref.label("taxon_code"),
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
        TTerritory.code.label("territory_code"),
        TTerritory.label.label("territory_name"),
    ]
    query = (
        select(*fields, func.count(TAssessment.id).label("assessment_count"))
        .join(Taxref, Taxref.cd_nom == TPriorityTaxon.cd_nom)
        .outerjoin(TAssessment, TAssessment.id_priority_taxon == TPriorityTaxon.id)
        .outerjoin(TTerritory, TTerritory.id_territory == TPriorityTaxon.id_territory)
    )

    if territory:
        query = query.where(func.lower(TTerritory.code) == territory.lower())

    if cd_nom:
        query = query.where(TPriorityTaxon.cd_nom == cd_nom)

    if cpi:
        query = query.where(
            or_(
                TPriorityTaxon.revised_conservation_priority == cpi,
                TPriorityTaxon.computed_conservation_priority == cpi,
            )
        )

    if with_assessment:
        query = query.having(func.count(TAssessment.id) > 0)

    if sort:
        try:
            (column, direction) = sort.split(":")

            available_sort = {
                "fullName": [Taxref.nom_complet],
                "cpi": [
                    TPriorityTaxon.revised_conservation_priority,
                    TPriorityTaxon.computed_conservation_priority,
                ],
                "territoryName": [TTerritory.label],
                "dateMin": [TPriorityTaxon.min_prospect_zone_date],
                "dateMax": [TPriorityTaxon.max_prospect_zone_date],
                "areaPresenceCount": [TPriorityTaxon.presence_area_count],
                "assessmentCount": [func.count(TAssessment.id)],
            }
            order_fields = available_sort.get(column, Taxref.nom_valide)
            if direction == "desc":
                desc_fieds = map(desc, order_fields)
                query = query.order_by(*desc_fieds)
            elif direction == "asc":
                query = query.order_by(*order_fields)
            else:
                msg = f"Unknown sort direction '{direction}'. Use only: asc, desc."
                log.error(msg)
                return {"message": msg, "status": "error"}, 400
        except NotImplementedError:
            values = ", ".join(list(available_sort.keys()))
            msg = f"Unknown sort column '{column}'. Use only: {values}."
            log.error(msg)
            return {"message": msg, "status": "error"}, 400

    query = query.group_by(*fields)
    count = DB.session.scalar(select(func.count("*")).select_from(query))
    items = DB.session.execute(query.limit(limit).offset(page * limit)).unique().all()

    # Manage output
    output = {
        "total_count": count,
        "incomplete_results": (limit < count),
        "items": [d._asdict() for d in items],
    }
    return prepare_output(output)


@blueprint.route("/taxons/<int:priority_taxon_id>", methods=["GET"])
@permissions.check_cruved_scope("R", module_code="CONSERVATION_STRATEGY")
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
        Taxref.cd_ref.label("taxon_code"),
        Taxref.nom_complet.label("full_name"),
        Taxref.nom_complet_html.label("display_full_name"),
        Taxref.lb_nom.label("short_name"),
        BibNoms.id_nom.label("taxhub_record_id"),
        TPriorityTaxon.revised_conservation_priority.label("revised_cpi"),
        TPriorityTaxon.computed_conservation_priority.label("computed_cpi"),
        TPriorityTaxon.min_prospect_zone_date.label("date_min"),
        TPriorityTaxon.max_prospect_zone_date.label("date_max"),
        TPriorityTaxon.presence_area_count,
        TTerritory.label.label("territory_name"),
        TTerritory.id_territory.label("territory_id"),
    ]
    query = (
        select(*fields, func.count(TAssessment.id).label("assessment_count"))
        .join(Taxref, Taxref.cd_nom == TPriorityTaxon.cd_nom)
        .outerjoin(BibNoms, BibNoms.cd_nom == Taxref.cd_nom)
        .outerjoin(TAssessment, TAssessment.id_priority_taxon == TPriorityTaxon.id)
        .outerjoin(TTerritory, TTerritory.id_territory == TPriorityTaxon.id_territory)
        .filter(TPriorityTaxon.id == priority_taxon_id)
        .group_by(*fields)
    )

    data = DB.session.execute(query).one()._asdict()

    # Manage medias
    if with_medias:
        query = (
            select(
                TMedias.titre.label("title"),
                TMedias.url,
                TMedias.chemin.label("path"),
                TMedias.auteur.label("author"),
                TMedias.desc_media.label("description"),
                # TMedias.date_media.label("date"),
                TMedias.source,
                TMedias.licence,
                # TODO: get media type value in GN v2.8.0+
            )
            .join(Taxref, Taxref.cd_ref == TMedias.cd_ref)
            .join(TPriorityTaxon, TPriorityTaxon.cd_nom == Taxref.cd_nom)
            .where(TPriorityTaxon.id == priority_taxon_id)
            .where(TMedias.is_public == True)
            .where(TMedias.supprime == False)
        )
        medias = DB.session.execute(query).mappings().all()
        data["medias"] = [dict(media) for media in medias]

    # Manage TaxHub Attributs
    if with_taxhub_attributs:
        query = (
            select(
                CorTaxonAttribut.valeur_attribut.label("content"),
                BibAttributs.nom_attribut.label("code"),
            )
            .join(BibAttributs, BibAttributs.id_attribut == CorTaxonAttribut.id_attribut)
            .join(Taxref, Taxref.cd_ref == CorTaxonAttribut.cd_ref)
            .join(TPriorityTaxon, TPriorityTaxon.cd_nom == Taxref.cd_nom)
            .where(TPriorityTaxon.id == priority_taxon_id)
        )
        attributs = DB.session.execute(query).mappings().all()
        data["attributs"] = {}
        for attribut in attributs:
            data["attributs"][attribut.code] = attribut.content

    # Manage output
    return prepare_output(data)


@blueprint.route("/organisms", methods=["GET"])
@permissions.check_cruved_scope("R", module_code="CONSERVATION_STRATEGY")
@json_resp
def get_organisms():
    """
    Liste tous les organismes partenaires.

    :returns: une liste de dictionnaires contenant les infos des organismes
        partenaires.
    """
    # Get request parameters
    order_by = request.args.get("order-by", "nom_organisme")

    organism_repo = OrganismRepository()
    data = organism_repo.get_all(order_by)

    return prepare_output(data)


@blueprint.route("/assessments", methods=["POST"])
@permissions.check_cruved_scope("C", module_code="CONSERVATION_STRATEGY")
@json_resp
def create_assessment():
    """
    Ajouter une fiche bilan stationnel.

    :returns: un objet réponse contenant un "message" et un "status". Le
        "status" prend la valeur "success" si tout s'est bien passé
        (code HTTP 200) et "error" en cas de problème (code HTTP 500).
    """
    # Transform received data
    data = prepare_input(dict(request.get_json()))
    data["assessment"]["meta_create_by"] = g.current_user.id_role
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
            "status": "error",
        }
        code = 500
    else:
        response = {"message": "Success of adding the assessment.", "status": "success"}
        code = 200
    return response, code


@blueprint.route("/assessments", methods=["GET"])
@permissions.check_cruved_scope("R", module_code="CONSERVATION_STRATEGY")
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
    priority_taxon_id = request.args.get("priority-taxon-id")
    limit = int(request.args.get("limit", 20))
    page = int(request.args.get("page", 0))

    # Find data
    assessment_repo = AssessmentRepository()
    count, items = assessment_repo.get_all(priority_taxon_id, limit, page)

    # Manage output
    output = {
        "total_count": count,
        "incomplete_results": (limit < count),
        "items": items,
    }
    return prepare_output(output)


@blueprint.route("/assessments/<int:assessment_id>", methods=["GET"])
@permissions.check_cruved_scope("R", module_code="CONSERVATION_STRATEGY")
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
@permissions.check_cruved_scope("U", module_code="CONSERVATION_STRATEGY")
@json_resp
def update_assessment(assessment_id):
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
    data["assessment"]["meta_update_by"] = g.current_user.id_role
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
            "status": "error",
        }
        code = 500
    else:
        response = {
            "message": "Success of updating the assessment.",
            "status": "success",
        }
        code = 200
    return response, code


@blueprint.route("/tasks", methods=["GET"])
@permissions.check_cruved_scope("R", module_code="CONSERVATION_STRATEGY")
@json_resp
def get_tasks():

    # Get request parameters
    organisms = (
        request.args.get("organisms").split(",")
        if "organisms" in request.args
        else None
    )
    progress_status = request.args.get("progress-status")
    type = request.args.get("type")
    sort = request.args.get("sort")
    limit = int(request.args.get("limit", 20))
    page = int(request.args.get("page", 0))

    # Execute actions query

    TNomenclaturesT = aliased(TNomenclatures)
    TNomenclaturesP = aliased(TNomenclatures)

    date_action = case(
        [
            (TNomenclaturesP.cd_nomenclature == "pl", TAction.implementation_date),
            (TNomenclaturesP.cd_nomenclature == "c", TAction.starting_date),
        ],
        else_=func.to_date(cast(TAction.plan_for, String), "YYYY"),
    )

    fields_action = [
        TAction.id.label("action_id"),
        TAction.id_assessment.label("assessment_id"),
        Taxref.lb_nom.label("taxon_name"),
        TTerritory.label.label("territory_name"),
        date_action.label("date"),
        literal_column("'action'").label("type"),
        TNomenclaturesT.label_default.label("label"),
        TNomenclaturesP.label_default.label("progress_status"),
        TNomenclaturesP.cd_nomenclature.label("code"),
        TTerritory.code.label("territory_code"),
        TPriorityTaxon.id.label("priority_taxon_id"),
        CorActionOrganism.id_organism.label("organism_id"),
    ]

    query_action = (
        select(*fields_action)
        .outerjoin(TAssessment, TAssessment.id == TAction.id_assessment)
        .outerjoin(TPriorityTaxon, TPriorityTaxon.id == TAssessment.id_priority_taxon)
        .outerjoin(Taxref, Taxref.cd_nom == TPriorityTaxon.cd_nom)
        .outerjoin(TTerritory, TTerritory.id_territory == TPriorityTaxon.id_territory)
        .outerjoin(
            TNomenclaturesT, TNomenclaturesT.id_nomenclature == TAction.id_action_type
        )
        .outerjoin(
            TNomenclaturesP,
            TNomenclaturesP.id_nomenclature == TAction.id_action_progress,
        )
        .outerjoin(CorActionOrganism, CorActionOrganism.id_action == TAction.id)
    )

    # Execute assessments query

    date_assessment = func.to_date(
        cast(TAssessment.next_assessment_year, String), "YYYY"
    )

    fields_assessment = [
        literal_column("NULL").label("action_id"),
        TAssessment.id.label("assessment_id"),
        Taxref.lb_nom.label("taxon_Name"),
        TTerritory.label.label("territory_name"),
        date_assessment.label("date"),
        literal_column("'assessment'").label("type"),
        TNomenclaturesT.label_default.label("label"),
        TNomenclaturesP.label_default.label("progress_status"),
        TNomenclaturesP.cd_nomenclature.label("code"),
        TTerritory.code.label("territory_code"),
        TAssessment.id_priority_taxon.label("priority_taxon_id"),
        CorActionOrganism.id_organism.label("organism_id"),
    ]

    query_assessment = (
        select(*fields_assessment)
        .outerjoin(TPriorityTaxon, TPriorityTaxon.id == TAssessment.id_priority_taxon)
        .outerjoin(Taxref, Taxref.cd_nom == TPriorityTaxon.cd_nom)
        .outerjoin(TTerritory, TTerritory.id_territory == TPriorityTaxon.id_territory)
        .outerjoin(TAction, TAction.id_assessment == TAssessment.id)
        .outerjoin(CorActionOrganism, CorActionOrganism.id_action == TAction.id)
        .outerjoin(
            TNomenclaturesT,
            and_(
                TNomenclaturesT.cd_nomenclature == "rfbs",
                TNomenclaturesT.id_type
                == func.ref_nomenclatures.get_id_nomenclature_type("CS_ACTION"),
            ),
        )
        .outerjoin(
            TNomenclaturesP,
            and_(
                TNomenclaturesP.cd_nomenclature == "pr",
                TNomenclaturesP.id_type
                == func.ref_nomenclatures.get_id_nomenclature_type(
                    "CS_ACTION_PROGRESS"
                ),
            ),
        )
    )

    if progress_status:
        query_action = query_action.filter(
            TNomenclaturesP.cd_nomenclature == progress_status
        )
        query_assessment = query_assessment.filter(
            TNomenclaturesP.cd_nomenclature == progress_status
        )

    if type == "action":
        query = query_action.distinct(TAction.id)
    elif type == "assessment":
        query = query_assessment.distinct(TAssessment.id)
    else:
        union_query = (
            union(query_action, query_assessment).subquery()
        )
        query = select(union_query).distinct()

    if organisms:
        query = query.filter(CorActionOrganism.id_organism.in_(organisms))

    if sort:
        subquery = query.subquery()
        query = select(subquery)  # enable orderby on date
        try:
            (column, direction) = sort.split(":")

            available_sort = {
                "date": ["date"],
                "progressStatus": ["progress_status"],
                "taxonName": ["taxon_name"],
                "type": ["type"],
                "territoryName" : ["territory_name"],
                "label": ["label"],
            }
            order_fields = available_sort.get(column, "date")
            if direction == "desc":
                desc_fields = map(desc, order_fields)
                query = query.order_by(*desc_fields)
            elif direction == "asc":
                query = query.order_by(*order_fields)
            else:
                msg = f"Unknown sort direction '{direction}'. Use only: asc, desc."
                log.error(msg)
                return {"message": msg, "status": "error"}, 400
        except NotImplementedError:
            values = ", ".join(list(available_sort.keys()))
            msg = f"Unknown sort column '{column}'. Use only: {values}."
            log.error(msg)
            return {"message": msg, "status": "error"}, 400

    # for pagination
    count = DB.session.scalar(select(func.count("*")).select_from(query))
    items = DB.session.execute(query.limit(limit).offset(page * limit)).all()

    # Manage output
    output = {
        "total_count": count,
        "incomplete_results": (limit < count),
        "items": [d._asdict() for d in items],
    }
    return prepare_output(output)
