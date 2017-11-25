#!/bin/bash -e

if [ -z "$GITHUB_API_KEY" ]; then
    >&2 echo "Please set GITHUB_API_KEY."
    exit 1
fi

if [ -z "$GITHUB_USERNAME" ]; then
    >&2 echo "Please set GITHUB_USERNAME."
    exit 1
fi

if [ -z "$GITHUB_EMAIL" ]; then
    >&2 echo "Please set GITHUB_EMAIL."
    exit 1
fi

if [ -z "$GITHUB_WIKI_UPSTREAM_URL" ]; then
    >&2 echo "Please set GITHUB_WIKI_UPSTREAM_URL."
    exit 1
fi

if [ -z "$GITHUB_WIKI_ORIGIN_URL" ]; then
    >&2 echo "Please set GITHUB_WIKI_ORIGIN_URL."
    exit 1
fi

git config user.name $GITHUB_USERNAME
git config user.email $GITHUB_EMAIL
git remote remove origin
git remote add origin https://$GITHUB_API_KEY@$GITHUB_WIKI_ORIGIN_URL.git
git remote add upstream https://$GITHUB_API_KEY@$GITHUB_WIKI_UPSTREAM_URL.git
git fetch origin
git fetch upstream
git merge upstream/master --no-edit
git push origin HEAD:master
git push upstream HEAD:master
