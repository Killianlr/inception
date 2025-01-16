NAME = inception
REPO_DB = /home/klrubuntuinception/data/mariadb
REPO_WP = /home/klrubuntuinception/data/wordpress

all: ${NAME}

${NAME}: create_repos
	cp /home/klrubuntuinception/.env ./srcs/
	docker compose -f ./srcs/docker-compose.yml build
	docker compose -f ./srcs/docker-compose.yml up -d

clean:
	docker container stop nginx mariadb wordpress
	docker compose -f ./srcs/docker-compose.yml down

clear:
	@if [ -d "${REPO_DB}" ] || [ -d "${REPO_WP}" ]; then \
		echo "Deleting database and WordPress volumes..."; \
		sudo rm -rf ${REPO_DB} ${REPO_WP}; \
	else \
		echo "No volumes to delete."; \
	fi
	docker system prune -af
	docker volume rm srcs_mariadb srcs_wordpress
	docker volume prune -af
	docker network prune -f

fclean: clean clear

re: fclean all

create_repos:
	mkdir -p ${REPO_DB}
	mkdir -p ${REPO_WP}

.PHONY: create_repos all clean fclean re

