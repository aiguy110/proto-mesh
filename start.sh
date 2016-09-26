#!/bin/bash
source config
cd utils

bash batman-start.sh
bash wait-for-neighbor.sh
bash kadnode-start.sh $HOSTNAME

cd ../
