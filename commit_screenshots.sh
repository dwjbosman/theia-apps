#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

SOURCE_BRANCH="master"
TARGET_BRANCH="bugs"

# Save some useful information
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`

# Now let's go have some fun with the cloned repo
# cd out
git config user.name "Travis CI"
git config user.email "$COMMIT_AUTHOR_EMAIL"

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
git commit -m "Deploy to GitHub Pages: ${SHA}"

git branch -r

# Now that we're all set up, we can push.
git push $SSH_REPO $TARGET_BRANCH
