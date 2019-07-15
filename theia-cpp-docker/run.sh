#!/bin/bash
CURDIR=$(pwd)
echo "container start path: $CONTAINER_START_PATH"
echo "theia root dir: $CURDIR"
env

cd /root/theia_cpp_extension
#yarn theia start $CURDIR --hostname=0.0.0.0 --log-level=debug --verbose
node /root/theia_cpp_extension/src-gen/backend/main.js $CURDIR --hostname=0.0.0.0
