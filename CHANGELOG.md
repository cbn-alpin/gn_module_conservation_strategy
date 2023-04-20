# CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.0] - 2023-04-23

### Added
- Add new nomenclatures in Actions types (docs/update_nomenclatures.sql).
- Added a Planning tab that lists all the actions to be carried out for priority taxa.
- Add of the breadcrumb when an Assessment or an Action is selected.
- Add the belonging territory on the detailed form of a Priority Taxon.
- Format all frontend documents with Prettier.
- Add of an Overview ('Synthèse') tab in the detailed form of a Priority Taxon summarizing all the data from the Priority Flora module (through a web service) for the taxon concerned. These data are summarized in the tables 'Prospecting overview', 'Population status' and 'Habitat status' as well as in automated calculations of the number of stations, the area of presence, the percentage of threatened stations and the percentage of stations with favorable habitat. The consultation of these data can be filtered by date and by the number of years to be taken into account.
- Add of automatic updates (insert and update triggers) of the calculation of the area and the number of total M5 meshes (inpn 5x5km) for each territory.
- Add references to AURA and PACA regions in `t_territory`.

### Changed
- Simplify module routes.
- Moved the Territory global filter to the Priority taxa list.
- Renaming the components by removing the "Cs" prefix.
- Merging of migration operations from v03 to v04 in an unique file.

### Removed
- Removed the welcome banner containing the title of the module and the global filter Territory.
- Removed the references to the global filter Territory.

### Fixed
In the Action field, the following nomenclatures have been corrected:
- 'niveau géographique territorial',
- 'état d'avancement mis en place',
- 'local action' becomes 'local level'

## [0.3.0] - 2022-11-16

### Added
- Add new nomenclatures in Actions.
- Add an export file to test the API with Postman.
- Packaging of the module.
- Add a "Creation date" field for new assessments.

### Changed
- Respect the Keepchangelog format.
- Rename the "cor_territory_taxon" table to "t_priority_taxon".
- Simplification of the taxon search web service.
- Simplification all web services URLs.
- Moved old module installation/uninstallation scripts to "bin" folder.
- Rename the module code to "CONSERVATION_STRATEGY".
- Simplification of the "package.json" file.
- Update the format of the fields containing dates in the module schema creation to consider the time zone.

### Fixed
- No more error if no territory is found.
- The reference to Taxref is functional.

## [0.2.0] - 2021-12-16

Version integrating the basic interfaces to enter assessments.

### Added
- Add a modal window "Creation/Modification of an assessment" to access the form to edit an assessment.
- Add a tab "Station report sheets" allowing to consult the information
of the assessments previously entered. Buttons "add an assessment" and
  "Modify this assessment" give access to the editing window of a form.
- Add a tab "General information" allowing to display the photos
  in a carousel and the content of several attributes from TaxHub.
  Direct links to TaxHub are available.
- Add a "Taxon detail page" allowing to access the tabs
  "General information" and "Station report" tabs.
- Add a tab "Priority taxon list" displaying a table and its search filters.
- Add a tab "Home" allowing to describe the module. Its content comes from a template.
- Add the "Conservation Strategy" page allowing to select the working territory
  and to access the "Home" and "Priority taxa list" tabs.
- Add a Bash script to import priority taxa and its documentation.
- Add a Bash script to import territories and its documentation.

## [0.1.0] - 2021-11-09

First stable version of the module compatible with GeoNature version 2.4.1.

### Added
- Add a breadcrumb trail to the interface via the `<breadcrumbs>` component
- Display the title (config) and the list of territories (webservice) on the interface.
- Restructure the contents of the `frontend/` folder to make it functional
- Add the web service `GET /territories`.
- Writing a first version of the `README.md` file.
- Add the uninstall Bash script of the module (`uninstall.sh`)
- Add the Bash script to install the database (`install_db.sh`)
- Add a `bin/utils.sh` library to improve the writing of Bash scripts.
- Add a `bin/` folder containing all the Bash scripts of the module.
- Add SQL script to uninstall the module database (`data/uninstall.sql`).
- Add SQL script to insert default data for the module (`data/install_default_data.sql`).
- Add SQL script to create module database (`data/install_schema.sql`).
- Auto creation of config files (`settings.ini` and `conf_gn_module.toml`)
  during module installation if necessary (`install_gn_module.py`). The absolute path to GeoNature
  is automatically filled in `settings.ini`.
- Definition of the essential config parameters of the module (`/config/conf_schema_toml.py`)
- Add in `.gitignore` the config files specific to an installation of the module.
- Add an `.editorconfig` file to keep a more consistent syntax.
- Add `CHANGELOG.md` file containing the history of code changes.
- Add GNU GPL V3 license in [LICENCE.txt](LICENCE.txt)
- Create the base code from the GeoNature module template.

### Changed
- Merge in `/.gitignore` the lines from `/frontend/.gitignore`.

### Removed
- Removed the `/frontend/.editorconfig` file because the `/.editorconfig` file is sufficient.
- Removed many seemingly useless files in the `/frontend/` folder

