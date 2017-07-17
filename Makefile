build:
	node_modules/.bin/gitbook build

setup: node_modules
	npm install gitbook-cli

node_modules:
	mkdir node_modules