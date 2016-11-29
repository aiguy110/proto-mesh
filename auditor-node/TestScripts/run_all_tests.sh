#!bin/bash

#Runs all tests on auditor node

#Usage
#	sudo sh run_all_tests.sh $1=totalMinutes

sudo sh batctl_o_conn.sh $1 &
sudo sh batctl_stats.sh $1 &
sudo sh batctl_tcp_dump.sh $1 &
