"""Create module schema

Revision ID: bf92b357ee67b921
Revises: 858d1ee4778a7135
Create Date: 2022-10-30 01:01:59.810801

"""
import importlib

from alembic import op
from sqlalchemy.sql import text

from geonature.core.gn_commons.models import TParameters

# revision identifiers, used by Alembic.
revision = "bf92b357ee67b921"
down_revision = "858d1ee4778a7135" # add specific data
branch_labels = None
depends_on = None


def upgrade():
    operations = text(
        importlib.resources.read_text(
            "gn_module_conservation_strategy.migrations.data", "schema.sql"
        )
    )
    op.get_bind().execute(operations)


def downgrade():
    op.execute("DROP SCHEMA pr_conservation_strategy CASCADE")
