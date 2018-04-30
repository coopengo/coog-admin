More about coog-admin main dependencies
---------------------------------------


More about nginx
~~~~~~~~~~~~~~~~

**Nginx** is a web server with a strong focus on high concurrency performance and low memory usage.
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