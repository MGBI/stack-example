# Rancher stack example

## Configuration structure
```
.
├── docker-compose.override.yml     # local development configuration only
├── docker-compose.rancher.yml      # production-like configuration only
├── docker-compose.yml              # common configuration
├── prod-compose.sh                 # Rancher stack deployment script
├── rancher_cli.env                 # Rancher API keys
└── shared_vars.env                 # public and secret environment variables
```

## Environment variables setup
```
// create and fill shared_vars.env file (ignored by git)
cp shared_vars.env.template shared_vars.env
edit shared_vars.env

// Add variables to the public or secrets ones
edit prod_compose.sh
```
Public environment variables should be saved in `.env.rancher` file.
Secret environment variables should be saved in separate files in `secrets` directory.


## Local development
(after Environment variables setup)
```
docker-compose up
```

## Containers deployment on Rancher
(after Environment variables setup)
```
// create and fill rancher_cli.env file (ignored by git)
cp rancher_cli.env.template rancher_cli.env
edit rancher_cli.env

./prod-compose.sh
```

