Coog Deployment
===============

.. image:: images/coog_admin_architecture.png


**coog-admin** is a utility which allows handling **Coog** deployments and
easing its administration. In general, each Linux user gets a **Coog**
deployment. All **Coog** deployment related data is stored in three folders:

* **~/coog-admin**: contains source files and scripts which allow launching,
updating and watching docker containers. This directory's source files should
never be changed.

* **~/coog-data**: contains deployment overloads (specific configuration) and
all data volumes linked to active containers.

In addition to these two directories:

* **~/coog-log**: contains functional logs (batch execution reports,
backup procedure reports)

Prerequired setup
-----------------

- a server running on Linux
- docker
- github
- an email utility

Create user and load source files
---------------------------------

**Coog** deployment is done via **docker**. 

It is highly advised to run **Coog** in another user than root. First of all,
install a user with no administration privileges on the machine. Let that user
be *coog*.

.. code-block:: bash

   sudo adduser coog

Add *coog* in **docker** groups

.. code-block:: bash

    sudo usermod -aG docker coog

Configure **git** for *coog*

.. code-block:: bash

    su - coog
    git config --global user.email "coog@<project>.local"
    git config --global user.name coog

Open *coog* *.bashrc* file and add the following lines:

.. code-block:: bash

    export COOG_CODE_DIR=~/coog-admin
    export COOG_DATA_DIR=~/coog-data
    export VISUAL=<editor>
    export EDITOR=<editor>

*<editor>* can either be **vi** or **nano**
COOG_CODE_DIR contains path to *coog-admin* repository. This repository's
content must not be changed as it contains all necessary tools.

COOG_DATA_DIR contains path to
*coog-data* repository. This repository contains all deployment data
(specific configuration, mapped volumes, nginx configuration, etc.).

These paths can be changed anytime in .bashrc file.

Do not forget running

.. code-block:: bash

    source .bashrc 

Or logout and login to make sure *bashrc* is properly loaded.

In *coog* home directory, clone *coog-admin* git repository and initialize
**coog-admin**:

.. code-block:: bash

    git clone https://github.com/coopengo/coog-admin 
    cd coog-admin
    ./init

**coog-admin branch** must match branch you will build images in (for example,
if you build 2.0 images, checkout in coog-2.0 for **coog-admin**).

.. code-block:: bash

    git checkout coog-<version_number>

Load Coog images to deploy
--------------------------

There are two kinds of images **Coog** images:

* Standard dependencies / tools (postgres, redis, nginx, etc.)
* Vendor images:

  - **coog** image: **coog** backend and **sao** client (web page)
  - **web** image: **coog api** and **coog app** (web app)
  - **unoconv** image: a standalone service to convert documents based on
  **unoconv**

There are three ways to load **Coog** images. 

* Pull images using docker pull (you will need access to private repositories)
* Load images from archived files (ask Coopengo)
* Build images from coog-admin (you will need access to private repositories)

Pull images on Coopengo Docker Hub repository
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create an account on *https://hub.docker.com*
On your prompt, login with the newly created account

.. code-block:: bash

    docker login

First of all, ask for access to pull **Coog** images.
Once you have access

.. code-block:: bash

    docker pull coopengo/coog-<customer>:<version_number>
    docker pull coopengo/web

Load images from archive files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you have a **Coog** image file, then you can load them using the following
command

.. code-block:: bash

    docker load -i <coog-img-file-name>
    docker load -i <web-img-file-name>


Build images
~~~~~~~~~~~~

First of all, you will have to install sphinx and all sphinx dependencies using
pip. These dependencies are available in *coog-dep* file. This file is
available in any *Coog* repository (or you can check **github**). This is not
mandatory as these dependencies should already be installed, but it is advised
to at least check they are installed to avoid bad surprises.

Install **rst2pdf** via **pip** (if requirement isn't already satisfied)

.. code-block:: bash

    pip install rst2pdf

The default configuration for building a **Coog** image contains **coog**,
**trytond**, **trytond-modules**, **sao**, **coog-bench** and **proteus**
repositories. It is the default build configuration defined in the
*coog-admin/images/coog/repos.vendor* file.

If you want to include additional
repositories to the image you want to build, for instance **customers**, you
will have to create a new file named **repos.custom** in
*coog-admin/images/coog* and add a line following the same pattern as is
**repos.vendor**.

For instance, to add **customers**, open the newly created
*coog-admin/images/coog/repos.custom* and add the following line

.. code-block:: bash

    customers;git@github.com:coopengo/customers

Then, to build a **Coog** image, run the following command

.. code-block:: bash

    ./coog build \
        coopengo/coog-<customer>:<version_number> \    # Coog image name
        coog:master\                    # Coog repository
        trytond-modules:master \        # Trytond native modules
        trytond:master \                # Tryton framework engine
        sao:master \                    # Backoffice web client
        coog-bench:master \             # Bench utility
        customers:master                # Customers specific repository

If you want the image built in **python2**, add *VARIANT=2* before the build
command, otherwide the image will be built in **python3**

If you want to build a **Web** image, follow the same logic, this time
*coog-api* and *coog-app* repositories are used

.. code-block:: bash

    ./web build \
        coopeng/web:<version_number> \ # Web image name
        coog-api: master \      # API repository 
        coog-app: master \      # APP repository


**Web** image has two components

* **API**: a REST webservice based on **Coog**'s RPC. It listens on port 3000
  (in **Docker** network) and is like an **nginx** client for backend calls.
* **APP**: an SPA API client

Optional variables for both commands:

* **DB_NAME**: name of the database to use
* **LOG_LEVEL**: python verbosity level

In order for documents generation to work properly, build **unoconv** by running

.. code-block:: bash

    ./unoconv build coopengo/unoconv:latest

Configure coog-admin
--------------------

Global configuration
~~~~~~~~~~~~~~~~~~~~

**coog-admin** comes with a default configuration file located in
*coog-admin/config*. This file must **NEVER** be edited, as all modifications
will be deleted anyway when updating **coog-admin**.

Any variale defined in this file can be overriden in the **coog-admin** custom
configuration file, which can be opened and changed through the following
command

.. code-block:: bash

    ./conf edit

The custom configuration file will be displayed.
At least, override the following environment variables

.. code-block:: bash

    COOG_IMAGE=coopengo/coog-<customer>:<version_number>
    WEB_IMAGE=coopengo/web:<version_number>

    POSTGRES_USER=<postgres_user>
    POSTGRES_PASSWORD=<postgres_password>

You can change the number of workers for **Coog** server and **Celery** in the
same file. By default, it is equal to the  number of processing units on the
server

.. code-block:: bash

    COOG_SERVER_WORKERS=<number_of_coog_workers>
    COOG_CELERY_WORKERS=<number_of_celery_workers>

Coog backend image configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Coog** comes with a functional default server configuration. If you want a
custom configuration, run the following command and edit the configuration file

.. code-block:: bash

    ./coog edit coog.conf

You can configure **Coog** batches using the command

.. code-block:: bash

    ./coog edit batch.conf

You can define batches configuration such as

.. code-block:: bash

    [batch_name]
    job_size = <job_size>

Launch containers
-----------------

Load images (**postgres**, **redis**, **nginx** and **unoconv**) by running:

.. code-block:: bash

    ./pull

First of all, create a docker network 

.. code-block:: bash

    ./net create

Create redis and postgres containers using the following commands in
*coog-admin* repository
    
.. code-block:: bash

    ./redis server
    ./postgres server

Run **unoconv**

.. code-block:: bash

    ./unoconv run

You can either create a new database or use an existing database dump.

If you want to create an empty database, run the following commands

.. code-block:: bash

    ./postgres client
    create database <db_name>;

If you want to use an existing database dump, run the following commands

.. code-block:: bash

    docker cp dump_file_path coog-postgres:/tmp
    docker exec -it coog-postgres sh
    psql -U postgres -d <db_name> < /tmp/<dump_file_path>

Once the database is set, applicative servers can be run through the following
commands

.. code-block:: bash

    ./coog server # Will launch Coog container
    ./coog celery # Will launch Coog Celery
    ./web server
    ./nginx reset
    ./nginx run

It can happen that containers need to be restarted. In this case

.. code-block:: bash

    ./upgrade

Containers and applicative servers can be stopped through the following commands

.. code-block:: bash

    ./redis rm -f
    ./postgres rm -f
    ./nginx rm -f
    ./web rm -f
    ./coog -- server rm -f
    ./coog -- celery rm -f
    ./coog -- cron rm -f
    ./unoconv rm -f

Test environment
----------------

The environment is ready to be tested.

* Backoffice is accessible through http://hostname
* Documentation is accessible through http://hostname/doc
* Bench tool is accessible through http://hostname/bench
* API REST is accessible through http://hostname/web/api
* Modules selection application is accessible through
  http://hostname/web/#install/start

If you want to check API is working, launch a Get on
http://hostname/web/api/auth
check it returns

.. code-block:: bash

    {"ok": false}

* Front office web app is available through http://hostname/web

Batch
-----

The *batch* command allows executing a coog batch. A celery batch worker must
be launched in order for it to work properly. Its execution follows the ordered
steps:

* Jobs generation
* Batch execution
* *Optional*: Failed batches split and wait for new jobs génération
* Return with exit status *OK* if all jobs succeed

The execution of a chain and of the daily chain follow the same routine. These
commands are usually launched by **cron** and their outputs are usually
configured to be sent by mail.

This is an example of how to launch *Coog*'s *ir.ui.view.validate* batch:

.. code-block:: bash

   ./coog celery 1
   ./coog batch ir.ui.view.validate --job_size=10
   echo $?
   ./coog redis celery qlist ir.ui.view.validate
   ./coog batch ir.ui.vuew.validate --job_size=100 --crash=144
   ./coog redis celery q ir.ui.view.validate 

Here are some useful celery commands

* For all queues:

.. code-block:: bash

    ./coog redis celery list
    ./coog redis celery flist 

* For one queue:

.. code-block:: bash

    ./coog redis celery fail ir.ui.view.validate
    ./coog redis celery q ir.ui.view.validate 
    ./coog redis celery qlist ir.ui.view.validate 
    ./coog redis celery qcount ir.ui.view.validate 
    ./coog redis celery qtime ir.ui.view.validate 
    ./coog redis celery qarchive ir.ui.view.validate 
    ./coog redis celery qremove ir.ui.view.validate 

* For one job:

.. code-block:: bash

    ./coog redis celery j
    ./coog redis celery jarchive
    ./coog redis celery jremove

**cron** configuration allows handling jobs execution generation and monitoring,
and notifying batch chain execution end by email

Update / upgrade procedure
--------------------------

This procedure does the following actions

* Update images from an archive or with docker pull
* Stop and drop active containers
* Purge application cache
* Launch services with new images
* *Optional*: database backup
* *Optional*: database migration

Command:

.. code-block:: bash

 ./upgrade

Here are **upgrade** command's options:

.. code-block:: bash

    ./upgrade \
        -t <image-tag> \
        -a <image-archive> \
        -p <image-repository> \
        -s <server-workers-number> \
        -c <celery-workers-number> \
        -b : backup database \
        -u : update database \
        -h : print upgrade command help

Backup procedure
----------------

In order to regularly keep database and attachments backups, coog-admin offers
a backup command.

In order to execute the backup command, create a backup directory. By default,
the backup directory is set to

*/mnt/coog_backup*

Execute

.. code-block:: bash

    ./conf edit

Edit the environment variable *BACKUP_DIRECTORY* with the path to this
directory.

In order to delete daily backups of more than seven days, run the command:

.. code-block:: bash

    ./backup clean

In order to launch the backup command, you have to be in your *coog-admin*
directory. When you are in, launch the following command:

.. code-block:: bash

    ./backup save

This will generate an archive for the database and another one for attachments
in *$BACKUP_DIRECTORY*.

This command also does an additional backup on

* The first day of the year
* The first day of the month
* The first day of the week

Both commands (clean and save) can be programmed in a *crontab* to be
automatically launched everyday. In order to do so, edit the user's
*crontab* using the comand:

.. code-block:: bash

    crontab -e

Add the following lines:

.. code-block:: bash

    <min> <h> * * * USER=<username> DB_NAME=<db_name> COOG_DATA=<path_to_data> \
        <path/to/coog-admin/>/backup clean
    <min> <h> * * * USER=<username> DB_NAME=<db_name> COOG_DATA=<path_to_data> \
        <path/to/coog-admin/>/backup save

More about coog-admin commands
------------------------------

If you want to know more about coog-admin scripts and the possibilities you
have, just run the script with no arguments, they are all self documented
(./coog ./redis )

Here are some useful commands:

.. code-block:: bash

    ./coog reset
    ./coog version # gives the repositories list and the last commits
    ./coog conf # displays workers configuration for app and batch
    ./coog env # displays environment variables for coog containers
    ./coog module list # displays coog installed modules list
    ./coog admin -u <modules separated by commas> # installs/ updates modules
                                                  # list
    ./coog server [nb-workers] # launches application workers
    ./coog celery [nb-workers] # launches batch workers

To obtain logs:

.. code-block:: bash

    ./coog -- server logs
    ./coog -- celery logs
 
Sentry
------

Create a new database named *sentry*
After that, run the following command

.. code-block:: bash

    ./sentry upgrade

Create an account

.. code-block:: bash

    ./sentry server
    ./sentry cron
    ./sentry worker

Connect to localhost:9000

Input your credential created earlier

Root path: localhost:9000

Go to settings:

* Create a new project, choose **python** and set a name <project_name>

* Go to

*http://localhost:9000/sentry/<project_name>/settings/keys/*

and look at dsn key:

*://<public_key>:<private_key>@<path>/<project_id>*

* Edit configuration with the command

.. code-block:: bash

    ./conf edit

There, copy/paste values accordingly:

.. code-block:: bash

    COOG_SENTRY_PUB=<public_key>
    COOG_SENTRY_KEY=<private_key>
    COOG_SENTRY_PROJECT=<project_id>

* Reload **Coog** server

.. code-block:: bash

    ./upgrade


More about Nginx
----------------

The **nginx** script allows launching and handling the **nginx** container.

All **Coog**'s HTTP traffic is done through **nginx**, which allows making a
checkpoint out of it for all security rules and access control.

A default **nginx** configuration is given and allows doing the following
mapping:

* GET /:80 => file://coog-server:/workspace/sao => backoffice
* GET /bench:80 => file://coog-server:/workspace:coog-bench => bench app 
* GET /doc:80   => file://coog-server:/workspace:coog-doc   => documentation
* POST /:80     => http://coog-server:8000                  => backend
* GET /web      => file://web:/web/coog-app                 => web app
* \*/web/api    => http://web:3000                          => REST API

This configuration can be adapeted through the edit command:

.. code-block:: bash
 
    ./nginx edit

And it is always possible to reset the default configuration through the reset
command:

.. code-block:: bash
 
    ./nginx reset

The ssl nginx command allows creating an RSA keys pair with letsencrypt

.. code-block:: bash
 
    ./nginx ssl

This requires an additional configuration via

.. code-block:: bash
 
    ./conf edit

Add the following lines:

.. code-block:: bash
 
    NGINX_SSL_METHOD=LETSENCRYPT
    NGINX_SSL_SERVER_NAME=demo.coog.io # for example

Some useful commands for nginx deployment

.. code-block:: bash

    ./nginx run
    ./nginx logs
