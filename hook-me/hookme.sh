#!/bin/bash

SRC_PATH=$(pwd)
UTILS_PATH="$SRC_PATH/src/utils/"
NET_PATH="/sys/class/net/"

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

function check_status() {
    for DEV in $@ ; do
	DEV_STATUS=$(cat "$NET_PATH/$DEV/operstate")
	[ "$DEV_STATUS" == "up" ] && {
	    print_ko "Already connected, now exiting.." 1
	    exit 1
	}
    done
}

check_status $WLANS
check_status $ETH