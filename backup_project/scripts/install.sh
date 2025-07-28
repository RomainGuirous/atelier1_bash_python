#!/bin/bash
# Script d'installation du système de sauvegarde

# Création des dossiers nécessaires

mkdir -p {data/{backup,work,reports},logs,scripts,tests}

# Droits d'exécution sur les scripts

find scripts -type f -name "*.sh" -exec chmod +x {} \;

# Vérification de Python3

#command -v python3: affiche le chemin de l’exécutable si trouvé.
if ! command -v python3 &> /dev/null; then
    echo "Python3 n'est pas installé. Veuillez l'installer avant de continuer."
    exit 1 # terminer le script si Python3 n'est pas trouvé et rendre un code d'erreur
fi

# Génération de fichiers de test

#car > chemin/fichier <<EOL txt EOL: crée un fichier texte avec le contenu entre EOL
#pratique pour multiple lignes
cat > tests/test_install.csv <<EOL
Nom,Âge,Ville
Alice,25,Paris
Bob,30,Lyon
Charlie,35,Marseille
EOL

cat > tests/test_install.txt <<EOL
Ceci est un fichier de test.
Chaque ligne contient du texte simple.
Ce fichier sert à valider le traitement des .txt.
Bonne analyse et bon courage !
EOL

# Affichage des commandes pour démarrer

#cat <<EOM: permet d'afficher un texte multi-lignes dans le terminal
cat <<EOM
Installation terminée !

Pour lancer le script de sauvegarde automatique :
    bash scripts/watch.sh
Pour lancer le script de sauvegarde manuel :
    bash scripts/backup.sh
Pour générer des rapports sur les fichiers .txt ou .csv :
    python3 "$HOME/backup_project/scripts/analyze.py" "<chemin_relatif_fichier>" "$HOME/backup_project/data/reports/"
Pour lancer le rapport quotidien :
    python3 scripts/daily_report.py "$HOME/backup_project/data/reports"

Pour lancer les tests :
    importer les fichiers test du dossier tests dans le dossier data/work
    puis exécuter les scripts précédents pour vérifier le bon fonctionnement.
EOM
