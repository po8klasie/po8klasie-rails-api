# This repository has been archived.

Repository contents won't be updated and issues/discussions won't be monitored.

We decided to continue to develop po8klasie respectively in:
* [web-frontend repo](https://github.com/po8klasie/web-frontend)
* [po8klasie-fastapi repo](https://github.com/po8klasie-fastapi)

---

# po8klasie-rails-api

This repository contains the backend code for [po8klasie.pl](https://po8klasie.pl) written in Ruby on Rails. 

For further information on how to run the project check out the docs folder

## Quick start
Do not use described setup in production! 
See our [infra repo](https://github.com/po8klasie/infra) for info on how to set up prod-ready deployment.

### Using ruby locally
1. For convenience, create symlink from `docker-compose.yml` to `docker-compose.db.yml` (`ln -s docker-compose.db.yml docker-compose.yml`)
2. Start Postgres using `docker-compose up -d`  or `docker-compose -f docker-compose.db.yml up -d`
3. Run Ruby on Rails locally

### Using docker-compose

1. For convenience, create symlink from `docker-compose.yml` to `docker-compose.local.yml` (`ln -s docker-compose.local.yml docker-compose.yml`)
2. Run `docker-compose up -d` or `docker-compose -f docker-compose.local.yml up -d`
