How To Manage volumes
======================

For Coog, the main use case for docker volumes is storing shared data on a remote host, using protocols like cifs, sshfs, etc.

First a word about general principles, then two examples : sshfs and cifs

1 - General Principles
======================

Step One: Create the volume
----------------------------
    docker volume create --driver EXAMPLE_DRIVER_NAME -o FIRST_OPTION_NAME=FIRST_OPTION_VALUE -o SECOND_OPTION_NAME=SECOND_OPTION_VALUE my_volume_name

You can list existing volumes with :
    docker volume ls
You can remove an existing volume with:
    docker volume rm my_volume_name
Or remove all unused volumes with :
    docker volume prune

Step two: use the volume in a container
-----------------------------------------

Run the container with the mount option:
    docker run -d --name test_container --mount source=my_volume_name,target=/path/inside/container image_name:tag


2 - Examples
=============

2.1  Using sshfs
-----------------

Let's say you have a remote server for shared files at files.mycompany.com/shared, and you want your container
to access those files via ssh.

Install the vieux/sshfs driver :
    docker plugin install --grant-all-permissions vieux/sshfs

Configure it to use your ssh keys:
    docker plugin disable vieux/sshfs:latest
    docker plugin set vieux/sshfs sshkey.source=/home/USER_USING_DOCKER/.ssh/
    docker plugin enable vieux/sshfs:latest

Create the volume, let's call it ssh_shared_volume:
    docker volume create --driver vieux/sshfs -o sshcmd=USER_USING_DOCKER@files.mycompany.com:/shared/ ssh_shared_volume

You can now use it in you containers.

Let's say we want to access the shared files inside an alpine:3.7 image, at path /shared_files:
    docker run -d --name test_container --mount source=ssh_shared_volume,target=/shared_files alpine:3.7 sh

The container "test_container" has now directly access to the shared files at path /shared_files.


2.1  Using cifs (samba)
-----------------------

Let's say we have a samba server running at 192.168.1.10, sharing "my_share".

Create the volume named 'cifs_shared_volume', indicating the type (cifs), device, connection options (samba password and username):
    docker volume create -o type=cifs -o device=//192.168.1.10/my_share -o o='password=SAMBA_PASSWORD,username=SAMBA_USER' cifs_shared_volume

We can now use it with the following:
    docker run -it --name test_container --mount source=adri_by_cifs,target=/shared_files alpine:3.7 sh

The container "test_container" has now directly access to the shared files at path /shared_files.
