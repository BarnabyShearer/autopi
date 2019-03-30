#!/bin/bash

if [ "$#" -ne 4 ]; then
    echo "./make.sh [device] [ssid] [psk] [ssh_id_pub_file]"
    exit 1
fi

# Download latest Raspian lite and re-enable boot.rc
TMP="$(mktemp -p /dev/shm/)"
curl -L https://downloads.raspberrypi.org/raspbian_lite_latest -o $TMP
unzip -p $TMP \
    | sed 's/# Print the IP address/.        \/boot\/boot.rc/' \
    | sudo dd of=$1 bs=4M conv=fsync status=progress
rm $TMP

# Mount /boot
sudo partprobe
MNT=`mktemp -d`
sudo mount `ls ${1}p1 ${1}1` $MNT

# Setup Wifi
sudo tee $MNT/wpa_supplicant.conf << EOF
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=US

network={
        ssid="${2}"
        psk="${3}"
}
EOF

# Enable key based SSH
sudo tee $MNT/boot.rc <<EOF
mkdir -p /home/pi/.ssh
echo '`cat ${4}`' > /home/pi/.ssh/authorized_keys
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl enable ssh
systemctl start ssh
EOF

# Unmount
sudo umount $MNT
rmdir $MNT
