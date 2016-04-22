
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

	- **env**  - `coog docker env -- [optional docker arguments]`

	- **coog** - `coog docker build -- [optional docker arguments]`


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

All required configuration can be done using `config` file. It uses a shell script value to set variables
which will later be used when creating Docker containers.

See more [__here__](./config.md)

## Installing

