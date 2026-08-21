#!/bin/bash

# ==============================================
# SCRIPT : GÉNÉRATEUR DE CHAPITRES NEXUS (WORD)
# DOSSIER : NEXUS L'ÉVEIL DU SUJET ZÉRO
# CHAPITRES : 1 à 320 (format .docx)
# VERSION MINIMALISTE
# ==============================================

# --- 1. Vérification de Pandoc ---
echo "🔍 Vérification de Pandoc..."
if ! command -v pandoc &> /dev/null; then
    echo "❌ Pandoc n'est pas installé."
    echo ""
    echo "📥 Pour installer Pandoc sur Git Bash (Windows) :"
    echo "   1. Téléchargez-le sur : https://pandoc.org/installing.html"
    echo "   2. Ou avec Chocolatey : choco install pandoc"
    echo "   3. Ou avec Scoop : scoop install pandoc"
    echo ""
    read -p "Voulez-vous continuer avec des fichiers .txt ? (o/N) : " reponse
    
    if [[ "$reponse" =~ ^[oO]$ ]]; then
        echo "📄 Génération en .txt (sans Pandoc)..."
        EXTENSION="txt"
        USE_PANDOC=false
    else
        echo "❌ Script annulé. Installez Pandoc et réessayez."
        exit 1
    fi
else
    echo "✅ Pandoc est installé !"
    EXTENSION="docx"
    USE_PANDOC=true
fi

# --- 2. Définition du dossier ---
NOM_DOSSIER="NEXUS L'ÉVEIL DU SUJET ZÉRO"

# --- 3. Création du dossier ---
echo "Création du dossier : $NOM_DOSSIER"
mkdir -p "$NOM_DOSSIER"

if [ ! -d "$NOM_DOSSIER" ]; then
    echo "❌ Erreur : Impossible de créer le dossier."
    exit 1
fi

# --- 4. Génération des 320 chapitres ---
echo "Début de la génération des 320 chapitres..."

for i in $(seq 1 320); do
    NUM_FORMATE=$(printf "%03d" $i)
    NOM_FICHIER="Chapitre_${NUM_FORMATE}.${EXTENSION}"
    CHEMIN_FICHIER="$NOM_DOSSIER/$NOM_FICHIER"
    
    # Contenu minimal : juste le titre du chapitre
    CONTENU="CHAPITRE $i"
    
    if [ "$USE_PANDOC" = true ]; then
        echo "$CONTENU" | pandoc -o "$CHEMIN_FICHIER"
    else
        echo "$CONTENU" > "$CHEMIN_FICHIER"
    fi
    
    if [ $((i % 10)) -eq 0 ]; then
        echo "   ✓ $i chapitres générés..."
    fi
done

# --- 5. Fin ---
echo "✅ Génération terminée avec succès !"
echo "📁 Dossier créé : $(pwd)/$NOM_DOSSIER"
echo "📄 Nombre de fichiers : $(ls -1 "$NOM_DOSSIER" | wc -l)"

exit 0
