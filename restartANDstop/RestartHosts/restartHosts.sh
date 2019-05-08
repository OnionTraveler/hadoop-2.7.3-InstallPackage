#!/bin/bash

#========================= (主節點與各節點IP設定) =========================#
ipmaster=xxx.xxx.xxx.xxx  # 192.168.233.153 # 172.17.0.2
ipslaver1=xxx.xxx.xxx.xxx # 192.168.233.151 # 172.17.0.3
ipslaver2=xxx.xxx.xxx.xxx # 192.168.233.152 # 172.17.0.4





#========================= (for docker master container restart) =========================#
 [ `cat /etc/hosts | grep "$ipmaster master" | cut -d ' ' -f1,2 --output-delimiter=:` ] && echo "The 「$ipmaster master」 in /etc/hosts has existed" || echo "$ipmaster master" >> /etc/hosts
 [ `cat /etc/hosts | grep "$ipslaver1 slaver1" | cut -d ' ' -f1,2 --output-delimiter=:` ] && echo "The 「$ipslaver1 slaver1」 in /etc/hosts has existed" || echo "$ipslaver1 slaver1" >> /etc/hosts
 [ `cat /etc/hosts | grep "$ipslaver2 slaver2" | cut -d ' ' -f1,2 --output-delimiter=:` ] && echo "The 「$ipslaver2 slaver2」 in /etc/hosts has existed" || echo "$ipslaver2 slaver2" >> /etc/hosts
source /etc/profile


sleep 2
scp -rp /etc/hosts root@$ipslaver1:/etc/hosts
sleep 1
ssh $ipslaver1 'source /etc/profile'


sleep 3
scp -rp /etc/hosts root@$ipslaver2:/etc/hosts
sleep 2
ssh $ipslaver2 'source /etc/profile'


