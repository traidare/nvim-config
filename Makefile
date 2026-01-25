VARIANTS = default nvim-minimal nvim-small
# Capture any arguments after the target name
ARGS = $(filter-out $@,$(MAKECMDGOALS))
# Use first argument as variant, or default if none provided
VARIANT = $(or $(word 1,$(ARGS)),default)

# Make variant names do nothing on their own
.PHONY: default nvim nvim-minimal nvim-small
default nvim nvim-minimal nvim-small:
	@:

test:
	nix run .#$(VARIANT) -- --headless "+messages" "+w !cat" +qa

health:
	nix run .#$(VARIANT) -- --headless "+checkhealth" "+w !cat" +qa

check: test health

test-all:
	@for variant in $(VARIANTS); do \
		echo "=== Testing $$variant for errors ==="; \
		nix run .#$$variant -- --headless "+messages" "+w !cat" +qa; \
	done

health-all:
	@for variant in $(VARIANTS); do \
		echo "=== Running healthcheck on $$variant ==="; \
		nix run .#$$variant -- --headless "+checkhealth" "+w !cat" +qa; \
	done

check-all: test-all health-all

update:
	nix flake update
