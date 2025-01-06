FROM	debian:buster

RUN	apt-get update
RUN	apt-get install -y nginx
RUN	apt-get install -y openssl

COPY	./conf/nginx.conf /etc/nginx/conf.d
COPY	index.html /var/www/html/index.html

RUN mkdir /etc/nginx/ssl
RUN 	openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
	-out /etc/nginx/ssl/kle-rest.crt \
       	-keyout /etc/nginx/ssl/kle-rest.key \
	-subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=kle-rest/CN=kle-rest/"

#RUN	mkdir -p /run/nginx

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"] 
