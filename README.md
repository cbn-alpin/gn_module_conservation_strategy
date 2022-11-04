# Module - Stratégie Conservation

Module GeoNature d'aide à la Stratégie de Conservation (CS) du réseau
Flore Sentinelle (projet SCALP), piloté par le CBNA.


## Installation

* Installez GeoNature (https://github.com/PnX-SI/GeoNature) en
version 2.7.5 ou supérieure.
* Téléchargez la dernière version stable du module (``wget https://github.com/cbn-alpin/gn_module_conservation_strategy/archive/X.Y.Z.zip``) dans ``/home/${USER}/``
* Dézippez la dans ``/home/${USER}/`` (``unzip X.Y.Z.zip``)
* Placez-vous dans le répertoire ``backend`` de GeoNature et lancez
les commandes suivantes (le code du module est "CONSERVATION_STRATEGY") :

```
    source venv/bin/activate
    geonature install_gn_module <mon_chemin_absolu_vers_le_module> <code_du_module>
    # Exemple : geonature install_gn_module /home/`whoami`/gn_module_conservation_strategy-X.Y.Z CONSERVATION_STRATEGY
```

* Créer le fichier ``bin/config/settings.ini``
et y stocker le chemin vers le fichier de configuration de GeoNature.
Vous pouvez maintenant (optionel) surcoucher éventuellement un des
paramètres présent dans le fichier ``bin/config/settings.default.ini`` en
le copiant dans ``bin/config/settings.ini`` pour l'y modifier.
* Réaliser les imports nécessaires au fonctionnement du module à l'aide
des scripts présents dans le dossier `bin/` pour :
  * les territoires
  * les taxons prioritaires
* Vous trouverez plus d'informations sur l'importation de données et ces scripts dans [la documentation qui leur est dédiée](docs/import-data.md).
* Complétez la configuration du module dans le fichier ``config/conf_gn_module.toml``
(créé lors de l'installation du module) en surcouchant les valeurs par
défaut présentes dans le fichier ``config/conf_gn_module.sample.toml``:
  * Ensuite, relancez la mise à jour de la configuration du module :
    * Se rendre dans le répertoire ``geonature/backend``
    * Activer le venv (si nécessaire) : ``source venv/bin/activate``
    * Lancer la commande de mise à jour de configuration du module :
      ``geonature update-module-configuration CONSERVATION_STRATEGY``
* Une fois le module installé et configuré, il vous faudra l'activer
avec : `geonature activate-gn-module CONSERVATION_STRATEGY`
* Vous pouvez sortir du venv en lançant la commande ``deactivate``

### Interaction avec TaxHub

Le module Stratégie Conservation utilise les informations stokées dans les
attributes "Description", "Commentaires" du thème Atlas. Il se charge aussi
d'ajouter deux nouveaux attributs à TaxHub sur le thème Atlas :
*Écologie* et *Chorologie texte*.
Enfin, il ajoute aussi son propre thème "Strat. Conservation" qui contient l'attribut
"*Méthode de suivi préconisée*".

## Désinstallation

**⚠️ ATTENTION :** la désinstallation du module implique la suppression de toutes les données associées.
Assurez vous d'avoir fait une sauvegarde de votre base de données au préalable.

Suivez la procédure suivante :
1. Rétrograder la base de données pour y enlever les données spécifiques au module :
    ```bash
    geonature db downgrade conservation_strategy@base
    ```
1. Désinstaller le package du virtual env :
    ```
    pip uninstall gn-module-conservation-strategy
    ```
    - Possibilité de voir le nom du module avec : `pip list`
1. Supprimer la ligne relative au module dans `gn_commons.t_modules`
1. Supprimer le lien symbolique du module dans les dossiers :
    - `geonature/external_modules`
    - `geonature/frontend/src/external_assets/`
1. Mettre à jour le frontend :
    ```bash
    geonature update-configuration --build false && geonature generate-frontend-tsconfig && geonature generate-frontend-tsconfig-app && geonature generate-frontend-modules-route
    ```

## Déploiement sur Flore Sentinelle

### En mode développement
* Se placer dans le dossier du module : `cd ~/workspace/cbna/scalp/gn_module_conservation_strategy`
* Uploader le code (supprimer l'option `--dry-run` si tout est ok) :
`rsync -av --exclude-from ./.rsync-exclude.txt ./ geonatureadmin@<ip-serveur>:~/gn_modules_conservation_strategy/ --dry-run`
  * Le fichier `.rsync-exclude.txt` contient les noms des fichiers et dossiers
    qui seront exclus de la synchronisation.
  * Penser à modifier les chemins du module local et sur le serveur si vos chemins sont différents.
* Lors du premier déploiement suivre les étapes d'installation du module décrites ci-dessus.
* Lors des synchronisations suivante :
  * si la base de données est modifiée, la mettre à jour avec :
    ```bash
    geonature db upgrade conservation_strategy@head
    ```
  * recompiler le module en relançant sa configuration dans le `venv` du
    backend de GeoNature : `geonature update-module-configuration CONSERVATION_STRATEGY`

## Licence

* [Licence OpenSource GPL v3](./LICENSE.txt)
* Copyleft 2021 - Conservatoire Botanique National Alpin

[![Logo CBNA](http://www.cbn-alpin.fr/images/stories/habillage/logo-cbna.jpg)](http://www.cbn-alpin.fr)
