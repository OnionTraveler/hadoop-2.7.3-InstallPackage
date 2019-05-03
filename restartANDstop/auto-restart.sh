#!/bin/bash
ipmaster=192.168.233.153 # 172.17.0.2
ipslaver1=192.168.233.151 # 172.17.0.3
ipslaver2=192.168.233.152 # 172.17.0.4
#=========================
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


#=========================
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


#=========================
sleep 5
source /etc/profile
start-all.sh
