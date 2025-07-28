# Atelier 1 : Bash & Python

Ce projet est un atelier pratique combinant des scripts Bash et Python pour la gestion, l’analyse et le reporting de données. Il est organisé pour faciliter la sauvegarde, l’analyse et la génération de rapports quotidiens sur des jeux de données.

## Structure du projet

```
backup_project/
├── config.txt                # Fichier de configuration
├── sujet_tp_data_1.md        # Sujet du TP
├── data/
│   ├── backup/               # Sauvegardes des données
│   ├── reports/              # Rapports générés
│   └── work/                 # Données de travail
├── logs/                     # Logs d'exécution
├── scripts/
│   ├── analyze.py            # Script d'analyse des données
│   ├── backup.sh             # Script de sauvegarde Bash
│   ├── daily_report.py       # Génération de rapport quotidien
│   ├── install.sh            # Installation des dépendances
│   └── watch.sh              # Surveillance des fichiers
├── tests/
│   ├── test_install.csv      # Fichiers de test
│   └── test_install.txt      # Fichiers de test
```

## Scripts principaux

- **backup.sh** : Sauvegarde les données du dossier `data/work` vers `data/backup`.
- **analyze.py** : Analyse les données présentes dans le dossier `data/work`.
- **daily_report.py** : Génère un rapport quotidien à partir des données analysées.
- **install.sh** : Installe les dépendances nécessaires au projet.
- **watch.sh** : Surveille les modifications dans les fichiers de données.

## Utilisation

1. **Installation des dépendances**
   ```bash
   bash scripts/install.sh
   ```
2. **Sauvegarde des données**
   ```bash
   bash scripts/backup.sh
   ```
3. **Analyse des données**
   ```bash
   python scripts/analyze.py
   ```
4. **Génération du rapport quotidien**
   ```bash
   python scripts/daily_report.py
   ```
5. **Surveillance des fichiers**
   ```bash
   bash scripts/watch.sh
   ```

## Tests

Des fichiers de test sont disponibles dans le dossier `tests/` pour valider l’installation et le bon fonctionnement des scripts.

## Auteur

- Atelier réalisé le 28 juillet 2025.

---
N’hésite pas à consulter le fichier `sujet_tp_data_1.md` pour plus de détails sur le sujet du TP.