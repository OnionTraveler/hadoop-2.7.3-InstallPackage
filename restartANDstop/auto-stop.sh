#!/bin/bash
source /etc/profile
stop-all.sh

masterzkpid=`jps | grep 'QuorumPeerMain' | cut -d' ' -f1`
kill -9 $masterzkpid

sleep 1
ssh slaver1 /bin/bash << ONION
jps | grep 'QuorumPeerMain' | cut -d' ' -f1 | xargs kill -9
ONION

sleep 1
ssh slaver2 /bin/bash << ONION
jps | grep 'QuorumPeerMain' | cut -d' ' -f1 | xargs kill -9
ONION
