#!/bin/bash

set -e

# ERRORS CODE

E_BADARGS=11
E_BADLOCATION=12

usage()
{
    cat <<UsagePrint
Usage :
    ./clone.bash -t target [-v] [-h]
    ./clone.bash --target target [--verbose] [--help]
    Clone all your repositories from your github account
    Verbose : Permit to see what is done at each step
    Help : Print this help
UsagePrint

exit $E_BADARGS
}

options=$(getopt -a -n "$(basename $0)" -l "target:,help,verbose" -- "t:hv" "$@")

if [ $? -ne 0 ]; then
    usage
fi

eval set --$options

while [ ! -z "$1" ]
do
    case "$1" in
        -t) target="$2"; shift ;;
        -h) usage ;;
        --target) target="$2"; shift ;;
        --help) usage ;;
    esac
    shift
done

if [ -z $target ]; then
    echo "Target path is manadatory"
    exit $E_BADARGS
fi

if [ ! -d $target ]; then
    echo "This is not  a valid location"
    exit $E_BADLOCATION
fi

if [ -z $TOKEN ];then
    echo "You need a Github token TOKEN='mysecret' bash clone.sh"
    exit $E_BADARGS
fi

api_result=$(TOKEN=$TOKEN php clone.php)

if [[ $? -ne 0 ]]; then
    echo $api_result
    exit 1
fi

TOKEN=$TOKEN php clone.php | while read -r line
do
    lang=$(echo "$line" | cut -d'|' -f1)
    url=$(echo "$line" | cut -d'|' -f2)

    cd "$target"

    if [ ! -d "$lang" ]; then
        mkdir $([[ $verbose = 1 ]] && echo "-v") "$lang"
    fi

    cd "$lang"
    git clone "$url"
done

if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    echo "Erreur script PHP"
    exit 1
fi
