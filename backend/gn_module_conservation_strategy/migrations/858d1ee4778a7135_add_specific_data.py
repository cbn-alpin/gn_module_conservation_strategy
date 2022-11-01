"""Add specific data (nomenclatures, taxonomy list, module infos)

Revision ID: 858d1ee4778a7135
Revises: None
Create Date: 2022-10-29 23:06:31.392946

"""
import importlib
from csv import DictReader

from alembic import op
import sqlalchemy as sa
from sqlalchemy.sql import text

from utils_flask_sqla.migrations.utils import logger
from gn_module_conservation_strategy import MODULE_CODE


revision = "858d1ee4778a7135"
down_revision = None
branch_labels = "conservation_strategy"
depends_on = ("f06cc80cc8ba",)  # GeoNature 2.7.5

"""
Insert CSV file into specified table.
If source columns are specified, CSV file in copied in a temporary table,
then data restricted to specified source columns are copied in final table.
"""


def copy_from_csv(
    f, schema, table, dest_cols="", source_cols=None, header=True, encoding=None, delimiter=None
):
    if dest_cols:
        dest_cols = " (" + ", ".join(dest_cols) + ")"
    if source_cols:
        final_table = table
        final_table_cols = dest_cols
        table = f"import_{table}"
        dest_cols = ""
        field_names = get_csv_field_names(f, encoding=encoding, delimiter=delimiter)
        op.create_table(
            table, *[sa.Column(c, sa.String) for c in map(str.lower, field_names)], schema=schema
        )

    options = ["FORMAT CSV"]
    if header:
        options.append("HEADER")
    if encoding:
        options.append(f"ENCODING '{encoding}'")
    if delimiter:
        options.append(f"DELIMITER E'{delimiter}'")
    options = ", ".join(options)
    cursor = op.get_bind().connection.cursor()
    cursor.copy_expert(
        f"""
        COPY {schema}.{table}{dest_cols}
        FROM STDIN WITH ({options})
    """,
        f,
    )

    if source_cols:
        source_cols = ", ".join(source_cols)
        op.execute(
            f"""
            INSERT INTO {schema}.{final_table}{final_table_cols}
            SELECT {source_cols}
                FROM {schema}.{table};
            """
        )
        op.drop_table(table, schema=schema)


def get_csv_field_names(f, encoding, delimiter):
    if encoding == "WIN1252":  # postgresql encoding
        encoding = "cp1252"  # python encoding
    # t = TextIOWrapper(f, encoding=encoding)
    reader = DictReader(f, delimiter=delimiter)
    field_names = reader.fieldnames
    # t.detach()  # avoid f to be closed on t garbage collection
    f.seek(0)
    return field_names


def upgrade():
    operations = text(
        importlib.resources.read_text("gn_module_conservation_strategy.migrations.data", "data.sql")
    )
    op.get_bind().execute(operations, {"moduleCode": MODULE_CODE})

    with importlib.resources.open_text(
        "gn_module_conservation_strategy.migrations.data", "nomenclatures.csv"
    ) as csvfile:
        logger.info("Inserting Conservation Strategy nomenclatures…")
        copy_from_csv(
            csvfile,
            "ref_nomenclatures",
            "t_nomenclatures",
            dest_cols=(
                "id_type",
                "cd_nomenclature",
                "mnemonique",
                "label_default",
                "definition_default",
                "label_fr",
                "definition_fr",
                "id_broader",
                "hierarchy",
            ),
            source_cols=(
                "ref_nomenclatures.get_id_nomenclature_type(type_nomenclature_code)",
                "cd_nomenclature",
                "mnemonique",
                "label_default",
                "definition_default",
                "label_fr",
                "definition_fr",
                "ref_nomenclatures.get_id_nomenclature(type_nomenclature_code, cd_nomenclature_broader)",
                "hierarchy",
            ),
            header=True,
            encoding="UTF-8",
            delimiter=",",
        )


def downgrade():
    delete_nomenclatures("CS_ACTION_GEO_LEVEL")
    delete_nomenclatures("CS_ACTION")
    delete_nomenclatures("CS_ACTION_PROGRESS")

    delete_taxhub_attribute("atlas_ecology")
    delete_taxhub_attribute("atlas_chorology_description")
    delete_taxhub_attribute_theme("Strat. Conservation")
    delete_module(MODULE_CODE)


def delete_nomenclatures(mnemonique):
    operation = text(
        """
            DELETE FROM ref_nomenclatures.t_nomenclatures
            WHERE id_type = (
                SELECT id_type
                FROM ref_nomenclatures.bib_nomenclatures_types
                WHERE mnemonique = :mnemonique
            );
            DELETE FROM ref_nomenclatures.bib_nomenclatures_types
            WHERE mnemonique = :mnemonique
        """
    )
    op.get_bind().execute(operation, {"mnemonique": mnemonique})


def delete_taxhub_attribute_theme(theme_name):
    operation = text(
        """
            -- Delete TaxHub attributs theme
            WITH attributs_deleted AS (
                DELETE FROM taxonomie.bib_attributs WHERE id_theme IN (
                    SELECT id_theme FROM taxonomie.bib_themes
                    WHERE nom_theme = :themeName
                )
                RETURNING id_attribut
            )
            DELETE FROM taxonomie.cor_taxon_attribut WHERE id_attribut IN (
                SELECT id_attribut FROM attributs_deleted
            );

            DELETE FROM taxonomie.bib_themes WHERE nom_theme = :themeName ;
        """
    )
    op.get_bind().execute(operation, {"themeName": theme_name})


def delete_taxhub_attribute(attribut_name):
    operation = text(
        """
            -- Delete TaxHub attribut
            DELETE FROM taxonomie.cor_taxon_attribut WHERE id_attribut = (
                SELECT id_attribut
                FROM taxonomie.bib_attributs
                WHERE nom_attribut = :attributName
            );

            DELETE FROM taxonomie.bib_attributs WHERE nom_attribut = :attributName ;
        """
    )
    op.get_bind().execute(operation, {"attributName": attribut_name})


def delete_module(module_code):
    operation = text(
        """
            -- Unlink module from dataset
            DELETE FROM gn_commons.cor_module_dataset
                WHERE id_module = (
                    SELECT id_module
                    FROM gn_commons.t_modules
                    WHERE module_code = :moduleCode
                ) ;

            -- Uninstall module (unlink this module of GeoNature)
            DELETE FROM gn_commons.t_modules
                WHERE module_code = :moduleCode ;
        """
    )
    op.get_bind().execute(operation, {"moduleCode": module_code})
