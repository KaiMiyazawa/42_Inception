# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: miyazawa.kai.0823 <miyazawa.kai.0823@st    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/02/24 15:28:18 by miyazawa.ka       #+#    #+#              #
#    Updated: 2025/03/08 16:23:02 by miyazawa.ka      ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml

.PHONY : all build up down stop start ps hosts clean

all : up

hosts:
	@sudo cp /etc/hosts /etc/hosts.backup
	@sudo chmod 777 /etc/hosts
	@echo "127.0.0.1 kmiyazaw.42.fr" | sudo tee -a /etc/hosts
	@sudo chmod 644 /etc/hosts
	@echo "Hosts file updated"


build :
	@docker compose -f $(DOCKER_COMPOSE_FILE) build --no-cache

up :
	@docker compose -f $(DOCKER_COMPOSE_FILE) up

down :
	@docker compose -f $(DOCKER_COMPOSE_FILE) down

stop :
	@docker compose -f $(DOCKER_COMPOSE_FILE) stop

start :
	@docker compose -f $(DOCKER_COMPOSE_FILE) start

ps :
	@docker compose -f $(DOCKER_COMPOSE_FILE) ps

clean :
	@docker system prune -a -f
	@read -p "Are you sure you want to delete ./srcs/database and ./srcs/web? [y/N] " confirm && \
		if [ "$$confirm" = "y" ]; then \
			sudo rm -rf ./srcs/database ./srcs/web; \
		else \
			echo "Clean operation aborted."; \
		fi
