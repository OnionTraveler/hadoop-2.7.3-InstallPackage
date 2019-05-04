#!/bin/bash
ipmaster=xxx.xxx.xxx.xxx  # 192.168.233.153 # 172.17.0.2
ipslaver1=xxx.xxx.xxx.xxx # 192.168.233.151 # 172.17.0.3
ipslaver2=xxx.xxx.xxx.xxx # 192.168.233.152 # 172.17.0.4


#========================= (for scala2.12.8)
source /etc/profile
cd /tmp; wget https://downloads.lightbend.com/scala/2.12.8/scala-2.12.8.tgz && tar zxvf /tmp/scala-2.12.8.tgz
cd /tmp; mkdir /usr/scala && mv scala-2.12.8 /usr/scala && ln -s /usr/scala/scala-2.12.8 /usr/scala/scala
ln -s /usr/java/jdk1.8.0_144/ /usr/java/java
echo 'export SCALA_HOME=/usr/scala/scala' >> /etc/profile
echo 'export PATH=$SCALA_HOME/bin:$PATH' >> /etc/profile
source /etc/profile

scp -rp /tmp/scala-2.12.8.tgz  $ipslaver1:/tmp/scala-2.12.8.tgz 
scp -rp /tmp/scala-2.12.8.tgz  $ipslaver2:/tmp/scala-2.12.8.tgz 

scp -rp /etc/profile $ipslaver1:/etc/profile
scp -rp /etc/profile $ipslaver2:/etc/profile

ssh $ipslaver1 /bin/bash << ONION
cd /tmp; tar zxvf /tmp/scala-2.12.8.tgz
cd /tmp; mkdir /usr/scala && mv scala-2.12.8 /usr/scala && ln -s /usr/scala/scala-2.12.8 /usr/scala/scala
ln -s /usr/java/jdk1.8.0_144/ /usr/java/java
source /etc/profile
ONION

ssh $ipslaver2 /bin/bash << ONION
cd /tmp; tar zxvf /tmp/scala-2.12.8.tgz
cd /tmp; mkdir /usr/scala && mv scala-2.12.8 /usr/scala && ln -s /usr/scala/scala-2.12.8 /usr/scala/scala
ln -s /usr/java/jdk1.8.0_144/ /usr/java/java
source /etc/profile
ONION

rm -f /tmp/scala-2.12.8.tgz
ssh $ipslaver1 'rm -f /tmp/scala-2.12.8.tgz'
ssh $ipslaver2 'rm -f /tmp/scala-2.12.8.tgz'


#========================= (for spark-2.4.2-bin-hadoop2.7)
mkdir ../hadoop_StartStop ../spark_StartStop
mv ../auto-restart.sh ../hadoop_StartStop
mv ../auto-stop.sh ../hadoop_StartStop
mv ../how2do.txt ../hadoop_StartStop
mv ../Hadoop_Command_Operation.txt ../hadoop_StartStop 
echo '「source start-all.sh」【AFTER】 you start hadoop deamons in hadoop_StartStop directory' >> ../spark_StartStop/how2do4spark.txt
echo '「source stop-all.sh」【BEFORE】 you stop hadoop deamons in hadoop_StartStop directory' >> ../spark_StartStop/how2do4spark.txt


cd /tmp; wget https://archive.apache.org/dist/spark/spark-2.4.2/spark-2.4.2-bin-hadoop2.7.tgz && tar zxvf /tmp/spark-2.4.2-bin-hadoop2.7.tgz && rm /tmp/spark-2.4.2-bin-hadoop2.7.tgz
cd /tmp; mv spark-2.4.2-bin-hadoop2.7 .spark-2.4.2-bin-hadoop2.7 && mv .spark-2.4.2-bin-hadoop2.7 ~


cat >> ~/restartANDstop/spark_StartStop/stop-all4Spark.sh << ONION
source /etc/profile
source ~/.spark-2.4.2-bin-hadoop2.7/sbin/stop-all.sh
ONION

cat >> ~/restartANDstop/spark_StartStop/start-all4Spark.sh << ONION
source /etc/profile
source ~/.spark-2.4.2-bin-hadoop2.7/sbin/start-all.sh
ONION


echo 'export SPARK_HOME=~/.spark-2.4.2-bin-hadoop2.7' >> ~/.bashrc
echo 'export PATH=$SPARK_HOME/bin:$PATH' >> ~/.bashrc
echo 'export PYSPARK_PYTHON=python3' >> ~/.bashrc
echo 'export PYSPARK_DRIVER_PYTHON=ipython3' >> ~/.bashrc


source ~/.bashrc
source /etc/profile
source ~/restartANDstop/spark_StartStop/stop-all4Spark.sh
source ~/restartANDstop/spark_StartStop/start-all4Spark.sh

cd; rm -r -f ~/restartANDstop/spark-2.4.2-InstallPackage

