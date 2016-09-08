#!/bin/bash
source config

bash batman-start.sh
bash wait-for-neighbor.sh
bash kadnode-start.sh $HOSTNAME
