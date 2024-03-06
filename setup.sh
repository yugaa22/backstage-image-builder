#!/bin/bash

if [[ "$CNOE_DEBUG" -eq 1 ]]; then
  set -x
fi

set -eu
set -o pipefail

root_dir=$(dirname $(readlink -f $0))

source $root_dir/env.sh
container_root_dir=/home/user/cnoe-backstage-build

mkdir -p $root_dir/vendor
mkdir -p $root_dir/vendor/backstage-templates/

export BACKSTAGE_USE_UCP="${BACKSTAGE_USE_UCP:=0}"

echo "Creating docker container for backstage host build"
docker build \
    -t backstage-host-build \
    --build-arg USER_UID=$UID \
    $root_dir/backstage/host-build

export SKIP_BACKSTAGE_PLUGIN_INSTALL="${SKIP_BACKSTAGE_PLUGIN_INSTALL:-0}"

if [[ "$SKIP_BACKSTAGE_PLUGIN_INSTALL" -ne 1 ]]; then
    mkdir -p $root_dir/vendor/backstage-plugins/src
    cd $root_dir/vendor/backstage-plugins/src
    
    while read plugin_repo; do
        git clone $plugin_repo || true
    done < $root_dir/backstage-plugin-repos.txt
    
    cd -
fi

if [[ ! -d $root_dir/vendor/backstage ]]; then
    docker run -ti \
        -v $(readlink -f $root_dir/vendor):/home/user/vendor \
        -v $root_dir:/home/user/cnoe-backstage-build \
        -e SKIP_BACKSTAGE_PLUGIN_INSTALL=$SKIP_BACKSTAGE_PLUGIN_INSTALL \
        backstage-host-build \
        /bin/bash /home/user/cnoe-backstage-build/backstage/host-build/host-build.sh
else
  echo ""
  echo "!!!BACKSTAGE DIRECTORY $root_dir/vendor/backstage already exists. Please delete and re-run.!!!"
fi

#backstage_docker="cnoe-backstage-build"
#
#if [[ "$SKIP_BACKSTAGE_INSTALL" -ne 1 ]]; then
#    docker kill $backstage_docker || true
#    docker rm $backstage_docker || true
#
#    if [[ "$BACKSTAGE_USE_UCP" -eq 1 ]]; then
#      $root_dir/backstage/cnoe-backstage-kubernetes-auth/setup.sh
#
#      echo "Attempting to create token for Backstage SA"
#      export BACKSTAGE_SA_TOKEN=$(kubectl create token backstage)
#      export UCP_API_URL="${UCP_API_URL:-$(kubectl config view --minify --output jsonpath="{.clusters[0].cluster.server}")}"
#      export UCP_CA_DATA="${UCP_CA_DATA:-$(kubectl config view --raw --output jsonpath='{.clusters[0].cluster.certificate-authority-data}')}"
#
#      if [[ ! -f $root_dir/vendor/backstage/k8s-config.yaml ]]; then
#        cp $root_dir/backstage/cnoe-backstage-kubernetes-auth/k8s-config.yaml $root_dir/vendor/backstage/k8s-config.yaml
#      fi
#
#      if ! grep -q "k8s-config.yaml" $root_dir/vendor/backstage/app-config.yaml; then
#cat <<-EOF >> $root_dir/vendor/backstage/app-config.yaml
#kubernetes:
#  serviceLocatorMethod:
#    type: 'multiTenant'
#  clusterLocatorMethods:
#    - \$include: k8s-config.yaml
#EOF
#      fi
#    fi
#
#    export GITHUB_TOKEN="${GITHUB_TOKEN:-'please-set-GITHUB_TOKEN-env-var'}"
#    export BACKSTAGE_SA_TOKEN="${BACKSTAGE_SA_TOKEN:-'please-set-BACKSTAGE_SA_TOKEN-env-var'}"
#    export UCP_API_URL="${UCP_API_URL:-'please-set-UCP_API_URL-env-var'}"
#    export UCP_CA_DATA="${UCP_CA_DATA:-'please-set-UCP_CA_DATA-env-var'}"
#
#    docker run -t -d \
#        -v $(readlink -f $root_dir/vendor/backstage):/home/user/backstage \
#        -v $(readlink -f $root_dir/vendor/backstage-templates):/home/user/backstage-templates \
#        -v $root_dir:/home/user/cnoe-backstage-build \
#        -p 3000:3000 \
#        -p 3001:3001 \
#        -p 7007:7007 \
#        --net="host" \
#        --name="cnoe-backstage-build" \
#        -e GITHUB_TOKEN=$GITHUB_TOKEN \
#        -e UCP_API_URL=$UCP_API_URL \
#        -e UCP_CA_DATA=$UCP_CA_DATA \
#        -e BACKSTAGE_SA_TOKEN=$BACKSTAGE_SA_TOKEN \
#        backstage-host-build \
#        /bin/bash /home/user/cnoe-backstage-build/backstage/host-build/run-dev.sh   
#fi
