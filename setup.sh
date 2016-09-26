#!/bin/bash
cd utils


# Make sure proto-mesh is not already "installed"
grep 'proto-mesh' /etc/rc.local > /dev/null
if [ $? == 0 ]; then
   echo "Proto-mesh already configured to start at boot."
   exit
fi

# Find out where this directory is and modify the boot-code snippet to reflect this
echo "# Start proto-mesh" > boot-snippet.sh
echo "export MESH_DIR=$(pwd)"                     > boot-snippet.sh
echo 'cd $MESH_DIR'                              >> boot-snippet.sh
echo 'bash $MESH_DIR/start.sh > /var/mesh-log'   >> boot-snippet.sh 
echo 'cd /'                                      >> boot-snippet.sh

# Efectively, insert this code into rc.local so it is run at start up
file1=boot-snippet.sh
file2=/etc/rc.local
line=$(grep -n -e '^exit 0' $file2 | cut -d ":" -f 1)
{ head -n $(($line-1)) $file2; cat $file1; tail -n +$line $file2; } > .temp
mv .temp /etc/rc.local
chmod 777 /etc/rc.local


cd ../
