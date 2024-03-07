#!/bin/bash

if [[ "$CNOE_DEBUG" -eq 1 ]]; then
  set -x
fi

set -eu
set -o pipefail

root_dir=$(dirname $(readlink -f $0))

mkdir -p $root_dir/vendor

if [[ ! -d $root_dir/vendor/backstage ]]; then
    mkdir $root_dir/vendor/backstage
    git clone https://github.com/cnoe-io/backstage-app.git $root_dir/vendor/backstage
    cp Dockerfile $root_dir/vendor/backstage
    cp .dockerignore $root_dir/vendor/backstage
    
    cd $root_dir/vendor/backstage
    git checkout k8s-apply
else
  echo ""
  echo "!!!BACKSTAGE DIRECTORY $root_dir/vendor/backstage already exists. Please delete and re-run.!!!"
fi

cd $root_dir/vendor/backstage
docker image build -t ghcr.io/cnoe-io/backstage-app .
