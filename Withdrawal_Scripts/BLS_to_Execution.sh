#!/bin/bash
sudo chmod -R 777 /home/ec2-user/validator_keys
echo "Please enter the path for deposit_data.json file: "
read DEPOSIT_FILE

# Set the key name you want to retrieve
KEY_NAME="withdrawal_credentials"

# Check if jq is already installed
if ! command -v jq &> /dev/null; then
    echo "jq not found. Installing..."
    if command -v apt-get &> /dev/null
    then
        # Debian-based distribution
        echo "Detected Debian-based distribution, installing jq..."
        #sudo apt-get update
        sudo apt-get install jq
    elif command -v yum &> /dev/null
    then
        # Red Hat-based distribution
        echo "Detected Red Hat-based distribution, installing jq..."
        sudo yum install jq
    elif command -v dnf &> /dev/null
    then
        # Fedora-based distribution
        echo "Detected Fedora-based distribution, installing jq..."
        sudo dnf install jq
    fi
else 
    echo "jq already installed"
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

echo "Enter the execution address for withdrawals (your metamask wallet address): "
read execution_address

#This command requests bls withdrawal credentials
command="docker run -it --rm -v $(pwd):/app/bls_to_execution_changes public.ecr.aws/n2u0q7l0/depositcli:v2.0.5 --language=english generate-bls-to-execution-change --chain=mainnet --mnemonic='$MNEMONIC' --bls_withdrawal_credentials_list='$withdrawal_credentials' --validator_start_index='$VALIDATOR_INDEX' --validator_indices='$indices' --execution_address='$execution_address'"



# Execution ofthe command
echo "Executing the following command:"
echo "$command"
eval "$command"