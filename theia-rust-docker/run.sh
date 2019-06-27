#!/bin/bash
CURDIR=$(pwd)
echo "container start dir: $CONTAINER_START_DIR"
echo "theia root dir: $CURDIR"
env

cd /root/theia_rust_extension
yarn theia start $CURDIR --hostname=0.0.0.0

