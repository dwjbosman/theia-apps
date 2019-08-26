#!/bin/bash

# this script is called by Travis to build the Docker image
NPM_TAG=$1
IMAGE_NAME=$2
NODEVERSION=$3

cd "$IMAGE_NAME-docker"

CHANGED_FILES=$(git diff --name-status HEAD~1 HEAD .)
if [ -z "$CHANGED_FILES" ]
then
    # nothing changed, skip building
    exit 0    
fi
echo "There were changes in $IMAGE_NAME"

IMAGE="theiaide/$IMAGE_NAME"
IMAGE_TAG="$IMAGE":$(npm view "@theia/core@$NPM_TAG" version)
echo $IMAGE_TAG
docker build --build-arg "version=$NPM_TAG" --build-arg "NODE_VERSION=$NODE_VERSION" --build-arg "GITHUB_TOKEN=$GITHUB_TOKEN" . -t "$IMAGE_TAG" --no-cache
docker tag "$IMAGE_TAG" "$IMAGE:$NPM_TAG"
docker run --init -d -p 0.0.0.0:4000:3000 "$IMAGE_TAG"


