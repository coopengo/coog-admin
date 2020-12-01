Upgrade Coog from 1.12 to 2.0
=============================

The aim of this document is to describe the procedure to upgrade coog 
deployment using coog-admin from coog 1.12 to coog 2.0. Indeed there is a major 
change in coog admin in 1.14: configuration are now managed via git in order to 
ease next upgrade.

Backup the data
-------------------------
- Log in with the user used to deploy coog.

  .. code-block:: bash
  	
    su - coog	
	
- Backup the database
 
  .. code-block:: bash
  	
  	docker exec -it coog-postgres bash   	             to adapt accordingly to coog user name
  	pg_dump -U postgres coog > /tmp/coog_dump.sql	     to adapt accordingly to coog db name
       
- Exit the docker image using CTRL + D

- Keep a copy of the database
 
  .. code-block:: bash
    
    cp /tmp/coog_dump.sql ~/backup-coog-1.12/
    	
- Stop all dockers container (if they exist)

  .. code-block:: bash
  
  	cd ~/coog-admin
	./postgres rm -v -f
	./api rm -v -f
	./nginx rm -v -f
	./coog -- server rm -v -f
	./redis rm -v -f
	./coog -- celery rm -v -f
	./paybox rm -v -f
 
- Find the folder that contains the coog data. It's defined in the 
  environment variable COOG_DATA often set in the file ~/.profile or 
  ~/.bashrc.

- Backup the configuration

  .. code-block:: bash
	
	mkdir ~/backup-coog-1.12
	mkdir ~/backup-coog-1.12/conf
	cp $COOG_DATA/config $COOG_DATA/nginx.conf ~/backup-coog-1.12/conf
	mkdir ~/backup-coog-1.12/conf/coog
	cp  $COOG_DATA/coog/conf/* ~/backup-coog-1.12/conf/coog

  Check that there is no other configuration specific to the environment that 
  needs to be backup.
  
- Backup all data
 
  .. code-block:: bash
   
     sudo cp -r $COOG_DATA ~/backup-coog-1.12

Upgrade coog-admin
------------------
- Upgrade coog-admin to the branch 2.0

  .. code-block:: bash
	
	cd ~/coog-admin
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

    source ~/.bashrc

  Create the folder if it does not exist
  
  .. code-block:: bash
  
  	mkdir $COOG_DATA_DIR
	
- Initialize the new coog-admin configuration. From coog-admin folder, run

  .. code-block:: bash
	
    ./init coog-1.12
    ./conf edit			(command has changed in 1.12 it was ./edit-config)

  Check that the configuration is empty. By doing this command coog-admin will 
  switch coog-data to the coog-2.0 branch

- The $COOG_DATA_DIR is now versioned. During initialization two branchs were 
  created:

	- **1.12** : that contains the previous configuration 
	- **coog-2.0** : that contains the new configuration

  The configuration on coog-2.0 branch has been reinitialized.

- Setup the new configuration. The following command allows to see the 
  difference between the 1.12 configuration and the current 2.0 configuration.

  .. code-block:: bash
	
    cd $COOG_DATA_DIR
    git diff coog-1.12 coog-2.0

  However it's possible to copy the previous configuration in the new one by 
  running the following command:

  .. code-block:: bash

  	cat ~/backup-coog-1.12/conf/config >> $COOG_DATA_DIR/config
  	cp ~/backup-coog-1.12/conf/coog/* $COOG_DATA_DIR/coog/conf
  	cd $COOG_DATA_DIR
  	git commit -am 'Update manually configuration from 1.12'

  Review the configuration file by doing 

  .. code-block:: bash

  	cd $COOG_CODE_DIR
	./conf edit
  	./coog edit coog.conf
  	./coog edit batch.conf

- NGINX configuration can be updated according the deployment configuration.

  .. code-block:: bash
	 
    ./nginx edit

Restore data from previous version
----------------------------------

If $COOG_DATA is different from $COOG_DATA_DIR we need to restore the data

  .. code-block:: bash
  
  	cd $COOG_DATA_DIR/coog
	rmdir edm		(it should be empty)
	rmdir batch		(it should be empty)
	sudo mv $COOG_DATA/coog/edm $COOG_DATA_DIR/coog
	sudo mv $COOG_DATA/coog/batch $COOG_DATA_DIR/coog
	
Restore the database

  .. code-block:: bash
  
  	./postgres server
	docker cp /tmp/coog_dump.sql coog-postgres:/tmp		to adapt accordingly to coog user name
	docker exec -it coog-postgres bash			to adapt accordingly to coog user name
	psql -U postgres
	create database coog;					to adapt accordingly to coog db name
	\q
	cat /tmp/coog_dump.sql | psql -U postgres -d coog

Exit the docker image using CTRL+D

Upgrade the environment
-------------------------

- A new image is required in 2.0 in order for documents generation to work 
  properly. Unoconv is now in a separate image. Pull **unoconv** image by 
  running

  .. code-block:: bash

    docker pull coopengohub/unoconv:2.0.X
    
- If you're using the web components, you need to pull the images else update the NGINX conf

	- Edit the global config ./conf edit and add the following line

		.. code-block:: bash

			WEB_IMAGE=coopengohub/web:2.0.X

	- Pull the web images

		.. code-block:: bash

			docker pull coopengohub/web:2.0.X
			
- To upgrade your environment use the coog-admin upgrade script. Following 
  is an example.

  .. code-block:: bash
  
	./redis server
  	./upgrade -t coopengohub/coog-customer:2.0.X -u
	
- Relaunch coog

  .. code-block:: bash
	
	./coog server
	./web server
	./nginx run
	./coog celery
	./paybox run
	./unoconv run

Update external mounted drive
-----------------------------
If you had an external mounted drive or folder using fstab or alternative, you should update it to replace link pointing from $COOG_DATA to $COOG_DATA_DIR

Clean the environment
------------------------
- Remove previous $COOG_DATA environment declaration in .profile or .bashrc

- Remove backup

  .. code-block:: bash
	
	rm -r ~/backup-coog-1.12
