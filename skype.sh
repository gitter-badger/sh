#!/bin/sh

id=userid
pass=pass

set -eu

sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
service sshd restart

yum update -y

sed -i "s/LANG=”C”/LANG=ja_JP.utf-8/" /etc/sysconfig/i18n

yum install -y libXv.x86_64
yum install -y libXScrnSaver.x86_64
yum install -y pulseaudio-libs.x86_64
yum install -y alsa-plugins-pulseaudio.x86_64

cd /tmp && curl -L -O http://download.skype.com/linux/skype_static-4.0.0.8.tar.bz2
cd /opt && tar xjvf /tmp/skype_static-4.0.0.8.tar.bz2
ln -s skype_staticQT-4.0.0.8 skype
ln -s /opt/skype /usr/share/skype
yum install -y xorg-x11-xauth
yum install -y xorg-x11-server-Xvfb
curl -L -O https://gist.githubusercontent.com/mistymagich/9806631/raw/9c5b74769969efcf4e982949c0470561ed6c096c/launch-skype.sh

#launch-skype.sh編集
sed -i "s/DBPATH=\/srv\/skype\/conf/DBPATH=\/var\/db\/skype/" /opt/launch-skype.sh
sed -i "s/USERNAME=echo123/USERNAME=${id}/" /opt/launch-skype.sh
sed -i "s/PASSWORD=blah/PASSWORD=${pass}/" /opt/launch-skype.sh

#実行ユーザを登録
useradd skype
sed -i "s/%wheel  ALL=(ALL)       NOPASSWD: ALL/wheel  ALL=(ALL)       NOPASSWD: ALL/" /etc/sudoers
sed -i "/Defaults    requiretty/a Defaults:skype    \!requiretty" /etc/sudoers
usermod -G wheel skype

#必要なディレクトリと権限の設定
mkdir /var/db/skype /var/run/skype/ /var/log/skype/
chown skype:skype /var/db/skype /var/run/skype/ /var/log/skype/
chmod 755 /opt/launch-skype.sh

yum install -y ld-linux.so.2
yum install -y alsa-lib.i686
yum install -y libXv.so.1
yum install -y libXss.so.1
yum install -y libQtGui.so.4
ln -s /usr/lib/libtiff.so.3 /usr/lib/libtiff.so.4


mv /opt/launch-skype.sh /etc/init.d/skype
chkconfig --add skype
chkconfig skype on

yum install -y --nogpgcheck http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
yum install -y x11vnc ipa-gothic-fonts

/etc/init.d/skype start
x11vnc -display :20

yum install -y python-setuptools dbus-python pygobject2 dbus-x11
service messagebus start
easy_install Skype4Py

export DISPLAY=:20


# python
# import Skype4Py
# skype = Skype4Py.Skype(Transport='x11')
# skype.Attach()

## ここで、Skypeからプログラムのアクセス要求ダイアログが表示されるので承認する。（初回のみ）

##>>> chat = skype.CreateChatWith("自分のSkype名")
##>>> chat.SendMessage(u"テストメッセージ！")

#env DISPLAY=:20 XAUTHORITY=/var/run/skype/Xauthority python bot.py












