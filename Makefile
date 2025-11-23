.PHONY: help
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
# Coming Soon (Phase 3a):
#   make build-all     - Build all C and Go projects
#   make test-all      - Run all tests across all projects
#   make clean-all     - Clean all build artifacts
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
	@echo "Phase 3a Status: PR 1/9 (Help target only)"
	@echo "Next: PR 2 will add directory structure documentation"
	@echo ""
