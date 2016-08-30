#!/bin/bash
source config

bash batman-start.sh
bash kadnode-start.sh $HOSTNAME
