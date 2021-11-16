# Importer des données dans le module Stratégie Conservation

Plusieurs scripts sont disponibles pour importer les données manipulées 
dans le module CS. Les données sources à importer doivent être fourni au 
format CSV (encodage UTF-8) ou Shape en fonction du type de données
 suivantes :
 - territoire (`import_territory.sh`) *territory* : CSV
 - taxons prioritaires (`import_taxa.sh`) *taxa* : CSV

Chacun de ces scripts est disponibles dans le dossier `bin/`.

Avant de lancer les scripts, il est nécessaires de correctement les paramètrer.
Par défaut, les paramètres sont définis dans le fichier `config/settings.default.ini`.
Vous pouvez les surcharger dans votre fichier `config/settings.ini`.

Les paramètres de chaque type de données à importer sont préfixés avec le
même terme. 
Ces paramètres permettent entre autre d'indiquer :
 - le chemin et le nom vers le fichier source (CSV ou Shape)
 - le chemin et le nom du fichier de log où les informations affichées 
   durant son execution seront enregistrées


## Format des données
Voici le détail des champs des fichiers CSV ou Shape attendus par défaut :

### Territory (CSV)

Chemin du fichier par défaut : `data/imports/territory.csv`.
Description des colonnes attendues dans le fichier CSV contenant la liste 
des **territoires** :

 - **label** : nom du territoire utilisé pour l'affichage.
 - **code** : code du territoire permettant d'établir le lien avec une 
        entrée de la table `ref_geo.l_areas`, champ `area_code`.
 - **area_type** : code du type de territoire concerné. Les codes sont présents 
        dans la table `ref_geo.bib_areas_types`, champ `type_code`.
 - **code_parent** : code du territoire parent contenant le territoire actuel. 
        Il est nécessaire d'ordonner les entrées de ce fichier pour que le 
        territoire parent soit présent dans une ligne précédente.
 - **surface** : surface en km² du territoire.
 - **meshes_total** : nombre de maille SINP 5km² présentes dans le territoire. 
        La fonction `st_intersects()` de Postgis est utilisé pour liste ces mailles.

### Taxa (CSV)

Description des colonnes attendues dans le fichier CSV contenant la liste 
des **taxons prioritaires** :

 - **territory_code** : code du territoire concerné.
 - **cd_nom** : code du nom retenu du taxon présent dans TaxRef.
 - **presence_meshes_count** : 
 - **small_isolated_population** : 
 - **indigenousness** : 
 - **iucn_cotation** : 
 - **iucn_criteria** : 
 - **rarity** : 
 - **rarity_class** : 
 - **revised_conservation_priority** : indice de priorité de conservation révisé à dire d'expert.
 - **revision_comment** : commentaire indiquant les raisons de la révision à dire d'expert de la priorité du taxon.
 - **revision_date** : date de révision à dire d'expert de la priorité du taxon.


## Options des scripts d'import

Il possèdent tous les options suivantes :
 - `-h` (`--help`) : pour afficher l'aide du script.
 - `-v` (`--verbosity`) : le script devient verbeux est affiche plus de 
    messages concernant le travail qu'il accomplit.
 - `-x` (`--debug`) : le mode débogage de Bash est activé.
 - `-c` (`--config`) : permet d'indiquer le chemin vers un fichier de 
    configuration spécifique. 
    Par défaut, le fichier `config/settings.default.ini` est chargé en premier. 
    Il est ensuite surchargé par le fichier `config/settings.ini` s'il existe.
 - `-d` (`--delete`) : chacun des imports peut être annulé avec cette option. 
    Attention, il faut s'assurer que le script est correctement configuré 
    avec les paramètres correspondant à l'import que vous souhaitez annuler.

## Procédure

Afin que les triggers présents sur les tables soient déclenchés 
dans le bon ordre et que les scripts trouvent bien les données 
de référence dont ils ont besoin, il est obligatoire de lancer 
les scripts dans cet ordre :
 1. territoires : `import_territory.sh`
 2. taxons prioritaires : `import_taxa.sh`

La désinstallation des données importées se fait dans le sens inverse. 

**ATTENTION :** concernant la désinstallation, il s'agit d'une manipulation 
délicate à utiliser principalement sur une base de données de test ou 
lors du développement du module. En production, nous vous conseillons 
fortement d'éviter son utilisation. Si vous y êtes contraint, veuillez 
sauvegarder votre base de données auparavant.

Pour lancer un script, ouvrir un terminal et se placer dans le dossier `bin/` 
du module.
Ex. pour lancer le script des territoires :
 - en importation : `./import_territory.sh`
 - en suppression des imports précédents : `./import_territory.sh -d`
