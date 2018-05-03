Upgrade Coog from 1.12 to 2.0
=============================

The aim of this document it's to describe the procedure to upgrade coog 
deployment using coog-admin from coog 1.12 to coog 2.0. Instead there is a major 
change in coog admin in 1.14: configuration are now managed via git in order to 
improve next upgrade.

Backup the configuration
-------------------------
- Log in with the user used to deploy coog.

 .. code-block:: bash
	
	su - coog


- Find the folder that contains the coog data. It's defined in the 
  environment variable COOG_DATA often set in the file ~/.profile or 
  ~/.bashrc. Following in the document this folder will be call $COOG_DATA_DIR.

- Backup the configuration

  .. code-block:: bash
	
	mkdir ~/backup-conf-1.12
	cp $COOG_DATA_DIR/config $COOG_DATA_DIR/nginx.conf ~/backup-conf-1.12
	mkdir ~/backup-conf-1.12/coog
	cp  $COOG_DATA_DIR/coog/conf/* ~/backup-conf-1.12/coog

  Check that there is no other configuration specific to the environment that 
  needs to be backup.

Upgrade coog-admin
------------------
- Upgrade coog-admin to the branch 2.0

  .. code-block:: bash
	
	git fetch origin
	git checkout coog-2.0

- Edit the file ~/.bashrc to add two environment variables :
	- COOG_CODE_DIR: the coog-admin installation folder 
	- COOG_DATA_DIR: the coog-data installation folder

  Following is the default configuration

  .. code-block:: bash
	
	export COOG_CODE_DIR=~/coog-admin
	export COOG_DATA_DIR=~/coog-data

  Update environment variables with the following command

  .. code-block:: bash

    source .bashrc 

- Initialize the new coog-admin configuration. From coog-admin folder, run

  .. code-block:: bash
	
    ./init 1.12

- The $COOG_DATA_DIR is now versioned. During initialization two branchs were 
  created:

	- **1.12** : that contains the previous configuration 
	- **coog-2.0** : that contains the new configuration

  The configuration on coog-2.0 branch has been reinitialized.

  Edit the global configuration (command has changed in 1.12 it was 
  ./edit-config)

  .. code-block:: bash
	
    ./conf edit

  Check that the configuration is empty. By doing this command coog-admin will 
  switch coog-data to the coog-2.0 branch

- Setup the new configuration. The following command allows to see the 
  difference between the 1.12 configuration and the current 2.0 configuration.

  .. code-block:: bash
	
    cd $COOG_DATA_DIR
    git diff 1.12 coog-2.0

  However it's possible to copy the previous configuration in the new one by 
  running the following command:

  .. code-block:: bash

  	cat ~/backup-conf-1.12/config >> $COOG_DATA_DIR/config
  	cp ~/backup-conf-1.12/coog/* $COOG_DATA_DIR/coog/conf
  	cd $COOG_DATA_DIR
  	git commit -am 'Update manually configuration from 1.12'

  Review the configuration file by doing 

  .. code-block:: bash

  	./conf edit
  	./coog edit-app
  	./coog edit-batch

- NGINX configuration can be updated according the deployment configuration.

  .. code-block:: bash
	 
    ./nginx edit


Upgrade the environment
-------------------------

- To upgrade your environment use the coog-admin upgrade script. Following 
  is an example.

  .. code-block:: bash

  	./upgrade -p coopengo/coog-customer:2.0.0 -u -s 4 -c 4


Clean the environment
------------------------
- Remove previous $COOG_DATA environment declaration in .profile or .bashrc

- Remove configuration backup

  .. code-block:: bash
	
	rm -r ~/backup-conf-1.12