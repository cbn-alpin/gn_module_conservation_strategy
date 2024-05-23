"""declare available perms

Revision ID: ea9abb70965f
Revises: bf92b357ee67b921
Create Date: 2024-05-21 14:54:16.712052

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'ea9abb70965f'
down_revision = 'bf92b357ee67b921'
branch_labels = None
depends_on = None


def upgrade():
    op.execute(
        """
        INSERT INTO
            gn_permissions.t_permissions_available (
                id_module,
                id_object,
                id_action,
                label,
                scope_filter
            )
        SELECT
            m.id_module,
            o.id_object,
            a.id_action,
            v.label,
            v.scope_filter
        FROM
            (
                VALUES
                    ('CONSERVATION_STRATEGY', 'ALL', 'C', True, 'Ajouter des données au module CONSERVATION_STRATEGY'),
                    ('CONSERVATION_STRATEGY', 'ALL', 'R', True, 'Voir les données du module CONSERVATION_STRATEGY'),
                    ('CONSERVATION_STRATEGY', 'ALL', 'U', True, 'Modifier les données du module CONSERVATION_STRATEGY'),
                    ('CONSERVATION_STRATEGY', 'ALL', 'E', True, 'Exporter les données du module CONSERVATION_STRATEGY'),
                    ('CONSERVATION_STRATEGY', 'ALL', 'D', True, 'Supprimer les données du module CONSERVATION_STRATEGY')
            ) AS v (module_code, object_code, action_code, scope_filter, label)
        JOIN
            gn_commons.t_modules m ON m.module_code = v.module_code
        JOIN
            gn_permissions.t_objects o ON o.code_object = v.object_code
        JOIN
            gn_permissions.bib_actions a ON a.code_action = v.action_code
        """
    )
    op.execute(
        """
        WITH bad_permissions AS (
            SELECT
                p.id_permission
            FROM
                gn_permissions.t_permissions p
            JOIN gn_commons.t_modules m
                    USING (id_module)
            WHERE
                m.module_code = 'CONSERVATION_STRATEGY'
            EXCEPT
            SELECT
                p.id_permission
            FROM
                gn_permissions.t_permissions p
            JOIN gn_permissions.t_permissions_available pa ON
                (p.id_module = pa.id_module
                    AND p.id_object = pa.id_object
                    AND p.id_action = pa.id_action)
        )
        DELETE
        FROM
            gn_permissions.t_permissions p
                USING bad_permissions bp
        WHERE
            bp.id_permission = p.id_permission;
        """
    )


def downgrade():
    op.execute(
        """
        DELETE FROM
            gn_permissions.t_permissions_available pa
        USING
            gn_commons.t_modules m
        WHERE
            pa.id_module = m.id_module
            AND
            module_code = 'CONSERVATION_STRATEGY'
        """
    )
