#!/bin/bash -e
RANCHER_STACK_NAME=${RANCHER_STACK_NAME:-stack-example}

if [ ! -f rancher_cli.env ]; then
	echo "ERROR: You have to create rancher_cli.env file from rancher_cli.env.template"
	exit 1
fi

if [ ! -f shared_vars.env ]; then
	echo "ERROR: You have to: create shared_vars.env file from shared_vars.env.template"
	exit 1
fi

# load and export all defined variables
set -o allexport
source shared_vars.env
set +o allexport

cleanup () {
	rm -f .env.rancher
	rm -rf secrets
}

trap cleanup EXIT

# set variables used in docker-compose file
envsubst < env.rancher.tmpl > .env.rancher

source .env.rancher

# check variables used in docker-compose files
test $PUBLIC_VARIABLE


create_secrets_files () {(
	# subshell without printing executed commands
	set +x
	test $SECRET_VARIABLE

	# the contents of the specified files will be used to create the secrets
	# before creating the stack and starting the services
	mkdir -p secrets
	echo $SECRET_VARIABLE > secrets/secret-variable.txt
)}

create_secrets_files

rancher_cli () {
	rancher --file docker-compose.yml --file docker-compose.rancher.yml \
		--rancher-file rancher-compose.yml "$@"
}

# load Rancher access data
source rancher_cli.env

test $RANCHER_URL
test $RANCHER_ACCESS_KEY
test $RANCHER_SECRET_KEY

rancher_cli up -d --stack $RANCHER_STACK_NAME --env-file .env.rancher --pull \
	--upgrade --confirm-upgrade --description "A simple Rancher stack example"
