#!/bin/bash
#20240427 will restart massa right away if stopped
#to launch with |& tee logs.txt
RUST_BACKTRACE=1
export RUST_BACKTRACE
START_DATETIME=$(date +"%Y/%m/%d-%H:%M.%S")
#PATH_MASSANODE="/root/massa-running-node/massa/massa-node/"
#PATH_MASSANODE="/home/enola/MASSA/massa_dl-as-is/massa-2.4-202411/"
PATH_MASSANODE="/home/enola/MASSA/massa_dl-as-is/massa-2.4-202411/massa/massa-node/"
BIN_MASSANODE=$PATH_MASSANODE"massa-node"
PATH_MASSASCRIPT=/home/enola/massa-scripts
PASSWORD_MASSANODE=$(cat $PATH_MASSASCRIPT'/massa-node.pwd')

stty -echoctl # hide ^C

# function called by trap
exit_script() {
    tput setaf 1
    printf "\rSIGINT caught      "
    tput sgr0
    sleep 1
    printf "bye"
    exit 0;
}

#https://stackoverflow.com/questions/12771909/bash-using-trap-ctrlc
trap 'exit_script' SIGINT
#exit

cd $PATH_MASSANODE
nlaunch=0
while [ $nlaunch -gt -1 ]
do
 echo "previous start number: "$nlaunch.
 echo "Will do execution of $BIN_MASSANODE -p ****"
 $BIN_MASSANODE -p $PASSWORD_MASSANODE
 sleep 4
 echo mv "$PATH_MASSANODE/logs.txt" "$PATH_MASSANODE/logs_$START_DATETIME"
 mv "$PATH_MASSANODE/logs.txt" "$PATH_MASSANODE/logs_$START_DATETIME"
 nlaunch=$((nlaunch+1))
done


echo "massa-node launch 2 times since $STARTDATE" ;
