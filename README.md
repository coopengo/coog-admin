# COOG ADMIN

Coog Admin is a toolkit that makes it easy to manage Coog (Insurance ERP from
[Coopengo](http://www.coopengo.com)). It is aimed to provide all useful commands to:

- Deploy Coog (in all recommended configurations)
- Administrate Coog (monitor in runtime, upgrade, maintenance procedure, etc)
- Help on Coog troubleshooting (shared knowledge base between all Coog
  installations)

Coog Admin should be installed (cloned) on Coog host server. All other resources
are provides via Docker images.

[Docker](https://www.docker.com/) is the recommended platform to deploy Coog:

- Makes it easy to communicate with system administrators
- Designed to support all kind of Operating Systems
- Helpful to get integrated with third party softwares (right now we use
  postgresql, redis, nginx, sentry, etc)

Coog Admin is a passive tool. It does not launch any agent on your server. All
provided deployment scripts are just docker calls wrappings.

For the first versions, Coog Admin will be focused on deployment.

## What is this tool

- Set of shell scripts to ensure operations
- All Coog data are stored in **one folder** named `$COOG_DATA_DIR`
    - This ensures that the host server is kept clean (no files at different locations).
- Coog data includes postgresql databases, redis persistency, coog documents.
  All those are stored in sub-fodlers of `$COOG_DATA_DIR`.
- All operations scripts source a special script (`config`) that sets the
  configuration
- `config` last line is:

  ```
  [ -f $COOG_DATA_DIR/config ] && source $COOG_DATA_DIR/config
  ```
  Basically, all the configuration is done through environment variables, which
  are defined in `config`. To modify the configuration, just set your updated
  environment variables in `$COOG_DATA_DIR/config`.
- To clean your environment, you can just remove `$COOG_DATA_DIR` folder

It is very recommended to read the scripts to have a deep understanding of how
it works:

- [config](https://github.com/coopengo/coog-admin/blob/master/config): configuration
  items explained
- [postgres](https://github.com/coopengo/coog-admin/blob/master/postgres):
  typical launcher

## Commands

It is recommended to launch the command without any argument to see possible actions
Commands wrap docker commandline to make it easy to call docker without giving the container name

### edit-config

It customizes the environment by setting images tags, database name, or any other runtime parameter

### net (create)

Creates a network where all containers will live: `./net create`

### redis (server, client)

- `./redis server`: launches redis server
- `./redis client`: launches a redis client connected to the server

### postgres (server, client, dump)

- `./postgres server`: launches postgres server
- `./postgres client`: launches postgres client
- `./postgres dump`: dumps current database (to be piped to a file)

### coog (build, server, celery, etc.)

Coog image contains all resources to run Coog backend and Sao Web client

Environment variables to customize process exec (`DB_NAME` and `LOG_LEVEL`)

- `./coog build coog/coog:master trytond:master trytond-modules:master coog:master coog-bench:master sao:master`: builds a coog image
- `./coog reset`: resets coog configuration
- `./coog server 4`: launches a coog server with 4 uwsgi workers
- `./coog celery 4`: launches a coog set of 4 celery workers
- `./coog admin`: launches trytond admin utilities on current database
- `./coog batch ir.ui.view.validate`: executes a batch
- `./coog chain coog_core.check`: executes a batch chain
- `./coog redis celery qlist ir.ui.view.validate`: list queue jobs

### web (build, run)

Web image contains all resources to run Coog api and Coog App web application

Environment variables to customize process exec (`DEBUG`)

- `./web build coog/web:master coog-api:master coog-app:master`: builds a web image
- `./web run`

### nginx (reset, run)

- `./nginx reset`: resets nginx configuration
- `./nginx run`: runs nginx server

Once running, the url mapping is:
- `/`: Coog RPC and Sao client
- `/bench`: Bench Web app (when present)
- `/web/svc`: Coog API
- `/web`: Coog App

### upgrade

This command updates a running environment. It stops and drops running containers, mount new ones and launches `./coog admin -u ir` on current database to migrate database.

### BI

Config can be find at the config file into DWH, ETL and BI section and edited.

First of all, you have to set up a running database server to host your datawarehouse.

If you don't own any datawarehouse server use the command `dwh server` and name your database
like pentaho parameter `DW_DB_NAME`

Now you have to build the docker images, just run
`./etl build coog/etl:master coog-bi:master`

When it ends, run `./etl run` then datawarehouse will build itself.

You can see loaded data using `./dwh client`, connect to your database and then
request table to view the result.

If you don't own your server you can install one with :
`./bi build coog/bi:master coog-bi:master`

And then run it :
`./bi run`

If you have the server running, you'll maybe want to import defaults reports
and OLAP cubes : `./bi import`


/!\ You have to add your datawarehouse connection to the server. Follow this
step:
 - Connect to your server within your browser : `ip:port`
 - Connect as an admin login : `admin`, password : `password`
 - Wait, then click on `manage datasource`
 - Click on the wheel then `new connection`
 - Select postgresql then add your parameters :
    - Hostname : `<ETL_TARGET_DB_HOST>`
    - Database : `<ETL_TARGET_DB_NAME>`
    - Port : `<ETL_TARGET_DB_PORT>`
    - User : `<ETL_TARGET_DB_USER>`
    - Password : `<ETL_TARGET_DB_PASSWORD>`
