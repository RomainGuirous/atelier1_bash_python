import os
import json
import csv
from collections import Counter
from html import escape
import datetime


def analyze_file(file_path, output_dir):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    file_name = os.path.basename(file_path)
    date_str = str(datetime.datetime.now())[:10]

    stats = {
        "file_name": file_name,
        "lines": 0,
        "most_frequent_words": [],
    }

    word_counter = Counter()

    try:
        with open(file_path, "r", encoding="utf-8") as f:
            if file_path.endswith(".csv"):
                stats["columns"] = 0  # ajoute une clé spécifique pour CSV
                reader = csv.reader(f)
                for row in reader:
                    stats["lines"] += 1
                    stats["columns"] = max(stats["columns"], len(row))
                    word_counter.update(row)
                stats["most_frequent_words"] = [
                    {"word": word, "count": nb}
                    for (word, nb) in word_counter.most_common(5)
                ]

                # Write JSON report for CSV
                json_path = os.path.join(output_dir, f"{file_name}_{date_str}_csv.json")
                with open(json_path, "w", encoding="utf-8") as json_file:
                    json.dump(stats, json_file, indent=4)
                html_path = os.path.join(output_dir, f"{file_name}_{date_str}_csv.html")

            else:
                stats["words"] = 0  # Add specific key for TXT
                for line in f:
                    stats["lines"] += 1
                    words = line.split()
                    stats["words"] += len(words)
                    word_counter.update(words)
                stats["most_frequent_words"] = [
                    {"word": word, "count": nb}
                    for (word, nb) in word_counter.most_common(5)
                ]

                # Write JSON report for TXT
                json_path = os.path.join(output_dir, f"{file_name}_{date_str}_txt.json")
                with open(json_path, "w", encoding="utf-8") as json_file:
                    json.dump(stats, json_file, indent=4)
                html_path = os.path.join(output_dir, f"{file_name}_{date_str}_txt.html")

        # Write HTML report (common for both types)
        with open(html_path, "w", encoding="utf-8") as html_file:
            html_file.write(
                "<html><head><title>Rapport d'analyse</title></head><body>\n"
            )
            html_file.write(f"<h1>Rapport pour {escape(file_name)}</h1>\n")
            html_file.write(f"<p>Nombre de lignes : {stats['lines']}</p>\n")
            if "columns" in stats:
                html_file.write(f"<p>Nombre de colonnes : {stats['columns']}</p>\n")
            if "words" in stats:
                html_file.write(f"<p>Nombre de mots : {stats['words']}</p>\n")
            html_file.write("<p>Mots les plus fréquents :<ul>\n")
            for item in stats["most_frequent_words"]:
                html_file.write(f"<li>{escape(item['word'])} ({item['count']})</li>\n")
            html_file.write("</ul></p>\n")
            html_file.write("</body></html>\n")

        print(f"OK : {file_name}")

    except Exception as e:
        print(f"Erreur lors de l'analyse de {file_name} : {e}")


if __name__ == "__main__":
    import sys

    # si lors de l'exécution du script, il n'y a pas exactement deux arguments (le chemin du fichier et le répertoire de sortie)
    if len(sys.argv) != 3:
        print("Usage: python analyze.py <file_path> <output_dir>")
    else:
        # sys.argv[1] est le premier argument, sys.argv[2] est le deuxième argument
        # sys.argv[0] est le nom du script (ici 'analyze.py')
        analyze_file(sys.argv[1], sys.argv[2])
