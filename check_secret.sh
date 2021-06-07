#!/bin/bash

set -e

E_BADARGS=11
E_BADLOCATION=12
E_MISSING_APP=13

usage()
{
    cat <<UsagePrint
Usage :
    ./check_sercret.sh -t target [-d depth] [-h]
    ./clone.bash --target target [--depth depth] [--help]
    Check git's commits for secret on local repository on your filesystem.
UsagePrint

exit $E_BADARGS
}

options=$(getopt -a -n "$(basename $0)" -l "target:,depth:,help" -- "t:d:h" "$@")

if [ $? -ne 0 ]; then
    usage
fi

depth=2

eval set --$options

while [ ! -z "$1" ]
do
    case "$1" in
        -t) target="$2"; shift ;;
        -d) depth="$2"; shift ;;
        -h) usage ;;
        --target) target="$2"; shift ;;
        --depth) depth="$2"; shift ;;
        --help) usage ;;
    esac
    shift
done

if [ -z $target ]; then
    echo "Target path is manadatory"
    exit $E_BADARGS
fi

# Check if interger
if ! [ "$depth" -eq "$depth" ] 2> /dev/null
then
    echo "Depth is not an integer"
    exit $E_BADARGS
fi

if ! [ -d $target ]; then
    echo "Target is not a valid location"
    exit $E_BADARGS
fi

gitleaks -q
if [ $? -ne 0 ]; then
    echo "Gitleak is not installed"
    exit $E_MISSING_APP
fi

# {} represent the result of find
find $target -maxdepth ${depth} -mindepth ${depth} -type d -exec gitleaks -v --leaks-exit-code=0 -p {} \; -exec echo {} \;
