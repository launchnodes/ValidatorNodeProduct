export PATH=$PATH:/usr/bin/curl
echo "Enter the bls_to_execution.json file location: "
read file
echo "Braodcasting..."
curl -X POST -H 'Content-type:application/json' -d @$file http://45.77.35.126:3500/eth/v1/beacon/pool/bls_to_execution_changes