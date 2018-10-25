SHELL := /bin/bash

.PHONY: help
help:
	@echo "Usage:"
	@echo " clean				remove all build, test, coverage and Python artifacts."
	@echo " clean-docs			remove docs artifacts."
	@echo " clean-build			remove build artifacts."
	@echo " clean-pyc			remove Python file artifacts."
	@echo " clean-test			remove test and coverage artifacts."
	@echo " coverage			run test suite with coverage."
	@echo " freeze				freeze requirements."
	@echo " install    			install requirements."
	@echo " lint				run code checker."
	@echo " unit-test			run unit test suite."
	@echo " integration-test	run integration test suite."
	@echo " register			register package."
	@echo " build				build source distribution."
	@echo " wheel				build universal wheel."
	@echo " upload				upload distributions."
	@echo " manifest			check MANIFEST.in."

.PHONY: clean
clean: clean-docs clean-test clean-build clean-pyc

.PHONY: clean-docs
clean-docs:
	rm -fr docs/_build

.PHONY: clean-build
clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -fr {} +

.PHONY: clean-pyc
clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

.PHONY: clean-test
clean-test:
	rm -fr .cache/
	rm -f .coverage
	rm -fr .pytest_cache/
	rm -fr htmlcov/

.PHONY: coverage
coverage:
	pytest --cov-report html:htmlcov \
		--cov-report term \
		--cov=fixerio \
		tests/

.PHONY: freeze
freeze:
	pip freeze > requirements.txt

.PHONY: install
install:
	pip install -r requirements.txt

.PHONY: install-to-freeze
install-to-freeze:
	pip install -r requirements-to-freeze.txt

.PHONY: lint
lint:
	flake8

.PHONY: unit-test
unit-test:
	pytest --ignore=tests/integration/

.PHONY: integration-test
integration-test:
	pytest tests/integration/

.PHONY: register
register:
	python setup.py register

.PHONY: build
build:
	python setup.py sdist bdist_wheel

.PHONY: upload-test
upload-test:
	twine upload --repository-url https://test.pypi.org/legacy/ dist/*

.PHONY: upload
upload:
	twine upload dist/*

.PHONY: manifest
manifest:
	check-manifest
