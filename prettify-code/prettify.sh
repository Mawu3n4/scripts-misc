#!/bin/bash

if [ $# -lt 1 ] ; then
    echo "Usage: prettify.sh DIR"
fi

DIR=$1
cat patterns | while read PATTERN ; do
    GREP_PATTERN=$(echo -n "$PATTERN" | cut -d'D' -f1 | sed "s/'//g")
    SED_PATTERN=$(echo -n "$PATTERN" | cut -d'D' -f2 | sed "s/'//g")
    IS_REGEXP=$(echo -n "$PATTERN" | cut -d'D' -f3 | sed "s/'//g")

    SED_ARG="'s/$GREP_PATTERN/$SED_PATTERN/g'"

    [ -n "$IS_REGEXP" ] && {
	SED_CMD="sed -ir"
	GREP_CMD="grep -IrE"
    } || {
	SED_CMD="sed -i"
	GREP_CMD="grep -Ir"
    }

    $GREP_CMD '$GREP_PATTERN' $DIR | cut -d ':' -f1 | while read line; do $SED_CMD $SED_ARG \$line; done
done