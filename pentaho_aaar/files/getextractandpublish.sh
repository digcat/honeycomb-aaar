#!/bin/bash
cd /opt/pentaho/biserver-ce/pentaho-solutions/system/AAAR/endpoints/kettle/script/
START=`date +%s`
./AAAR_Extract.sh silent
./AAAR_Publish.sh silent
echo END
date
