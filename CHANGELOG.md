# CHANGELOG

## v0.1.0 (unreleased)

Première version stable du module compatible avec GeoNature version 2.4.1.

**Fonctionnalités**
* Ajout d'un fil d'ariane à l'interface via le composant `<breadcrumbs>`
* Affichage du titre (config) et de la liste des territoires (webservice) sur l'interface.
* Suppression de nombreux fichiers semblant inutiles dans le dossier `frontend/`
* Restructuration du contenu du dossier `frontend/` pour le rendre fonctionnel
* Ajout du web service `GET /territories`.
* Rédaction d'une première version du fichier `README.md`.
* Ajout du script Bash de désinstallation du module (`uninstall.sh`)
* Ajout du script Bash d'installation de la base de données (`install_db.sh`) 
* Ajout d'une librairie `bin/utils.sh` permettant d'améliorer l'écriture des scripts Bash.
* Ajout d'un dossier `bin/` contenant tous les scripts Bash du module.
* Ajout du script SQL de désinstallation de la base de données du module (`data/uninstall.sql`).
* Ajout du script SQL d'insertion des données par défaut du module (`data/install_default_data.sql`).
* Ajout du script SQL de création de la base de données du module (`data/install_schema.sql`).
* Création auto des fichiers de config (`settings.ini` et `conf_gn_module.toml`) 
lors de l'installation du module si nécessaire (`install_gn_module.py`). Le chemin absolu vers GeoNature
est automatiquement renseigné dans `settings.ini`.
* Définition des paramètres de config essentiel du module (`/config/conf_schema_toml.py`)
* Fusion dans `/.gitignore` des lignes de `/frontend/.gitignore`.
* Ajout dans `.gitignore` des fichier de config spécifique à une installation du module.
* Suppression du fichier `/frontend/.editorconfig` car le fichier `/.editorconfig` est suffisant.
* Ajout d'un fichier `.editorconfig` permettant de garder une syntaxe plus cohérente.
* Ajout du fichier `CHANGELOG.md` contenant l'historique des changements de code.
* Ajout de la licence GNU GPL V3 dans [LICENCE.txt](LICENCE.txt)
* Création du code de base à partir du template de module GeoNature.
