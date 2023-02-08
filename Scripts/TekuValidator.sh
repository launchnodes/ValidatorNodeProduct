echo "Enter the keystore file name: "
read filename
echo "Enter the validator_keys password: "
read -s walletpassword
sudo yum install nano -y
sudo yum install unzip -y
unzip -o validator_keys.zip
sudo mkdir /home/ec2-user/validator
sudo mv /home/ec2-user/validator_keys /home/ec2-user/validator
sudo mkdir /home/ec2-user/validator/passwords
echo $walletpassword > $filename.txt
sudo mv /home/ec2-user/$filename.txt /home/ec2-user/validator/passwords
cd $Home
sudo chmod -R 777 validator


echo -e "\n\n\nHappy Staking, from Launchnodes..."
