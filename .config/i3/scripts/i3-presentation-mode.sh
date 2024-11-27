#!/bin/bash
# Stops and continues process according to parameters toggle, enable and disable
# Without parameters script returns STOPPED_MSG (resp. RUNNING_MSG)

LOCKER_CMD="xautolock"
RUNNING_MSG=""
STOPPED_MSG="Presentation mode: On"

if [ -z $1 ];then
    if [[ $(ps -o state= -Cxautolock) < 'T' ]];then
        echo -n $RUNNING_MSG
    else
        echo -n $STOPPED_MSG
    fi
else
    
    if [ $1 == 'toggle' ]; then
        if [[ $(ps -o state= -Cxautolock) < 'T' ]];then
            killall -SIGSTOP $LOCKER_CMD
        else
            killall -SIGCONT $LOCKER_CMD
        fi
        exit
    fi
    
    if [ $1 == 'enable' ]; then
        killall -SIGSTOP $LOCKER_CMD
        exit
    fi
    
    if [ $1 == 'disable' ]; then
        killall -SIGCONT $LOCKER_CMD
        exit
    fi
fi