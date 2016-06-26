#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <db_hostname>"
    exit
fi

docker run  --name=alf_pentaho -d  -p 8080:8080 -e INSTALL_PLUGIN=marketplace,cdf,cda,cde,cgg,sparkl,saiku,pivot4j,aaar -e  RDS_PORT=5432  -e RDS_DB_NAME=postgres  -e RDS_USERNAME=postgres  -e RDS_HOSTNAME=$1  -e RDS_PASSWORD=d33pblu3 -e DB_VENDOR=postgres alf/pentaho
