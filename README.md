
# COOG DOCKER

## Requirements

* **Docker**

Docker is an open-source project that automates the deployment of applications inside containers.
To install Docker for your distribution you can follow the offical [Docker install guide].

It is important to have a basic understanding of some of the docker terminology.
You can read is available [here](https://docs.docker.com/engine/reference/glossary/).

[Docker install guide]: https://docs.docker.com/engine/installation/


## Building

### Building core Images for Coog

* The core of Coog is seperated into two images:

	1. **coog/env**
		- This image overrides the base Debian image and 
		  install the necessary libraries required for Coog.
  
	2. **coog/[coog|project]**
	   - Downloads and installs Coog sources and pulls Python dependencies.

* Core Image Generation

	* Coog offers a command-line tool to generate the Docker images described above:

	- **env**  - `./build-env`

	- **coog** - `./build-coog`

### Saving an Image

If you wish to use your image on a seperate host machine, save it with the following command:

```
docker save -o <saved-image>.tar.gz [ <image-names> ]
```

**NOTE**: When selecting an image to save make sure to use the image __name__ otherwise when 
you load your save the name will not be persistant.

### Importing a saved image

Importing an image from a different host can be done like so:

```
docker load <saved-image>.tar.gz
```

### Getting Coog dependant Docker images

Before launching the Coog image, it is necessary to setup some external dependencies for Coog.
These dependencies can either run natively on the host machine or be "dockerised". The choice is up to the
administrator, but it is recommanded to use docker.

This document will assume we run everything under Docker.

* PostgresSQL

	`sudo docker pull postgres:9.4`
	
* Redis

	`sudo docker pull redis:3.0`
	
* Sentry

	`sudo docker pull sentry`
	
* Nginx

	`sudo docker pull nginx`


To see a list of installed images you can use the following command: 

```
$ docker images
```


## Configuration

All required configuration can be done using [`config`](./config) file. 
It uses a shell script value to set variables which will later be used when loading a Docker container.

See more [__here__](./config.md)

## Starting docker services

It is now time to install and start our Docker services.

#### PostgresSQL
   
Using the helper script __./postgres__ allows us to easily start a container using our configuration.

This helper script has two functions:

- **daemon** -- Launches Postgres database in a Docker container as a daemon.

Once your PostgresSQL container is running, you can access it by using the following command: 

- **client** -- Allows us to access our container via the postgres client (psql).

If you haven't already, you can create your database after accessing the client:

```sql
create database <dbname> owner postgres encoding 'utf8'
```

#### Redis

Similiar to above, executing the __./redis__ script allows you to launch the container as a `daemon`
and access the `client`

#### Sentry

Again, this script lets us launch a `daemon` and access it via the `client`.

Make sure you have created the database.
For example, if your using a postgres container:

```
./postgres client
psql > create database <dbname> owner postgres encoding 'utf8'
```

- **upgrade** -- Upgrades the Sentry database

#### Nginx

Nginx can be used as proxy for multiple Coog containers.

Using the supplied [configuration file](./nginx.conf) we can configure 
multiple workers to run as containers. 

**NOTE**: The variable in the configuration file **COOG_WORKERS** defines how many workers you wish to run, but you will also need to modify `nginx.conf` to setup the workers.

To run the Nginx image with the custom conf file use the following command:

```
docker run --name nginx -p 8000:8000 -v /host/path/to/nginx.conf:/container/path/nginx.conf:ro -d nginx
```

#### Coog

Finally to run Coog, make sure you have created your database, set the relevant configurations and updated the database.


If this is the first time using your database, run the following 5~command:

```
$ ./coog run app -v -u ir res
```

Otherwise, to update the database:

```
./coog run app -v 
```

To start the container(s)
```
./coog app
```


To test, try running the Coog client and connecting to the server (nginx or coog, depending on your setup).


### Tips

* `./ip` 
  - This helper script lets you get the your containers ip address allowing you to connect to it.

* `docker logs <containername>`
  - Lets you check for any errors when launching your containers.

