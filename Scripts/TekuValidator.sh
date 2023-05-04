#!/bin/bash

sudo yum install nano -y
sudo yum install unzip -y
unzip -o validator_keys.zip
sudo mkdir /home/ec2-user/validator
sudo mv /home/ec2-user/validator_keys /home/ec2-user/validator
sudo mkdir /home/ec2-user/validator/passwords

#Number of keys
echo Enter the number of keys:
read num

#Automation for keystore file names
cd /home/ec2-user/validator/validator_keys
echo "Retrieving keystore_filenames.."
ls | grep "^keystore.*\.json$" > keystore_filenames.txt
sudo chmod 777 keystore_filenames.txt
sudo chmod -R 777 /home/ec2-user/validator/passwords
sudo mv /home/ec2-user/validator/validator_keys/keystore_filenames.txt /home/ec2-user/validator/passwords
cd /home/ec2-user/validator/passwords

# prompt user to enter a password (the -s option hides the input)
read -s -p "Enter the validator_keys password: " password


#Progress bar
num_files=$(wc -l < keystore_filenames.txt)
progress=0
printf "\n\nCreating files: [%-50s] %d%%" "" "$progress"
while IFS= read -r line; do
    #Creating text files
    # extract the filename without extension
    filename=$(basename -- "$line")
    # remove the ".json" extension
    filename="${filename%.*}"
    # append the password to the file
    echo "$password" >> "$filename.txt"
    
    #Progress
    ((progress++))
    #Progress bar
    percentage=$((progress * 100 / num_files))
    filled=$(printf "%-$((percentage / 2))s" | tr ' ' '#')
    empty=$(printf "%-$(((100 - percentage) / 2))s" | tr ' ' ' ')
    printf "\rCreating files: [%s%s] %d%%" "$filled" "$empty" "$percentage"

done < keystore_filenames.txt

#remove the file
sudo rm -r keystore_filenames.txt
  
cd $Home
sudo chmod -R 777 validator
echo -e "\n\n\nHappy Staking, from Launchnodes..."