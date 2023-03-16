sudo yum install nano -y
sudo yum install unzip -y
unzip -o validator_keys.zip
sudo mkdir /home/ec2-user/validator
sudo mv /home/ec2-user/validator_keys /home/ec2-user/validator
sudo mkdir /home/ec2-user/validator/passwords
echo Enter the number of keys:
read num
for ((i=1;i<=$num;i++)); do
  while true; do
    echo "Enter the name of keystore file $i (Exculde .json extension): "
    read file_name
    if [[ $file_name == *.json ]]; then
        echo "Please enter file name without .json extension."
    else
        break
    fi
  done
  echo "Enter the validator_keys password: "
  read -s walletpassword 
  echo "Creating file $file_name"
  echo $walletpassword > $file_name.txt
  sudo mv /home/ec2-user/$file_name.txt /home/ec2-user/validator/passwords
done
cd $Home
sudo chmod -R 777 validator
echo -e "\n\n\nHappy Staking, from Launchnodes..."
