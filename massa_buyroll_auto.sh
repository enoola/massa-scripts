#!/usr/bin/bash
#script to verify if we can buy a roll, in other words if we have 100MAS

#My crontab looks like this :
###BEGIN EXPORT MY CRONTAB
  # run every 2minutes
  # m h  dom mon dow   command
  # */2 * * * * /root/massa-running-node/massa/massa-client/massa_buyroll_auto.sh >> /root/massa-running-node/massa/massa-client/massa_buyroll_auto.logs
  #
###END EXPORT MY CRONTAB
#
NMAS_TOLEAVE=3
NMAS_PER_ROLLS=100
PATH_MASSACLIENT='/root//massa/massa-client/'
BIN_MASSACLIENT=$PATH_MASSACLIENT"massa-client"
PATH_MASSASCRIPT='/root/massa-scripts'
#BIN_MASSACLIENT=${PATH_MASSACLIENT}/mas
PASSWORD_MASSACLIENT=$(cat $PATH_MASSASCRIPT'/massa-client.pwd')
ADDR_WALLET=$(cat $PATH_MASSASCRIPT'/massa-wallet.addr')

#improv. shall verify pwd isn't blank
#echo $PASSWORD_MASSACLIENT

cd $PATH_MASSACLIENT

nrolls=$(${BIN_MASSACLIENT} -p $PASSWORD_MASSACLIENT 'get_addresses' $ADDR_WALLET | grep Rolls | grep -oP "final=\K\d+")
nmas=$(${BIN_MASSACLIENT} -p $PASSWORD_MASSACLIENT 'get_addresses' $ADDR_WALLET | grep Balance | grep -oP "final=\K\d+")
#echo "Found $nmas MAS in the $ADDR_WALLET"

nmas_mini=$(( NMAS_TOLEAVE + NMAS_PER_ROLLS ))
if [[ $nmas -lt $nmas_mini ]]
	then
	printf '%s %d %s \r\n' $(date +"%Y/%m/%d-%H:%M.%S")" | You have " $nmas "MAS, not enough, to create a role. Stopping...."
	exit 42
fi

nusable_mas=$(( nmas - NMAS_TOLEAVE ))
#'nRollsToBuy=$(('$nusable_mas' / '$NMAS_PER_ROLLS'))'

nRollsToBuy=$((nusable_mas / NMAS_PER_ROLLS))
echo "$(date +"%Y/%m/%d-%H:%M.%S") | Good news enough to make $nRollsToBuy roll."

./massa-client -p $PASSWORD_MASSACLIENT 'buy_rolls' $ADDR_WALLET $nRollsToBuy 0.1
echo "$(date +"%Y/%m/%d-%H:%M.%S") | $nRollsToBuy roll(s) have been ordered."


nrollsfinal_now=$(./massa-client -p $PASSWORD_MASSACLIENT 'get_addresses' $ADDR_WALLET | grep Rolls | grep -oP "final=\K\d+")
nrollscandidate_now=$(./massa-client -p $PASSWORD_MASSACLIENT 'get_addresses' $ADDR_WALLET | grep Rolls | grep -oP "candidate=\K\d+")
nrolls_expected=$(( nRollsToBuy + nrolls ))
echo $(date +"%Y/%m/%d-%H:%M.%S")" | Expected Number of Rolls at the end, ('current rolls number' + 'number of rolls to buy' ) $nrolls + $nRollsToBuy : " $nrolls_expected


#printf "We expect a total of %d rolls.\r\n" $nrolls_expected

NSECONDS_TOSLEEP=2
bRollsAreFinal=0
i=0

while [[ nrollsfinal_now -lt nrollscandidate_now -or i -eq 10 ]]
do
	echo "$(date +"%Y/%m/%d-%H:%M.%S") | iteration $i."
	echo "$(date +"%Y/%m/%d-%H:%M.%S") | wait $NSECONDS_TOSLEEP seconds"
	sleep $NSECONDS_TOSLEEP
	echo "$(date +"%Y/%m/%d-%H:%M.%S") | $NSECONDS_TOSLEEP seconds"

	nrollsfinal_now=$(./massa-client -p $PASSWORD_MASSACLIENT 'get_addresses' $ADDR_WALLET | grep Rolls | grep -oP "final=\K\d+")
	nrollscandidate_now=$(./massa-client -p $PASSWORD_MASSACLIENT 'get_addresses' $ADDR_WALLET | grep Rolls | grep -oP "candidate=\K\d+")

	if [[ nrollsfinal_now -eq nrolls_expected -or nrollscandidate_now -eq nrolls_expected]]
	then
 		#echo $(date +"%Y/%m/%d-%H:%M.%S") | "OK. You now have "$nrolls_expected"."
		# well it shall make
		echo "Looks good, either your rolls is made, or it is being made and shown in candidate field."
	fi

	#Verify that the rolls has been finalize
	#I decided I wanted to see the roll appearing in final field as well : 
	#__begin truncated output of massa-client get_addresses ADDR_WALLET
	#  ...
	#  Balance: final=71.189804643, candidate=71.189804643
	#  Rolls: final=8, candidate=8
	#  ...
	#__end of truncated output__
	#note that it should be 1h40min average
	if [[ nrollsfinal_now -eq nrollscandidate_now ]]
	then
		bRollsAreFinal=1
		echo $(date +"%Y/%m/%d-%H:%M.%S")' | OK. You now have "$nrollsfinal_now'.'
		echo "See :"
		./massa-client -p $PASSWORD_MASSACLIENT 'get_addresses' $ADDR_WALLET
		exit $nrollsfinal_now
	fi
	i+=1
done

echo "See :"
./massa-client -p $PASSWORD_MASSACLIENT 'get_addresses' $ADDR_WALLET

echo $(date +"%Y/%m/%d-%H:%M.%S")' | KO...'.'

#cd -
exit 0
