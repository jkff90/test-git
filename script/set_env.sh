#!/bin/bash

PRJ_NAME=test_prj
UVM_HOME=/home/uvm

let count=0
cur_dir=$(pwd)                                    # execute command pwd, same as cur_dir=`pwd`
while [ "${cur_dir##*/}" != "$PRJ_NAME" ]; do     # get name of current dir
   cur_dir=${cur_dir%/*}                          # up 1 hierachy
   let  $((count++))
   if [ $count -gt 20 ]
   then
      echo "Error: Cannot find project root, Please make sure you source the script under the directory $PRJ_NAME";
      break
   fi
done
PRJ_ROOT=$cur_dir

export UVM_HOME
export PRJ_ROOT
export PRJ_NAME

alias compile='perl $PRJ_ROOT/script/compile.pl'

echo ============================================================
echo " FINISH SETUP ENV"
echo "   +USER     = $USER"
echo "   +HOSTNAME = $HOSTNAME"
echo "   +UVM_HOME = $UVM_HOME"
echo "   +PRJ_NAME = $PRJ_NAME"
echo "   +PRJ_ROOT = $PRJ_ROOT"
echo ============================================================
