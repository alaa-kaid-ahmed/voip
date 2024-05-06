#!/bin/bash

# Chemin vers le fichier CSV contenant les informations des utilisateurs
csv_file='utilisateurs.csv'

# Fonction pour ajouter un utilisateur à Asterisk
ajouter_utilisateur() {
    local nom_utilisateur=$1
    local mot_de_passe=$2
    local extension=$3

    # Ajouter l'authentification de l'utilisateur à PJSIP
    echo -e "[$nom_utilisateur]\nusername=$nom_utilisateur\nsecret=$mot_de_passe\n" >> /etc/asterisk/pjsip.conf

    # Ajouter l'endpoint (extension) à PJSIP
    echo -e "[$extension]\ntype=endpoint\ncontext=internal\nauth=$nom_utilisateur\naors=$extension\n" >> /etc/asterisk/pjsip.conf

    # Ajouter l'AOR (Address of Record) à PJSIP
    echo -e "[$extension]\ntype=aor\ncontact=sip:$extension\n" >> /etc/asterisk/pjsip.conf
}

# Lecture du fichier CSV et ajout des utilisateurs à Asterisk
while IFS=, read -r nom_utilisateur mot_de_passe extension; do
    # Ignorer la première ligne si elle contient des en-têtes
    if [[ $nom_utilisateur != "Nom d'utilisateur" ]]; then
        ajouter_utilisateur "$nom_utilisateur" "$mot_de_passe" "$extension"
    fi
done < "$csv_file"

echo "Ajout des utilisateurs terminé."
