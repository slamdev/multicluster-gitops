#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if command -v "kubeval" >/dev/null; then
  KUBEVAL="kubeval"
else
  tmpDir=$(mktemp -d)
  wget -O "${tmpDir}/kubeval.tar.gz" "https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-$(uname -s)-amd64.tar.gz"
  tar xf "${tmpDir}/kubeval.tar.gz" -C "${tmpDir}"
  KUBEVAL="${tmpDir}/kubeval"
fi

${KUBEVAL} --version

for f in ../clusters/*/*/kustomization.yaml; do
  echo "linting ${f}"
  kustomize build "$(dirname "${f}")" | ${KUBEVAL} --strict --kubernetes-version=1.14.7 --skip-kinds=HelmRelease
done
