import setuptools
from pathlib import Path


root_dir = Path(__file__).absolute().parent
with (root_dir / "VERSION").open() as f:
    version = f.read()
with (root_dir / "README.md").open() as f:
    long_description = f.read()

setuptools.setup(
    name="gn_module_conservation_strategy",
    version=version,
    description="Module Conservation Stratégie",
    long_description=long_description,
    long_description_content_type="text/x-rst",
    maintainer="Conservatoire Botanique National Alpin",
    maintainer_email="geonature@cbn-alpin.fr",
    url="https://github.com/cbn-alpin/gn_module_conservation_strategy",
    packages=setuptools.find_packages("backend"),
    package_dir={"": "backend"},
    package_data={"gn_module_conservation_strategy.migrations": ["data/*.sql"]},
    entry_points={
        "gn_module": [
            "code = gn_module_conservation_strategy:MODULE_CODE",
            "picto = gn_module_conservation_strategy:MODULE_PICTO",
            "blueprint = gn_module_conservation_strategy.blueprint:blueprint",
            "config_schema = gn_module_conservation_strategy.conf_schema_toml:GnModuleSchemaConf",
            "migrations = gn_module_conservation_strategy:migrations",
        ],
    },
    classifiers=[
        "Development Status :: 1 - Planning",
        "Intended Audience :: Developers",
        "Natural Language :: English",
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: GNU Affero General Public License v3"
        "Operating System :: OS Independent",
    ],
)
