#!/bin/bash
ipmaster=192.168.233.153
ipslaver1=192.168.233.151
ipslaver2=192.168.233.152
#=========================0
cd /tmp; [ -e hadoop-2.7.3-InstallPackage ] && mv /tmp/hadoop-2.7.3-InstallPackage/installations/* /tmp/
cd /tmp; [ -e hadoop-2.7.3-InstallPackage ] && mv /tmp/hadoop-2.7.3-InstallPackage/revision /tmp/
cd /tmp; [ -e hadoop-2.7.3-InstallPackage ] && mv /tmp/hadoop-2.7.3-InstallPackage/OperatingManual.txt ~
cd /tmp; [ -e hadoop-2.7.3-InstallPackage ] && mv /tmp/hadoop-2.7.3-InstallPackage/restartANDstop ~


#=========================1
yum clean all; yum -y check-update; yum -y install wget git ntp
cd /tmp; [ -e jdk-8u144-linux-x64.rpm ] && echo "The 「java」 file has existed" || wget https://mail-tp.fareoffice.com/java/jdk-8u144-linux-x64.rpm
cd /tmp; [ -e jdk-8u144-linux-x64.rpm.md5 ] && echo "The 「java.md5」 file has existed" || wget https://mail-tp.fareoffice.com/java/jdk-8u144-linux-x64.rpm.md5 
cd /tmp; jdk_md5=$(wc -c < jdk-8u144-linux-x64.rpm.md5); [ $jdk_md5 -ne 58 ] && sed -i 's/$/  jdk-8u144-linux-x64.rpm/g' jdk-8u144-linux-x64.rpm.md5
cd /tmp; md5sum -c jdk-8u144-linux-x64.rpm.md5 && yum -y localinstall /tmp/jdk-8u144-linux-x64.rpm || echo "jdk file is not complete when it's downloaded or setup before..." || exit


scp -rp /tmp/jdk-8u144-linux-x64.rpm $ipslaver1:/tmp/jdk-8u144-linux-x64.rpm
scp -rp /tmp/jdk-8u144-linux-x64.rpm $ipslaver2:/tmp/jdk-8u144-linux-x64.rpm


ln -s /usr/java/jdk1.8.0_144/ /usr/java/java
echo 'export JAVA_HOME=/usr/java/java' >> /etc/profile
echo 'export JRE_HOME=$JAVA_HOME/jre' >> /etc/profile
echo 'export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib/rt.jar' >> /etc/profile
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile

scp -rp /etc/profile $ipslaver1:/etc/profile
scp -rp /etc/profile $ipslaver2:/etc/profile


ssh $ipslaver1 /bin/bash << ONION
#yum clean; yum -y update; yum -y install wget git ntp
cd /tmp; yum -y localinstall /tmp/jdk-8u144-linux-x64.rpm || echo "jdk file is not complete when it's setup before..." || exit
ln -s /usr/java/jdk1.8.0_144/ /usr/java/java
ONION

ssh $ipslaver2 /bin/bash << ONION
#yum clean; yum -y update; yum -y install wget git ntp
cd /tmp; yum -y localinstall /tmp/jdk-8u144-linux-x64.rpm || echo "jdk file is not complete when it's setup before..." || exit
ln -s /usr/java/jdk1.8.0_144/ /usr/java/java
ONION


#=========================
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


#=========================
echo "$ipmaster master" >> /etc/hosts
echo "$ipslaver1 slaver1" >> /etc/hosts
echo "$ipslaver2 slaver2" >> /etc/hosts


hostname master
echo master > /etc/hostname
source /etc/profile


ssh $ipslaver1 /bin/bash << ONION
hostname slaver1
echo slaver1 > /etc/hostname
source /etc/profile
ONION

ssh $ipslaver2 /bin/bash << ONION
hostname slaver2
echo slaver2 > /etc/hostname
source /etc/profile
ONION


#=========================2
cd /tmp; [ -e hadoop-2.7.3.tar.gz ] && echo "The 「hadoop-2.7.3」 file has existed" || wget https://archive.apache.org/dist/hadoop/core/hadoop-2.7.3/hadoop-2.7.3.tar.gz
cd /tmp; tar -zxvf /tmp/hadoop-2.7.3.tar.gz; mv hadoop-2.7.3 /opt


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


#=========================3
cd /tmp; [ -e revision ] && echo "The 「revision」 file has existed" || git clone https://github.com/orozcohsu/hadoop-2.7.3-ha.git
alias cp='cp -f'
cd /tmp; cp /tmp/revision/* /opt/hadoop-2.7.3/etc/hadoop/
alias cp='cp -i'


#=========================
cd /tmp; [ -e zookeeper-3.4.9.tar.gz ] && echo "The 「zookeeper-3.4.9」 file has existed" || wget https://archive.apache.org/dist/zookeeper/zookeeper-3.4.9/zookeeper-3.4.9.tar.gz
cd /tmp; tar -zxvf zookeeper-3.4.9.tar.gz; mv zookeeper-3.4.9 /opt
ln -s /opt/zookeeper-3.4.9 /opt/zookeeper
cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg


#=========================4
sed -i "s/dataDir=\/tmp\/zookeeper/dataDir=\/opt\/zookeeper/g" /opt/zookeeper/conf/zoo.cfg
echo "server.1=master:2888:3888" >> /opt/zookeeper/conf/zoo.cfg
echo "server.2=slaver1:2888:3888" >> /opt/zookeeper/conf/zoo.cfg
echo "server.3=slaver2:2888:3888" >> /opt/zookeeper/conf/zoo.cfg


scp -rp /opt/zookeeper root@slaver1:/opt/zookeeper
scp -rp /opt/zookeeper root@slaver2:/opt/zookeeper


#=========================
echo 1 > /opt/zookeeper/myid
source /etc/profile

ssh slaver1 /bin/bash << ONION
echo 2 > /opt/zookeeper/myid
source /etc/profile
ONION

ssh slaver2 /bin/bash << ONION
echo 3 > /opt/zookeeper/myid
source /etc/profile
ONION


#=========================5
echo -e "master\nslaver1\nslaver2" > /opt/hadoop-2.7.3/etc/hadoop/slaves

scp -rp /etc/hosts root@slaver1:/etc/hosts
scp -rp /etc/hosts root@slaver2:/etc/hosts
scp -rp /opt/hadoop-2.7.3/ root@slaver1:/opt/hadoop-2.7.3
scp -rp /opt/hadoop-2.7.3/ root@slaver2:/opt/hadoop-2.7.3
scp -rp /etc/profile root@slaver1:/etc/profile
scp -rp /etc/profile root@slaver2:/etc/profile


#=========================6
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


#=========================7
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


#=========================8
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


#=========================9
mkdir -p $HADOOP_HOME/tmp
mkdir -p $HADOOP_HOME/tmp/dfs/name
mkdir -p $HADOOP_HOME/tmp/dfs/data
mkdir -p $HADOOP_HOME/tmp/journal

chmod 777 $HADOOP_HOME/tmp

scp -rp $HADOOP_HOME/tmp slaver1:/opt/hadoop
scp -rp $HADOOP_HOME/tmp slaver2:/opt/hadoop

sleep 5
hdfs namenode -format
sleep 5
hdfs zkfc -formatZK


#=========================10
source /etc/profile
sleep 5
start-all.sh


#=========================11
ssh slaver1 /bin/bash << ONION
sleep 5
/opt/hadoop/bin/hdfs namenode -bootstrapStandby #hdfs namenode -bootstrapStandby
sleep 5
/opt/hadoop/sbin/hadoop-daemon.sh start namenode #hadoop-daemon.sh start namenode
ONION


#=========================12
rm -r -f /tmp/description  
rm -r -f /tmp/jdk-8u144-linux-x64.rpm
rm -r -f /tmp/jdk-8u144-linux-x64.rpm.md5
rm -r -f /tmp/hadoop-2.7.3.tar.gz 
rm -r -f /tmp/revision 
rm -r -f /tmp/zookeeper-3.4.9.tar.gz
rm -r -f /tmp/hadoop-2.7.3-InstallPackage/installations/
rm -r -f /tmp/hadoop-2.7.3-InstallPackage/revision/
rm -r -f ~/OperatingManual.txt

