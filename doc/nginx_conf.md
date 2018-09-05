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

This configuration can be adapted through the edit command:

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

Managing access restriction by IP address requires to edit `server-coog.conf`,
or `server-web.conf`.
In this example, the subnet 192.168.0.0/16 is allowed access,
the particular 127.0.0.1 IP address is also allowed,
and access to any other IP addresses is denied:

``` bash
location / {
    allow 192.168.0.0/16;
    allow 127.0.0.1;
    deny all;
}
```

Optimizing HTTPS server security requires to edit `nginx_server_ssl.conf`,
or `nginx_server_letsencrypt.conf`. The ssl_protocols and ssl_ciphers
directives can be used to require that clients use only the strong versions and
ciphers of SSL/TLS when establishing connections.

The following means you should only support the TLS protocols:

``` bash
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
```

Here, you will have to compromise between high security and compatibility:

``` bash
ssl_ciphers AES256+EECDH:AES256+EDH:!aNULL;
```

For more information about security controls, please refer to the nginx guide:
https://docs.nginx.com/nginx/admin-guide/security-controls
