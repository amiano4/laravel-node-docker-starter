# Load environment variables from .env
include .env
export $(shell sed 's/=.*//' .env)

# Check if USE_HTTPS is true
ifeq ($(USE_HTTPS),true)
PROTOCOL=https
NGINX_FINAL_PORT=$(NGINX_SSL_PORT)
else
PROTOCOL=http
NGINX_FINAL_PORT=$(NGINX_PORT)
endif

# Variables
FRONTEND_URL="$(PROTOCOL)://localhost:$(FRONTEND_PORT)"
NGINX_URL="$(PROTOCOL)://localhost:$(NGINX_FINAL_PORT)"
PHPMYADMIN_URL="http://localhost:$(PHPMYADMIN_PORT)"
MAILHOG_URL="http://localhost:$(MAILHOG_PORT)"

define print_running_services
	@echo ""
	@echo "\033[1;32m$(1)"
	@echo ""
	@echo "🔗 \033[1;34mLaravel API:     \033[0m$(NGINX_URL)"
	@echo ""
	@echo "🔗 \033[1;34mApp (Vue.js):    \033[0m$(FRONTEND_URL)"
	@echo ""
	@echo "🔗 \033[1;34mphpMyAdmin:      \033[0m$(PHPMYADMIN_URL)"
	@echo ""
	@echo "🔗 \033[1;34mMailhog:         \033[0m$(MAILHOG_URL)"
	@echo ""
endef

up:
	docker compose up -d --build
	$(call print_running_services, "✅ Containers started!")

down:
	docker compose down

restart:
	docker compose down && docker compose up -d --build
	$(call print_running_services, "🔄 Containers restarted!")

reset:
	docker compose down -v && docker compose up -d --build
	$(call print_running_services, "🧨 Containers and volumes reset!")

logs:
	docker compose logs -f --tail=100

shell-php:
	docker compose exec php bash

shell-node:
	docker compose exec node_app sh 

shell-mysql:
	docker compose exec mysql bash

shell-redis:
	docker compose exec redis bash
