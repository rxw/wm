#!/bin/sh
#
# Copyright (c) 2015 Greduan <me@greduan.com>, licensed under the WTFPL
# Adds group-like capabilities, sorta like those you find in CWM and such WMs

usage() {
    cat << EOF
usage: $(basename $0) [-h] [-c wid] [-s wid group] [-tmMuU group]
       -h shows this help
       -c cleans WID from group files (and makes it visible)
       -s sets WID's group
       -t toggle group visibility state
       -m maps (shows) group
       -M maps group and unmaps all other groups
       -u unmaps (hides) group
       -U unmaps all the groups
EOF

    exit 1
}

# test for no arguments
test $# -eq 0 && usage

# I suggest it's under /tmp or somewhere that gets cleaned up at reboot or gets
# cleaned up after X stops running
FSDIR=${FSDIR:-/tmp/groups.sh}

# define our functions

# clean WID ($1) from group files
clean_wid() {
    # TODO: make POSIX compatible, -i is a GNU-ism
    sed -i "/$1/d" $FSDIR/group.*
}

# cleans group ($1) from (in)active files
clean_status() {
    # TODO: make POSIX compatible, -i is a GNU-ism
    sed -i "/$1/d" $FSDIR/active
    sed -i "/$1/d" $FSDIR/inactive
}

# shows all the windows in group ($1)
map_group() {
    # clean statuses
    clean_status $1
    # add to active
    echo $1 >> $FSDIR/active

    # loop through group and map windows
    while read line; do
        mapw -m $line
    done < $FSDIR/group.$1
}

# hides all the windows in group ($1)
unmap_group() {
    # safety
    if [ ! -f $FSDIR/group.$1 ] || [ ! -s $FSDIR/group.$1 ]; then
        echo "Group doesn't exist"
        exit 1
    fi

    # clean statuses
    clean_status $1
    # add to inactive
    echo $1 >> $FSDIR/inactive

    # loop through group and unmap windows
    while read line; do
        mapw -u $line
    done < $FSDIR/group.$1
}

# assigns WID ($1) to the group ($2)
set_group() {
    # make sure we've no duplicates
    clean_wid $1

    # insert WID into new group
    echo $1 >> $FSDIR/group.$2

    # if we can't find the group add it to groups and make it active
    grep -q $2 < $FSDIR/all || \
    echo $2 >> $FSDIR/all &&
    echo $2 >> $FSDIR/active

    # map WID if group is active
    grep -q $2 < $FSDIR/active && \
    mapw -m $1

    # unmap WID if group is inactive
    grep -q $2 < $FSDIR/inactive && \
    mapw -u $1
}

# toggles visibility state of all the windows in group ($1)
toggle_group() {
    # if we can't find the group, exit
    if ! grep -q $1 < $FSDIR/all; then
        echo "Group doesn't exist"
        return
    fi

    # search through active groups first
    grep -q $1 < $FSDIR/active && \
    unmap_group $1 && \
    return

    # search through inactive groups next
    grep -q $1 < $FSDIR/inactive && \
    map_group $1 && \
    return
}

# actual run logic (including arguments and such)

# check $FSDIR exists
if [ ! -d $FSDIR ]; then
    mkdir -p $FSDIR
fi

# TODO: optimize this
if [ ! -f $FSDIR/active ]; then
    touch $FSDIR/active
fi
if [ ! -f $FSDIR/inactive ]; then
    touch $FSDIR/inactive
fi
if [ ! -f $FSDIR/all ]; then
    touch $FSDIR/all
fi

# clean WIDs that don't exist
cat $FSDIR/group.* 2>/dev/null | while read wid; do
    wattr $wid || clean_wid $wid
done
# clean group files that are empty
for file in $FSDIR/group.*; do
    # is the group empty?
    if [ ! -s $file ]; then
        rm -f $file
    fi
done

# getopts yo
while getopts "hc:s:t:m:M:u:U" opt; do
    case $opt in
        h)
            usage
            ;;
        c)
            clean_wid $OPTARG
            mapw -m $OPTARG
            break
            ;;
        s)
            set_group $OPTARG $(eval echo "\$$OPTIND")
            break
            ;;
        t)
            toggle_group $OPTARG
            break
            ;;
        m)
            map_group $OPTARG
            break
            ;;
        M)
            for file in $FSDIR/group.*; do
                group=${file##*.}
                unmap_group $group
            done
            map_group $OPTARG
            break
            ;;
        u)
            unmap_group $OPTARG
            break
            ;;
        U)
            for file in $FSDIR/group.*; do
                group=${file##*.}
                unmap_group $group
            done
            break
            ;;
    esac
done