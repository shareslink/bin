#!/bin/bash
# echo target android file path
# By Johnson Z.

if [[ -z "$1" ]]; then
    echo "Usage: go <regex>"
    exit
fi

T=`cat ~/.alias.x` #$(gettop)
declare -i T_length=${#T}

mkdir -p cscope
filelist="./cscope/filelist"
if [[ ! -f $T/$filelist ]]; then
    echo "Msg: Run idx -c to generate cscope/filelist first!"
    exit
fi

echo "Msg: Searching $1:"
lines=

# suffix to be found
x=
if [ $# = 2 ]; then x=$2; fi

lines=($(\grep -i "$1" $T/$filelist |grep "\.$x" |awk -F" " '{print $2}' |sed -e 's/\/[^/]*$//' |sort |uniq))
if [[ ${#lines[@]} = 0 ]]; then
    echo "Msg: Nothing found"
    exit
fi

pathname=
choice=
T_length=$T_length+2
if [[ ${#lines[@]} > 1 ]]; then
    while [[ -z "$pathname" ]]; do
        index=1
        line=
        for line in ${lines[@]}; do
            line=`echo "$line" | cut -c $T_length-`
            grep "frameworks" $line
            if [ $? = 0 ]; then
                printf "* %7s %s\n" "[$index]" $line
            else
                printf "  %7s %s\n" "[$index]" $line
            fi
            ls "$line" | awk '{print "\t      "$1}' | grep -i "$1" --color=always
            index=$(($index + 1))
        done
        echo
        echo -n "IPT: Select path index: "
        unset choice
        read choice
        if [[ $choice -gt ${#lines[@]} || $choice -lt 1 ]]; then
            echo "Msg: Invalid choice: $choice"
            continue
        fi
        pathname=${lines[$(($choice-1))]}
    done
else
    pathname=${lines[0]}
fi

###########################################################################
echo "Msg: $pathname"
###########################################################################
if [ -e /usr/bin/xsel ]; then
    # remember path into cliper board
    # then, u cld Ctrl+Shift+V to paste it on cmd window.
    echo "$pathname" | xsel -b -i
fi

if [ -e $pathname/$1 ]; then
    if [ -d $pathname/$1 ]; then
        # it's a dir
        echo "Msg: $pathname/$1"
    else
        # it's a file
        echo
        echo -n "IPT: Vi $1 ?"
        read input
        vi $pathname/$1
    fi
else
    suffixes=".java .c .cpp .h .xml .mk"
    files=""
    declare -i index=0
    for suffix in $suffixes; do
        if [ -f $pathname/$1$suffix ]; then
            files="$files $pathname/$1$suffix"
            index=$index+1
        fi
    done
  
    if [ $index = 0 ]; then
        if [ -d $pathname ]; then
            files=`ls $pathname | grep -i "$1"`
            favor=""
            declare -i favor_account=0
            for file in $files; do
                if [ -f "$pathname/$file" ]; then
                    favor="$file"
                    favor_account=$favor_account+1
                fi
            done

            if [ $favor_account -eq 1 ]; then
                echo
                echo -n "IPT: Vi $favor ? "
                read input
                vi "$pathname/$favor"
            else
                names=`ls "$pathname" | grep -i "$1"`
                declare -i idx=0
                for name in $names; do
                    echo "     [$idx] $name"
                    idx=$idx+1
                done
                echo
                echo -n "IPT: Vi which one: "
                read idx
                names=($names) # convert to ary
                vi "$pathname/${names[$idx]}"
            fi

            exit
        else
            echo "Err: Invalid path: $pathname"
            exit
        fi
    fi

    if [ $index = 1 ]; then
        echo
        echo -n "IPT: Vi `basename $files` ? "
        read input
        vi $files
    else
        index=0
        for file in $files; do
            echo "Msg: [$index] `basename $file`"
            index=$index+1
        done
        echo
        echo -n "IPT: Vi which one: "
        read idx
        echo "Msg: `basename ${files[$idx]}`"
        vi ${files[$idx]}
    fi
fi

