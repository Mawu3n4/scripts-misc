#!/bin/bash

SRC_PATH=$(pwd)
UTILS_PATH="$SRC_PATH/src/utils/"
NET_PATH="/sys/class/net/"

KNOWN_FILE="$SRC_PATH/known_networks.tmp"

# Load all files ending with $PATTERN in $L_PATH
function load_items () {
    local PATTERN="$1"
    local L_PATH="$2"

    ITEMS=$(ls -1 $L_PATH | grep $PATTERN)

    for ITEM in $ITEMS; do
        . /$L_PATH/$ITEM
    done
}

# load funcs
load_items ".utils$" $UTILS_PATH

# got root ?
check_root

WLANS=$(ls -1 "/sys/class/net/" | grep "wlan")
ETHS=$(ls -1 "/sys/class/net/" | grep "eth")

check_status $WLANS
check_status $ETH

KNOWN_NETW=$(cat /etc/network/interfaces | grep "conf" | cut -d'/' -f4)

for NETWORK in $KNOWN_NETW ; do
    cat "/etc/wpa_supplicant/$NETWORK" 2>/dev/null | grep -E $'[\t ]+ssid' | cut -d '=' -f2 | sed 's/"//g' >> $KNOWN_FILE
done

rm -f $KNOWN_FILE