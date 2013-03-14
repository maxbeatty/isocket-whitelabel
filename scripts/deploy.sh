#!/bin/bash

dir=`dirname $0`
tag=$1
switchBack=false
allowableUser=jenkins

if [ "$USER" != "$allowableUser" ]; then
  echo Only user $allowableUser is allowed to deploy!
  exit 1;
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
rvm gemset use whitelabel-deploy

if [ $# -lt 1 ]; then
  switchBack=true
  pushd $dir >& /dev/null
  currentBranch=`git rev-parse --abbrev-ref HEAD`
  git pull
  tag=`git tag -l "release-*" | sort --version-sort -r | head -n 1`
  git checkout $tag
  popd >& /dev/null
fi

distDir="$dir/../dist"

npm install && bower install && grunt build

if [ $? -ne 0 ]; then
  echo "build failed"
  exit 1
fi

grunt deploy:$USER

if $switchBack ; then
  pushd $dir >& /dev/null
  git checkout $currentBranch
  popd >& /dev/null
fi
