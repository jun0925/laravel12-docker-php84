# .env 파일이 있으면 불러오기
-include .env
export

APP_ENV ?= dev

ifeq ($(APP_ENV), production)
COMPOSE = docker compose -f docker-compose.yml -f docker-compose.prod.yml
else
COMPOSE = docker compose -f docker-compose.yml -f docker-compose.dev.yml
endif

env:
	@echo "APP_ENV=$(APP_ENV)"
	@echo "COMPOSE=$(COMPOSE)"

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

restart:
	$(COMPOSE) down
	$(COMPOSE) up -d --build

ps:
	$(COMPOSE) ps

logs:
	$(COMPOSE) logs -f

php:
	$(COMPOSE) exec php bash

# Laravel
key:
	$(COMPOSE) exec php php artisan key:generate

migrate:
	$(COMPOSE) exec php php artisan migrate

.PHONY: up down restart ps logs php key migrate
