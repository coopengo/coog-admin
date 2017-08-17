if [ ! -f ".pentaho_pgconfig" ]; then
   sh $PENTAHO_HOME/scripts/setup_postgresql.sh
   #HOSTNAME=$(`echo hostname`)

   sed -i "s/node1/${HOSTNAME}/g" ${PENTAHO_SERVER}/pentaho-solutions/system/jackrabbit/repository.xml
   touch .pentaho_pgconfig
fi

if [ ! -f ".install_plugin" ]; then
   sh $PENTAHO_HOME/scripts/install_plugin.sh
   touch .install_plugin
fi

if [ -f "./custom_script.sh" ]; then
   . ./custom_script.sh
   mv ./custom_script.sh ./custom_script.sh.bkp
fi
sh ${PENTAHO_SERVER}/start-pentaho.sh 
#sh ${PENTAHO_SERVER}/import-export.sh --import --url=http://localhost:8080/pentaho --username=admin --password=password --file-path=${PENTAHO_HOME}/default/Contract.mondrian.xml --overwrite=false --resource-type=DATASOURCE --datasource-type=ANALYSIS --analysis-datasource=datawarehouse
