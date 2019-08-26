#!/bin/bash
set -ex

# this script is called by Travis to build the Docker image
IMAGE_NAME=$1

git remote set-branches --add origin $TRAVIS_BRANCH
git fetch

cd "$IMAGE_NAME-docker"

CHANGED_FILES=$(git diff --name-status HEAD...$TRAVIS_BRANCH .)
if [ -z "$CHANGED_FILES" ]
then
    # nothing changed, skip building
    exit 1 
fi
echo "There were changes in $IMAGE_NAME"

exit 0
