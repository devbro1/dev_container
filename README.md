# dev_container
A docker container meant for all development works a developer may need to do.

It includes a developer container that has all the commands a developer may need.

It includes a docker-compose.yml with all the services you mind need.

# installed tools
- php 8.3
    - Xdebug
- javascript(nvm)
    - node22
    - node24
    - yarn
- database
    - postgresql 16
    - mysql mongo
- messaging
    - rabbitmq
- BI
    - metabase
- cache
    - redis
- localstack: AWS emulator
- sops
- age
- terraform
- localstack
- aws-vault
- python3
- zip
- tar
- gcc
- g++
- jq
- yq
- gh: github cli
- lsof
- pwgen
- rust
- golang
- hashicorp-vault
- asdf
- az: Azure cli
- glab: gitlab cli
- gcloud: GCP cli
- wkhtmltopdf
- chromium
- snyk
- nx
- redis-cli

# files to change
- web.Dockerfile: add your name for git config
- run-at-start.sh: any script that you need to run after first launch of container

## How to start
```
docker compose -f docker-compose.yml up -d --build development 
```