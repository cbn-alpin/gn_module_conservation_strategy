# Changelog
Toutes les modifications notables apportées à ce projet seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
et ce projet adhère à [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Inédit]

## [0.4.1] - 2023-11-03

### Corrections
- Corriger l'affichage des calculs en affichant le message aucune données seulement si nécessaire.
- Modification du webservice de Priority Flora pour y ajouter les calculs dans un attribut distinct.

## [0.4.0] - 2023-04-23

### Fonctionnalités
- Ajout de nouvelles nomenclatures dans les Actions (docs/update_nomenclatures.sql).
- Ajout d'un onglet Planning qui recense toutes les actions à mener vis-à-vis des taxons prioritaires.
- Ajout du fil d'Ariane lorsqu'une fiche Bilan Stationnel ou une Action est sélectionnée.
- Ajout du territoire d'appartenance sur la fiche détaillée du Taxon Prioritaire.
- Ajout d'un onglet Synthèse dans la fiche détaillée du Taxon Prioritaire recensant toutes les données issues du module Bilan Stationnel (via un web service) pour le taxon concerné. Ces données sont synthétisées dans les tableaux 'Synthèse des prospections', 'État des populations' et 'État des habitats' ainsi que dans des encarts pour les calculs automatisés du nombre de stations, de la surface d'aire de présence, du pourcentage de stations menacées ainsi que du pourcentage de stations à habitat favorable. La consultation de ces données peut être filtrée par date et par nombre d'années à prendre en compte.
- Ajout de mises à jours automatiques (triggers insert et update) du calcul de la surface et du nombre de mailles M5 (inpn 5x5km) totales pour chaque territoire.
- Ajout du référencement des régions AURA et PACA dans `t_territory`.

### Changements
- Simplification des routes du module.
- Déplacement du filtre global Territoire vers la liste des taxons prioritaires.
- Renommage des composants en enlevant le préfixe "Cs".
- Formatage de tous les fichiers du frontend avec Prettier.
- Fusion des opérations de migration de la v0.3 à la v0.4 dans un fichier unique.

### Suppressions
- Suppression du bandeau d'acceuil contenant le titre du module et le filtre global Territoire.
- Suppression des références au filtre global Territoire.

### Corrections
Au niveau du champ Action, les nomenclatures suivantes ont été corrigées :
- 'niveau géographique territorial' et pas territoriale
- 'état d'avancement mis en place' et pas mise en place
- 'Action locale' devient 'Niveau local'

## [0.3.0] - 2022-11-16

### Fonctionnalités
- Ajout de nouvelles nomenclatures dans les Actions.
- Ajout d'un fichier d'export pour tester l'API avec Postman.
- Respect du format Keepchangelog.
- Packaging du module.
- Ajout du champ "Date de création" dans le formulaire de création des fiches bilan stationnel.

### Changements
- Renommage de la table cor_territory_taxon en t_priority_taxon.
- Simplification du web service de recherche de taxons.
- Simplification des URL de tous les web services.
- Déplacement des anciens scripts d'installation/désinstallation du module vers le dossier "bin".
- Renommage du code du module en "CONSERVATION_STRATEGY".
- Simplification du fichier "package.json".
- Mise à jour du format des champs contenant des dates dans le schéma du module pour considérer la time zone.

### Corrections
- Plus d'erreur si aucun territoire n'est trouvé.
- La référence à Taxref pour établir les fiches taxons est fonctionnelle.


## [0.2.0] - 2021-12-16

Version intégrant les interfaces de base permettant de saisir une fiche bilan stationnel.

### Fonctionnalités
- Ajout d'une fenêtre modale "Création/Modification d'une fiche bilan stationnel"
permettant d'accéder au formulaire d'édition d'une fiche bilan stationnel.
- Ajout d'un onglet "Fiches bilan stationnel" permettant de consulter les informations
des fiches bilans stationnels préalablement saisies. Des boutons "ajouter une fiche bilan stationnel" et
"Modifier cette fiche bilan stationnel" permettent d'accès à la fenêtre d'édition d'une fiche.
- Ajout d'un onglet "Informations générales" permettant d'afficher les photos
dans un carousel et le contenu de plusieurs attributs provenant de TaxHub.
Des liens directs vers TaxHub sont disponibles.
- Ajout d'une page "Fiche détaillée d'un taxon" permettant d'accéder aux onglets
"Informations générales" et "Fiches bilan stationnel".
- Ajout d'un onglet "Liste des taxons Prioritaires" affichant un tableau
paginé côté serveur et ses filtres de recherche.
- Ajout d'un onglet "Accueil" permettant de décrire le module. Son contenu provient d'un template.
- Ajout de la page "Stratégie Conservation" permettant de sélectionner le territoire
de travail et d'accéder aux onglets "Accueil" et "Liste des taxons Prioritaires".
- Ajout d'un script Bash d'import des taxons prioritaires et sa documentation.
- Ajout d'un script Bash d'import des territoires et sa documentation.

## [0.1.0] - 2021-11-09

Première version stable du module compatible avec GeoNature version 2.4.1.

### Fonctionnalités
- Ajout d'un fil d'ariane à l'interface via le composant `<breadcrumbs>`
- Affichage du titre (config) et de la liste des territoires (webservice) sur l'interface.
- Restructuration du contenu du dossier `frontend/` pour le rendre fonctionnel
- Ajout du web service `GET /territories`.
- Rédaction d'une première version du fichier `README.md`.
- Ajout du script Bash de désinstallation du module (`uninstall.sh`)
- Ajout du script Bash d'installation de la base de données (`install_db.sh`)
- Ajout d'une librairie `bin/utils.sh` permettant d'améliorer l'écriture des scripts Bash.
- Ajout d'un dossier `bin/` contenant tous les scripts Bash du module.
- Ajout du script SQL de désinstallation de la base de données du module (`data/uninstall.sql`).
- Ajout du script SQL d'insertion des données par défaut du module (`data/install_default_data.sql`).
- Ajout du script SQL de création de la base de données du module (`data/install_schema.sql`).
- Création auto des fichiers de config (`settings.ini` et `conf_gn_module.toml`)
lors de l'installation du module si nécessaire (`install_gn_module.py`). Le chemin absolu vers GeoNature
est automatiquement renseigné dans `settings.ini`.
- Définition des paramètres de config essentiel du module (`/config/conf_schema_toml.py`)
- Ajout dans `.gitignore` des fichier de config spécifique à une installation du module.
- Ajout d'un fichier `.editorconfig` permettant de garder une syntaxe plus cohérente.
- Ajout du fichier `CHANGELOG.md` contenant l'historique des changements de code.
- Ajout de la licence GNU GPL V3 dans [LICENCE.txt](LICENCE.txt)
- Création du code de base à partir du template de module GeoNature.


### Changements
- Fusion dans `/.gitignore` des lignes de `/frontend/.gitignore`.


### Suppressions
- Suppression du fichier `/frontend/.editorconfig` car le fichier `/.editorconfig` est suffisant.
- Suppression de nombreux fichiers semblant inutiles dans le dossier `frontend/`
