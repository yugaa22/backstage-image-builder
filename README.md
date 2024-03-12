# CNOE BACKSTAGE IMAGE BUILDER

The CNOE Backstage image builder creates a backstage image with CNOE
customizations applied.

## Build

```bash
export BACKSTAGE_IMAGE_NAME=backstage-app
export BACKSTAGE_IMAGE_TAG=latest

./build-backstage-image.sh "$BACKSTAGE_IMAGE_NAME:$BACKSTAGE_IMAGE_TAG"
```

## Examples

To remote registry:

```bash
export BACKSTAGE_IMAGE_REGISTRY="ghcr.io/cnoe-io/"
export BACKSTAGE_IMAGE_NAME=backstage-app
export BACKSTAGE_IMAGE_TAG=latest

./build-backstage-image.sh "$BACKSTAGE_IMAGE_REGISTRY$BACKSTAGE_IMAGE_NAME:$BACKSTAGE_IMAGE_TAG)"
docker push "$BACKSTAGE_IMAGE_REGISTRY$BACKSTAGE_IMAGE_NAME:$BACKSTAGE_IMAGE_TAG"
```

To local IDPBuilder hosted Gitea registry:

```bash
export BACKSTAGE_IMAGE_REGISTRY="gitea.cnoe.localtest.me:8443/giteaadmin/"
export BACKSTAGE_IMAGE_NAME=backstage-app
export BACKSTAGE_IMAGE_TAG=latest

./build-backstage-image.sh "$BACKSTAGE_IMAGE_REGISTRY$BACKSTAGE_IMAGE_NAME:$BACKSTAGE_IMAGE_TAG)"
docker push "$BACKSTAGE_IMAGE_REGISTRY$BACKSTAGE_IMAGE_NAME:$BACKSTAGE_IMAGE_TAG"
```
