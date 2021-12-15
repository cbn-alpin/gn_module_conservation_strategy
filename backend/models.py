from flask import current_app
from sqlalchemy import ForeignKey, func
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import synonym
from uuid import uuid4

from utils_flask_sqla.serializers import serializable
from pypnnomenclature.models import TNomenclatures

from geonature.utils.env import DB
from geonature.core.ref_geo.models import LAreas


# TODO: replace by apptax dependency in GeoNature 2.8.0+
class BibAttributs(DB.Model):
    __tablename__ = "bib_attributs"
    __table_args__ = {"schema": "taxonomie"}
    id_attribut = DB.Column(DB.Integer, nullable=False, primary_key=True)
    nom_attribut = DB.Column(DB.Unicode(255), nullable=False)
    label_attribut = DB.Column(DB.Unicode(50), nullable=False)
    liste_valeur_attribut = DB.Column(DB.Unicode, nullable=False)
    obligatoire = DB.Column(DB.Boolean, default=False, nullable=False)
    desc_attribut = DB.Column(DB.Unicode)
    type_attribut = DB.Column(DB.Unicode(50))
    type_widget = DB.Column(DB.Unicode(50))
    ordre = DB.Column(DB.Integer)

    def __repr__(self):
        return "<CorTaxonAttribut %r>" % self.valeur_attribut

# TODO: replace by apptax dependency in GeoNature 2.8.0+
@serializable
class BibNoms(DB.Model):
    __tablename__ = "bib_noms"
    __table_args__ = {
        "schema": "taxonomie",
        "extend_existing": True,
    }
    id = DB.Column("id_nom", DB.Integer, primary_key=True)
    taxon_name_code = DB.Column("cd_nom", DB.Integer, ForeignKey("taxonomie.taxref.cd_nom"), nullable=True)
    taxon_ref_code = DB.Column("cd_ref", DB.Integer)
    vernacular_name = DB.Column("nom_francais", DB.Unicode)
    comments = DB.Column(DB.Unicode)

    taxref = DB.relationship("Taxref", lazy="select")
    # attributs = DB.relationship("CorTaxonAttribut", lazy="select")
    # lists = DB.relationship("CorNomListe", lazy="select")
    #medias = DB.relationship("cs.backend.models.TMedias", lazy="select")


# TODO: replace by apptax dependency in GeoNature 2.8.0+
class TMedias(DB.Model):
    __tablename__ = "t_medias"
    __table_args__ = {"schema": "taxonomie"}
    id_media = DB.Column(DB.Integer, nullable=False, primary_key=True)
    cd_ref = DB.Column(DB.Integer)
    titre = DB.Column(DB.Unicode(255))
    url = DB.Column(DB.Unicode(255))
    chemin = DB.Column(DB.Unicode(255))
    auteur = DB.Column(DB.Unicode(1000))
    #date_media = DB.Column(DB.DateTime)
    desc_media = DB.Column(DB.Unicode)
    is_public = DB.Column(DB.Boolean, default=True, nullable=False)
    supprime = DB.Column(DB.Boolean, default=False, nullable=False)
    id_type = DB.Column(DB.Integer, nullable=False)
    source = DB.Column(DB.Unicode(25))
    licence = DB.Column(DB.Unicode(100))

    def __repr__(self):
        return "<TMedias %r>" % self.titre


# TODO: replace by usershub dependency in GeoNature 2.8.0+
@serializable
class BibOrganisms(DB.Model):
    __tablename__ = "bib_organismes"
    __table_args__ = {
        "schema": "utilisateurs",
        "extend_existing": True,
    }
    id = DB.Column("id_organisme", DB.Integer, primary_key=True)
    uuid = DB.Column("uuid_organisme", UUID(as_uuid=True), unique=True, nullable=False, default=uuid4)
    name = DB.Column("nom_organisme", DB.Unicode(100))
    logo_url = DB.Column("url_logo", DB.Unicode(255))

    def __repr__(self):
        return "<BibOrganisms %r>" % self.name

# TODO: replace by usershub dependency in GeoNature 2.8.0+
@serializable
class TRoles(DB.Model):
    __tablename__ = "t_roles"
    __table_args__ = {
        "schema": "utilisateurs",
        "extend_existing": True,
    }
    id = DB.Column("id_role", DB.Integer, primary_key=True)
    uuid = DB.Column("uuid_role", UUID(as_uuid=True), unique=True, nullable=False, default=uuid4)
    firstname = DB.Column("prenom_role", DB.Unicode(50))
    lastname = DB.Column("nom_role", DB.Unicode(50))
    email = DB.Column("email", DB.Unicode(250))

    def get_full_name(self):
        """
        Methode qui concatène le nom et prénom du role
        retourne un nom complet
        """
        if self.firstname == None:
            full_name = self.lastname
        else:
            full_name = self.firstname + " " + self.lastname
        return full_name

    def __repr__(self):
        return f"<TRoles {self.get_full_name()}>"

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
            onupdate="CASCADE",
        ),
    )
    id_parent = DB.Column(
        DB.Integer,
        DB.ForeignKey(
            "pr_conservation_strategy.t_territory.id_territory",
            ondelete="CASCADE",
            onupdate="CASCADE",
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
class CorTerritoryTaxon(DB.Model):
    __tablename__ = "cor_territory_taxon"
    __table_args__ = {"schema": "pr_conservation_strategy"}
    id_territory = DB.Column(
        DB.Integer,
        DB.ForeignKey(
            "pr_conservation_strategy.t_territory.id_territory",
            ondelete="CASCADE",
            onupdate="CASCADE",
        ),
        primary_key=True,
    )
    cd_nom = DB.Column(
        DB.Integer,
        DB.ForeignKey(
            "taxonomie.taxref.cd_nom",
            ondelete="NULL",
            onupdate="CASCADE",
        ),
        primary_key=True,
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
    organism = DB.relationship(
        "BibOrganisms"
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
            onupdate="CASCADE",
        ),
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
            onupdate="CASCADE",
        ),
    )
    id_action_type = DB.Column(
        DB.Integer,
        DB.ForeignKey(
            "ref_nomenclatures.t_nomenclatures.id_nomenclature",
            ondelete="NULL",
            onupdate="CASCADE",
        ),
    )
    id_action_progress = DB.Column(
        DB.Integer,
        DB.ForeignKey(
            "ref_nomenclatures.t_nomenclatures.id_nomenclature",
            ondelete="NULL",
            onupdate="CASCADE",
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
        uselist=True,
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
    taxon_name_code = DB.Column(
        "cd_nom",
        DB.Integer,
        DB.ForeignKey(
            "taxonomie.taxref.cd_nom",
            ondelete="NULL",
            onupdate="CASCADE",
        ),
    )
    id_territory = DB.Column(
        DB.Integer,
        DB.ForeignKey(
            "pr_conservation_strategy.t_territory.id_territory",
            ondelete="CASCADE",
            onupdate="CASCADE",
        ),
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
            onupdate="CASCADE",
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
            onupdate="CASCADE",
        )
    )
    # Relationships
    territory = DB.relationship(
        "TTerritory",
    )
    actions = DB.relationship(
        "TAction",
        uselist=True,
        lazy="joined",
    )
    create_by = DB.relationship(
        "TRoles",
        foreign_keys=[meta_create_by],
    )
    update_by = DB.relationship(
        "TRoles",
        foreign_keys=[meta_update_by],
    )
