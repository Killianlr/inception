NAME = inception
REPO_DB = /home/kle-rest/data/mariadb
REPO_WP = /home/kle-rest/data/wordpress

all: ${NAME}

${NAME}: create_repos
	cp /home/kle-rest/.env ./srcs/
	docker compose -f ./srcs/docker-compose.yml build
	docker compose -f ./srcs/docker-compose.yml up -d

clean:
	docker container stop nginx mariadb wordpress
	docker compose -f ./srcs/docker-compose.yml down

clear:
	@if [ -d "${REPO_DB}" ]; then \
		echo "Deleting database volume..."; \
		sudo rm -rf ${REPO_DB}; \
	else \
		echo "No database volume to delete."; \
	fi
	@if [ -d "${REPO_WP}" ]; then \
		echo "Deleting WordPress volume..."; \
		sudo rm -rf ${REPO_WP}; \
	else \
		echo "No WordPress volume to delete."; \
	fi
	docker system prune -af
	@if docker volume ls -q -f name=srcs_mariadb; then \
		docker volume rm srcs_mariadb; \
	else \
		echo "No srcs_mariadb volume to remove."; \
	fi
	@if docker volume ls -q -f name=srcs_wordpress; then \
		docker volume rm srcs_wordpress; \
	else \
		echo "No srcs_wordpress volume to remove."; \
	fi
	docker volume prune -af
	docker network prune -f

fclean: clean clear

re: fclean all

create_repos:
	mkdir -p ${REPO_DB}
	mkdir -p ${REPO_WP}

.PHONY: create_repos all clean fclean re

