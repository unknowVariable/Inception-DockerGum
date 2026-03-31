LOGIN := $(shell grep '^LOGIN=' srcs/.env | cut -d= -f2)

.PHONY: up down build ps logs clean fclean re

up:
	@mkdir -p /home/$(LOGIN)/data/mariadb /home/$(LOGIN)/data/wordpress
	@cd srcs && docker compose up -d --build

down:
	@cd srcs && docker compose down

build:
	@cd srcs && docker compose build

ps:
	@cd srcs && docker compose ps

logs:
	@cd srcs && docker compose logs

clean: down

fclean:
	@cd srcs && docker compose down --rmi all --volumes --remove-orphans

re: fclean up
