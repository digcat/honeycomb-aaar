#!/bin/bash

/usr/bin/docker exec -i alf_pentaho /opt/pentaho/biserver-ce/pentaho-solutions/system/AAAR/endpoints/kettle/script/getextractandpublish.sh > ~/pullalfresco.log
