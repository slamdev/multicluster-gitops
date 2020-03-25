#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# script emulates a release process of new app by tagging a docker image with a random string and pushing it to a repo
REPO="slamdev"
ENV="prod"
APPS="app1 app2"

for app in ${APPS}; do
  rnd=$(openssl rand -hex 3)
  tag="${REPO}/${app}:${ENV}-${rnd}"
  docker build --file Dockerfile --build-arg "RND=${rnd}" --tag "${tag}" .
  docker push "${tag}"
done
