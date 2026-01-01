#!/bin/bash

if [ "$#" -ne 9 ]; then
    echo "$0 <replicas_count> <host1> <host2> <host3> <host4> <endNumHost1> <endNumHost2> <endNumHost3> <endNumHost4>"
    exit 1
fi


replicas_count=$1
host1=$2
host2=$3
host3=$4
host4=$5
endNumHost1=$6
endNumHost2=$7
endNumHost3=$8
endNumHost4=$9


config="{"
config+="\"maxBatchSize\": 100,"
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
config+="\"consensus\": 1,"
config+="\"RBCType\": 0,"
config+="\"replicas\": ["

for ((i=0; i<replicas_count; i++)); do
    if [ "$i" -lt "$endNumHost1" ]; then
        current_host=$host1
    elif [ "$i" -lt "$endNumHost2" ]; then
        current_host=$host2
    elif [ "$i" -lt "$endNumHost3" ]; then
        current_host=$host3
    elif [ "$i" -lt "$endNumHost4" ]; then
        current_host=$host4
    fi
    config+="{\"id\": \"$i\", \"host\": \"$current_host\", \"port\": \"$((11000 + i))\"}"
    if [ "$i" -lt "$((replicas_count - 1))" ]; then
        config+=","
    fi
done

config+="]}"
echo "$config" > ./etc/conf.json

echo "save to conf.json"
