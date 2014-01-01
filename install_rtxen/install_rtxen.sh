#/bin/bash
rtxen_path=..

if ! [ -f /boot/grub2/grub.cfg ] || ! [ -f /etc/default/grub ]; then
  echo "Are you using grub instead of grub2.This install script only works for grub2!"
  exit 1
fi

grub2_mkconfig_path=/usr/sbin
if ! [ -f ${grub2_mkconfig_path}/grub2-mkconfig ]; then
    echo "grub2-mkconfig not found! Please run 'whereis grub2-mkconfig' to specify the grub2_mkconfig_path."
    exit 1
fi
#grub2_mkconfig_path="`whereis grub2-mkconfig`"

#backup the grub files
echo "Back up grub files"
sudo mkdir grub_backup
sudo cp /boot/grub2/grub.cfg ./grub_backup/grub.cfg.old
sudo cp /etc/default/grub ./grub_backup/grub
sudo cp -r /etc/grub.d ./grub_backup
sudo cp ${grub2_mkconfig_path}/grub2-mkconfig ./grub_backup

#compile rt-xen
echo "RT-Xen: Compile and install"
cd ${rtxen_path}
sudo make world
sudo make install

if ! [ -f /boot/xen-4.1.4.gz ]; then
  echo "RT-Xen: Compiling or install failed! /boot/xen-4.1.4.gz does not exit!"
  exit 1
else
  echo "RT-Xen: RT-Xen is compiled; Image(xen-4.1.4.gz) should be in /boot/"
  ls /boot/xen-4.1.4.gz
fi

echo "RT-Xen: Update grub2 for RT-Xen..."
sleep 2
sudo cp ./install_rtxen/grub2/grub2-mkconfig ${grub2_mkconfig_path}
sudo cp ./install_rtxen/grub2/22_linux_rtxen /etc/grub.d/
#sudo cp ./install_rtxen/grub2/grub /etc/default/
sudo cat ./install_rtxen/grub2/grub-rtxen >> /etc/default/grub

sudo rub2-mkconfig -o /boot/grub2/grub.cfg
cat /boot/grub2/grub.cfg | grep RT-Xen
echo "If you have seen 'submenu RT-Xen', then your RT-Xen has been successfully installed!"
echo "Reboot your machine and select RT-Xen in the grub2."
echo "Recommend: choose the RT-Xen with gedf scheduler;\n\tAfter log into the system, run the command "sudo service xend start" and 'xl sched-gedf' to check your RT-Xen works well.\n\tIf Domain-0's vcpu's information is displayed, RT-Xen is confirmed successfully installed in your machine!"




