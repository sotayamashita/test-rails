#!/bin/bash

set -Ceu

readonly USERNAME=sota0805
readonly IMAGE=create-rails-app

git pull

version=`cat VERSION`
echo "version: $version"

# run build
./scripts/build.sh

# tag it
git add -A
git commit -m "version $version"
git tag -a "$version" -m "version $version"
git push
git push --tags

docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$version

docker push $USERNAME/$IMAGE:latest
docker push $USERNAME/$IMAGE:$version
