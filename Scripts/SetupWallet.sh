#!/bin/bash

function validate_password() {
    
    while true; do
        
        echo "Set the password for Wallet: "
        read -s walletpassword
        if [[ ${#walletpassword} -ge 8 && "$walletpassword" == *[A-Z]* && "$walletpassword" == *[a-z]* && "$walletpassword" == *[0-9]* ]]; then
        
            if [[ $walletpassword =~ ['!@#$%^&*()_+'] ]]; then
                
                sudo yum install nano -y
                sudo yum install unzip -y
                unzip -o validator_keys.zip

                mkdir /home/ec2-user/password

                cd password

                echo $walletpassword > pass.txt

                cd $Home
                
                docker rm AccountImport
                
                sudo docker run -it -v $HOME/Eth2Validators/prysm-wallet-v2:/wallet -v /home/ec2-user/password:/password --network="host" gcr.io/prysmaticlabs/prysm/validator:v5.0.3 wallet create --wallet-dir=/wallet --accept-terms-of-use --wallet-password-file=/password/pass.txt
                
                sudo docker run -it -v $HOME/validator_keys:/keys -v $HOME/Eth2Validators/prysm-wallet-v2:/wallet -v $HOME/Eth2:/validatorDB -v /home/ec2-user/password:/password --name AccountImport gcr.io/prysmaticlabs/prysm/validator:v5.0.3 --datadir=/validatorDB accounts import --keys-dir=/keys --wallet-dir=/wallet --accept-terms-of-use --wallet-password-file=/password/pass.txt
                sudo chown -R ec2-user:ec2-user /home/ec2-user/Eth2 /home/ec2-user/Eth2Validators
                sudo chmod 700 /home/ec2-user/Eth2 /home/ec2-user/Eth2Validators
               
                
                return
            else
                
                echo "[The Password must have at least 8 characters, at least 1 alphabetical character, 1 unicode symbol, and 1 number. Eg: Paas@12345]" >&2
            fi
                        
            
            
        else
            echo "[The Password must have at least 8 characters, at least 1 alphabetical character, 1 unicode symbol, and 1 number. Eg: Paas@12345]" >&2
        fi
    done
}


validate_password

echo -e "\n\n\nHappy Staking, from Launchnodes..."
