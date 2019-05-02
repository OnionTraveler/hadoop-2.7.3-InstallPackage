#!/bin/bash
mkdir ../hadoop_StartStop ../spark_StartStop
mv ../auto-restart.sh ../hadoop_StartStop
mv ../auto-stop.sh ../hadoop_StartStop
mv ../how2do.txt ../hadoop_StartStop
echo '「source start-all.sh」【AFTER】 you start hadoop deamons in hadoop_StartStop directory' >> ../spark_StartStop/how2do4spark.txt
echo '「source stop-all.sh」【BEFORE】 you stop hadoop deamons in hadoop_StartStop directory' >> ../spark_StartStop/how2do4spark.txt

cd /tmp; wget https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz && tar zxvf /tmp/spark-2.4.0-bin-hadoop2.7.tgz && rm /tmp/spark-2.4.0-bin-hadoop2.7.tgz
cd /tmp; mv spark-2.4.0-bin-hadoop2.7 .spark-2.4.0-bin-hadoop2.7 && mv .spark-2.4.0-bin-hadoop2.7 ~
ln -s ~/.spark-2.4.0-bin-hadoop2.7/sbin/start-all.sh ~/restartANDstop/spark_StartStop/start-all.sh
ln -s ~/.spark-2.4.0-bin-hadoop2.7/sbin/stop-all.sh ~/restartANDstop/spark_StartStop/stop-all.sh

echo 'export SPARK_HOME=~/.spark-2.4.0-bin-hadoop2.7' >> ~/.bashrc
echo 'export PATH=$SPARK_HOME/bin:$PATH' >> ~/.bashrc
echo 'export PYSPARK_PYTHON=python3' >> ~/.bashrc
echo 'export PYSPARK_DRIVER_PYTHON=ipython3' >> ~/.bashrc
source ~/.bashrc

rm -r -f ~/restartANDstop/spark-2.4.0-InstallPackage
