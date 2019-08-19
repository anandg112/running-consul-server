#!/bin/sh -e

echo "pulling consul"
docker pull consul


echo "running consul agent"
SERVER_CONTAINER_NAME=$1
echo "${SERVER_CONTAINER_NAME}"
CLIENT_CONTAINER_NAME=$2
echo "${CLIENT_CONTAINER_NAME}"

# process will run in the background. 
# also set port mapping to your local machine as 
# well as binding the client interface of agent to 0.0.0.0
if [ ! "$(docker ps -a | grep badger)" ]; then
    echo " container not running, starting consul"
    docker run \
    -d \
    -p 8500:8500 \
    -p 8600:8600/udp \
    --name=$SERVER_CONTAINER_NAME \
    consul agent -server -ui -node=server-1 -bootstrap-expect=1 -client=0.0.0.0
else 
    echo " container already running!"
fi

SERVER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $SERVER_CONTAINER_NAME)
echo "${SERVER_IP}"

echo "running Consul client"
if [ ! "$(docker ps -a | grep fox)" ]; then
    echo "client container not running, starting consul"
    docker run \
    --name=$CLIENT_CONTAINER_NAME \
    consul agent -node=client-1 -join=$SERVER_IP
else 
    echo " container already running!"
fi