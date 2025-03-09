# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: miyazawa.kai.0823 <miyazawa.kai.0823@st    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/02/24 15:28:18 by miyazawa.ka       #+#    #+#              #
#    Updated: 2025/03/09 20:53:48 by miyazawa.ka      ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml

.PHONY : all set build up down stop start ps clean

all : up

set:
	@sudo cp /etc/hosts /etc/hosts.backup
	@sudo chmod 777 /etc/hosts
	@echo "127.0.0.1 kmiyazaw.42.fr" | sudo tee -a /etc/hosts
	@sudo chmod 644 /etc/hosts
	@echo "Hosts file updated"
	@sudo mkdir -p /home/kmiyazaw/data/database
	@sudo mkdir -p /home/kmiyazaw/data/web
	@echo "Data directories created"

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
	@docker system prune -a -f --volumes

#clean :
#	@docker system prune -a -f
#	@read -p "Are you sure you want to delete ./srcs/database and ./srcs/web? [y/N] " confirm && \
#		if [ "$$confirm" = "y" ]; then \
#			sudo rm -rf ./srcs/database ./srcs/web; \
#		else \
#			echo "Clean operation aborted."; \
#		fi