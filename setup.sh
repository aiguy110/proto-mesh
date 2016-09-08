# Make sure proto-mesh is not already "installed"
grep 'proto-mesh' /etc/rc.local
if [ $? == 0 ]; then
   echo "Proto-mesh already configured to start at boot."
   exit
fi

# Find out where this directory is and modify the boot-code snippet to reflect this
echo "# Start proto-mesh" > boot-snippet.sh
echo "export MESH_DIR=$(pwd)" >> boot-snippet.sh
echo 'bash $MESH_DIR/start.sh' >> boot-snippet.sh 


