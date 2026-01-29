# ===== 기본 설정 =====
COMPOSE = docker compose -f docker-compose.yml -f docker-compose.dev.yml

# ===== 기본 명령 =====
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

# ===== 컨테이너 접속 =====
php:
	$(COMPOSE) exec php bash

node:
	$(COMPOSE) exec node sh

# ===== Laravel 명령 =====
key:
	$(COMPOSE) exec php php artisan key:generate

migrate:
	$(COMPOSE) exec php php artisan migrate

migrate-fresh:
	$(COMPOSE) exec php php artisan migrate:fresh

# ===== 프론트 =====
npm-install:
	$(COMPOSE) exec node npm install

npm-dev:
	$(COMPOSE) exec node npm run dev

npm-build:
	$(COMPOSE) exec node npm run build

# ===== 초기 세팅 (clone 후 1회) =====
init:
	$(COMPOSE) up -d --build
	@echo "-----------------------------------"
	@echo "Laravel init completed."
	@echo "Next steps:"
	@echo "1. make php"
	@echo "2. php artisan key:generate"
	@echo "-----------------------------------"

.PHONY: up down restart ps logs php node key migrate migrate-fresh npm-install npm-dev npm-build init
