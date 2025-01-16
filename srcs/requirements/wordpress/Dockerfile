FROM debian:buster

# Mise à jour et installation des paquets nécessaires
RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y wget \
    php \
    php-fpm \
    php-mysql \
    php-json \
    php-mbstring \
    php-xml \
    php-curl \
    php-cli \
    mariadb-client \
    sendmail

# Création du répertoire et réglage des permissions
RUN mkdir -p /var/www/html \
&& chown -R www-data:www-data /var/www/html \
&& chmod -R 755 /var/www/html

# Port exposé pour PHP-FPM
EXPOSE 9000/tcp

# Configuration de PHP-FPM (remplacement des fichiers de configuration)
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf
COPY ./conf/php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf

# Installation de WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
&& chmod +x wp-cli.phar \
&& mv wp-cli.phar /usr/local/bin/wp

# Script de création et installation de WordPress
COPY ./tools/wordpress_script.sh ./
RUN chmod +x ./wordpress_script.sh

ENTRYPOINT ["./wordpress_script.sh"]

