set -eux
set -o pipefail

root_dir=$(dirname $(readlink -f $0))

export PLUGIN_ROOT=$VENDOR_ROOT/backstage-plugins

mkdir -p $PLUGIN_ROOT/src
mkdir -p $PLUGIN_ROOT/published

echo "Copying in-tree plugins to vendor for installation..."
if [[ -d $root_dir/src ]] ; then
    cd $root_dir/src
    for file in */ ;
    do
        plugin_src_dir="${file%/}"
        cp -r $root_dir/src/$plugin_src_dir $PLUGIN_ROOT/src/
    done
fi

echo "Installing plugins from vendorized plugin src folders..."
plugin_list=()
cd $PLUGIN_ROOT/src
for file in */ ; do
    plugin_src_dir="${file%/}"
    plugin_name=$(cat $plugin_src_dir/package.json | python3 -c 'import json,sys;print(json.load(sys.stdin)["name"])')

    cd $PLUGIN_ROOT/src/$plugin_src_dir

    yarn install
    yarn tsc
    yarn build
    #npm config set prefix /tmp
    npx -y local-package-publisher -p

    plugin_published_dir=$PLUGIN_ROOT/published/$plugin_src_dir

    rm -rf $plugin_published_dir

    mv $(cat .local-pack/settings.json | python3 -c 'import json,sys;print(json.load(sys.stdin)["TempPath"])') $plugin_published_dir

    plugin_list=("${plugin_list[@]}" "$plugin_name"@file:$plugin_published_dir)
done

yarn add --cwd $BACKSTAGE_ROOT/packages/backend "${plugin_list[@]}" @backstage/integration

echo "Copying pre-configured scaffolder.js into place to register scaffolder plugin routes..."
cp $root_dir/scaffolder.ts $BACKSTAGE_ROOT/packages/backend/src/plugins/scaffolder.ts
