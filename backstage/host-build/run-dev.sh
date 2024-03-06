#!/bin/bash

set -eu
set -o pipefail

cd /home/user/backstage/
yarn dev-with-serve-templates
