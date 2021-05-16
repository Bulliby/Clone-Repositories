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

close_stderr_stdout()
{
    exec 11>&1 12>&2 1>&- 2>&-     
}

restore_stderr_stdout()
{
    exec 11>&1- 12>&2-     
}

options=$(getopt -a -n "$(basename $0)" -l "target:,help,verbose" -- "t:hvd" "$@")

if [ $? -ne 0 ]; then
    usage
fi

eval set --$options

while [ ! -z "$1" ]
do
    case "$1" in
        -t) target="$2"; shift ;;
        -v) verbose=1 ;;
        -h) usage ;;
        --target) target="$2"; shift ;;
        --help) usage ;;
        --verbose) verbose=1 ;;
    esac
    shift
done

v=""
if [[ $verbose ]]; then
    v="v"
fi

if [ -z $target ]; then
    echo "Target path is manadatory"
    exit $E_BADARGS
fi

if [ ! -d $target ]; then
    echo "This is not  a valid location"
    exit $E_BADLOCATION
fi

if [[ $verbose -eq 0 ]]; then
    close_stderr_stdout
fi


while read -r line
do
    cd "$target"
    lang=$( echo "$line" | cut -f1)
    url=$( echo "$line" | cut -f2)
    if [ ! -d "$lang" ]; then
        mkdir $([[ $verbose = 1 ]] && echo "-v") "$lang"
    fi
    cd "$lang"
    git clone "$url"
done < <(python clone.py)

if [[ $verbose -eq 1 ]]; then
    restore_stderr_stdout
fi

