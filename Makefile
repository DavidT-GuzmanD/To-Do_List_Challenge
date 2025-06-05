# Makefile para pruebas de Flutter con información detallada
.PHONY: help test test-detailed test-coverage test-watch test-verbose test-clean setup

# Variables
FLUTTER = flutter
DART = dart

# Colores para output
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color
BOLD = \033[1m

help: ## Muestra esta ayuda
	@echo "$(BOLD)🧪 COMANDOS DE PRUEBAS FLUTTER$(NC)"
	@echo "=================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-20s$(NC) %s\n", $$1, $$2}'

setup: ## Instala dependencias y genera mocks
	@echo "$(YELLOW)📦 Instalando dependencias...$(NC)"
	$(FLUTTER) pub get
	@echo "$(YELLOW)🔧 Generando mocks...$(NC)"
	$(FLUTTER) packages pub run build_runner build --delete-conflicting-outputs
	@echo "$(GREEN)✅ Setup completado$(NC)"

test: ## Ejecuta pruebas básicas
	@echo "$(YELLOW)🧪 Ejecutando pruebas básicas...$(NC)"
	$(FLUTTER) test

test-detailed: ## Ejecuta pruebas con información detallada
	@echo "$(YELLOW)🔍 Ejecutando pruebas DETALLADAS...$(NC)"
	$(FLUTTER) test \
		--reporter=expanded \
		--concurrency=1 \
		--plain-name \
		test/

test-coverage: ## Ejecuta pruebas con cobertura de código
	@echo "$(YELLOW)📊 Ejecutando pruebas con COBERTURA...$(NC)"
	$(FLUTTER) test --coverage
	@echo "$(GREEN)📈 Reporte de cobertura generado en: coverage/lcov.info$(NC)"

test-watch: ## Ejecuta pruebas en modo observación
	@echo "$(YELLOW)👀 Modo OBSERVACIÓN activado (Ctrl+C para salir)...$(NC)"
	$(FLUTTER) test --reporter=expanded

test-verbose: ## Ejecuta pruebas con máximo detalle
	@echo "$(YELLOW)🔬 Ejecutando pruebas con MÁXIMO DETALLE...$(NC)"
	$(FLUTTER) test \
		--reporter=expanded \
		--concurrency=1 \
		--coverage \
		--plain-name \
		--test-randomize-ordering-seed=random

test-specific: ## Ejecuta una prueba específica (uso: make test-specific FILE=test/mi_test.dart)
	@echo "$(YELLOW)🎯 Ejecutando prueba específica: $(FILE)$(NC)"
	$(FLUTTER) test $(FILE) --reporter=expanded --plain-name

test-bloc: ## Ejecuta solo las pruebas del TaskBloc
	@echo "$(YELLOW)🎯 Ejecutando pruebas del TaskBloc...$(NC)"
	$(FLUTTER) test test/task_bloc_test.dart --reporter=expanded --plain-name

test-clean: ## Limpia archivos de cobertura y regenera mocks
	@echo "$(YELLOW)🧹 Limpiando archivos temporales...$(NC)"
	rm -rf coverage/
	rm -rf .dart_tool/
	$(FLUTTER) clean
	$(FLUTTER) pub get
	$(FLUTTER) packages pub run build_runner clean
	$(FLUTTER) packages pub run build_runner build --delete-conflicting-outputs
	@echo "$(GREEN)✅ Limpieza completada$(NC)"

test-summary: ## Muestra un resumen de las pruebas
	@echo "$(BOLD)📋 RESUMEN DE PRUEBAS$(NC)"
	@echo "======================"
	@echo "Total de archivos de prueba:"
	@find test/ -name "*_test.dart" | wc -l
	@echo "Archivos de prueba encontrados:"
	@find test/ -name "*_test.dart" -exec basename {} \;

# Comando por defecto
all: setup test-detailed

# Para uso con el script de Dart
test-runner-detailed: ## Usa el script personalizado para pruebas detalladas
	$(DART) test_runner.dart detailed

test-runner-coverage: ## Usa el script personalizado para cobertura
	$(DART) test_runner.dart coverage