#!/bin/bash
#set -x
set -e # Exit with nonzero exit code if anything fails

SOURCE_BRANCH="master"
TARGET_BRANCH="screenshot_test"

# Save some useful information
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`

# Now let's go have some fun with the cloned repo
# cd out
git config user.name "Travis CI"
git config user.email "$COMMIT_AUTHOR_EMAIL"

git checkout -b bugs

find . -name '*.png' | xargs git add

find . -name '*.png'
git status


# If there are no changes to the compiled out (e.g. this is a README update) then just bail.
if git diff --staged --quiet; then
    echo "No changes to the output on this push; exiting."
    exit 0
fi

# Commit the "changes", i.e. the new version.
# The delta will show diffs between new and old versions.
# git add -A .
git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"

git remote add origin-results https://${GIT_TOKEN}@github.com/dwjbosman/theia-apps.git > /dev/null 2>&1
#git remote add origin-results https://github.com/dwjbosman/theia-apps.git
git push --quiet --set-upstream origin-results bugs 
