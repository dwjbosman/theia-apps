#!/bin/bash
CURDIR=$(pwd)
echo "container start path: $CONTAINER_START_PATH"
echo "theia root dir: $CURDIR"
env

cd /root/theia_rust_extension
yarn theia start $CURDIR --hostname=0.0.0.0 --log-level=debug --verbose

