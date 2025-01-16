FROM    debian:buster

# Mise à jour des paquets et installation de MariaDB
RUN     apt-get update \
&&      apt-get upgrade -y \
&&      apt-get install -y --no-install-recommends \
        mariadb-server \
        mariadb-client \
&&      apt-get clean \
&&      rm -rf /var/lib/apt/lists/*

# Ouverture du port 3306 pour MariaDB
EXPOSE  3306/tcp

# Copie du fichier de configuration de MariaDB
COPY    ./conf/mariadb-server.cnf /etc/mysql/mariadb.conf.d/mariadb-server.cnf

# Script de création de la base de données et des utilisateurs
COPY    ./tools/mariadb_script.sh /etc/

# Utilisation du script d'installation de MariaDB comme point d'entrée
ENTRYPOINT [ "./etc/mariadb_script.sh" ]

