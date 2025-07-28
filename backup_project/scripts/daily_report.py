import os
from datetime import date
import json


def daily_report(file_path):
    if not os.path.exists(file_path):
        print("Dossier de reports non existant")
        return
    # Récupérer la date du jour
    today = str(date.today())[:10]

    # Créer le nom du fichier de rapport
    report_file = os.path.join(file_path, f"daily_report_{today}.html")

    # Si le fichier de rapport n'existe pas, le créer avec en-tête HTML
    if not os.path.exists(report_file):
        with open(report_file, "w", encoding="utf-8") as f:
            f.write(
                f"<html><head><title>Rapport quotidien {today}</title></head><body>\n"
            )
            f.write(f"<h1>Rapport quotidien pour le {today}</h1>\n")
            f.write("<hr>\n")

    # Parcourir les fichiers du dossier
    for file in os.listdir(file_path):
        if file.endswith(f"{today}_csv.json") or file.endswith(f"{today}_txt.json"):
            json_file_path = os.path.join(file_path, file)
            try:
                with open(json_file_path, "r", encoding="utf-8") as f:
                    content = json.load(f)
            except Exception as e:
                content = f"Erreur de lecture du JSON : {e}"
            # Écrire le contenu dans le rapport quotidien (formaté en HTML)
            with open(report_file, "a", encoding="utf-8") as report:
                report.write(f"<h2>Contenu de {file} :</h2>\n")
                report.write(
                    f"<pre>{json.dumps(content, indent=2, ensure_ascii=False)}</pre>\n"
                )
                report.write("<br>\n")

    # Terminer le fichier HTML
    with open(report_file, "a", encoding="utf-8") as f:
        f.write("</body></html>\n")

    print(f"{os.path.basename(report_file)}: OK")


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Usage: python daily_report.py <dossier>")
    else:
        daily_report(sys.argv[1])
