#!/bin/bash
# compile projects
mac=`uname`
log=~/.com.log
echo "`date`" >> $log
# if [ -d ~/wks/www.shareslink.com ]; then cd ~/wks/www.shareslink.com else echo "~/wks/www.shareslink.com is not existing, exit." exit fi

echo "--------------------------------------------------------------------------------"
echo -e "\033[31m        LAST TIME COMPILATION INFO\033[0m"
echo "--------------------------------------------------------------------------------"
if [ -e .com ]; then cat .com; fi
echo

echo "--------------------------------------------------------------------------------"
echo -e "\033[31m        THIS TIME COMPILATION INFO\033[0m"
echo "--------------------------------------------------------------------------------"
echo "pwd=`pwd`"
idx=

if [ $# = 0 ]; then
    echo "1)  develop"
    echo "2)  betatest"
    echo "3)  preduction"
    echo "4)  production"
    echo -n "please choose index: "
    read idx
    if [ "$idx" = "" ]; then
        idx=1
    fi
    if [ "$idx" = "e" ]; then exit; fi
    if [ "$idx" = "E" ]; then exit; fi
else
    idx=$1
fi

opt=
if [ $idx = 1 ]; then
    opt=develop
elif [ $idx = 2 ]; then
    opt=betatest
elif [ $idx = 3 ]; then
    opt=preduction
elif [ $idx = 4 ]; then
    opt=production
else
    echo Bad chooice
    exit
fi

echo "--------------------------------------------------------------------------------"
echo "    clean target folders"
echo "--------------------------------------------------------------------------------"
find . -name target | while read i; do
    if [ -d $i ]; then
        exe "rm -fr $i"
    fi
done

echo "--------------------------------------------------------------------------------"
echo "    compile with option $opt"
echo "--------------------------------------------------------------------------------"
echo -n "mvn clean install -P $opt -Dmaven.test.skip=true "
read idx
if [ "$idx" = "e" ]; then exit; fi
if [ "$idx" = "E" ]; then exit; fi




mvn -T 4 clean install -P $opt -Dmaven.test.skip=true
pwd=`pwd`
echo "pwd=`pwd`" > .com
echo "pwd=`pwd`" >> $log
echo "[`date`]: mvn clean install -P $opt -Dmaven.test.skip=true" >> .com
echo "[`date`]: mvn clean install -P $opt -Dmaven.test.skip=true" >> $log
find . -name .git | sort | while read i; do
    d=`dirname $i`
    if [ "$d" = "." ]; then
        echo "`git log | head -n 1`    $d" >> .com
        echo "`git log | head -n 1`    $d" >> $log
    else
        cd $d
        echo "`git log | head -n 1`    $d" >> ../.com
        echo "`git log | head -n 1`    $d" >> $log
        cd $pwd
    fi
done

if [ -f ./02.ServiceModule/07.SecurityService/src/main/libed.so ]; then
    cp ./02.ServiceModule/07.SecurityService/src/main/libed.* /usr/local/lib/
fi

if [ -f /usr/local/lib/libed.so ]; then
    inf "Compilation is finished, please execute dub/web command for deployment"
fi

