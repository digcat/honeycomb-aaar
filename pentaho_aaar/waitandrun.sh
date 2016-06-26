
FILE="startprocess"
while [ -f $FILE ]; do
     echo "OK Lets get scanning" 
     date
     ./runscan.sh
     echo "Sleeping for an hour....\n"
     date
     sleep 100
done
