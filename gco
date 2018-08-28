#!/bin/sh
if [ $# = 0 ]; then
    echo gco path
    exit
fi

if [ $# = 1 ]; then
    exe pwd
    exe git checkout $1
    exit
else
    while getopts "c:t:h" arg
    do
        case $arg in
            h)
                echo gco xxx
                echo     git checkout xxx
                echo
                echo gco -c xxx
                echo     git checkout xxx for all
                echo
                echo gco -t xxx
                echo     git checkout tag for all
                exit
                ;;
            c)
                wks=`pwd`
                find . -name .git | while read i; do
                    line
                    cd "$wks/`dirname $i`"
                    exe pwd
                    exe git checkout $OPTARG
                done;
                exit
                ;;
            t)
                wks=`pwd`
                find . -name .git | while read i; do
                    line
                    cd "$wks/`dirname $i`"
                    exe pwd
                    exe git checkout $OPTARG
                done;
                exit
                ;;
        esac
    done
    shift $((OPTIND-1))
fi
