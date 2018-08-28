#!/bin/bash
sip=
usr=
pwd=
war=
tmc=
dep=
dir=
sfx=

if [ $# = 0 ]; then
    echo "$0 sip usr pwd war tmc dep dir sfx"
    sip=182.92.169.67
    usr=root
    pwd=xxxxxx
    war=~/ins/tmc/webapps/ads.war 
    tmc=/root/ins/tmc
    dep=/root/ins/tmc/webapps/ads.war
    dir=/root/ins/tmc/webapps/ads
    sfx=.upload

    echo -n "deploy ads now [Y/n] "
    read cmd
    if [ "$cmd" = "n" ]; then
        echo do nothing
    else
        ads_copy $war $usr $sip $dep $pwd $sfx
        ads_reboot $usr $sip $pwd $tmc $dir $dep $sfx
    fi

    exit
else
    sip=$1
    usr=$2
    pwd=$3
    war=$4
    tmc=$5
    dep=$6
    dir=$7
    sfx=$8
fi

echo sip=$sip
echo usr=$usr
echo pwd=$pwd
echo war=$war
echo tmc=$tmc
echo dep=$dep
echo dir=$dir
echo sfx=$sfx

ads_copy $war $usr $sip $dep $pwd $sfx
ads_reboot $usr $sip $pwd $tmc $dir $dep $sfx
