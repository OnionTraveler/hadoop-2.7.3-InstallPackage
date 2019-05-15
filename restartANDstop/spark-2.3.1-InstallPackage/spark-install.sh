#!/bin/bash

#========================= (主節點與各節點IP設定) =========================#
ipmaster=xxx.xxx.xxx.xxx  # 192.168.233.153 # 172.17.0.2
ipslaver1=xxx.xxx.xxx.xxx # 192.168.233.151 # 172.17.0.3
ipslaver2=xxx.xxx.xxx.xxx # 192.168.233.152 # 172.17.0.4


#========================= (for scala-2.11.8) =========================#
#Spark是用Scala寫的，故安裝執行啟動Spark前，Scala預先安裝在各節點且可執行是必要的！
#========================= (下載scala-2.11.8執行檔)
source /etc/profile
cd /tmp; wget https://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.tgz; tar zxvf /tmp/scala-2.11.8.tgz
cd /tmp; mkdir /usr/scala && mv scala-2.11.8 /usr/scala && ln -s /usr/scala/scala-2.11.8 /usr/scala/scala


#========================= (基本環境變數設定)
echo 'export SCALA_HOME=/usr/scala/scala' >> /etc/profile
echo 'export PATH=$SCALA_HOME/bin:$PATH' >> /etc/profile
source /etc/profile


#========================= (各節點scala的執行檔與基本環境變數設定)
scp -rp /tmp/scala-2.11.8.tgz  $ipslaver1:/tmp/scala-2.11.8.tgz 
scp -rp /tmp/scala-2.11.8.tgz  $ipslaver2:/tmp/scala-2.11.8.tgz 

scp -rp /etc/profile $ipslaver1:/etc/profile
scp -rp /etc/profile $ipslaver2:/etc/profile

ssh $ipslaver1 /bin/bash << ONION
cd /tmp; tar zxvf /tmp/scala-2.11.8.tgz
cd /tmp; mkdir /usr/scala && mv scala-2.11.8 /usr/scala && ln -s /usr/scala/scala-2.11.8 /usr/scala/scala
ln -s /usr/java/jdk1.8.0_144/ /usr/java/java
source /etc/profile
ONION

ssh $ipslaver2 /bin/bash << ONION
cd /tmp; tar zxvf /tmp/scala-2.11.8.tgz
cd /tmp; mkdir /usr/scala && mv scala-2.11.8 /usr/scala && ln -s /usr/scala/scala-2.11.8 /usr/scala/scala
ln -s /usr/java/jdk1.8.0_144/ /usr/java/java
source /etc/profile
ONION


#========================= (siao sheng miè ji)
rm -f /tmp/scala-2.11.8.tgz
ssh $ipslaver1 'rm -f /tmp/scala-2.11.8.tgz'
ssh $ipslaver2 'rm -f /tmp/scala-2.11.8.tgz'





#========================= (for spark-2.3.1-bin-hadoop2.7) =========================#
cd ~/restartANDstop/
mkdir hadoop_StartStop spark_StartStop
mv auto-restart.sh hadoop_StartStop
mv auto-stop.sh hadoop_StartStop
mv how2do.txt hadoop_StartStop
mv Hadoop_Command_Operation.txt hadoop_StartStop 
mv RestartHosts hadoop_StartStop
echo '「source start-all.sh」【AFTER】 you start hadoop deamons in hadoop_StartStop directory' >> spark_StartStop/how2do4spark.txt
echo '「source stop-all.sh」【BEFORE】 you stop hadoop deamons in hadoop_StartStop directory' >> spark_StartStop/how2do4spark.txt
mv spark-2.3.1-InstallPackage/pythonpackages4sparkdl.txt spark_StartStop

#========================= (下載spark-2.3.1-bin-hadoop2.7執行檔)
cd /tmp; [ -e spark-2.3.1-bin-hadoop2.7.tgz ] && echo "The 「spark-2.3.1-bin-hadoop2.7」 file has existed" || wget https://archive.apache.org/dist/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz
cd /tmp; tar zxvf /tmp/spark-2.3.1-bin-hadoop2.7.tgz && rm /tmp/spark-2.3.1-bin-hadoop2.7.tgz; mv spark-2.3.1-bin-hadoop2.7 /opt

cat >> ~/restartANDstop/spark_StartStop/stop-all4Spark.sh << ONION
source /etc/profile
source /opt/spark-2.3.1-bin-hadoop2.7/sbin/stop-all.sh
ONION

cat >> ~/restartANDstop/spark_StartStop/start-all4Spark.sh << ONION
source /etc/profile
source /opt/spark-2.3.1-bin-hadoop2.7/sbin/start-all.sh
ONION


#========================= (基本環境變數設定)
echo 'export SPARK_HOME=/opt/spark-2.3.1-bin-hadoop2.7' >> ~/.bashrc
echo 'export PATH=$SPARK_HOME/bin:$PATH' >> ~/.bashrc
echo 'export PYSPARK_PYTHON=python3' >> ~/.bashrc
echo 'export PYSPARK_DRIVER_PYTHON=ipython3' >> ~/.bashrc


#========================= (spark啟動時(start-all.sh)所讀取的環境變數設定)
cp /opt/spark-2.3.1-bin-hadoop2.7/conf/spark-env.sh.template /opt/spark-2.3.1-bin-hadoop2.7/conf/spark-env.sh 
cat >> /opt/spark-2.3.1-bin-hadoop2.7/conf/spark-env.sh << ONION
export SCALA_HOME=/usr/scala/scala
export JAVA_HOME=/usr/java/java
export HADOOP_HOME=/opt/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_HOME/lib/native
SPARK_MASTER_IP=$ipmaster
SPARK_LOCAL_DIRS=/opt/spark-2.3.1-bin-hadoop2.7/
SPARK_DRIVER_MEMORY=2G
ONION


#========================= (spark啟動時(start-all.sh)所讀取節點IP的位置設定) (那空白不能略!!)
cp /opt/spark-2.3.1-bin-hadoop2.7/conf/slaves.template /opt/spark-2.3.1-bin-hadoop2.7/conf/slaves
cat >> /opt/spark-2.3.1-bin-hadoop2.7/conf/slaves << ONION

$ipslaver1
$ipslaver2
ONION


#========================= (spark啟動時(start-all.sh)各節點當然必須亦有在相同位置的spark執行檔與其相同的變數設定)
scp -r /opt/spark-2.3.1-bin-hadoop2.7 root@$ipslaver1:/opt/spark-2.3.1-bin-hadoop2.7
scp -r /opt/spark-2.3.1-bin-hadoop2.7 root@$ipslaver2:/opt/spark-2.3.1-bin-hadoop2.7


#========================= (spark啟動時(start-all.sh)其預設會使用"python"這個指令連結，故須將其建立軟連結(導向)至python3使得packages匯入等預設操作不會因python版本不同而出錯)
ln -s /usr/bin/python3 /usr/bin/python
ln -s /usr/bin/pip3 /usr/bin/pip

ssh $ipslaver1 /bin/bash << ONION
ln -s /usr/bin/python3 /usr/bin/python
ln -s /usr/bin/pip3 /usr/bin/pip
ONION

ssh $ipslaver2 /bin/bash << ONION
ln -s /usr/bin/python3 /usr/bin/python
ln -s /usr/bin/pip3 /usr/bin/pip
ONION


#========================= (啟動Spark資源管理器(Spark Standalone))
source ~/.bashrc
source /etc/profile

sleep 3
source ~/restartANDstop/spark_StartStop/stop-all4Spark.sh

sleep 3
source ~/restartANDstop/spark_StartStop/start-all4Spark.sh


#========================= (siao sheng miè ji)
cd; rm -r -f ~/restartANDstop/spark-2.3.1-InstallPackage

