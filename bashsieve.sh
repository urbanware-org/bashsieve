#!/usr/bin/env bash

#
# BashSieve - Simple history entry removal tool
# Copyright (c) 2026 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub: https://github.com/urbanware-org/bashsieve
# GitLab: https://gitlab.com/urbanware-org/bashsieve
#

script_dir="$(dirname $(readlink -f $0))"
config_file="$script_dir/bashsieve.conf"
list_file="$script_dir/bashsieve.list"

output_msg() {
    message="$1"

    logger "$message"
    if [ $verbose -eq 1 ]; then
        echo "$message"
    fi
}

read_config() {
    source $config_file

    if [ -z "$verbose" ] || [ "$verbose" = "0" ]; then
        verbose=0
    else
        verbose=1
    fi
}

# Main entry point

if [ ! -e "$config_file" ]; then
    echo "error: Required config file 'bashsieve.conf' does not exist"
    exit 1
fi
read_config

if [ ! -e "$config_file" ]; then
    echo "error: Required list file 'bashsieve.list' does not exist"
    exit 1
fi
if [ ! -e "$list_file" ]; then
    echo "error: List file 'bashsieve.list' does not exist"
    exit 2
fi

while read line; do
    if [ ! -z "$line" ] && [[ ! "$line" == ^\#* ]]; then
        line=$(sed -e "s/#.*//g" <<< $line)
        termlist="$line $termlist"
    fi
done < $list_file
termlist=$(awk '{$1=$1};1' <<< "$termlist")

if [ -z "$termlist" ]; then
    echo "error: Term list in 'bashsieve.list' is empty, nothing to remove"
    exit 3
fi

terms=$(sed -e s/\ /\|/g <<< "${termlist::-1}")
tempfile="/tmp/bashsieve_$$.tmp"  # include the process ID to avoid conflicts
lines_before=$(wc -l < ~/.bash_history)

grep -Eiv "$terms" ~/.bash_history > $tempfile
cat $tempfile > ~/.bash_history
rm -f $tempfile

lines_after=$(wc -l < ~/.bash_history)
lines_removed=$(( lines_before - lines_after ))

if [ $lines_removed -ne 0 ]; then
    output_msg "bashsieve[$USER]: Lines removed: $lines_removed"
else
    output_msg "bashsieve[$USER]: No lines to be removed"
fi

