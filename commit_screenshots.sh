#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

SOURCE_BRANCH="master"
TARGET_BRANCH="bugs"

# Save some useful information
REPO=`git config remote.origin.url`
AUTH_REPO=${REPO/https:\/\/github.com\//https://${GITHUB_TOKEN}@github.com/}
SHA=`git rev-parse --verify HEAD`

git config user.name "Travis CI"
git config user.email "$COMMIT_AUTHOR_EMAIL"

git fetch --depth 1 origin $TARGET_BRANCH:$TARGET_BRANCH
git checkout $TARGET_BRANCH

#empty the branch, ignore error if alrady empty
git rm -r . || true

#add all png files
find . -name '*.png' | xargs git add

# If there are no changes to the compiled out (e.g. this is a README update) then just bail.
if git diff --staged --quiet; then
    echo "No changes to the output on this push; exiting."
    exit 0
fi

git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
git remote add origin-results ${AUTH_REPO} > /dev/null 2>&1
git push --quiet --set-upstream origin-results $TARGET_BRANCH
