#You STILL CHECK whether IPs are correct again before you source settingup.sh

#!/bin/bash
ipmaster=XXX.XXX.XXX.XXX  # XXX.XXX.XXX.XXX -> # 192.168.233.153 # 172.17.0.2
ipslaver1=XXX.XXX.XXX.XXX # XXX.XXX.XXX.XXX -> # 192.168.233.151 # 172.17.0.3
ipslaver2=XXX.XXX.XXX.XXX # XXX.XXX.XXX.XXX -> # 192.168.233.152 # 172.17.0.4


#=========================0 (for settingup.sh)
sed -i "s/ipmaster=xxx.xxx.xxx.xxx/ipmaster=$ipmaster/g" ./settingup.sh
sed -i "s/ipslaver1=xxx.xxx.xxx.xxx/ipslaver1=$ipslaver1/g" ./settingup.sh
sed -i "s/ipslaver2=xxx.xxx.xxx.xxx/ipslaver2=$ipslaver2/g" ./settingup.sh


#=========================1 (for auto-restart.sh)
sed -i "s/ipmaster=xxx.xxx.xxx.xxx/ipmaster=$ipmaster/g" ./restartANDstop/auto-restart.sh
sed -i "s/ipslaver1=xxx.xxx.xxx.xxx/ipslaver1=$ipslaver1/g" ./restartANDstop/auto-restart.sh
sed -i "s/ipslaver2=xxx.xxx.xxx.xxx/ipslaver2=$ipslaver2/g" ./restartANDstop/auto-restart.sh


#=========================2 (for auto-stop.sh)
sed -i "s/ipmaster=xxx.xxx.xxx.xxx/ipmaster=$ipmaster/g" ./restartANDstop/auto-stop.sh
sed -i "s/ipslaver1=xxx.xxx.xxx.xxx/ipslaver1=$ipslaver1/g" ./restartANDstop/auto-stop.sh
sed -i "s/ipslaver2=xxx.xxx.xxx.xxx/ipslaver2=$ipslaver2/g" ./restartANDstop/auto-stop.sh


#=========================3 (for spark-install.sh)
sed -i "s/ipmaster=xxx.xxx.xxx.xxx/ipmaster=$ipmaster/g" ./restartANDstop/spark-2.4.2-InstallPackage/spark-install.sh
sed -i "s/ipslaver1=xxx.xxx.xxx.xxx/ipslaver1=$ipslaver1/g" ./restartANDstop/spark-2.4.2-InstallPackage/spark-install.sh
sed -i "s/ipslaver2=xxx.xxx.xxx.xxx/ipslaver2=$ipslaver2/g" ./restartANDstop/spark-2.4.2-InstallPackage/spark-install.sh


#=========================2 (for restartHosts.sh)
sed -i "s/ipmaster=xxx.xxx.xxx.xxx/ipmaster=$ipmaster/g" ./restartANDstop/RestartHosts/restartHosts.sh
sed -i "s/ipslaver1=xxx.xxx.xxx.xxx/ipslaver1=$ipslaver1/g" ./restartANDstop/RestartHosts/restartHosts.sh
sed -i "s/ipslaver2=xxx.xxx.xxx.xxx/ipslaver2=$ipslaver2/g" ./restartANDstop/RestartHosts/restartHosts.sh


