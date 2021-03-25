#!/bin/bash

SELF_ADDR="agoric14s4t5hhdxz3d6x89my2jckeelqlfsc94602m0e"
OPERATOR="agoricvaloper14s4t5hhdxz3d6x89my2jckeelqlfsc942hejnc"
WALLET_NAME="validator"
WALLET_PWD="YourPasswordHere"
BIN_FILE="/home/agoric/go/bin/ag-cosmos-helper"
CHAIN_ID="agorictest-7"
SALARY=0 #if you want to keep something without delegate
KEYRING="file"  #in my case is file, normally "os"
DENOM="uagstake"

while true; do
        # withdraw reward
        echo -e "$WALLET_PWD\n$WALLET_PWD\n" | $BIN_FILE tx distribution withdraw-rewards $OPERATOR --commission --chain-id $CHAIN_ID --from $WALLET_NAME -y --gas auto --gas-adjustment 1.5  --keyring-backend $KEYRING
        sleep  5 #give time for TX
        echo .....Check balance....

        # check current balance
        BALANCE=$($BIN_FILE query bank balances $SELF_ADDR -o json  | jq -r .balances[0].amount)

        echo .
        echo CURRENT BALANCE IS: $BALANCE
        echo .

        if (( $BALANCE >= 100 ));then
                PERMITED=$((BALANCE-SALARY))
                PERMITED+=$DENOM
                echo .
                echo "Let's delegate $PERMITED of REWARD tokens to $SELF_ADDR"
                echo .
                # delegate balance
                echo -e "$WALLET_PWD\n$WALLET_PWD\n" | $BIN_FILE tx staking delegate $OPERATOR $PERMITED --chain-id $CHAIN_ID --from $WALLET_NAME -y   --gas auto  --gas-adjustment 1.5  --keyring-backend $KEYRING

        else
        echo .
                echo "Reward is less than 1 uagstake"

        fi

        #loop
        echo .
        echo 'NEXT CHECK IN 5 min'
        echo . 
        sleep 300
done
