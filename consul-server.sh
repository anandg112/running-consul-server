#!/bin/sh -e

echo "pulling consul"
docker pull consul


echo "running consul agent"

# process will run in the background. 
# also set port mapping to your local machine as 
# well as binding the client interface of agent to 0.0.0.0
if [ ! "$(docker ps -a | grep badger)" ]; then
    echo " container not running, starting consul"
    docker run \
    -d \
    -p 8500:8500 \
    -p 8600:8600/udp \
    --name=badger \
    consul agent -server -ui -node=server-1 -bootstrap-expect=1 -client=0.0.0.0
else 
    echo " container already running!"

fi