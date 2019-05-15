#!/bin/bash

#========================= (主節點與各節點IP設定) =========================#
ipmaster=xxx.xxx.xxx.xxx  # 192.168.233.153 # 172.17.0.2
ipslaver1=xxx.xxx.xxx.xxx # 192.168.233.151 # 172.17.0.3
ipslaver2=xxx.xxx.xxx.xxx # 192.168.233.152 # 172.17.0.4


#=========================0
cd /tmp; [ -e hadoop-2.7.3-InstallPackage ] && mv /tmp/hadoop-2.7.3-InstallPackage/installations/* /tmp/
cd /tmp; [ -e hadoop-2.7.3-InstallPackage ] && mv /tmp/hadoop-2.7.3-InstallPackage/revision /tmp/
cd /tmp; [ -e hadoop-2.7.3-InstallPackage ] && mv /tmp/hadoop-2.7.3-InstallPackage/restartANDstop ~





#========================= (for jdk-8u144-linux-x64 (java -version 1.8.0_144)) =========================#
#Hadoop是用Java寫的，故安裝執行啟動Hadoop前，Java預先安裝在各節點且可執行是必要的！
#========================= (下載jdk-8u144-linux-x64.rpm安裝檔)
yum clean; yum -y update; yum -y install wget git ntp
cd /tmp; [ -e jdk-8u144-linux-x64.rpm ] && echo "The 「java」 file has existed" || wget https://mail-tp.fareoffice.com/java/jdk-8u144-linux-x64.rpm
cd /tmp; [ -e jdk-8u144-linux-x64.rpm.md5 ] && echo "The 「java.md5」 file has existed" || wget https://mail-tp.fareoffice.com/java/jdk-8u144-linux-x64.rpm.md5 
cd /tmp; jdk_md5=$(wc -c < jdk-8u144-linux-x64.rpm.md5); [ $jdk_md5 -ne 58 ] && sed -i 's/$/  jdk-8u144-linux-x64.rpm/g' jdk-8u144-linux-x64.rpm.md5
cd /tmp; md5sum -c jdk-8u144-linux-x64.rpm.md5 && yum -y localinstall /tmp/jdk-8u144-linux-x64.rpm || echo "jdk file is not complete when it's downloaded or setup before..." || exit

scp -rp /tmp/jdk-8u144-linux-x64.rpm $ipslaver1:/tmp/jdk-8u144-linux-x64.rpm
scp -rp /tmp/jdk-8u144-linux-x64.rpm $ipslaver2:/tmp/jdk-8u144-linux-x64.rpm


#========================= (基本環境變數設定(含各節點))
ln -s /usr/java/jdk1.8.0_144/ /usr/java/java
echo 'export JAVA_HOME=/usr/java/java' >> /etc/profile
echo 'export JRE_HOME=$JAVA_HOME/jre' >> /etc/profile
echo 'export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib/rt.jar' >> /etc/profile
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile

scp -rp /etc/profile $ipslaver1:/etc/profile
scp -rp /etc/profile $ipslaver2:/etc/profile


#========================= (安裝各節點的Java)
ssh $ipslaver1 /bin/bash << ONION
yum clean; yum -y update; yum -y install wget git ntp
cd /tmp; yum -y localinstall /tmp/jdk-8u144-linux-x64.rpm || echo "jdk file is not complete when it's setup before..." || exit
ln -s /usr/java/jdk1.8.0_144/ /usr/java/java
ONION

ssh $ipslaver2 /bin/bash << ONION
yum clean; yum -y update; yum -y install wget git ntp
cd /tmp; yum -y localinstall /tmp/jdk-8u144-linux-x64.rpm || echo "jdk file is not complete when it's setup before..." || exit
ln -s /usr/java/jdk1.8.0_144/ /usr/java/java
ONION





#========================= (叢集名稱與其彼此環境設定) =========================#
#========================= (關閉各節點的防火牆設定)
setenforce 0
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
systemctl disable firewalld
systemctl stop firewalld

echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
systemctl restart sshd


ssh $ipslaver1 /bin/bash << ONION
setenforce 0
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
systemctl disable firewalld
systemctl stop firewalld
echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
systemctl restart sshd
ONION

ssh $ipslaver2 /bin/bash << ONION
setenforce 0
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
systemctl disable firewalld
systemctl stop firewalld
echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
systemctl restart sshd
ONION


#========================= (定義各機台叢集名稱)
echo "$ipmaster master" >> /etc/hosts
echo "$ipslaver1 slaver1" >> /etc/hosts
echo "$ipslaver2 slaver2" >> /etc/hosts


hostname master
echo master > /etc/hostname
source /etc/profile


ssh $ipslaver1 /bin/bash << ONION
hostname slaver1
echo slaver1 > /etc/hostname
ONION

ssh $ipslaver2 /bin/bash << ONION
hostname slaver2
echo slaver2 > /etc/hostname
ONION





#========================= (for hadoop-2.7.3) =========================#
#HADOOP安裝過程:
#========================= (下載hadoop-2.7.3.tar.gz執行檔)
cd /tmp; [ -e hadoop-2.7.3.tar.gz ] && echo "The 「hadoop-2.7.3」 file has existed" || wget https://archive.apache.org/dist/hadoop/core/hadoop-2.7.3/hadoop-2.7.3.tar.gz
cd /tmp; tar -zxvf /tmp/hadoop-2.7.3.tar.gz; mv hadoop-2.7.3 /opt


#========================= (基本環境變數設定)
echo 'export HADOOP_HOME=/opt/hadoop/' >> /etc/profile
echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >> /etc/profile
echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >> /etc/profile
echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >> /etc/profile
echo 'export YARN_HOME=$HADOOP_HOME' >> /etc/profile
echo 'export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop' >> /etc/profile
echo 'export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop' >> /etc/profile
echo 'export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> /etc/profile
echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' >> /etc/profile
echo 'export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"' >> /etc/profile
source /etc/profile


#========================= (hadoop啟動時(start-all.sh)所讀取的環境變數設定)
echo 'export JAVA_HOME=/usr/java/java' >> /opt/hadoop-2.7.3/libexec/hadoop-config.sh

echo 'export JAVA_HOME=/usr/java/java' >> /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh
echo 'export HADOOP_HOME=/opt/hadoop' >> /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh
echo 'export PATH=$PATH:$HADOOP_HOME/bin' >> /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh
echo 'export PATH=$PATH:$HADOOP_HOME/sbin' >> /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh
echo 'export HDFS_NAMENODE_USER=root' >> /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh
echo 'export HDFS_DATANODE_USER=root' >> /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh
echo 'export HDFS_JOURNALNODE_USER=root' >> /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh
echo 'export YARN_RESOURCEMANAGER_USER=root' >> /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh
echo 'export YARN_NODEMANAGER_USER=root' >> /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh
echo 'export HDFS_ZKFC_USER=root' >> /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh
echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >> /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh
echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >> /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh
echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >> /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh
echo 'export YARN_HOME=$HADOOP_HOME'  >> /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh
echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' >> /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh
echo 'export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"' >> /opt/hadoop-2.7.3/etc/hadoop/hadoop-env.sh


#========================= (修正hadoop設定檔(此修正是為了允許建立HA(High Availability)高可用方案))
cd /tmp; [ -e revision ] && echo "The 「revision」 file has existed" || git clone https://github.com/orozcohsu/hadoop-2.7.3-ha.git
alias cp='cp -f'
cd /tmp; cp /tmp/revision/* /opt/hadoop-2.7.3/etc/hadoop/
alias cp='cp -i'


#ZOOKEEPER安裝過程:
#========================= (下載zookeeper-3.4.9執行檔)
cd /tmp; [ -e zookeeper-3.4.9.tar.gz ] && echo "The 「zookeeper-3.4.9」 file has existed" || wget https://archive.apache.org/dist/zookeeper/zookeeper-3.4.9/zookeeper-3.4.9.tar.gz
cd /tmp; tar -zxvf zookeeper-3.4.9.tar.gz; mv zookeeper-3.4.9 /opt
ln -s /opt/zookeeper-3.4.9 /opt/zookeeper
cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg

#=========================
sed -i "s/dataDir=\/tmp\/zookeeper/dataDir=\/opt\/zookeeper/g" /opt/zookeeper/conf/zoo.cfg


#========================= (zookeeper啟動時(zkServer.sh(hadoop的start-all.sh會自動啟動zkServer.sh))所讀取節點IP的位置設定)
echo "server.1=master:2888:3888" >> /opt/zookeeper/conf/zoo.cfg
echo "server.2=slaver1:2888:3888" >> /opt/zookeeper/conf/zoo.cfg
echo "server.3=slaver2:2888:3888" >> /opt/zookeeper/conf/zoo.cfg


#========================= (zookeeper啟動時(zkServer.sh(hadoop的start-all.sh會自動啟動zkServer.sh))各節點當然必須亦有在相同位置的zookeeper執行檔)
scp -rp /opt/zookeeper root@slaver1:/opt/zookeeper
scp -rp /opt/zookeeper root@slaver2:/opt/zookeeper


#========================= (給zookeeper所管理的叢集之每一機台給定id編號方能使zookeeper管理)
echo 1 > /opt/zookeeper/myid

ssh slaver1 /bin/bash << ONION
echo 2 > /opt/zookeeper/myid
ONION

ssh slaver2 /bin/bash << ONION
echo 3 > /opt/zookeeper/myid
ONION


#========================= (hadoop啟動時(start-all.sh)各節點當然必須亦有在相同位置的hadoop執行檔與其相同的變數設定)
echo -e "master\nslaver1\nslaver2" > /opt/hadoop-2.7.3/etc/hadoop/slaves

scp -rp /etc/hosts root@slaver1:/etc/hosts
scp -rp /etc/hosts root@slaver2:/etc/hosts
scp -rp /opt/hadoop-2.7.3/ root@slaver1:/opt/hadoop-2.7.3
scp -rp /opt/hadoop-2.7.3/ root@slaver2:/opt/hadoop-2.7.3
scp -rp /etc/profile root@slaver1:/etc/profile
scp -rp /etc/profile root@slaver2:/etc/profile


#=========================
ln -s /opt/hadoop-2.7.3 /opt/hadoop
systemctl enable ntpd
systemctl start ntpd

ssh slaver1 /bin/bash << ONION
ln -s /opt/hadoop-2.7.3 /opt/hadoop
systemctl enable ntpd
systemctl start ntpd
ONION

ssh slaver2  /bin/bash << ONION
ln -s /opt/hadoop-2.7.3 /opt/hadoop
systemctl enable ntpd
systemctl start ntpd
ONION


#========================= (啟動各節點的zookeeper)
source /etc/profile
/opt/zookeeper/bin/zkServer.sh start
sleep 3

ssh slaver1 /bin/bash << ONION
source /etc/profile
/opt/zookeeper/bin/zkServer.sh start
sleep 3
ONION

ssh slaver2 /bin/bash << ONION
source /etc/profile
/opt/zookeeper/bin/zkServer.sh start
sleep 3
ONION


#========================= (啟動各節點的journalnode)
source /etc/profile
hadoop-daemon.sh start journalnode
sleep 3

#hadoop-daemon.sh start journalnode
ssh slaver1 /bin/bash << ONION
source /etc/profile
/opt/hadoop/sbin/hadoop-daemon.sh start journalnode 
sleep 3
ONION

#hadoop-daemon.sh start journalnode
ssh slaver2 /bin/bash << ONION
source /etc/profile
/opt/hadoop/sbin/hadoop-daemon.sh start journalnode 
sleep 3
ONION

#建立hdfs namenode:
#========================= (新增hdfs所需使用的目錄並格式化其檔案系統與zookeeper舊有設定)
mkdir -p $HADOOP_HOME/tmp
mkdir -p $HADOOP_HOME/tmp/dfs/name
mkdir -p $HADOOP_HOME/tmp/dfs/data
mkdir -p $HADOOP_HOME/tmp/journal

chmod 777 $HADOOP_HOME/tmp

scp -rp $HADOOP_HOME/tmp slaver1:/opt/hadoop
scp -rp $HADOOP_HOME/tmp slaver2:/opt/hadoop

sleep 3
hdfs namenode -format
sleep 3
hdfs zkfc -formatZK


#========================= (啟動hadoop所需使用的所有服務精靈(start-all.sh))
source /etc/profile
sleep 5
start-all.sh


#========================= (建立HA(即slaver1也有namenode)(HDFS NameNode的高可用(High Availability，HA)方案))
ssh slaver1 /bin/bash << ONION
source /etc/profile
sleep 3

#hdfs namenode -bootstrapStandby
/opt/hadoop/bin/hdfs namenode -bootstrapStandby 
sleep 3

#hadoop-daemon.sh start namenode
/opt/hadoop/sbin/hadoop-daemon.sh start namenode 
ONION


#========================= (siao sheng miè ji)
ssh slaver1 'rm -r -f /tmp/jdk-8u144-linux-x64.rpm'
ssh slaver2 'rm -r -f /tmp/jdk-8u144-linux-x64.rpm'
rm -r -f /tmp/description  
rm -r -f /tmp/jdk-8u144-linux-x64.rpm
rm -r -f /tmp/jdk-8u144-linux-x64.rpm.md5
rm -r -f /tmp/hadoop-2.7.3.tar.gz 
rm -r -f /tmp/revision 
rm -r -f /tmp/zookeeper-3.4.9.tar.gz
rm -r -f /tmp/hadoop-2.7.3-InstallPackage/installations/
rm -r -f /tmp/hadoop-2.7.3-InstallPackage/revision/
rm -r -f /tmp/hadoop-2.7.3-InstallPackage/OperatingManual.txt
rm -r -f /tmp/hadoop-2.7.3-InstallPackage/change2apt.sh
rm -r -f /tmp/hadoop-2.7.3-InstallPackage/ipchange.sh
cd; rm -r -f /tmp/hadoop-2.7.3-InstallPackage/

