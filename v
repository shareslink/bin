#!/bin/bash
###############################################################################
# set CSCOPE_DB
###############################################################################
# echo CSCOPE_DB=
# if [ -f cscope.out ]; then
#     DB=cscope.out
# fi
# 
# if [ "`pwd`" = "`cat ~/.spd`" ]; then
#     echo "for cscope, pwd is spd, ignore ./cscope"
# else
#     if [ -d cscope ]; then
#         outs=`find cscope | grep out$`
#         for out in $outs; do
#             if [ -f $out ]; then
#                 DB="$out $DB"
#                 echo $out
#             fi
#         done
#     fi
# fi
# 
# if [ -f ~/.CSCOPE_DB ]; then
#     outs=`cat ~/.CSCOPE_DB`
#     for out in $outs; do
#         if [ -f $out ]; then
#             DB="$out $DB"
#             echo $out
#         fi
#     done
# fi
# 
# export CSCOPE_DB=$DB



###############################################################################
# vi 
###############################################################################
if [ $# = 0 ]; then
	vi
	exit
fi

echo "$1" | grep ":"
if [ $? = 0 ]; then
    file=`echo $1 | awk -F":" '{print $1" +"$2}'`
    echo "vi $file"
    vi $file
else    
    if [ -e "$1" ]; then
        vi "$1"
    elif [ -e cscope/filelist ]; then
        lines=($(\grep -i "$1" cscope/filelist | awk -F" " '{print $2}' | sort -u))
        pathname=
        choice=
        if [[ ${#lines[@]} > 1 ]]; then
            while [[ -z "$pathname" ]]; do
                index=1
                line=
                for line in ${lines[@]}; do
                    if [ -e $line ]; then
                        echo "[$index] $line"
                        index=$(($index + 1))
                    fi
                done

                echo -n "Select one: "
                unset choice
                read choice
                if [[ $choice -gt ${#lines[@]} || $choice -lt 1 ]]; then
                    echo "Invalid choice"
                    continue
                fi
                pathname=${lines[$(($choice-1))]}
            done
        else
            pathname=${lines[0]}
        fi
        echo "vi $pathname"
        vi $pathname
    else
        echo "vi $1"
        vi $1
    fi
fi

