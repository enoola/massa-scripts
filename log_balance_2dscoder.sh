#!/bin/bash

#04/02/2025, 11:26
#functionnal
#
# retrieve current $MAS count, and rolls count as well, will be launch every 6hours
#
# this is to be invoked periodicaly as this : /root/massa-scripts/log_balance_2dscoder.sh >> ~/massa-scripts/balance_log.csv


MYWALLET_ADDR='AU1CGGfxDF7soXGvrLYnFLFTdWNhmfbn2TQpHZUKXg5tXB3fjjcB'
PATH_MASSASCRIPT='/root/massa-scripts/'
PATH_MASSACLIENT='/root/massa/massa-client'
BIN_MASSACLIENT="${PATH_MASSACLIENT}/massa-client"

cd "${PATH_MASSACLIENT}"

#echo "${BIN_MASSACLIENT}" -p $(cat ~/massa-scripts/massa-client.pwd) 'get_addresses' ${MYWALLET_ADDR}
#exit 1

# Capture the output from the command
output=$("${BIN_MASSACLIENT}" -p $(cat ~/massa-scripts/massa-client.pwd) 'get_addresses' ${MYWALLET_ADDR})
#echo $output
#exit 1
# Extract the balance value using grep and sed
balance_value=$(echo "$output" | grep "Balance: final=" | sed 's/.*final=//; s/,.*//')

# Extract the rolls number using grep and sed
rolls_number=$(echo "$output" | grep "Rolls: final=" | sed 's/.*final=//; s/,.*//')

# Get current timestamp
cur_timestamp=$(date +%s)

# Format the current timestamp into a human-readable UTC date and time
cur_date_time=$(date -u -d "@$cur_timestamp" "+%Y-%m-%d %H:%M:%S")

# Concatenate the values with columns for the current timestamp and human-readable date and time
result="${cur_timestamp};${cur_date_time};${balance_value};${rolls_number}"
# Concatenate the values into a single line separated by a semicolon
#result="${balance_value};${rolls_number}"

# Print the result
echo $result
