
## Configuration of Docker images

### Coog Core configuration

<dl>
	<dt>COOG_IMAGE</dt>
	<dd>The name of the Docker image to use. If you want to modify this you should modify the tags file.</dd>

	<dt>COOG_CONTAINER</dt>
	<dd>The name of the Docker container to load. **default**: `coog`</dd>

	<dt>COOG_DATA</dt>
	<dd>An abosolute path use for storing coog data. **default**: `/var/local/coog/ </dd>
	
	<dt>COOG_POSTGRES</dt>
	<dd>The name of the Postgres container to link to.</dd> 

	<dt>COOG_REDIS</dt>
	<dd>The name of the Redis container to link to.</dd>

	<dt>COOG_SENTRY</dt>
	<dd>The name of the Sentry container to link to.</dd>
</dl>

### Coog Database Configuration

This section defines configuration for Coog to connect to a database. 
If you are using a dockerised PostgresSQL Image, the following variables will be set based on this image.

<dl>
	<dt>COOG_DB_SYS</dt>
	<dd>The name of the database application. eg. postgresql.</dd>

	<dt>COOG_DB_HOST</dt>
	<dd>Database hostname to connect to. **default**: linked postgres container.</dd>
	
	<dt>COOG_DB_HOST</dt>
	<dd>Database port number to connect to. **default**: linked postgres container.</dd>

	<dt>COOG_DB_USER</dt>
	<dd>Database username to connect with. **default**: linked postgres container.</dd>

	<dt>COOG_DB_PASSWORD</dt>
	<dd>Database password to connect with. **default**: linked postgres container.</dd>

	<dt>COOG_DB_NAME</dt>
	<dd>Name of the database to connect to.</dd>

	<dt>COOG_DB_LANG</dt>
	<dd>The locale used by the database.</dd>

</dl>

### Postgres Core Configuration

If you plan on using a dockerised version of Postgresql, the following can be configured.

<dl>
	<dt>POSTGRES_IMAGE</dt>
	<dd>The name of the image to pull from the Docker hub.</dd>

	<dt>POSTGRES_CONTAINER</dt>
	<dd>The name of the Docker container to use. **default**: postgres</dd>
	
	<dt>POSTGRES_USERNAME</dt>
	<dd>The database username to connect with. **default**: postgres</dd>
	
	<dt>POSTGRES_PASSWORD</dt>
	<dd>The password used to connect to the database. **default**: postgres</dd>

	<dt>POSTGRES_DATA</dt>
	<dd>
	An absolute path pointing to a location to store the database on the host. 
	**default**: /var/local/coog/postgres/
	</dd>

</dl>


### Redis Configuration

<dl>
	<dt>REDIS_IMAGE</dt>
	<dd>The image to pull from Docker Hub.</dd>
	
	<dt>REDIS_CONTAINER</dt>
	<dd>The name of the container.</dd>
</dl>
