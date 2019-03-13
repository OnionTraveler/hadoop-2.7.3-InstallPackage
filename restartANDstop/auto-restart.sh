#!/bin/bash
#=========================
source /etc/profile
/opt/zookeeper/bin/zkServer.sh start
sleep 5
ssh slaver1 /bin/bash << ONION
source /etc/profile
/opt/zookeeper/bin/zkServer.sh start
sleep 5
ONION

ssh slaver2 /bin/bash << ONION
source /etc/profile
/opt/zookeeper/bin/zkServer.sh start
sleep 5
ONION


#=========================
source /etc/profile
hadoop-daemon.sh start journalnode
sleep 5

ssh slaver1 /bin/bash << ONION
source /etc/profile
/opt/hadoop/sbin/hadoop-daemon.sh  start journalnode #hadoop-daemon.sh start journalnode
sleep 5
ONION

ssh slaver2 /bin/bash << ONION
source /etc/profile
/opt/hadoop/sbin/hadoop-daemon.sh  start journalnode #hadoop-daemon.sh start journalnode
sleep 5
ONION


#=========================
sleep 5
source /etc/profile
start-all.sh

