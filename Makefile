.PHONY: help build-c-all test-c-all build-go-all test-go-all build-all test-all
.DEFAULT_GOAL := help

# jcaldwell-labs Unified Build System
# ====================================
#
# This Makefile provides unified build and test commands across all
# organization repositories (9 projects: 6 C, 2 Go, 1 meta).
#
# Quick Start:
#   make help          - Show this help message
#
# Directory Structure:
#   See README.md "Repository Structure" section for complete layout
#
# Available Commands:
#   make build-all     - Build all C and Go projects (READY)
#   make test-all      - Run all tests across all projects (READY)
#   make build-c-all   - Build only C projects
#   make test-c-all    - Test only C projects
#   make build-go-all  - Build only Go projects
#   make test-go-all   - Test only Go projects
#

help: ## Show this help message
	@echo "jcaldwell-labs Unified Build System"
	@echo "===================================="
	@echo ""
	@echo "Available targets:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Project Structure:"
	@echo "  C Projects (6):     boxes-live, terminal-stars, tario,"
	@echo "                      adventure-engine-v2, smartterm-prototype, atari-style"
	@echo "  Go Projects (2):    fintrack, my-context"
	@echo "  Meta Projects (1):  .github"
	@echo ""
	@echo "Phase 3a Status: COMPLETE ✓ (Unified build system operational)"
	@echo "Next: Phase 3b will add integration examples"
	@echo ""
	@echo "For complete directory layout, see: README.md (Repository Structure)"
	@echo ""

build-c-all: ## Build all C projects with zero warnings
	@echo "Building all C projects..."
	@./scripts/build-c-projects.sh

test-c-all: ## Run all C project test suites
	@echo "Testing all C projects..."
	@./scripts/test-c-projects.sh

build-go-all: ## Build all Go projects with zero warnings
	@echo "Building all Go projects..."
	@./scripts/build-go-projects.sh

test-go-all: ## Run all Go project test suites
	@echo "Testing all Go projects..."
	@./scripts/test-go-projects.sh

build-all: build-c-all build-go-all ## Build all C and Go projects
	@echo "All projects built successfully\!"

test-all: test-c-all test-go-all ## Run all test suites
	@echo "All tests passed successfully\!"
