# COOG ADMIN

Coog Admin is a toolkit that makes it easy to manage Coog (Insuance ERP from
Coopengo). It is aimed to provide all useful commands to:

- Deploy Coog (in all recommended configurations)
- Administrate Coog (monitor in runtime, upgrade, maintenance procedure, etc)
- Help on Coog troubleshooting (shared knowledge base between all Coog
  installtions)

Coog Admin should be installed (cloned) on Coog host server. All other resources
are provides via Docker images.

[Docker](https://www.docker.com/) is the recommended platform to deploy Coog:

- Makes it easy to communicate with sys admins
- Optimal to support all kind of Operating Systems
- Helpful to get integrated with third party softwares (right now we use
  postgresql, redis, nginx, sentry, etc)

Coog Admin is a passive tool. It does not launch any agent on your server. All
provided deployment scripts are just docker calls wrappings.

For the first versions, Coog Admin will be focused on deployment.

## What is this tool

- Set of shell scripts to ensure operations
- All operations scripts source a special script (`.env`) that sets the
  configuration
- `.env` last command is to source `/usr/local/coog/env` script (the last
  contains your overrides to personalize your environment
- `/usr/local/coog` contains ALL Coog specific data (no worry, we keep your
  server clean)

    - Never modify Coog Admin directly
    - To clean your environment, you can just delete `/usr/local/coog` folder

It is very recommended to read the scripts to have a deep understanding of how
it works:

- [.env](https://github.com/coopengo/coog-admin/blob/master/.env): configuration
  items explained
- [postgres](https://github.com/coopengo/coog-admin/blob/master/postgres):
  typical launcher

### Content description

- pull: pulls all needed images for Coog
- clean: useful to clean old images on filesystem
- .env: all configuration variables
- redis: launches redis (client and server) from a docker image
- postgres: launches postgres (client and server) from a docker images
- sentry: runs sentry (server and workers) from a docker images. This could link
  to redis and postgres docker container or points to other servers (depending
  on configuration). Default is link to Docker.
- coog: runs coog (workers, batch). It links to redis and postgres based on
  configuration
- nginx: launches nginx as a reverse proxy and load balancer for Coog
    - a commented configuration example is provided [here](https://github.com/coopengo/coog-admin/blob/master/config/nginx.conf)
    - this could be overridden is `/usr/local/coog/nginx.conf`

## Use case

Coming soon.
