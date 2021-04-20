#!/bin/bash -ex
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
	rm -rf secrets
}

check_compose_variables () {
	# check variables used in docker-compose files

	# values of the variables will be read from the current environment
	test $PUBLIC_VARIABLE
}


create_secrets_files () {
	# create files with secrets values
	test $SECRET_VARIABLE

	# content of the specified files will be used to create the secrets
	# before creating the stack and starting the services
	mkdir -p secrets
	echo $SECRET_VARIABLE > secrets/secret-variable.txt
	unset SECRET_VARIABLE
}

rancher_cli () {
	rancher --file docker-compose.yml --file docker-compose.rancher.yml \
		--rancher-file rancher-compose.yml "$@"
}

trap cleanup EXIT

check_compose_variables

create_secrets_files

# load Rancher access data
source rancher_cli.env

test $RANCHER_URL
test $RANCHER_ACCESS_KEY
test $RANCHER_SECRET_KEY

rancher_cli up -d --stack $RANCHER_STACK_NAME --pull --upgrade \
	--confirm-upgrade --description "A simple Rancher stack example"
