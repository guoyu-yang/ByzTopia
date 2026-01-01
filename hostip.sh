#!/bin/bash


if [ "$#" -ne 3 ]; then
    echo "$0 <replicas_count> <ip_address> <starting_port>"
    exit 1
fi


replicas_count=$1
ip_address=$2
starting_port=$3


base_ip=$(echo "$ip_address" | cut -d'.' -f1-3)


config="{"
config+="\"maxBatchSize\": 1000,"
config+="\"maxTxSize\": 250,"
config+="\"sleepTimer\": 50,"
config+="\"randomTimer\": 50,"
config+="\"clientTimer\": 300000,"
config+="\"broadcastTimer\": 300000,"
config+="\"tParameter\": 0,"
config+="\"verbose\": false,"
config+="\"evalMode\": 0,"
config+="\"evalInterval\": 10,"
config+="\"cryptoOpt\": 0,"
config+="\"local\": true,"
config+="\"maliciousNode\": false,"
config+="\"maliciousMode\": 0,"
config+="\"maliciousNID\": \"1,2\","
config+="\"splitPorts\": false,"
config+="\"logOpt\": 0,"
config+="\"consensus\": 4,"
config+="\"RBCType\": 1,"
config+="\"replicas\": ["

for ((i=0; i<replicas_count; i++)); do
    incremented_host=$((i + 2))
    config+="{\"id\": \"$i\", \"host\": \"$base_ip.$incremented_host\", \"port\": \"$starting_port\"}"
    if [ "$i" -lt "$((replicas_count - 1))" ]; then
        config+=","
    fi
done

config+="]}"
echo "$config" > ./etc/conf.json

echo "save to conf.json"
