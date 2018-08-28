#!/bin/bash

# subString(src, bin, end)
subString() {
    src=$1
    bin=$2
    end=$3

    # cut from 1
    if [ $bin -lt 1 ]; then return 1; fi

    # check parameters
    if [ $bin -gt $end ]; then return 1; fi

    # check src length
    if [ ${#src} = 0 ]; then return 1; fi

    echo "$src" | cut -c $bin-$end
}

# indexOf(src, sub)
indexOf() {
    src=$1
    sub=$2

    # check src length
    if [ ${#src} = 0 ]; then return 1; fi
    if [ ${#sub} = 0 ]; then return 1; fi

    declare -i length=${#src}
    declare -i i=0
    subStringLength=${#sub}
    while [ $i -lt $length ]; do
        i=$i+1
        declare -i end=$i+$subStringLength-1
        subString=`subString "$src" "$i" "$end"`
        if [ $? -ne 0 ]; then return 1; fi

        if [ "$sub" = "$subString" ]; then
            echo $i
            return
        fi

    done

    echo -1
}

# contains(src, sub)
contains() {
    src=$1
    sub=$2

    # check src length
    if [ ${#src} = 0 ]; then return 1; fi
    if [ ${#sub} = 0 ]; then return 1; fi

    return `indexOf "$src" "$sub"`
}



