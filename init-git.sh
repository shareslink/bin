#!/bin/bash
if [ $# = 0 ]; then
    echo init-git ssh://git@src.shareslink.com/sig.shareslink.com.git
    exit
fi

git init
git remote add origin $1
git push origin master
