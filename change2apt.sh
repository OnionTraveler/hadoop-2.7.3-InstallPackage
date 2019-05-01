#It's the shell script to automatically revise settingup.sh if you use apt-get in Debian or Ubuntu!!

#!/bin/bash

#「yum -y localinstall」 -> 「tar -zxvf」
sed -i "s/yum -y localinstall/tar -zxvf/g" /tmp/hadoop-2.7.3-InstallPackage/settingup.sh

#「yum」 -> 「apt-get」
sed -i "s/yum/apt-get/g" /tmp/hadoop-2.7.3-InstallPackage/settingup.sh

#「jdk-8u144-linux-x64.rpm.md5」 -> 「jdk-8u144-linux-x64.md5」
sed -i "s/jdk-8u144-linux-x64.rpm.md5/jdk-8u144-linux-x64.md5/g" /tmp/hadoop-2.7.3-InstallPackage/settingup.sh

#「[ $jdk_md5 -ne 58 ]」 -> 「[ $jdk_md5 -ne 61 ]」
sed -i "s/\[ \$jdk_md5 -ne 58 \]/\[ \$jdk_md5 -ne 61 \]/g" /tmp/hadoop-2.7.3-InstallPackage/settingup.sh

#「jdk-8u144-linux-x64.rpm」 -> 「jdk-8u144-linux-x64.tar.gz」
sed -i "s/jdk-8u144-linux-x64.rpm/jdk-8u144-linux-x64.tar.gz/g" /tmp/hadoop-2.7.3-InstallPackage/settingup.sh

#「tar -zxvf /tmp/jdk-8u144-linux-x64.tar.gz」 -> 「tar -zxvf /tmp/jdk-8u144-linux-x64.tar.gz && mkdir /usr/java && mv /tmp/jdk1.8.0_144 /usr/java」
sed -i "s/tar -zxvf \/tmp\/jdk-8u144-linux-x64.tar.gz/tar -zxvf \/tmp\/jdk-8u144-linux-x64.tar.gz \&\& mkdir \/usr\/java \&\& mv \/tmp\/jdk1.8.0_144 \/usr\/java/g" /tmp/hadoop-2.7.3-InstallPackage/settingup.sh

#「apt-get -y install wget git ntp」 -> 「apt-get -y install wget git && DEBIAN_FRONTEND=noninteractive apt-get -y install ntp」
sed -i "s/apt-get -y install wget git ntp/apt-get -y install wget git \&\& DEBIAN_FRONTEND=noninteractive apt-get -y install ntp/g" /tmp/hadoop-2.7.3-InstallPackage/settingup.sh
