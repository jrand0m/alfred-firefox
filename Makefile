# Project tasks. Usage: make <domain>[-<subdomain>]
# Thin wrapper around the mage targets in magefile.go (run via `go run`, so
# nothing besides Go and make needs to be installed).

MAGE := go run github.com/magefile/mage

# mage needs a (dummy) Alfred preferences dir when Alfred isn't configured, e.g. on CI
export alfred_preferences ?= $(CURDIR)/.alfred/Alfred.alfredpreferences
export alfred_version ?= 5

.PHONY: help build build-workflow build-universal build-extension link dist test deps deps-update clean

help:
	@echo "make build            universal workflow (same as dist)"
	@echo "make build-workflow   workflow for this machine's architecture"
	@echo "make build-universal  universal (arm64 + amd64) workflow binary"
	@echo "make build-extension  Firefox extension (.xpi) into ./dist"
	@echo "make link              symlink the build into Alfred's workflows folder (dev)"
	@echo "make dist             single universal .alfredworkflow into ./dist"
	@echo "make test             go vet + go test"
	@echo "make deps             go mod tidy"
	@echo "make deps-update      upgrade all dependencies"
	@echo "make clean            remove build output"

build: dist

build-workflow:
	$(MAGE) -v build

build-universal:
	$(MAGE) -v universal

build-extension:
	$(MAGE) -v extension

link:
	$(MAGE) -v link

dist:
	$(MAGE) -v dist

test:
	go vet ./...
	go test ./...

deps:
	go mod tidy

deps-update:
	go get -u ./...
	go mod tidy

clean:
	rm -rf build dist .alfred
