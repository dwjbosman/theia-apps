#!/bin/bash
set -ex

# this script is called by Travis to build the Docker image
NPM_TAG=$1
IMAGE_NAME=$2
NODEVERSION=$3


# git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
# git fetch
# git diff --name-only HEAD origin/${TRAVIS_BRANCH}

git remote set-branches --add origin $TRAVIS_BRANCH
git fetch

cd "$IMAGE_NAME-docker"

#CHANGED_FILES=$(git diff --name-status HEAD~1 HEAD .)
CHANGED_FILES=$(git diff --name-status HEAD...$TRAVIS_BRANCH .)
if [ -z "$CHANGED_FILES" ]
then
    # nothing changed, skip building
    exit 0    
fi
echo "There were changes in $IMAGE_NAME"
echo $CHANGED_FILES

exit 0


IMAGE="theiaide/$IMAGE_NAME"
IMAGE_TAG="$IMAGE":$(npm view "@theia/core@$NPM_TAG" version)
echo $IMAGE_TAG
docker build --build-arg "version=$NPM_TAG" --build-arg "NODE_VERSION=$NODE_VERSION" --build-arg "GITHUB_TOKEN=$GITHUB_TOKEN" . -t "$IMAGE_TAG" --no-cache
docker tag "$IMAGE_TAG" "$IMAGE:$NPM_TAG"
docker run --init -d -p 0.0.0.0:4000:3000 "$IMAGE_TAG"


