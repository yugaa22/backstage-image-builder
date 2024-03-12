# CNOE BACKSTAGE IMAGE BUILDER

The CNOE Backstage image builder creates a backstage image with CNOE
customizations applied.

## Build

```bash
~ ./build-backstage-image.sh
```

## PUSH 

To remote registry:

```bash
~ docker push ghcr.io/cnoe-io/backstage-app:latest

```

To local IDPBuilder hosted Gitea registry:

```bash
~ docker push gitea.cnoe.localtest.me:8443/giteaadmin/backstage-app:latest
```
