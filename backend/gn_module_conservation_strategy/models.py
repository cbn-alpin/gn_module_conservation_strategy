from sqlalchemy import ForeignKey, func
from sqlalchemy.dialects.postgresql import JSONB

from utils_flask_sqla.serializers import serializable

from geonature.utils.env import DB


@serializable
class TTerritory(DB.Model):
    __tablename__ = "t_territory"
    __table_args__ = {"schema": "pr_conservation_strategy"}
    id_territory = DB.Column(
        DB.Integer,
        primary_key=True,
    )
    id_area = DB.Column(
        DB.Integer,
        DB.ForeignKey(
            "ref_geo.l_areas.id_area",
            ondelete="NULL",
        ),
    )
    id_parent = DB.Column(
        DB.Integer,
        DB.ForeignKey(
            "pr_conservation_strategy.t_territory.id_territory",
            ondelete="CASCADE",
        ),
    )
    label = DB.Column(
        DB.Unicode(255),
        nullable=False,
    )
    code = DB.Column(
        DB.Unicode(25),
        nullable=False,
    )
    surface = DB.Column(
        DB.Integer,
    )
    meshes_total = DB.Column(
        DB.Integer,
    )


@serializable
class TPriorityTaxon(DB.Model):
    __tablename__ = "t_priority_taxon"
    __table_args__ = {"schema": "pr_conservation_strategy"}
    id = DB.Column(
        "id_priority_taxon",
        DB.Integer,
        primary_key=True,
    )
    id_territory = DB.Column(
        DB.Integer,
        DB.ForeignKey(
            "pr_conservation_strategy.t_territory.id_territory",
            ondelete="CASCADE",
        ),
        nullable=False,
    )
    cd_nom = DB.Column(
        DB.Integer,
        DB.ForeignKey(
            "taxonomie.taxref.cd_nom",
            ondelete="NULL",
        ),
        nullable=False,
    )
    presence_meshes_count = DB.Column(
        DB.Integer,
    )
    small_isolated_population = DB.Column(
        DB.Boolean,
        default=False,
    )
    indigenousness = DB.Column(
        DB.Unicode(3),
    )
    iucn_cotation = DB.Column(
        DB.Unicode(3),
    )
    iucn_criteria = DB.Column(
        DB.Unicode(50),
    )
    rarity = DB.Column(
        DB.Float,
    )
    rarity_class = DB.Column(
        DB.Unicode(2),
    )
    computed_conservation_priority = DB.Column(
        DB.Integer,
    )
    compute_date = DB.Column(
        DB.DateTime,
    )
    revised_conservation_priority = DB.Column(
        DB.Integer,
    )
    revision_date = DB.Column(
        DB.DateTime,
    )
    revision_comment = DB.Column(
        DB.Unicode,
    )
    min_prospect_zone_date = DB.Column(
        DB.DateTime,
    )
    max_prospect_zone_date = DB.Column(
        DB.DateTime,
    )
    presence_area_count = DB.Column(
        DB.Integer,
    )


@serializable
class TAssessment(DB.Model):
    __tablename__ = "t_assessment"
    __table_args__ = {"schema": "pr_conservation_strategy"}
    id = DB.Column(
        "id_assessment",
        DB.Integer,
        primary_key=True,
    )
    id_priority_taxon = DB.Column(
        DB.Integer,
        DB.ForeignKey(
            "pr_conservation_strategy.t_priority_taxon.id_priority_taxon",
            ondelete="CASCADE",
        ),
        nullable=False,
    )
    date_min = DB.Column(
        DB.DateTime,
    )
    date_max = DB.Column(
        DB.DateTime,
    )
    assessment_date = DB.Column(
        DB.DateTime,
        server_default=func.now(),
    )
    threats = DB.Column(
        DB.Unicode,
    )
    description = DB.Column(
        DB.Unicode,
    )
    next_assessment_year = DB.Column(
        DB.Integer,
    )
    computed_data = DB.Column(
        JSONB(),
    )
    meta_create_date = DB.Column(
        DB.DateTime,
        server_default=func.now(),
    )
    meta_create_by = DB.Column(
        DB.Integer,
        DB.ForeignKey(
            "utilisateurs.t_roles.id_role",
            ondelete="NULL",
        ),
    )
    meta_update_date = DB.Column(
        DB.DateTime,
        onupdate=func.now(),
    )
    meta_update_by = DB.Column(
        DB.Integer,
        DB.ForeignKey(
            "utilisateurs.t_roles.id_role",
            ondelete="NULL",
        ),
    )
    # Relationships
    priority_taxon = DB.relationship(
        "TPriorityTaxon",
    )
    actions = DB.relationship(
        "TAction",
        lazy="joined",
        cascade="all,delete-orphan",
        uselist=True,
        back_populates="assessment",
    )
    create_by = DB.relationship(
        "User",
        foreign_keys=[meta_create_by],
    )
    update_by = DB.relationship(
        "User",
        foreign_keys=[meta_update_by],
    )


@serializable
class TAction(DB.Model):
    __tablename__ = "t_action"
    __table_args__ = {"schema": "pr_conservation_strategy"}
    id = DB.Column(
        "id_action",
        DB.Integer,
        primary_key=True,
    )
    id_assessment = DB.Column(
        DB.Integer,
        DB.ForeignKey(
            "pr_conservation_strategy.t_assessment.id_assessment",
            ondelete="CASCADE",
        ),
        nullable=False,
    )
    creation_date = DB.Column(
        DB.DateTime,
        server_default=func.now(),
    )
    id_action_level = DB.Column(
        DB.Integer,
        DB.ForeignKey(
            "ref_nomenclatures.t_nomenclatures.id_nomenclature",
            ondelete="NULL",
        ),
    )
    id_action_type = DB.Column(
        DB.Integer,
        DB.ForeignKey(
            "ref_nomenclatures.t_nomenclatures.id_nomenclature",
            ondelete="NULL",
        ),
    )
    id_action_progress = DB.Column(
        DB.Integer,
        DB.ForeignKey(
            "ref_nomenclatures.t_nomenclatures.id_nomenclature",
            ondelete="NULL",
        ),
    )
    plan_for = DB.Column(
        DB.Integer,
    )
    starting_date = DB.Column(
        DB.DateTime,
        server_default=func.now(),
    )
    implementation_date = DB.Column(
        DB.DateTime,
        server_default=func.now(),
    )
    description = DB.Column(
        DB.Unicode,
    )
    # Relationships
    assessment = DB.relationship(
        "TAssessment",
        foreign_keys=[id_assessment],
        back_populates="actions",
    )
    action_level = DB.relationship(
        "TNomenclatures",
        foreign_keys=[id_action_level],
    )
    action_type = DB.relationship(
        "TNomenclatures",
        foreign_keys=[id_action_type],
    )
    action_progress = DB.relationship(
        "TNomenclatures",
        foreign_keys=[id_action_progress],
    )
    partners = DB.relationship(
        "CorActionOrganism",
        cascade="all,delete-orphan",
        uselist=True,
    )


@serializable
class CorActionOrganism(DB.Model):
    __tablename__ = "cor_action_organism"
    __table_args__ = {"schema": "pr_conservation_strategy"}
    id_action = DB.Column(
        DB.Integer,
        ForeignKey("pr_conservation_strategy.t_action.id_action"),
        primary_key=True,
    )
    id_organism = DB.Column(
        DB.Integer,
        ForeignKey("utilisateurs.bib_organismes.id_organisme"),
        primary_key=True,
    )
    # Relationships
    organism = DB.relationship("Organisme")
