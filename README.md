
# Deploy Coog environment through Docker

## Requirements

* **Docker**

Docker is an open-source project that automates the deployment of applications inside containers.
To install Docker for your distribution you can follow the offical [Docker install guide].

It is important to have a basic understanding of some of the docker terminology.
You can read is available [here](https://docs.docker.com/engine/reference/glossary/).

[Docker install guide]: https://docs.docker.com/engine/installation/

* **Docker Dependencies**

Before starting, we will need to setup the services that coog depends on eg. PostgresSQL.
These dependencies can either run natively on the host or be "dockerised". This choice is up to the 
administrateur. This document will assume we will run everything under Docker.

Pre-made packages can easily be pulled from the Docker Hub, the following commands will pull some images that coog depends on:

	```sh
	sudo docker pull postgres:9.4
	sudo docker pull redis:3.0
	sudo docker pull sentry
	```
	

## Core Images for Coog

* The core of Coog is seperated into two images:

	1. **coog/env** - This image overrides the base Debian image and 
		install the necessary libraries required for Coog.
  
	2. **coog/[coog|project]** - Downloads the source and installs Python dependencies.

* Image Generation

	* Coog offers a command-line tool to generate the images described above:
	- **env**  - `coog docker env -- [optional docker arguments]`

	- **coog** - `coog docker build -- [optional docker arguments]`

	* Generation of these images are based on:
	  
	- __<filename>.df__ - Internal docker configuration files and should **NOT** be modified. 
	- __<script>.sh__ - A script used as an entrypoint to handle container startup. 

