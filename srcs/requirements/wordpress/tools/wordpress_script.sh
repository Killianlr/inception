#!/bin/sh

cd /var/www/html/wordpress

# Assure-toi que MariaDB est prêt
sleep 10

# Vérifie si wp-config.php n'existe pas, ce qui signifie que WordPress n'est pas encore configuré
if [ ! -f "/var/www/html/wordpress/wp-config.php" ]; then
    # Télécharge WordPress version 6.4.3
    wp core download --allow-root --version=6.4.3

    # Crée le fichier wp-config.php avec les détails de la base de données
    wp config create --allow-root \
        --dbname=${SQL_DB_NAME} \
        --dbuser=${SQL_USER_NAME} \
        --dbpass=${SQL_USER_PASSWORD} \
        --dbhost=${SQL_HOST} \
        --url=${DOMAIN_NAME}

    # Installe WordPress avec les informations de l'administrateur
    wp core install --allow-root \
        --title=${SITE_TITLE} \
        --url=${DOMAIN_NAME} \
        --admin_user=${ADMIN_USER} \
        --admin_password=${ADMIN_PASSWORD} \
        --admin_email=${ADMIN_EMAIL}

    # Crée un utilisateur WordPress avec un rôle d'auteur
    wp user create --allow-root \
        ${USER_LOGIN} ${USER_MAIL} \
        --role=author \
        --user_pass=${USER_PASSWORD}
fi

# Vide le cache de WordPress pour éviter les données obsolètes
wp cache flush --allow-root

# Crée le répertoire pour les fichiers socket si nécessaire
if [ ! -d /run/php ]; then
    mkdir /run/php
fi

# Assure-toi que les permissions sont correctes pour www-data
chown -R www-data:www-data /var/www/html/wordpress

# Redémarre PHP-FPM en mode foreground et en lisant les fichiers en tant qu'utilisateur régulier
/usr/sbin/php-fpm7.3 -F -R

