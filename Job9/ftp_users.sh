#!/bin/bash

#Import a csv file and skip the header
sed 1d ftp_users.csv | while IFS=, read -r Id Prenom Nom Mdp Role;
do
#Creating users
    username=$Prenom$Nom
    cleanusername=$(echo "${username}" | tr -d '[:space:]')
    sudo useradd -m -p $(openssl passwd -1 $Mdp) $cleanusername
    if [[ $Role == A* ]]; then
        usermod -aG sudo $cleanusername
    fi
#Creating a group for proftpd users
    addgroup ftp_users
	usermod -aG ftp_users $cleanusername
    sed -i '74 s/nogroup/ftp_users/g' /etc/proftpd/proftpd.conf
done

service proftpd restart
