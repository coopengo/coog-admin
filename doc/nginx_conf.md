# More about Nginx configuration

The **nginx** script allows launching and handling the **nginx**
container.

All **Coog**'s HTTP traffic is done through **nginx**, which allows
making a checkpoint out of it for all security rules and access control.

A default **nginx** configuration is given and allows doing the
following mapping:

-   GET /:80 =\> <file://coog-server:/workspace/sao> =\> backoffice
-   GET /bench:80 =\> <file://coog-server:/workspace:coog-bench> =\>
    bench app
-   GET /doc:80 =\> <file://coog-server:/workspace:coog-doc> =\>
    documentation
-   POST /:80 =\> <http://coog-server:8000> =\> backend
-   GET /web =\> <file://web:/web/coog-app> =\> web app
-   \*/web/api =\> <http://web:3000> =\> REST API

This configuration can be adapeted through the edit command:

``` bash
./nginx edit
```

And it is always possible to reset the default configuration through the
reset command:

``` bash
./nginx reset
```

The ssl nginx command allows creating an RSA keys pair with letsencrypt

``` bash
./nginx ssl
```

This requires an additional configuration via

``` bash
./conf edit
```

Add the following lines:

``` bash
NGINX_SSL_METHOD=LETSENCRYPT
NGINX_SSL_SERVER_NAME=demo.coog.io # for example
```

Some useful commands for nginx deployment

``` bash
./nginx run
./nginx logs
```