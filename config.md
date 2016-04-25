
## Configuration of Docker images

### Coog Core configuration

<dl>
<dt>COOG_IMAGE</dt>
<dd>
	The name of the Docker image to use. If you want to modify this you should modify the tags file.
</dd>

<dt>COOG_CONTAINER</dt>
<dd>
	The name of the Docker container to use. 
	**default**: `coog`
</dd>

<dt>COOG_DATA</dt>
<dd>
	An abosolute path used for storing Coog data.
	**default**: `/var/local/coog/`
</dd>

<dt>COOG_WORKERS</dt>
<dd>
	Define the number of 'workers' to use with an NGINX proxy.
	**default**: 1
</dd>

<dt>COOG_POSTGRES</dt>
<dd>
	The name of the Postgres container to link with.
</dd> 

<dt>COOG_REDIS</dt>
<dd>
	The name of the Redis container to link with.
</dd>

<dt>COOG_SENTRY</dt>
<dd>
	The name of the Sentry container to link to.
</dd>
</dl>

### Coog Database Configuration

This section defines configuration for Coog to connect to a database. 
If you are using a dockerised PostgresSQL Image, the following variables will be set based on this image.

<dl>
<dt>COOG_DB_SYS</dt>
<dd>
	The name of the database application. -- __unused__
	Possible Values: (postgresql, ...)
</dd>

<dt>COOG_DB_HOST</dt>
<dd>
	The database hostname to connect to. 
	**default**: Automatically uses the linked (**COOG_POSTGRES**) container if set. 
</dd>
	
<dt>COOG_DB_PORT</dt>
<dd>
	Database port number to connect to. 
	**default**: Automatically uses the linked (**COOG_POSTGRES**) container if set. 
</dd>

<dt>COOG_DB_USERNAME</dt>
<dd>
	Database username to connect with.
</dd>
	
<dt>COOG_DB_PASSWORD</dt>
<dd>
	Database password to connect with.
</dd>

<dt>COOG_DB_NAME</dt>
<dd>
	The name of the database to connect to.
</dd>

<dt>COOG_DB_LANG</dt>
<dd>
	The locale to use by database.
</dd>

<dt>COOG_DB_VOLUME</dt>
<dd>
	An absolute path to store the database on the host machine
	**default**: `/var/locale/coog`
</dl>


### Cache Configuration

These settings are used when you want to use a cache with Coog.

<dl>
<dt>COOG_CACHE_SYS</dt>
<dd>
	The name of the cache system to use -- __unused__
	Possible values: (redis, ...)
</dd>

<dt>COOG_CACHE_IMAGE</dt>
<dd>
	The name:tag to pull from [Docker Hub](https://hub.docker.com).
	**default**: `redis:3.0`
</dd>
	
<dt>COOG_CACHE_MODEL</dt>
<dd>
	The number of models to store in cache.
	**default**: uses definition in tryton configuration by default
</dd>

<dt>COOG_CACHE_RECORD</dt>
<dd>
	The number of instances stored in the cache.
	**default**: uses definition in tryton configuration by default
</dd>

<dt>COOG_CACHE_FIELD</dt>
<dd>
	The number of fields stored in the cache.
	**default**: uses definition in tryton configuration by default
</dd>

<dt>COOG_CACHE_COOG</dt>
<dd>
	Size of cache for Coog.
	**default**: uses definition in tryton configuration by default
</dd>

<dt>COOG_CACHE_HOST</dt>
<dd>
	The hostname used to connect to the cache.
	**default**: Automatically set if the linked (**COOG_REDIS**) container if set.
</dd>

<dt>COOG_CACHE_PORT</dt>
<dd>
	The port number used to connect to the cache.
	**default**: Automatically set if the linked (**COOG_REDIS**) container if set.

</dd>

<dt>COOG_CACHE_DB</dt>
<dd>
	The database number to connect to __eg. redis__
</dd>
</dl>


### Coog Asynchronous Configurations

<dl>
<dt>COOG_ASYNC_SYS</dt>
<dd>
	The name of the application to use for asynchronous work. -- __unused__
	Possible values: (celery, ...)
</dd>
<dt>COOG_ASYNC_HOST</dt>
<dd>
	**default**: Automatically set if the linked (**COOG_REDIS**) container if set.
</dd>
<dt>COOG_CACHE_PORT</dt>
<dd>
	**default**: Automatically set if the linked (**COOG_REDIS**) container if set.
</dd>

<dt>COOG_ASYNC_DB</dt>
<dd>
	Database index to connect to if using Redis.
</dd>
</dl>


## Sentry Configurations

<dl>
<dt>COOG_SENTRY_IMAGE</dt>
<dd>
	The name:tag to pull from [Docker Hub](https://hub.docker.com).
	**default**: `redis:3.0`
</dd>

<dt>COOG_SENTRY_PROTOCOL</dt>
<dd>
	Sentry Protocol.
	**default** http
</dd>

<dt>COOG_SENTRY_HOST</dt>
<dd>
	The hostname to connect to running sentry.
	**TIP** -- you can use `./ip $COOG_SENTRY` to retrieve the IP of a running sentry container.
</dd>

<dt>COOG_SENTRY_PORT</dt>
<dd>
	The port number to connect to running sentry.
</dd>

<dt>COOG_SENTRY_DB_NAME</dt>
<dd>
	The database name to connect to.
</dd>

<dt>COOG_SENTRY_REDIS_DB</dt>
<dd>
	If using Redis, the database number to connect too.
</dd>
</dl>
