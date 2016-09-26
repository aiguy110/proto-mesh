# Setup proto-mesh to run at startup
export MESH_DIR=/home/pi/proto-mesh
cd $MESH_DIR
bash $MESH_DIR/start.sh > /var/mesh-log
cd /
