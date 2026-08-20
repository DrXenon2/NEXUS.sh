#!/bin/bash

# ==============================================
# SCRIPT : GENERATEUR DE CHAPITRES NEXUS
# DOSSIER : NEXUS L'ÉVEIL DU SUJET ZÉRO
# CHAPITRES : 1 à 320
# ==============================================

# --- 1. Définition du nom du dossier principal ---
NOM_DOSSIER="NEXUS L'ÉVEIL DU SUJET ZÉRO"

# --- 2. Création du dossier principal ---
echo "Création du dossier : $NOM_DOSSIER"
mkdir -p "$NOM_DOSSIER"

# Vérifier si le dossier a bien été créé
if [ ! -d "$NOM_DOSSIER" ]; then
    echo "❌ Erreur : Impossible de créer le dossier."
    exit 1
fi

# --- 3. Boucle de création des 320 chapitres ---
echo "Début de la génération des 320 chapitres..."

for i in $(seq 1 320); do
    # Formatage du numéro de chapitre sur 3 chiffres (ex: 001, 002, ... 320)
    NUM_FORMATE=$(printf "%03d" $i)
    
    # Nom du fichier : Chapitre_001.txt, Chapitre_002.txt, etc.
    NOM_FICHIER="Chapitre_${NUM_FORMATE}.txt"
    
    # Chemin complet du fichier
    CHEMIN_FICHIER="$NOM_DOSSIER/$NOM_FICHIER"
    
    # --- Contenu du fichier (template) ---
    cat > "$CHEMIN_FICHIER" <<EOF
==================================================
   NEXUS : L'ÉVEIL DU SUJET ZÉRO
==================================================

CHAPITRE $i

DATE DE CRÉATION : $(date '+%Y-%m-%d %H:%M:%S')

--- RÉSUMÉ ---
Ceci est le contenu placeholder du chapitre $i.

Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.

--- NOTES DE L'AUTEUR ---
[Espace pour vos annotations personnelles]

--- PROCHAIN CHAPITRE ---
Le chapitre $((i+1)) explorera les mystères de la Nexus.

EOF

    # Afficher une progression toutes les 10 itérations
    if [ $((i % 10)) -eq 0 ]; then
        echo "   ✓ $i chapitres générés..."
    fi
done

# --- 4. Message de fin ---
echo "✅ Génération terminée avec succès !"
echo "📁 Dossier créé : $(pwd)/$NOM_DOSSIER"
echo "📄 Nombre de fichiers : $(ls -1 "$NOM_DOSSIER" | wc -l)"
echo ""
echo "Structure des fichiers :"
ls -la "$NOM_DOSSIER" | head -10
echo "... (et les autres)"

# Bonus : Créer un fichier README pour le projet
cat > "$NOM_DOSSIER/README.txt" <<EOF
==================================================
   PROJET : NEXUS - L'ÉVEIL DU SUJET ZÉRO
==================================================

Ce dossier contient les 320 chapitres du projet.

- Chaque fichier est nommé Chapitre_XXX.txt
- Les chapitres sont numérotés de 001 à 320
- Date de génération : $(date '+%Y-%m-%d %H:%M:%S')

Bonne écriture !
EOF

echo "📄 Fichier README.txt créé dans le dossier."

exit 0
