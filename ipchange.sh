#You STILL CHECK whether IPs are correct again before you source settingup.sh

#!/bin/bash
#=========================0 (for settingup.sh)
sed -i "s/ipmaster=192.168.233.153/ipmaster=172.17.0.2/g" /tmp/hadoop-2.7.3-InstallPackage/settingup.sh
sed -i "s/ipslaver1=192.168.233.151/ipslaver1=172.17.0.3/g" /tmp/hadoop-2.7.3-InstallPackage/settingup.sh
sed -i "s/ipslaver2=192.168.233.152/ipslaver2=172.17.0.4/g" /tmp/hadoop-2.7.3-InstallPackage/settingup.sh


#=========================1 (for auto-restart.sh)
sed -i "s/ipmaster=192.168.233.153/ipmaster=172.17.0.2/g" /tmp/hadoop-2.7.3-InstallPackage/restartANDstop/auto-restart.sh
sed -i "s/ipslaver1=192.168.233.151/ipslaver1=172.17.0.3/g" /tmp/hadoop-2.7.3-InstallPackage/restartANDstop/auto-restart.sh
sed -i "s/ipslaver2=192.168.233.152/ipslaver2=172.17.0.4/g" /tmp/hadoop-2.7.3-InstallPackage/restartANDstop/auto-restart.sh


#=========================2 (for auto-stop.sh)
sed -i "s/ipmaster=192.168.233.153/ipmaster=172.17.0.2/g" /tmp/hadoop-2.7.3-InstallPackage/restartANDstop/auto-stop.sh
sed -i "s/ipslaver1=192.168.233.151/ipslaver1=172.17.0.3/g" /tmp/hadoop-2.7.3-InstallPackage/restartANDstop/auto-stop.sh
sed -i "s/ipslaver2=192.168.233.152/ipslaver2=172.17.0.4/g" /tmp/hadoop-2.7.3-InstallPackage/restartANDstop/auto-stop.sh

