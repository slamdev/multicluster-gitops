#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# script emulates a release process of new app by tagging a docker image with a random string and pushing it to a repo
IMAGES="hashicorp/http-echo nginx"
REPO="slamdev"

for i in ${IMAGES}; do
  img=$(echo "${i}" | rev | cut -d'/' -f 1 | rev)
  rnd=$(openssl rand -hex 3)
  docker pull "${i}"
  docker tag "${i}" "${REPO}/${img}:${rnd}"
  docker push "${REPO}/${img}:${rnd}"
done
