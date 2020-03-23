#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# script emulates a release process of new app by tagging a docker image with a random string and pushing it to a repo
REPO="slamdev"
ENV="prod"

for i in Dockerfile-*; do
  img=$(echo "${i}" | cut -d'-' -f2)
  rnd=$(openssl rand -hex 3)
  tag="${REPO}/${img}:${ENV}-${rnd}"
  docker build --file "${i}" --build-arg "RND=${rnd}" --tag "${tag}" .
  docker push "${tag}"
done
