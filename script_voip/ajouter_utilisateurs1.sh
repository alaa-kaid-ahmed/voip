#!/bin/bash

# Chemin vers le fichier CSV contenant les informations des utilisateurs
csv_file='utilisateurs.csv'

# Fonction pour ajouter un utilisateur à pjsip.conf
ajouter_utilisateur() {
    local nom_utilisateur=$1
    local mot_de_passe=$2
    local extension=$3

    # Configuration à ajouter pour l'utilisateur
    config="[${extension}]
auth_type=userpass
type=auth
username=${extension}
password=${mot_de_passe}

[${extension}]
type=aor
qualify_frequency=60
max_contacts=1
remove_existing=yes
qualify_timeout=3.0
authenticate_qualify=no

[${extension}]
context=internal
auth=${extension}
aors=${extension}
type=endpoint
language=en
deny=0.0.0.0/0.0.0.0
trust_id_inbound=yes
send_rpid=no
transport=tcp_transport
rtcp_mux=no
call_group=
pickup_group=
disallow=all
allow=ulaw,alaw,gsm
mailboxes=300
permit=0.0.0.0/0.0.0.0
ice_support=no
use_avpf=no
dtls_cert_file=
dtls_private_key=
dtls_ca_file=
dtls_setup=actpass
dtls_verify=no
media_encryption=no
message_context=
subscribe_context=
allow_subscribe=yes
rtp_symmetric=yes
force_rport=yes
rewrite_contact=yes
direct_media=no
media_use_received_transport=no
callerid=\"linuxhelp\" <${extension}>"

    # Ajouter la configuration à pjsip.conf
    echo "$config" >> /etc/asterisk/pjsip.conf
}

# Lecture du fichier CSV et ajout des utilisateurs à pjsip.conf
while IFS=, read -r nom_utilisateur mot_de_passe extension; do
    # Ignorer la première ligne si elle contient des en-têtes
    if [[ $nom_utilisateur != "Nom d'utilisateur" ]]; then
        ajouter_utilisateur "$nom_utilisateur" "$mot_de_passe" "$extension"
    fi
done < "$csv_file"

echo "Ajout des utilisateurs terminé."
