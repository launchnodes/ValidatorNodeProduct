#!/bin/bash

echo "Downloading the requirements"
curl -LO https://github.com/ethereum/staking-deposit-cli/releases/download/v2.5.0/staking_deposit-cli-d7b5304-darwin-amd64.tar.gz
tar -zxvf staking_deposit-cli-d7b5304-darwin-amd64.tar.gz
cd staking_deposit-cli-d7b5304-darwin-amd64

echo "Please enter the path for deposit_data.json file: "
read DEPOSIT_FILE

# Set the key name you want to retrieve
KEY_NAME="withdrawal_credentials"

# Check if jq is already installed
if ! command -v jq &> /dev/null; then
    echo "jq not found. Installing..."
    if command -v brew &> /dev/null; then
    # Homebrew
        echo "Detected macOS with Homebrew, installing jq..."
        brew install jq
    elif command -v port &> /dev/null; then
    # MacPorts
        echo "Detected macOS with MacPorts, installing jq..."
        sudo port selfupdate
        sudo port install jq
    else
    # No package manager
        echo "Detected macOS without package manager, installing jq..."
        curl -L -o jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-osx-amd64
        chmod +x jq
        sudo mv jq /usr/local/bin
    fi
    exit 0
fi

# Use jq to extract the values for the specified key
withdrawal_credentials=$(jq -r '[.. | .'"${KEY_NAME}"'? // empty] | join(",")' "$DEPOSIT_FILE")

KEY_NAME="pubkey"
pubkey=$(jq -r ".. | .${KEY_NAME}?" "$DEPOSIT_FILE")
touch file.txt
echo "$pubkey" > file.txt
while read line; do
    
    JSON=$(curl http://37.59.18.136:3500/eth/v1/beacon/states/head/validators/0x$line)
    I="index"
    # Use jq to retrieve the value of the "title" field from the JSON data
    index=$(echo "$JSON" | jq -r '.data.index')
    indices="$indices $index"
    
done < file.txt
indices="${indices#"${indices%%[![:space:]]*}"}"
#Taking inputs from the user
echo "Enter the mnemonic:"
read MNEMONIC

echo "Enter validator start index:"
read VALIDATOR_INDEX

echo "Enter the execution address for withdrawals (your metamask wallet address):"
read execution_address

#This command requests bls withdrawal credentials
command="./deposit --language=english generate-bls-to-execution-change \
--chain=mainnet \
--mnemonic='$MNEMONIC' \
--bls_withdrawal_credentials_list='$withdrawal_credentials' \
--validator_start_index='$VALIDATOR_INDEX' \
--validator_indices='$indices' \
--execution_address='$execution_address'"

# Execution of the command
echo "Executing the following command:"
echo "$command"
eval "$command"