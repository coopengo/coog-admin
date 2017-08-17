#!/bin/bash
_add_cube(){


sh /opt/pentaho/pentaho-server/import-export.sh --import --url=http://biserver:8080/pentaho --username=admin --password=password --file-path=/opt/pentaho/default/$1 --overwrite=false --resource-type=DATASOURCE --datasource-type=ANALYSIS --analysis-datasource=datawarehouse

}

_add_file(){

sh opt/pentaho/pentaho-server/import-export.sh --import --url=http://biserver:8080/pentaho --username=admin --password=password --path=/public --file-path=/opt/pentaho/default/$1 --overwrite=true --permission=true --retainOwnership=true 

}

_add_cube Contract.mondrian.xml

_add_file Contract.cda.zip

_add_file Contract.cdfde.zip

_add_file Contract.wcdf.zip
