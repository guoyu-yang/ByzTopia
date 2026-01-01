#!/bin/bash


IMAGE_NAME="test"
IMAGE_TAG="1.0"

# build image

docker stop $(docker ps -a | grep "$IMAGE_NAME:$IMAGE_TAG" | awk '{print $1}')
# docker rm $(docker ps -a | grep "$IMAGE_NAME:$IMAGE_TAG" | awk '{print $1}')
docker rmi "$IMAGE_NAME:$IMAGE_TAG"
docker build -t $IMAGE_NAME:$IMAGE_TAG  .