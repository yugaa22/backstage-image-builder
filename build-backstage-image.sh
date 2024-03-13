#!/bin/bash

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--image-tag)
      TAG="$2"
      shift # past argument
      shift # past value
      ;;
    -b|--cnoe-backstage-branch)
      BRANCH="$2"
      shift # past argument
      shift # past value
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

TAG=${TAG:-backstage:latest}
BRANCH=${BRANCH:-main}

echo "IMAGE TAG = ${TAG}"
echo "CNOE BACKSTAGE-APP BRANCH = ${BRANCH}"

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

    echo "Checking out branch $BRANCH for 'backstage-app'"
    cd $root_dir/vendor/backstage
    git checkout $BRANCH
else
  echo "!!!BACKSTAGE DIRECTORY $root_dir/vendor/backstage already exists. Please delete and re-run.!!!"
fi

cd $root_dir

cp Dockerfile $root_dir/vendor/backstage
cp .dockerignore $root_dir/vendor/backstage
cp cnoe-wrapper.sh $root_dir/vendor/backstage

cd $root_dir/vendor/backstage

echo "The docker image will be tagged: $TAG"
docker image build -t $TAG .
