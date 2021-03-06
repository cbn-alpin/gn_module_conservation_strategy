import os, subprocess, fileinput, sys, re
from shutil import copy

from pathlib import Path
from geonature.utils.env import ROOT_DIR

MODULE_ROOT_DIR = Path(__file__).absolute().parent

def gnmodule_install_app(gn_db, gn_app):
    '''
        Fonction principale permettant de réaliser les opérations d'installation du module :
            - Base de données
            - Module (pour le moment rien)
    '''
    with gn_app.app_context():
        store_geonature_settings_ini_path()
        create_module_toml_config_file_from_sample()
        subprocess.call(['./bin/install_db.sh'], cwd=str(MODULE_ROOT_DIR))

def store_geonature_settings_ini_path():
    settingFile = str(MODULE_ROOT_DIR) + '/config/settings.ini'

    if not os.path.exists(settingFile):
        sampleSettingFile = str(MODULE_ROOT_DIR) + '/config/settings.sample.ini'
        copy(sampleSettingFile, settingFile)

    replacement = 'geonature_settings_path="' + str(ROOT_DIR) + '/config/settings.ini"\n'
    searchExp = re.compile(r'^\s*geonature_settings_path\s*=\s*"?([^"#$]+)"?\s*$')
    with fileinput.input(files=(settingFile), inplace=True) as f:
        for line in f:
            line = searchExp.sub(replacement, line)
            sys.stdout.write(line)

def create_module_toml_config_file_from_sample():
    confFile = str(MODULE_ROOT_DIR) + '/config/conf_gn_module.toml'
    if not os.path.exists(confFile):
        sampleConfFile = str(MODULE_ROOT_DIR) + '/config/conf_gn_module.sample.toml'
        copy(sampleConfFile, confFile)
