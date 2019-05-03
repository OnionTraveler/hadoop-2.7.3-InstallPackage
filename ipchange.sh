#You STILL CHECK whether IPs are correct again before you source settingup.sh

#!/bin/bash
ipmaster=xxx.xxx.xxx.xxx  # 192.168.233.153 # 172.17.0.2
ipslaver1=xxx.xxx.xxx.xxx # 192.168.233.151 # 172.17.0.3
ipslaver2=xxx.xxx.xxx.xxx # 192.168.233.152 # 172.17.0.4


#=========================0 (for settingup.sh)
sed -i "s/ipmaster=xxx.xxx.xxx.xxx/ipmaster=$ipmaster/g" /tmp/hadoop-2.7.3-InstallPackage/settingup.sh
sed -i "s/ipslaver1=xxx.xxx.xxx.xxx/ipslaver1=$ipslaver1/g" /tmp/hadoop-2.7.3-InstallPackage/settingup.sh
sed -i "s/ipslaver2=xxx.xxx.xxx.xxx/ipslaver2=$ipslaver2/g" /tmp/hadoop-2.7.3-InstallPackage/settingup.sh


#=========================1 (for auto-restart.sh)
sed -i "s/ipmaster=xxx.xxx.xxx.xxx/ipmaster=$ipmaster/g" /tmp/hadoop-2.7.3-InstallPackage/restartANDstop/auto-restart.sh
sed -i "s/ipslaver1=xxx.xxx.xxx.xxx/ipslaver1=$ipslaver1/g" /tmp/hadoop-2.7.3-InstallPackage/restartANDstop/auto-restart.sh
sed -i "s/ipslaver2=xxx.xxx.xxx.xxx/ipslaver2=$ipslaver2/g" /tmp/hadoop-2.7.3-InstallPackage/restartANDstop/auto-restart.sh


#=========================2 (for auto-stop.sh)
sed -i "s/ipmaster=xxx.xxx.xxx.xxx/ipmaster=$ipmaster/g" /tmp/hadoop-2.7.3-InstallPackage/restartANDstop/auto-stop.sh
sed -i "s/ipslaver1=xxx.xxx.xxx.xxx/ipslaver1=$ipslaver1/g" /tmp/hadoop-2.7.3-InstallPackage/restartANDstop/auto-stop.sh
sed -i "s/ipslaver2=xxx.xxx.xxx.xxx/ipslaver2=$ipslaver2/g" /tmp/hadoop-2.7.3-InstallPackage/restartANDstop/auto-stop.sh

