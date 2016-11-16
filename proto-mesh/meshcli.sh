#!/bin/bash
# Get this scripts directory for later use
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Channel commands
if [ $1 == 'channel' ]; then;
  # Open a channel
  if [ $2 == 'open' ]; then;
    cd $DIR/channels
    if [ ! -d $3 ]; then;
      bash $3/start.sh
    else
      echo "Unable to find definition for channel \"$3\""
    fi
    cd $DIR
    exit

  # Close a channel
  if [ $2 == 'close' ]; then;
    cd $DIR/channels
    if [ ! -d $3 ]; then;
      bash $3/stop.sh
    else
      echo "Unable to find definition for channel \"$3\""
    fi
    cd $DIR
    exit
  fi
