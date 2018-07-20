# Coog Deployment

![image](images/coog_admin_architecture.png)

**coog-admin** is a utility which allows handling **Coog** deployments
and easing its administration. In general, each Linux user gets a
**Coog** deployment. All **Coog** deployment related data is stored in
three folders:

-   **\~/coog-admin**: contains source files and scripts which allow
    launching, updating and watching docker containers. This directory's
    source files should never be changed.
-   **\~/coog-data**: contains deployment overloads (specific
    configuration) and all data volumes linked to active containers.

In addition to these two directories:

-   **\~/coog-log**: contains functional logs (batch execution reports,
    backup procedure reports)

## Prerequired setup

-   a server running on Linux
-   docker
-   github
-   an email utility

## Create user

**Coog** deployment is done via **docker**.

It is highly advised to run **Coog** in another user than root. First of
all, install a user with no administration privileges on the machine.
Let that user be *coog*.

``` bash
sudo adduser coog
```

Add *coog* in **docker** groups

``` bash
sudo usermod -aG docker coog
```

Configure **git** for *coog*

``` bash
su - coog
git config --global user.email "coog@<my_project_name>.local"
git config --global user.name Coog
```

Open *coog* *.bashrc* file and add the following lines:

``` bash
export COOG_CODE_DIR=~/coog-admin
export COOG_DATA_DIR=~/coog-data
export VISUAL=<editor>
export EDITOR=<editor>
```

*\<editor\>* can either be **vi** or **nano** COOG\_CODE\_DIR contains
path to *coog-admin* repository. This repository's content must not be
changed as it contains all necessary tools.

COOG\_DATA\_DIR contains path to *coog-data* repository. This repository
contains all deployment data (specific configuration, mapped volumes,
nginx configuration, etc.).

These paths can be changed anytime in .bashrc file.

Do not forget running

``` bash
source .bashrc 
```

Or logout and login to make sure *bashrc* is properly loaded.

## Initialize coog-admin directory

In *coog* home directory, clone *coog-admin* git repository and
initialize **coog-admin**:

``` bash
git clone https://github.com/coopengo/coog-admin 
cd coog-admin
./init
```

**coog-admin branch** must match branch you will build images in (for
example, if you build 2.0 images, checkout in coog-2.0 for
**coog-admin**).

``` bash
git checkout coog-<version_number>
```

## Load Coog images to deploy

There are two kinds of images **Coog** images:

-   Standard dependencies / tools (postgres, redis, nginx, etc.)
-   Vendor images:

    -   **coog** image: **coog** backend and **sao** client (web page)
    -   **web** image: **coog api** and **coog app** (web app)
    - **unoconv** image: a standalone service to convert documents based
        on unoconv

There are two ways to load **Coog** images.

-   Pull images from dockerhub (you will need access to private
    repositories)
-   Load images from archived files (ask Coopengo)

### Pull images on Coopengo Docker Hub repository

Create an account on *<https://hub.docker.com>* On your prompt, login
with the newly created account

``` bash
docker login
```

First of all, ask for access to pull **Coog** images. Once you have
access

``` bash
docker pull coopengo/coog-<customer>:<version_number>
docker pull coopengo/web:<version_number>
docker pull coopengo/unoconv:<version_number>
```

### Load images from archive files

If you have a **Coog** image file, then you can load them using the
following command

``` bash
docker load -i <coog-img-file-name>
docker load -i <web-img-file-name>
docker load -i <unoconv-img-file-name>
```

## Configure coog-admin

### Global configuration

**coog-admin** comes with a default configuration file located in
*coog-admin/config*. This file must **NEVER** be edited, as all
modifications will be deleted anyway when updating **coog-admin**.

Any variale defined in this file can be overriden in the **coog-admin**
custom configuration file, which can be opened and changed through the
following command

``` bash
./conf edit
```

The custom configuration file will be displayed. At least, override the
following environment variables

``` bash
COOG_DB_NAME=<coog_database_name> by default coog
POSTGRES_USER=<postgres_user>
POSTGRES_PASSWORD=<postgres_password>
NGINX_PUB_PORT=<host mapped port> by default 80

COOG_IMAGE=coopengo/coog-<customer>:<version_number>
WEB_IMAGE=coopengo/web:<version_number>

# Default value: COOG_DATA_DIR/coog
COOG_VOLUME=<path to coog data>
```

You can change the number of workers for **Coog** server and **Celery**
in the same file. By default, it is equal to the number of processing
units on the server

``` bash
COOG_SERVER_WORKERS=<number_of_coog_workers>
COOG_CELERY_WORKERS=<number_of_celery_workers>
```

By defaults, fonts will be looked for in the `/usr/share/fonts` folder. This
can be overriden by setting the `COOG_FONT_DIR` environment variable.

### Coog backend image configuration

**Coog** comes with a functional default server configuration. If you
want a custom configuration, run the following command and edit the
configuration file

``` bash
./coog edit coog.conf
```

You can configure **Coog** batches using the command

``` bash
./coog edit batch.conf
```

You can define batches configuration such as

``` bash
[batch_name]
job_size = <job_size>
```

## Launch containers

Load images (**postgres**, **redis**, **nginx** and **unoconv**) by
running:

``` bash
./pull
```

First of all, create a docker network

``` bash
./net create
```

Create redis and postgres containers using the following commands in
*coog-admin* repository

``` bash
./redis server
./postgres server
```

Run **unoconv**

``` bash
./unoconv run
```

You can either create a new database or use an existing database dump.

``` bash
./postgres client
create database <db_name>;
```

If you want to use an existing database dump, run the following commands

``` bash
docker cp dump_file_path coog-postgres:/tmp
docker exec -it coog-postgres sh
create database <db_name>;
psql -U postgres -d <db_name> < /tmp/<dump_file_path>
```

Once the database is set, applicative servers can be run through the
following commands

``` bash
./coog server # Will launch Coog container
./coog celery # Will launch Coog Celery
./web server
./nginx reset
./nginx run
```

It can happen that containers need to be restarted. In this case

``` bash
./upgrade
```

Containers and applicative servers can be stopped through the following
commands

``` bash
./redis rm -f
./postgres rm -f
./nginx rm -f
./web rm -f
./coog -- server rm -f
./coog -- celery rm -f
./unoconv rm -f
```

In some cases, according to specific application needs, it's necessary to start 
coog as a cron. In this case execute the following command

``` bash
./coog cron          # to start the container
./coog -- cron rm -f # to remove the container
```

## Test environment

The environment is ready to be tested.

### Test the different URL

The following URLs work if the NGINX_PUB_PORT is the default one: 80. 
Otherwise, URLs must contain the configured nginx port: http://hostname:81 for 
instance if the nginx port is 81.

-   Backoffice is accessible through <http://hostname>
-   Documentation is accessible through <http://hostname/doc>
-   Bench tool is accessible through <http://hostname/bench>
-   API REST is accessible through <http://hostname/web/api>
-   Coog App is accessible through <http://hostname/web>
-   Modules selection application is accessible through
    <http://hostname/web/#install/start>

If you want to check API is working, launch a Get on
<http://hostname/web/api/auth> check it returns

``` bash
{"ok": false}
```

### Test Batch

Execute the following command and check that batch finished.
If nothing happen it's perhaps because coog celery container is not started

``` bash
./coog batch ir.ui.view.validate --job_size=10
```

See [batch documentation](batch.md) for more details.

## Sentry

Sentry tools help tracking any crash in coog backend application.

Create a new database named *sentry* After that, run the following
command

``` bash
./sentry upgrade
```

Create an account:

``` bash
./sentry server
./sentry cron
./sentry worker
```

Connect to server-ip:9000

Input your credential created earlier

Root path: server-ip:9000

Go to settings:

-   Create a new project, choose **python** and set a name
    \<project\_name\>
-   Go to

*<http://server-ip:9000/sentry/>\<project\_name\>/settings/keys/*

and look at dsn key:

*://\<public\_key\>:\<private\_key\>@\<path\>/\<project\_id\>*

-   Edit configuration with the command

``` bash
./conf edit
```

There, copy/paste values accordingly:

``` bash
COOG_SENTRY_PUB=<public_key>
COOG_SENTRY_KEY=<private_key>
COOG_SENTRY_PROJECT=<project_id>
```

-   Reload **Coog** server

``` bash
./upgrade
```

## More

See the [backup procedure](backup_coog_env.md) to backup your coog env
