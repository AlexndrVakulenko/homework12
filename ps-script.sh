#!/bin/bash

(
echo "CMD|PID|PPID|STAT|TIME|TTY|PRIORITY"
for pid in `ls /proc | grep -E "^[0-9]+$"`; do
    if [ -d /proc/$pid ]; then
        stat=`</proc/$pid/stat`

        cmd=`echo "$stat" | awk -F" " '{print $2}' | sed -e's/(//g' | sed -e's/)//g' ` 
        state=`echo "$stat" | awk -F" " '{print $3}'`
        tty=`echo "$stat" | awk -F" " '{print $7}'`
     
        user_time=`echo "$stat" | awk -F" " '{print $14}'`
        kernel_time=`echo "$stat" | awk -F" " '{print $15}'`
        time=$((user_time + kernel_time))
        priority=`echo "$stat" | awk -F" " '{print $18}'`
        ppid=`echo "$stat" | awk -F" " '{print $4}'`

     echo "${cmd}|${pid}|$ppid|${state}|${time}|${tty}|${priority}"
    
     fi
done
) | column -t -s "|"
