# .env 파일이 있으면 불러오기
-include .env
export

APP_ENV ?= dev

ifeq ($(APP_ENV), production)
COMPOSE = docker compose -f docker-compose.yml -f docker-compose.prod.yml
else
COMPOSE = docker compose -f docker-compose.yml -f docker-compose.dev.yml
endif

# =========================
# Docker
# =========================
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


# =========================
# PHP / Laravel
# =========================
php:
	$(COMPOSE) exec -it php bash

migrate:
	$(COMPOSE) exec php php artisan migrate

artisan:
	$(COMPOSE) exec php php artisan $(cmd)

tinker:
	$(COMPOSE) exec php php artisan tinker

fix-permission:
	sudo chown -R $$(id -u):$$(id -g) .

# =========================
# Node / Vite
# =========================
node:
	$(COMPOSE) exec -it node sh

npm:
	$(COMPOSE) exec -it node npm $(cmd)

.PHONY: up down restart ps logs php migrate artisan tinker fix-permission node npm
