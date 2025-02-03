
Scripts to ease MASSA staking, if a roll can be created it does creates it

First you need to create 2 files 
massa-client.pwd
massa-node.pwd
respectively containing password for your node & the one for your wallet

no EOL so please do as follow :
$echo -n 'it\'s your pass' > massa-client.pwd
... repeat for massa-node.pwd

add a crontab
$crontab -e
```nano
# m h  dom mon dow   command
* * * * * /YOURPATH/massa-client/massa_buyroll_auto.sh >> /var/log/massa_buyroll_auto.logs
```


