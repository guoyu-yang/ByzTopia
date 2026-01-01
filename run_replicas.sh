#!/bin/bash

# 检查参数是否正确
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <n> <start_index>"
    exit 1
fi

# 节点数
n=$1

# 起始节点号
start_index=$2

IMAGE_NAME="test"
IMAGE_TAG="1.0"

docker stop $(docker ps -a | grep "$IMAGE_NAME:$IMAGE_TAG" | awk '{print $1}')

# sleep 2
docker run --rm -itd \
      --name bandwidth --cap-add=NET_ADMIN --net=byzt \
      $IMAGE_NAME:$IMAGE_TAG /bin/bash -c "tc qdisc del dev lo root" 
  echo "取消限制带宽成功运行！"

sleep 2
docker run --rm -itd \
      --name bandwidth --cap-add=NET_ADMIN --net=byzt \
      $IMAGE_NAME:$IMAGE_TAG /bin/bash -c "tc qdisc add dev lo root tbf rate 30gbit burst 625kb latency 50ms" 
  echo "限制带宽成功运行！"

# -v /opt/bft/asd/log:/home/fin/var \
# -v /opt/bft/asd/etc/conf.json:/home/fin/etc/conf.json \

#循环创建和运行 n 个 replicas 

for ((i = start_index; i < start_index + n; i++));
do
  cpu1=$((4*i))
  cpu2=$((4*i+1))
  cpu3=$((4*i+2))
  cpu4=$((4*i+3))
  if [ $i -gt 0 ]; then
    cpu1=$((cpu1-i))
    cpu2=$((cpu2-i))
    cpu3=$((cpu3-i))
    cpu4=$((cpu4-i))
  fi
  echo "运行第 $i 个容器实例... 绑定 $cpu1,$cpu2,$cpu3,$cpu4"
  docker run --cpus=4 --memory=16g --cpuset-cpus="$cpu1,$cpu2,$cpu3,$cpu4" --rm -itd \
      --name $IMAGE_NAME-$i --net=byzt \
      $IMAGE_NAME:$IMAGE_TAG /bin/bash -c "./bin/server $i > /home/fin/var/replica$i.out 2>&1" 
  echo $IMAGE_NAME-$i
  echo "第 $i 个容器实例成功运行！"
done

sleep 1

# 循环完成后，创建并运行client

echo "运行额外的容器实例client..."
docker run --cpus=1 --memory=4g --rm -itd \
    --name $IMAGE_NAME-client --net=byzt \
    $IMAGE_NAME:$IMAGE_TAG /bin/bash -c "./bin/client 100 1 10001 > /home/fin/var/client.out 2>&1"
echo "client器实例成功运行！"

#docker stop $(docker ps -a | grep test:1.0 | awk '{print $1}' )
#tc qdisc del dev eth0 root
#tc qdisc show dev lo

sleep 1

# docker run --rm -itd \
#       --name bandwidth --cap-add=NET_ADMIN --net=container:bft-experiment-3 \
#       $IMAGE_NAME:$IMAGE_TAG /bin/bash -c "tc qdisc del dev eth0 root" 
#   echo "取消限制带宽成功运行！"