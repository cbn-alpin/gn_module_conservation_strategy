from flask import current_app
from sqlalchemy import ForeignKey

from geonature.utils.utilssqlalchemy import serializable
from geonature.utils.env import DB

@serializable
class TTerritory(DB.Model):
    __tablename__ = "t_territory"
    __table_args__ = {"schema": "pr_conservation_strategy"}
    id_territory = DB.Column(
        DB.Integer, 
        primary_key=True,
    )
    id_parent = DB.Column(
        DB.Integer, 
        DB.ForeignKey('id_territory', ondelete='CASCADE', onupdate='CASCADE'),
    )
    label = DB.Column(
        DB.Unicode(255),
        nullable=False,
    )
    meshes_total = DB.Column(
        DB.Integer,
    )
