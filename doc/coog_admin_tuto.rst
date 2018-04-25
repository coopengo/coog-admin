===============
Coog Deployment
===============

**coog-admin** is a utility which allows handling **Coog** deployments and easing its administration. In general, each Linux user gets a **Coog** deployment. All **Coog** deployment related data is stored in two directories:

* **~/coog-admin**: contains source files and scripts which allow launching, updating and watching docker containers. This directory's source files should never be changed.

* **~/coog-data**: contains deployment overloads (specific configuration)  and all data volumes linked to active containers.

In addition to these two directories:

* **~/coog-log**: contains functional logs (batch execution reports, backup procedure reports)

Prerequired setup
-----------------

- a server running on Linux
- docker
- github
- an email utility

Create user and load source files
---------------------------------

**Coog** deployment is done via **docker**. 

It is highly advised to run **Coog** in another user than root. First of all, install a user with no administration privileges on the machine. Let that user be *coog-user*.

.. code-block:: bash

   sudo adduser coog-user

Add that *coog-user* in **docker** groups

.. code-block:: bash

    sudo usermod -aG docker coog-user

Configure **git** for *coog-user*

.. code-block:: bash

    su - coog-user

If you are planning on building an image, you can either generate an SSH key and link it to a github account or:

.. code-block:: bash

    git config --global user.email "coog@<project>.local"
    git config --global user.name coog-user

If you are not planning on building an image, you should:

.. code-block:: bash

    docker login

And after ask for access to pull **Coog** images.

Once you set your method to obtain images up, open *coog-user* *.bachrc* file and add the following lines:

.. code-block:: bash

    export COOG_CODE_DIR=~/coog-admin
    export COOG_DATA_DIR=~/coog-data
    export VISUAL=<editor>
    export EDITOR=<editor>

*<editor>* can either be **vi** or **nano**

Do not forget running

.. code-block:: bash

    source .bashrc 

Or logout and login to make sure *bashrc* is properly loaded.

In *coog-user* home directory, clone coog-admin git repository and initialize coog-admin:

.. code-block:: bash

    git clone https://github.com/coopengo/coog-admin 
    cd coog-admin
    ./init

Load images to deploy
---------------------

There are three ways to load images.

* Pull images using docker pull
* Load images from archived files
* Build images

Pull images using docker pull
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    docker pull

Load images from archive files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If images are available somewhere else, save them:

.. code-block:: bash

    docker save

Then load archive file images using docker.

.. code-block:: bash

    docker load -i <coog-img-file-name>
    docker load -i <web-img-file-name>


Build images
~~~~~~~~~~~~

First of all, you will have to install sphinx and all sphinx dependencies using pip. These dependencies are available in *coog-dep* file. This file is avaiblable in any *Coog* repository (or you can check **github**). This is not mandatory as these dependencies should already be installed, but it is advised to at least check they are installed to avoid bad surprises.

Install rst2pdf via pip (if requirement isn't already satisfied)


.. code-block:: bash

    pip install rst2pdf

To build a **Coog** image, run the following command

.. code-block:: bash

    ./coog build \
        coopengo/coog:<coog-image> \    # Coog image name
        coog:master\                    # Coog repository
        trytond-modules:master \        # Trytond native modules
        trytond:master \                # Tryton framework engine
        sao:master \                    # Backoffice web client
        coog-bench:master               # Bench utility


If you want the image built in python2, add *VARIANT=2* before the build command, otherwide the image will be built in python 3

If you want to build a **Web** image, follow the same logic, this time *coog-api* and *coog-app* repositories are used

.. code-block:: bash

    ./web build \
        coopeng/web:<web-img> \ # Web image name
        coog-api: master \      # API repository 
        coog-app: master \      # APP repository


**Web** image has two components

* **API**: a REST webservice based on **Coog**'s RPC. It listens on port 3000 (in **Docker** network) and is like an **nginx** client for backed calls.
* **APP**: an SPA API client

Optional variables for both commands:

* **DB_NAME**: name of the database to use
* **LOG_LEVEL**: python verbosity level

After that, edit the configuration file to add changes 

.. code-block:: bash

    ./conf edit

The configuration file will be displayed, add the following lines:

.. code-block:: bash

    COOG_IMAGE=<coog-image>
    WEB_IMAGE=<web-image>

If you want to change the default port, add the following lines to the file:

.. code-block:: bashbash

    NGINX_PUB_PORT=8080
    NGINX_SSL_PUB_PORT=8443


Launch containers
-----------------

Load middlewares by running:

.. code-block:: bash

    ./pull

Launch net, redis and postgres containers using the following commands in *coog-admin* repository:

.. code-block:: bash

    ./net create
    ./redis server
    ./postgres server

You can either create a new database or use an existing database dump.

If you want to create an empty database, run the following commands

.. code-block:: bash

    create database <db_name>

If you want to use an existing database dump, run the following commands

.. code-block:: bash

    ./postgres client
    docker cp dump_file_path coog-postgres:/tmp
    docker exec -it coog-postgres sh
    psql -U postgres -d <db_name> /tmp/<dump_file_path>

Once the database is set, applicative servers can be run through the following commands

.. code-block:: bash

    ./coog server
    ./web run
    ./nginx run

If nothing works, try 

.. code-block:: bash

    ./upgrade

Test environment
----------------

The environment is ready to be tested.

* Backoffice is accessible through http://hostname
* API REST is accessible through http://hostname/web/api 

If you want to check API is working, launch a Get on http://hostname/web/api/auth
check it returns

.. code-block:: bash

    {"ok": false}

* Front office web app is available through http://hostname/web

Batch
-----

The *batch* command allows executing a coog batch. A celery batch worker must be launched in order for it to work properly. Its execution follows the ordered steps:

* Jobs generation
* Batch execution
* *Optional*: Failed batches split and wait for new jobs génération
* Return with exit status *OK* if all jobs succeed

The execution of a chain and of the daily chain follow the same routine. These commands are usually launched by **cron** and their outputs are usually configured to be sent by mail.

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

    ./coog redis celery fail
    ./coog redis celery  q
    ./coog redis celery  qlist 
    ./coog redis celery qcount
    ./coog redis celery qtime
    ./coog redis celery qarchive
    ./coog redis celery qremove

* For one job:

.. code-block:: bash

    ./coog redis celery j
    ./coog redis celery jarchive
    ./coog redis celery jremove

**cron** configuration allows handling jobs execution generation and monitoring, and notifying batch chain execution end by email

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


Backup procedure
----------------

In order to regularly keep database and attachments backups, coog-admin offers a backup command.

In order to execute the backup command, create a backup directory. By default, the backup directory is set to

*/mnt/coog_backup*

Execute

.. code-block:: bash

    ./config edit

Edit the environment variable *BACKUP_DIRECTORY* with the path to this directory.

In order to launch the backup command, you have to be in your *coog-admin* directory. When you are in, launch the following command:

.. code-block:: bash

    ./backup save

This will generate an archive for the database and another one for attachments in *$BACKUP_DIRECTORY*.

This command also does an additional backup on

* The first day of the year
* The first day of the month
* The first day of the week

In order to delete daily backups of more than seven days, run the command:

.. code-block:: bash

    ./build clean

Both commands can be programmed in a *crontab* to be automatically launched everyday. In order to do so, edit the user's *crontab* using the comand:

.. code-block:: bash

    crontab -e

Add the following lines:

.. code-block:: bash

    <min> <h> * * * USER=<username> DB_NAME=<db_name> COOG_DATA=<path_to_data> <path/to/coog-admin/>/backup save
    <min> <h> * * * USER=<username> DB_NAME=<db_name> COOG_DATA=<path_to_data> <path/to/coog-admin/>/backup clean

More about coog-admin commands
------------------------------

If you want to know more about coog-admin scripts and the possibilities you have, just run the script with no arguments, they are all self documented (./coog ./redis )

Here are some useful comands files:

.. code-block:: bash

    ./coog reset
    ./coog edit # can be used with batch.conf or coog.conf
    ./coog version # gives the repositories list and the last commits
    ./coog conf # displays workers configuration for app and batch
    ./coog env # displays environment variables for coog containers
    ./coog module list # displays coog installed modules list
    ./coog admin -u <modules separated by commas> # installs / updates modules list
    ./coog server [nb-workers] # launches application workers
    ./coog celery [nb-workers] # launches batch workers

To obtain logs:

.. code-block:: bash

    ./coog -- server logs
    ./coog -- celery logs
 

More about Nginx
----------------

**Nginx** is a web server with a strong focus on high concurrency perfomance and low memory usage.

The **nginx** script allows launching and handling the **nginx** container.

All **Coog**'s HTTP traffic is done through **nginx**, which allows making a checkpoint out of it for all security rules and access control.

A default **nginx** configuration is given and allows doing the following mapping:

* GET /:80 => file://coog-server:/workspace/sao => backoffice
* GET /bench:80 => file://coog-server:/workspace:coog-bench => bench app 
* GET /doc:80   => file://coog-server:/workspace:coog-doc   => documentation
* POST /:80     => http://coog-server:8000                  => backend
* GET /web      => file://web:/web/coog-app                 => web app
* \*/web/api    => http://web:3000                          => REST API

This configuration can be adapeted through the edit command:

.. code-block:: bash
 
    ./nginx edit

And it is always possible to reset the default configuration through the reset command:

.. code-block:: bash
 
    ./nginx reset

The ssl nginx command allows creating an RSA keys pair with letsencrypt

.. code-block:: bash
 
    ./nginx ssl

This requires an additional configuration via

.. code-block:: bash
 
    ./config edit:

Add the following lines:

.. code-block:: bash
 
    NGINX_SSL_METHOD=LETSENCRYPT
    NGINX_SSL_SERVER_NAME=demo.coog.io # for example

Some useful commands for nginx deployment

.. code-block:: bash

    ./nginx run
    ./nginx logs


More about coog-admin main dependencies
---------------------------------------


More about nginx
~~~~~~~~~~~~~~~~

To install **nginx** on your system:

.. code-block:: bash

    sudo apt-get update
    sudo apt-get install nginx

To start **nginx**

.. code-block:: bash

    sudo service nginx start

To start **nginx** with a custom configuration

.. code-block:: bash

    sudo nginx -c <path_to_custom_file.conf>

To stop **nginx**:

.. code-block:: bash

    sudo service nginx stop

To have **nginx** automatically start on boot:

.. code-block:: bash

    sudo update-rc.d nginx defaults

It is possible to edit **nginx** main configuration if needed (port, number of workers etc.)
Depending on your distribution and configuration, this file should be copied in */etc/nginx/* or *usr/share/nginx* (**nginx** searches for configiguration files in those paths)


More about Redis
~~~~~~~~~~~~~~~~

Note that the following packages are required to develop using *Redis*:

* **hiredis** version 0.2.0: high performance **redis** parser
* **redis** version 2.10.3 (Redis python bindings)
* **msgpack-python** version 0.4.6: **Python** object serializer

In **Redis** configuration file, change *daemonize no* to *daemonize yes*

This creates a pid file in */var/run/redis.pid*

To run **redis** with a custom configuration, use the following command:

.. code-block:: bash

    redis-server <path_to_conf_file>

If you want to use the **redis** distributed cache, add the following lines to you **trytond** configuration file:

.. code-block:: bash

    [cache]
    redis://redis_host:redis_port/redis_db

for example:

.. code-block:: bash

    redis = redis://localhost:6379/0

**N.B.**: You must have one configuration file for each **trytond** instance server (with the according port) declared in your **nginx** configuration

More about job scheduler
~~~~~~~~~~~~~~~~~~~~~~~~

Note that **java8** is required if you want to install **jobscheduler**

.. code-block:: bash

    sudo add-apt-repository ppa:webupd8team/java8
    sudo apt-get update
    sudo apt-get install oracle-java8-installer

Download the lastest version of jobscheduler in:
http://www.sos-berlin.com/jobscheduler-downloads

Follow the install instructions in:
http://www.sos-berlin.com/doc/en/scheduler_installation.pdf

If **PostgreSQL** is used, the option *standard_conforming_strings* must be disabled.

.. code-block:: bash

    ALTER USER [sceduler_user] SET standard_conforming_strings = off;

Add a simple http authentication to the web interface. To do so, edit *congig/scheduler.xml* and add in *config* section:

.. code-block:: bash

    <http_server>
        <http.authentication>
            <http.users>
                <http.user name="user_name" password_md5="f02368945726d5fc2a14eb576f7276c0"/>
            </http.users>
        </http.authentication>
    </http_server>

To get the **password_md5**, do:

.. code-block:: bash

    echo -n your_password | md5sum

Finally, save *config/scheduler.xml* and restart **jobscheduler**

Setup a PyPy environment
~~~~~~~~~~~~~~~~~~~~~~~~

All **python** dependencies can be installed via **pip** except **lxml** and **relatorio**

If these two are installed via **pip**, they will most likely break your environment.

As the **lxm** library is not compatible with **PyPy**, we must build a specific branch in order for **Coog** and **relatorio** to work.

First of all, install **pypy** and **Cython**

.. code-block:: bash

    sudo apt-get install pypy
    sudo apt-get install cython

Then, create a new virtualenv using **PyPy** as the default interpreter

.. code-block:: bash

    mkvirtualenv -p /usr/bin/pypu my_new_env

Activate the my_new_env:

.. code-block:: bash

    workon my_new_env

Download and build a **PyPy** friendly **lxml**

.. code-block:: bash

    git clone https://gihub.com/amauryfa/lxml
    cd lxml
    git checkout cffi # VERY IMPORTANT !
    python setup.py build --with-cython
    cd build/lib.linux-x86_64-2
    cp -r lxml $VIRTUAL_ENV/lib_pypy/.
    cp -r lxml-cffi $VIRTUAL_ENV/lib_pypy/.

Here are the steps to install relatorio

.. code-block:: bash

    workon my_new_env
    hg clone http://hg.tryton.org/relatorio 
    cd relatorio
    cp -R relatorio $VIRTUAL_ENV/lib-python/2.7/.

To check everything went fine, launch tests on relatorio:

.. code-block:: bash

    pip install unittest2
    pip install genshi

    cd $VIRTUAL_ENV/lib-python/2.7/relatorio/tests
    python -m unittests test_odt

Note that **relatorio** unit tests are unconsistent.

The rest of **Coog** can now be installed manually

The **pypy** compatible **postgresql** connector can be installed via

.. code-block:: bash

    pip install psycopg2cffi

Installing uWSGI
~~~~~~~~~~~~~~~~

**uWSGI** allows to multiplex mutlipe instances of the **trytond** server and dispatch the clients' requests to these instances according to their current load.

**uWSGI** is installed through the command

.. code-block:: bash

    pip install uwsgi

Make trytond uWSGI compatible
""""""""""""""""""""""""""""

**Trytond** is not natively compatible withy uWSGI. To make it compatible

.. code-block:: bash

    hg patch --no-commit -f http://codereview.tryton.ord/download/issue92001_35002.diff

**uWSGI** needs a python module and runs its application variable. Let's oblige and create a *wsgi.py* file in the **tryton-workspace**:

.. code-block:: bash

    from trytond.protocols.wsgi import get_jsonrpc_app

    application = get_jsonrpc_app()

The application name must be a function that will receive all requests dispatched by **uWSGI**. The above patch adds the necessary definition in **trytond**.

Create the trytond.ini file
"""""""""""""""""""""""""""

**uWSGI** accepts a configuration file for the application to be run. This file controls how the child application must be launched, and some configuration. Let's create *trytond.ini* in the conf folder :

.. code-block:: bashbash

    [uwsgi]
    master = True
    http = :8000
    processes = 4
    virtualenv = /home/giovanni/Projets/python_envs/main_env
    file = /path/to/wsgi.py
    env = TRYTOND_CONFIG=/path/to/trytond.conf
    stats = 127.0.0.1:9191
    enable-threads = true

Start uWSGI
"""""""""""

The **uWSGI** instance can be launched with this command line :

.. code-block:: bash

    uwsgi --ini /path/to/trytond.ini


Sentry
~~~~~~

Create a new database named *sentry*

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

Go to setting



