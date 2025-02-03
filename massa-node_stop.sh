#!/usr/bin/bash
#script to verify if we can buy a roll, in other words if we have 100MAS


NMAS_PER_ROLLS=100
PATH_MASSACLIENT=/home/enola/MASSA/massa_dl-as-is/massa-running-node/massa-client/
BIN_MASSACLIENT=$PATH_MASSACLIENT"massa-client"

PATH_MASSASCRIPT=/home/enola/massa-scripts
PASSWORD_MASSACLIENT=$(cat $PATH_MASSASCRIPT'/massa-client.pwd')
ADDR_WALLET=$(cat $PATH_MASSASCRIPT'/massa-wallet.addr')
#improv. shall verify pwd isn't blank
#echo $PASSWORD_MASSACLIENT

cd $PATH_MASSACLIENT

nrolls=$(./massa-client -p $PASSWORD_MASSACLIENT 'node_stop' )

printf "%s" $nrolls

cd -
exit 0
