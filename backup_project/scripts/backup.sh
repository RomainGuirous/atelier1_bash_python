#!/bin/bash

log_action() {
    # Ajouter une ligne au fichier de log
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1 - $2 - $3" >> "$HOME/backup_project/logs/backup_$(date +%F).log"
}

copie_horo() {
    if [ ! -d "$HOME/backup_project/data/work" ]; then
        echo "Fichier work non trouvé" >&2
        log_action "ERREUR" "data/work" "Non trouvé"
        return 1
    fi

    find "$HOME/backup_project/data/work/" -type f | while read fichier; do
        # %: supprime ce qui suit (. non compris)
        # ##: garde ce qui suit (. non compris)
        nouveau_nom="$(basename "${fichier%.*}")_$(date +%F).${fichier##*.}"
        #si copie réusise => &&: réussite, sinon => || : echec
        cp "$fichier" "$HOME/backup_project/data/backup/$nouveau_nom" && \
        log_action "COPIE" "$fichier → $nouveau_nom" "OK" || \
        log_action "COPIE" "$fichier → $nouveau_nom" "ERREUR"
    done
}

analyze_file() {
    find "$HOME/backup_project/data/work/" -type f | while read fichier; do
        if [[ ${fichier##*.} == "csv" ||  ${fichier##*.} == "txt" ]]; then
            python3 "$HOME/backup_project/scripts/analyze.py" "$fichier" "$HOME/backup_project/data/reports/" && \
            log_action "ANALYZE" "$fichier" "OK" || \
            log_action "ANALYZE" "$fichier" "ERREUR"
        else
            taille=$(stat -c%s "$fichier")
            log_action "TAILLE" "$fichier" "$taille octets"
        fi
    done
}

archivage() {
    find "$HOME/backup_project/data/backup/" -type f -not -name "*.tar.gz" | \
    # 2> >(grep -v "Removing leading" >&2):
    # 2> redirige les erreurs vers grep pour filtrer les messages de tar
    # grep -v "Removing leading" : supprime les messages de tar qui ne sont pas pertinents
    # >&2 : redirige la sortie de grep vers stderr
    # le tout pour supprimer les messages: tar: Removing leading `/' from member names tar: Removing leading `/' from hard link targets
    # qui signifie que tar a supprimé le slash initial des noms de fichiers
    tar -czf "$HOME/backup_project/data/backup/archive_$(date +%Y-%m).tar.gz" -T - 2> >(grep -v "Removing leading" >&2) && \
    log_action "ARCHIVE" "archive_$(date +%Y-%m).tar.gz" "OK" || \
    log_action "ARCHIVE" "archive_$(date +%Y-%m).tar.gz" "ERREUR"
}

clean_old_archive() {
    find "$HOME/backup_project/data/backup/" -type f -name "*.tar.gz" -mtime +365 -exec rm {} + && \
    log_action "SUPPRESSION" "Archives de plus d'un an" "OK" || \
    log_action "SUPPRESSION" "Archives de plus d'un an" "ERREUR"
}

clean_work() {
    find "$HOME/backup_project/data/work/" -type f -exec rm {} + && \
    log_action "SUPPRESSION" "Fichiers de work supprimés après archivage" "OK" || \
    log_action "SUPPRESSION" "Fichiers de work supprimés après archivage" "ERREUR"
}

# Fonction principale
main() {
    echo "=== Début de la sauvegarde ==="
    copie_horo
    analyze_file  
    if archivage; then
        clean_old_archive
        clean_work
    else
        echo "Archivage échoué, nettoyage annulé."
        log_action "SECURITE" "Nettoyage work annulé" "Archivage échoué"
    fi
    echo "=== Fin de la sauvegarde ==="
}

# Appeler main si le script est exécuté directement
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi