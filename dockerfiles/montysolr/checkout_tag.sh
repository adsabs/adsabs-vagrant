#!/bin/bash

###
# This script is responsible for checking out a tag from a git repo
###

TAG=""

if [ -z "$TAG" ] || [ $TAG == "LATEST" ];
then
  echo "checking out latest tag:"
  TAG=`git describe --tags $(git rev-list --tags --max-count=1)`
  echo $TAG
else
  echo "TAG was set to $TAG"
fi

git fetch
git fetch --tags

git checkout "$TAG"
