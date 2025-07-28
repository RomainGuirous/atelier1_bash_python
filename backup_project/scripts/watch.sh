#!/bin/bash

while true; do

    if [ ! -d "$HOME/backup_project/data/work" ]; then
        echo "Le répertoire de travail n'existe pas. Création du répertoire..."
        mkdir -p "$HOME/backup_project/data/work"
    fi

    if [ "$(find "$HOME/backup_project/data/work/" -type f)" ]; then
        echo "Exécution du script de sauvegarde..."
        # Exécute le script de sauvegarde
        bash "$HOME/backup_project/scripts/backup.sh"
    else
        echo "Aucun fichier à sauvegarder dans le répertoire work."
    fi
    # Attend 30 secondes avant la prochaine exécution
    sleep 30
done