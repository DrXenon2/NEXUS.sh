#!/bin/bash

# ============================================================
# SCRIPT : GÉNÉRATEUR DE CHAPITRES NEXUS (WORD)
# PROJET : NEXUS L'ÉVEIL DU SUJET ZÉRO
# VERSION : 2.0 - 550 CHAPITRES PAR DÉFAUT
# ============================================================

# --- COULEURS ---
ROUGE='\033[0;31m'
VERT='\033[0;32m'
JAUNE='\033[1;33m'
BLEU='\033[0;34m'
CYAN='\033[0;36m'
GRAS='\033[1m'
NC='\033[0m'

# --- BANNER ---
echo -e "${CYAN}${GRAS}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║     NEXUS : L'ÉVEIL DU SUJET ZÉRO                        ║"
echo "║     GÉNÉRATEUR DE CHAPITRES (650)                        ║"
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# --- 1. PARAMÈTRES PAR DÉFAUT ---
NOM_DOSSIER="NEXUS L'ÉVEIL DU SUJET ZÉRO"
NB_CHAPITRES=650          # <--- Changé de 320 à 500
EXTENSION="docx"
USE_PANDOC=false
CONTENU_PERSONNALISE=""
AFFICHER_PROGRESSION=true

# --- 2. AFFICHAGE DE L'AIDE ---
afficher_aide() {
    echo -e "${BLEU}${GRAS}USAGE :${NC}"
    echo "  ./generer_nexus.sh [OPTIONS]"
    echo ""
    echo -e "${BLEU}${GRAS}OPTIONS :${NC}"
    echo "  -h, --help          Affiche cette aide"
    echo "  -n, --nb N          Nombre de chapitres (défaut: 500)"
    echo "  -d, --dossier NOM   Nom du dossier (défaut: NEXUS L'ÉVEIL DU SUJET ZÉRO)"
    echo "  -t, --txt           Force la génération en .txt (même si Pandoc est présent)"
    echo "  -c, --contenu TEXTE Contenu personnalisé des chapitres"
    echo "  -q, --quiet         Mode silencieux (pas de progression)"
    echo ""
    echo -e "${BLEU}${GRAS}EXEMPLES :${NC}"
    echo "  ./generer_nexus.sh                           # 500 chapitres en .docx"
    echo "  ./generer_nexus.sh -n 100 -d \"Mon Projet\"   # 100 chapitres"
    echo "  ./generer_nexus.sh -t -c \"Chapitre \"       # En .txt avec contenu personnalisé"
    exit 0
}

# --- 3. PARSING DES ARGUMENTS ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            afficher_aide
            ;;
        -n|--nb)
            NB_CHAPITRES="$2"
            if ! [[ "$NB_CHAPITRES" =~ ^[0-9]+$ ]]; then
                echo -e "${ROUGE}❌ Erreur : -n doit être un nombre entier.${NC}"
                exit 1
            fi
            shift 2
            ;;
        -d|--dossier)
            NOM_DOSSIER="$2"
            shift 2
            ;;
        -t|--txt)
            EXTENSION="txt"
            USE_PANDOC=false
            shift
            ;;
        -c|--contenu)
            CONTENU_PERSONNALISE="$2"
            shift 2
            ;;
        -q|--quiet)
            AFFICHER_PROGRESSION=false
            shift
            ;;
        *)
            echo -e "${ROUGE}❌ Option inconnue : $1${NC}"
            echo "Utilisez -h ou --help pour voir les options disponibles."
            exit 1
            ;;
    esac
done

# --- 4. VÉRIFICATION DE PANDOC (sauf si -t est utilisé) ---
if [[ "$EXTENSION" == "docx" ]]; then
    echo -e "${JAUNE}🔍 Vérification de Pandoc...${NC}"
    if ! command -v pandoc &> /dev/null; then
        echo -e "${ROUGE}❌ Pandoc n'est pas installé.${NC}"
        echo ""
        echo -e "${BLEU}📥 Pour installer Pandoc sur Git Bash (Windows) :${NC}"
        echo "   1. Téléchargez-le sur : https://pandoc.org/installing.html"
        echo "   2. Ou avec Chocolatey : choco install pandoc"
        echo "   3. Ou avec Scoop : scoop install pandoc"
        echo ""
        echo -e "${JAUNE}⚠️  Le script peut générer des fichiers .txt à la place.${NC}"
        read -p "Voulez-vous continuer avec des fichiers .txt ? (o/N) : " reponse
        
        if [[ "$reponse" =~ ^[oO]$ ]]; then
            echo -e "${VERT}📄 Génération en .txt (sans Pandoc)...${NC}"
            EXTENSION="txt"
            USE_PANDOC=false
        else
            echo -e "${ROUGE}❌ Script annulé. Installez Pandoc ou utilisez l'option -t.${NC}"
            exit 1
        fi
    else
        echo -e "${VERT}✅ Pandoc est installé ! (version : $(pandoc --version | head -n 1))${NC}"
        USE_PANDOC=true
    fi
fi

# --- 5. CRÉATION DU DOSSIER ---
echo -e "${JAUNE}📁 Création du dossier : $NOM_DOSSIER${NC}"
mkdir -p "$NOM_DOSSIER"

if [ ! -d "$NOM_DOSSIER" ]; then
    echo -e "${ROUGE}❌ Erreur : Impossible de créer le dossier.${NC}"
    exit 1
fi

# --- 6. GÉNÉRATION DES CHAPITRES ---
echo -e "${JAUNE}🚀 Début de la génération des $NB_CHAPITRES chapitres (format .$EXTENSION)...${NC}"
echo ""

DEBUT=$(date +%s)

for i in $(seq 1 $NB_CHAPITRES); do
    NUM_FORMATE=$(printf "%03d" $i)
    NOM_FICHIER="Chapitre_${NUM_FORMATE}.${EXTENSION}"
    CHEMIN_FICHIER="$NOM_DOSSIER/$NOM_FICHIER"
    
    if [[ -n "$CONTENU_PERSONNALISE" ]]; then
        CONTENU="${CONTENU_PERSONNALISE} ${i}"
    else
        CONTENU="CHAPITRE $i"
    fi
    
    if [ "$USE_PANDOC" = true ]; then
        echo "$CONTENU" | pandoc -o "$CHEMIN_FICHIER" 2>/dev/null
    else
        echo "$CONTENU" > "$CHEMIN_FICHIER"
    fi
    
    if [[ "$AFFICHER_PROGRESSION" = true ]]; then
        if [ $((i % 10)) -eq 0 ] || [ $i -eq 1 ] || [ $i -eq $NB_CHAPITRES ]; then
            POURCENT=$(( (i * 100) / NB_CHAPITRES ))
            echo -e "   ${BLEU}[$POURCENT%]${NC} ✓ $i / $NB_CHAPITRES chapitres générés..."
        fi
    fi
done

FIN=$(date +%s)
DUREE=$((FIN - DEBUT))

echo ""
echo -e "${VERT}${GRAS}✅ Génération terminée avec succès !${NC}"
echo -e "${VERT}📁 Dossier créé : $(pwd)/$NOM_DOSSIER${NC}"
echo -e "${VERT}📄 Nombre de fichiers : $(ls -1 "$NOM_DOSSIER" 2>/dev/null | wc -l)${NC}"
echo -e "${VERT}⏱️  Temps d'exécution : ${DUREE} secondes${NC}"
echo -e "${VERT}📐 Format : .$EXTENSION${NC}"

# --- 7. README ---
cat > "$NOM_DOSSIER/README.txt" <<EOF
==================================================
   PROJET : NEXUS - L'ÉVEIL DU SUJET ZÉRO
==================================================

Ce dossier contient $NB_CHAPITRES chapitres du projet.
Format : .$EXTENSION

- Chaque fichier est nommé Chapitre_XXX.$EXTENSION
- Les chapitres sont numérotés de 001 à $NB_CHAPITRES
- Date de génération : $(date '+%Y-%m-%d %H:%M:%S')
- Outil utilisé : $([ "$USE_PANDOC" = true ] && echo "Pandoc" || echo "Mode texte")

Taille totale du dossier : $(du -sh "$NOM_DOSSIER" 2>/dev/null | cut -f1)

Bonne écriture !
==================================================
EOF

echo -e "${VERT}📄 Fichier README.txt créé dans le dossier.${NC}"
echo -e "${CYAN}${GRAS}📖 Bonne écriture pour NEXUS : L'ÉVEIL DU SUJET ZÉRO !${NC}"

exit 0
