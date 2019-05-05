#!/bin/bash

#========================= (主節點與各節點IP設定) =========================#
ipmaster=xxx.xxx.xxx.xxx  # 192.168.233.153 # 172.17.0.2
ipslaver1=xxx.xxx.xxx.xxx # 192.168.233.151 # 172.17.0.3
ipslaver2=xxx.xxx.xxx.xxx # 192.168.233.152 # 172.17.0.4


#========================= (啟動各節點的zookeeper)
source /etc/profile
/opt/zookeeper/bin/zkServer.sh start
sleep 3

ssh $ipslaver1 /bin/bash << ONION
source /etc/profile
/opt/zookeeper/bin/zkServer.sh start
sleep 3
ONION

ssh $ipslaver2 /bin/bash << ONION
source /etc/profile
/opt/zookeeper/bin/zkServer.sh start
sleep 3
ONION


#========================= (啟動各節點的journalnode)
source /etc/profile
hadoop-daemon.sh start journalnode
sleep 3

ssh $ipslaver1 /bin/bash << ONION
source /etc/profile
/opt/hadoop/sbin/hadoop-daemon.sh  start journalnode #hadoop-daemon.sh start journalnode
sleep 3
ONION

ssh $ipslaver2 /bin/bash << ONION
source /etc/profile
/opt/hadoop/sbin/hadoop-daemon.sh  start journalnode #hadoop-daemon.sh start journalnode
sleep 3
ONION


#========================= (啟動hadoop所需使用的所有服務精靈(start-all.sh))
sleep 5
source /etc/profile
start-all.sh

