# Module - Stratégie Conservation

Module GeoNature d'aide à la Stratégie de Conservation (CS) du réseau 
Flore Sentinelle (projet SCALP), piloté par le CBNA.


## Installation

* Installez GeoNature (https://github.com/PnX-SI/GeoNature) en 
version 2.4.1 ou supérieure.
* Téléchargez la dernière version stable du module (``wget https://github.com/cbn-alpin/gn_module_conservation_strategy/archive/X.Y.Z.zip``) dans ``/home/${USER}/``
* Dézippez la dans ``/home/${USER}/`` (``unzip X.Y.Z.zip``)
* Placez-vous dans le répertoire ``backend`` de GeoNature et lancez 
les commandes suivantes (le nom du module abrégé en "cs" est utilisé 
comme code) :

```
    source venv/bin/activate
    geonature install_gn_module <mon_chemin_absolu_vers_le_module> <url_relative_du_module>
    # Exemple geonature install_gn_module /home/`whoami`/gn_module_conservation_strategy-X.Y.Z /cs)
```

* L'installation du module doit créer le fichier ``config/settings.ini`` 
et y stocker le chemin vers le fichier de configuration de GeoNature. 
Vous pouvez maintenant (optionel) surcoucher éventuellement un des 
paramètres présent dans le fichier ``config/settings.default.ini`` en 
le copiant dans ``config/settings.ini`` pour l'y modifier.
* Complétez la configuration du module dans le fichier ``config/conf_gn_module.toml`` 
(créé lors de l'installation du module) en surcouchant les valeurs par 
défaut présentes dans le fichier ``config/conf_gn_module.sample.toml``:
  * Ensuite, relancez la mise à jour de la configuration de GeoNature :
    * Se rendre dans le répertoire ``geonature/backend``
    * Activer le venv (si nécessaire) : ``source venv/bin/activate``
    * Lancer la commande de mise à jour de configuration du module 
    (abrégé ici en "cs")  : ``geonature update_module_configuration cs``
* Une fois le module installé et configuré, il vous faudra l'activer 
avec : `geonature activate_gn_module cs`
* Vous pouvez sortir du venv en lançant la commande ``deactivate``


## Désinstallation

* Utiliser le script `bin/uninstall.sh` en vous plaçant dans le dossier 
`bin/` puis en éxecutant : `./uninstall.sh`
* Cette action va supprimer :
  * dans la base de données toutes les données et structures en lien avec ce module.
  * supprimer le lien symbolique dans le dossier `external_modules` de GeoNature.
  * mettre à jour les fichiers de configuration du frontend de GeoNature 
(surtout utile pour le déveoloppement).
* En "production", vous devrez ensuite appliquer les changements à l'interface
en la reconstruisant. Pour se faire, lancez les commandes suivantes : 
  * se placer dans le répertoire ``backend`` : `cd ~/geonature/backend/`
  * charger le *venv* : `source venv/bin/activate`
  * recontruire l'interface (*frontend*) : `geonature frontend_build`


## Licence

* [Licence OpenSource GPL v3](./LICENSE.txt)
* Copyleft 2021 - Conservatoire Botanique National Alpin

[![Logo CBNA](http://www.cbn-alpin.fr/images/stories/habillage/logo-cbna.jpg)](http://www.cbn-alpin.fr)
