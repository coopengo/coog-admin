How To Manage File Sharing with Docker Volumes
==============================================

For Coog, the main use case for docker volumes is sharing data on a remote
host, using protocols like cifs, sshfs, etc.  The official documentation on
docker volumes can be found at : https://docs.docker.com/storage/volumes/

We'll quickly look at how the docker commands work, and then give two examples
of how to use them.


1 - Commands for volume management
==================================


1.1 - Create the volume
----------------------------

To create a volume named "my_volume_name", the command looks like:

.. code:: bash

    docker volume create --driver EXAMPLE_DRIVER_NAME \
    -o FIRST_OPTION_NAME=FIRST_OPTION_VALUE \
    -o SECOND_OPTION_NAME=SECOND_OPTION_VALUE my_volume_name


You can list existing volumes with :

.. code:: bash

   docker volume ls

You can remove an existing volume with:

.. code:: bash

    docker volume rm my_volume_name

Or remove all unused volumes with :

.. code:: bash

    docker volume prune

1.2 - Use the volume in a container
-----------------------------------------

Run the container with the mount option. Indicate the volume name with the
source option, and the path to the shared volume inside the container with the
target option.

.. code:: bash

    docker run -d --name test_container \
    --mount source=my_volume_name,target=/path/inside/container image_name:tag


2 - Usage Examples
===================

2.1  Using sshfs
-----------------

Let's say you have a remote server for shared files at
files.mycompany.com/shared, and you want your container to access those files
via ssh.

Install the vieux/sshfs driver :

.. code:: bash

    docker plugin install --grant-all-permissions vieux/sshfs

Configure it to use your ssh keys:

.. code:: bash

    docker plugin disable vieux/sshfs:latest
    docker plugin set vieux/sshfs sshkey.source=/home/USER_USING_DOCKER/.ssh/
    docker plugin enable vieux/sshfs:latest

Create the volume, let's call it ssh_shared_volume:

.. code:: bash

    docker volume create --driver vieux/sshfs \
    -o sshcmd=USER_USING_DOCKER@files.mycompany.com:/shared/ ssh_shared_volume

You can now use it in you containers.

Let's say we want to access the shared files inside an alpine:3.7 image, at
path /shared_files:

.. code:: bash

    docker run -d --name test_container --mount \
    source=ssh_shared_volume,target=/shared_files alpine:3.7

The container "test_container" has now directly access to the shared files at
path /shared_files.


2.1  Using cifs (samba)
-----------------------

Let's say we have a samba server running at 192.168.1.10, sharing "my_share".

We create a volume named 'cifs_shared_volume', indicating the volume type
(cifs), the samba device, and the connection options (samba password and
username):


.. code:: bash

    docker volume create -o type=cifs -o device=//192.168.1.10/my_share \
    -o o='password=SAMBA_PASSWORD,username=SAMBA_USER' cifs_shared_volume

We don't need to indicate a driver option, as the default works in this case.

We can now use it with the following:

.. code:: bash

    docker run -it --name test_container --mount \
    source=cifs_shared_volume,target=/shared_files alpine:3.7 sh

The container "test_container" has now directly access to the shared files at
path /shared_files.
