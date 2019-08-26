#!/bin/bash
set -ex

# This script is called by Travis during the install step.
# It returns 1 if no files where changed. In that case
# no further building/test is required for this image

IMAGE_NAME=$1

git remote set-branches --add origin $TRAVIS_BRANCH
git fetch

cd "$IMAGE_NAME-docker"

CHANGED_FILES=$(git diff --name-status $TRAVIS_BRANCH~1...$TRAVIS_BRANCH .)
if [ -z "$CHANGED_FILES" ]
then
    # nothing changed, skip building
    exit 1 
fi
echo "There were changes in $IMAGE_NAME"

exit 0
