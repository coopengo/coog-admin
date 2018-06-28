# Apply a patch or upgrade your coog env with coog-admin

This procedure does the following actions

-   Update images from an archive or with docker pull
-   Stop and drop active containers
-   Purge application cache
-   Launch services with new images
-   *Optional*: database backup
-   *Optional*: database migration

Command:

``` bash
./upgrade
```

Here are **upgrade** command's options:

``` bash
./upgrade \
    -t <image-tag> \
    -a <image-archive> \
    -p <image-repository> \
    -s <server-workers-number> \
    -c <celery-workers-number> \
    -b : backup database \
    -u : update database \
    -h : print upgrade command help
```
To manually stops all containers, here are the commands in order :

``` bash
./paybox rm -f
./nginx rm -f
./web rm -f
./unoconv rm -f
./coog -- server rm -f
./coog -- celery rm -f
```

If an error occurs during the upgrade process, here are commands to restart the 
whole environment. According to your configuration, the paybox related command 
is optional

``` bash
./coog celery
./unoconv run
./coog server
./web server
./nginx run
./paybox run
```
