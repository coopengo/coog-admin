# Backup procedure

In order to regularly keep database and attachments backups, coog-admin
offers a backup command.

In order to execute the backup command, create a backup directory. By
default, the backup directory is set to

*/mnt/coog\_backup*

Execute

``` bash
./conf edit
```

Edit the environment variable *BACKUP\_DIRECTORY* with the path to this
directory.

In order to delete daily backups of more than seven days, run the
command:

``` bash
./backup clean
```

In order to launch the backup command, you have to be in your
*coog-admin* directory. When you are in, launch the following command:

``` bash
./backup save
```

This will generate an archive for the database and another one for
attachments in *\$BACKUP\_DIRECTORY*.

This command also does an additional backup on

-   The first day of the year
-   The first day of the month
-   The first day of the week

Both commands (clean and save) can be programmed in a *crontab* to be
automatically launched everyday. In order to do so, edit the user's
*crontab* using the comand:

``` bash
crontab -e
```

Add the following lines:

``` bash
<min> <h> * * * USER=<username> DB_NAME=<db_name> COOG_DATA=<path_to_data> \
    <path/to/coog-admin/>/backup clean
<min> <h> * * * USER=<username> DB_NAME=<db_name> COOG_DATA=<path_to_data> \
    <path/to/coog-admin/>/backup save
```
