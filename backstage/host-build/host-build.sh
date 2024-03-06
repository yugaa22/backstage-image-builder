#!/bin/bash

set -eu
set -o pipefail

root_dir=$(dirname $(readlink -f $0))

#cd ~/backstage
export USERNAME=`id -nu $UID`
export BACKSTAGE_APP_NAME=backstage
export VENDOR_ROOT="/home/$USERNAME/vendor"
export BACKSTAGE_ROOT=$VENDOR_ROOT/$BACKSTAGE_APP_NAME

cd $VENDOR_ROOT

rm -f .yarnrc.yml

cat << EOF > .yarnrc
disable-self-update-check true

# NOTE: uncomment the following to enable registry overrides
# 
#registry "https://my-custom-npm-registry"
EOF

cat << EOF > .npmrc
disable-self-update-check=true

# NOTE: uncomment the following to enable registry overrides
# 
#registry=https://my-custom-npm-registry
EOF

#npx -y --loglevel verbose --cache $(pwd) --ignore-existing @backstage/create-app@latest --skip-install

git clone https://github.com/cnoe-io/backstage-app.git backstage

cd $BACKSTAGE_ROOT

#npx -y --loglevel verbose yarn-deduplicate yarn.lock

if [[ "$SKIP_BACKSTAGE_PLUGIN_INSTALL" -ne 1 ]]; then
    $root_dir/plugins/setup.sh
fi

echo "Copying default-app-config.yaml to app-config.yaml"
cp $root_dir/default-app-config.yaml ./app-config.yaml
