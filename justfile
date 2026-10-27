# Project tasks. Usage: just <domain> <subdomain> [target]

set shell := ["zsh", "-cu"]

# mage needs a (dummy) Alfred preferences dir when Alfred isn't configured, e.g. on CI
export alfred_preferences := env_var_or_default("alfred_preferences", justfile_directory() / ".alfred/Alfred.alfredpreferences")
export alfred_version := env_var_or_default("alfred_version", "5")

mage := "go run github.com/magefile/mage"

default:
    @just --list

# just build workflow|extension|all [native|universal]
build target="all" arch="native":
    #!/usr/bin/env zsh
    set -eu
    case "{{target}}" in
      workflow)
        if [[ "{{arch}}" == universal ]]; then {{mage}} -v universal; else {{mage}} -v build; fi ;;
      extension) {{mage}} -v extension ;;
      all)       {{mage}} -v dist ;;  # dist is always universal
      *) echo "unknown target: {{target}} (workflow|extension|all)"; exit 1 ;;
    esac

# just dist all  (universal .alfredworkflow + .xpi into ./dist)
dist target="all":
    just build {{target}} universal

# just test all
test target="all":
    go vet ./...
    go test ./...

# just deps update | tidy
deps action="tidy":
    #!/usr/bin/env zsh
    set -eu
    case "{{action}}" in
      update) go get -u ./... && go mod tidy ;;
      tidy)   go mod tidy ;;
      *) echo "unknown action: {{action}} (update|tidy)"; exit 1 ;;
    esac

# just clean all
clean target="all":
    rm -rf build dist .alfred
