###
# This script is responsible for checking out a tag from a git repo
###

#!/bin/bash
TAG=""

if [ -z "$TAG" ] || [ $TAG == "LATEST" ];
then
  echo "checking out latest tag:"
  TAG=`git describe --tags $(git rev-list --tags --max-count=1)`
  echo $TAG
else
  echo "TAG was set to $TAG"
fi

git checkout $TAG
