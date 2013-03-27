#!/bin/bash

allowableUser=jenkins

if [ "$USER" != "$allowableUser" ]; then
  echo "Only user $allowableUser is allowed to deploy!"
  exit 1;
fi

if [ $# -lt 1 ] || ! [[ $1 =~ ^[0-9]+$ ]]; then
  echo "Build number needed for deploy!"
  exit 1;
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
rvm gemset use whitelabel-deploy

npm install && bower install && grunt build

if [ $? -ne 0 ]; then
  echo "build failed"
  exit 1;
fi

if [ $# -lt 2 ] || [[ $2 =~ ^(major|minor|patch|build)$ ]]; then
  release=$2
else
  release="build"
fi

grunt deploy:$USER:$1:$release
