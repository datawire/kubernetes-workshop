build:
	node_modules/.bin/gitbook build

serve:
	node_modules/.bin/gitbook serve

setup: node_modules
	npm install gitbook-cli

node_modules:
	mkdir node_modules