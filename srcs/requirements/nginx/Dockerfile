FROM debian:buster

# Mise à jour et installation des paquets nécessaires
RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y nginx openssl

# Création des certificats SSL
RUN mkdir -p /etc/nginx/ssl \
&& openssl req -x509 -nodes -days 300 \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=kle-rest.42.fr"

# Configuration de Nginx
RUN mkdir -p /var/run/nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Droits et permissions
RUN mkdir -p /var/www/html \
&& chmod 755 /var/www/html \
&& chown -R www-data:www-data /var/www/html

# Exposer le port 80
EXPOSE 80

# Démarrage de Nginx en mode non-démon
ENTRYPOINT ["nginx", "-g", "daemon off;"]

