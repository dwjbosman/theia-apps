#!/bin/bash
CURDIR=$(pwd)
echo "Container start path: $CONTAINER_START_PATH"
echo "Theia root dir: $CURDIR"

cd $THEIA_RUST_APP_PATH
yarn theia start $CURDIR --hostname=0.0.0.0 --log-level=debug --verbose

