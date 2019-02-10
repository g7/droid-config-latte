#!/bin/bash
echo "macaddr: Setting up bluetooth"

hexchars="0123456789ABCDEF"
mac=$( for i in {1..10} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )
firmware="/etc/firmware/bt/BCM4356A2_001.003.015.0084.0268_ORC.hcd"
baudrate=3000000
device=/dev/ttyHSU0
addr=""

if [ ! -f "/data/misc/bluetooth/bluetooth_bdaddr" ]; then
    echo "File not found!"
    mkdir -p "/data/misc/bluetooth/"
    chmod 0755 "/data/misc/bluetooth/"
    echo 00$mac > "/data/misc/bluetooth/bluetooth_bdaddr"
fi

if [ -e "/data/misc/bluetooth/bluetooth_bdaddr" ]; then
    mkdir -p "/var/lib/bluetooth"
    chmod 0755 "/var/lib/bluetooth"
    addr="$(cat /data/misc/bluetooth/bluetooth_bdaddr)"
    if [ -e "/var/lib/bluetooth/board-address" ]; then
        if [ "$addr" != "$(cat /var/lib/bluetooth/board-address)" ]; then
            echo "macaddr: Updating bt MAC address"
            echo "$addr" > /var/lib/bluetooth/board-address
            echo "macaddr: Done"
        fi
    else
        echo "macaddr: Setting bt MAC address"
        echo "$addr" > /var/lib/bluetooth/board-address
        echo "macaddr: Done"
    fi
fi

