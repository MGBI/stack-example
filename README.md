# Rancher stack example

## Configuration structure
```
.
├── .env.rancher.tmpl               # template for .env.rancher file with all public environment variables
├── docker-compose.override.yml     # local development configuration only
├── docker-compose.rancher.yml      # production-like configuration only
├── docker-compose.yml              # common configuration
├── prod-compose.sh                 # Rancher stack deployment script
├── rancher_cli.env                 # Rancher API keys
└── shared_vars.env                 # the values of all public and secret environment variables
```

## Environment variables setup
```
// create and fill shared_vars.env file (ignored by git)
cp shared_vars.env.template shared_vars.env
edit shared_vars.env
```

## Local development
(after Environment variables setup)
```
docker-compose up
```

## Public and secret environment variables for production-like configuration
(after Environment variables setup)
```
// Add templates for the public variables
edit .env.rancher.tmpl
// And create secret files in `create_secrets_files` function
edit prod-compose.sh
```
As you can see, prod-compose.sh manages the environment variables:
* Public environment variables will be saved in `.env.rancher` file.
* Secret environment variables will be saved in separate files in `secrets` directory.

## Containers deployment on Rancher
(after Public and secret environment variables for production-like configuration)

Remember to start Rancher Secrets from Catalog before the deployment!

To deploy use your Rancher Account API Key (it can be shared between projects
in different environments as well) or create a new one:

Open the Rancher GUI and click in the top panel `API` → `Keys` and then click
`Add Account API Keys`.
```
// create and fill rancher_cli.env file (ignored by git)
cp rancher_cli.env.template rancher_cli.env
edit rancher_cli.env

./prod-compose.sh
```

