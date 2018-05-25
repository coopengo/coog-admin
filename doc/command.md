# Coog-admin Commands

It is recommended to launch the command without any argument to see possible actions
Commands wrap docker commandline to make it easy to call docker without giving the container name

## edit-config

It customizes the environment by setting images tags, database name, or any other runtime parameter

## net (create)

Creates a network where all containers will live: `./net create`

## redis (server, client)

- `./redis server`: launches redis server
- `./redis client`: launches a redis client connected to the server

## postgres (server, client, dump)

- `./postgres server`: launches postgres server
- `./postgres client`: launches postgres client
- `./postgres dump`: dumps current database (to be piped to a file)

## coog (build, server, celery, etc.)ww

Coog image contains all resources to run Coog backend and Sao Web client

Environment variables to customize process exec (`DB_NAME` and `LOG_LEVEL`)

- `./coog build` : builds a coog image (see [build chapter](build)
- `./coog reset`: resets coog configuration
- `./coog server 4`: launches a coog server with 4 uwsgi workers
- `./coog celery 4`: launches a coog set of 4 celery workers
- `./coog admin `: launches trytond admin utilities on current database : 
./coog admin -u <modules separated by commas> install/update modules
- `./coog batch ir.ui.view.validate`: executes a batch
- `./coog chain coog_core.check`: executes a batch chain
- `./coog redis celery qlist ir.ui.view.validate`: list queue jobs
- `./coog version`: gives the repositories list and the last commits
- `./coog env` : displays environment variables for coog containers
- `./coog module list` : displays coog installed modules list
- `./coog conf` : displays workers configuration for app and batch
- `./coog -- server logs`: Display coog logs
- `./coog -- celery logs`: Display celery logs

## web (build, run)

Web image contains all resources to run Coog api and Coog App web application

Environment variables to customize process exec (`DEBUG`)

- `./web build coog/web:master coog-api:master coog-app:master`: builds a web image
- `./web run`

## nginx (reset, run)

- `./nginx reset`: resets nginx configuration
- `./nginx run`: runs nginx server

Once running, the url mapping is:
- `/`: Coog RPC and Sao client
- `/bench`: Bench Web app (when present)
- `/web/svc`: Coog API
- `/web`: Coog App

## upgrade

This command updates a running environment. It stops and drops running containers, mount new ones and launches `./coog admin -u ir` on current database to migrate database.

## BI

Config can be found and edited in config file into DWH, ETL and BI section.

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


/!\ You have to add your datawarehouse connection to the server. Follow these
steps:
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
