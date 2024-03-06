#!/bin/bash

set -eux
set -o pipefail

setup_dir=$(dirname $(readlink -f $0))

export FORCE_BACKSTAGE_SA_INSTALL="${FORCE_BACKSTAGE_SA_INSTALL:=0}"

echo "Adding Service Account for backstage. The service account has has the following clusterrolebinding:"
cat $setup_dir/resources/*clusterrolebinding.yaml

echo "We will configure the following context with a backstage service account:"
kubectl config current-context

echo "The kubernetes cluster that will be configured has the following info:"
kubectl cluster-info

if [[ "$FORCE_BACKSTAGE_SA_INSTALL" -ne 1 ]]; then
  read -p "Are you sure? " -n 1 -r
  echo    # (optional) move to a new line
fi
if [[ "$FORCE_BACKSTAGE_SA_INSTALL" -eq 1 || $REPLY =~ ^[Yy]$ ]]
then
    echo "Applying configs"
    kubectl create -f $setup_dir/resources --recursive || true
fi
