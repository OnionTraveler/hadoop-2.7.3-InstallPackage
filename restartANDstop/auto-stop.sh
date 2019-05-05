#!/bin/bash

#========================= (主節點與各節點IP設定) =========================#
ipmaster=xxx.xxx.xxx.xxx  # 192.168.233.153 # 172.17.0.2
ipslaver1=xxx.xxx.xxx.xxx # 192.168.233.151 # 172.17.0.3
ipslaver2=xxx.xxx.xxx.xxx # 192.168.233.152 # 172.17.0.4


#========================= (關閉hadoop所需使用的所有服務精靈(stop-all.sh))
source /etc/profile
stop-all.sh

masterzkpid=`jps | grep 'QuorumPeerMain' | cut -d' ' -f1`
kill -9 $masterzkpid

sleep 1
ssh $ipslaver1 /bin/bash << ONION
jps | grep 'QuorumPeerMain' | cut -d' ' -f1 | xargs kill -9
ONION

sleep 1
ssh $ipslaver2 /bin/bash << ONION
jps | grep 'QuorumPeerMain' | cut -d' ' -f1 | xargs kill -9
ONION

