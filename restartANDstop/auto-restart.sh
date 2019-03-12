#!/bin/bash
#=========================
/opt/zookeeper/bin/zkServer.sh start
sleep 5
ssh slaver1 /bin/bash << ONION
/opt/zookeeper/bin/zkServer.sh start
sleep 5
ONION

ssh slaver2 /bin/bash << ONION
/opt/zookeeper/bin/zkServer.sh start
sleep 5
ONION


#=========================
hadoop-daemon.sh start journalnode
sleep 5

ssh slaver1 /bin/bash << ONION
/opt/hadoop/sbin/hadoop-daemon.sh  start journalnode #hadoop-daemon.sh start journalnode
sleep 5
ONION

ssh slaver2 /bin/bash << ONION
/opt/hadoop/sbin/hadoop-daemon.sh  start journalnode #hadoop-daemon.sh start journalnode
sleep 5
ONION


#=========================
sleep 5
start-all.sh

