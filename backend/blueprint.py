from flask import Blueprint, current_app, session

from geonature.core.gn_permissions import decorators as permissions
from geonature.core.gn_permissions.tools import get_or_fetch_user_cruved
from geonature.utils.env import DB
from geonature.utils.utilssqlalchemy import json_resp

from .models import TTerritory

blueprint = Blueprint('pr_conservation_strategy', __name__)


# Exemple d'une route simple
@blueprint.route('/territories', methods=['GET'])
#@permissions.check_cruved_scope('R', module_code="CONSERVATION_STRATEGY")
@json_resp
def get_view():
    q = DB.session.query(TTerritory)
    data = q.all()
    return [d.as_dict() for d in data]
