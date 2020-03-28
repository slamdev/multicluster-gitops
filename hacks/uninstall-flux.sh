#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# script uninstalls flux in all clusters
PROJECT=$(gcloud projects list --format='get(projectId)' | grep multicluster-gitops-)

function uninstall() {
  local cluster=$1
  local path=$2
  echo "--- uninstalling $1 $2"
  local zone
  zone=$(gcloud container clusters list --format='get(zone)' --filter="${cluster}" --project="${PROJECT}")
  gcloud container clusters get-credentials "${cluster}" --zone="${zone}" --project="${PROJECT}"
  for i in $(helm list -A -q); do
    ns=$(helm list -A -ojson | jq -r ".[] | select(.name == \"${i}\") | .namespace")
    helm uninstall --namespace "${ns}" "${i}"
  done
  kustomize build "../clusters/${path}" | kubectl delete -f -
  kubectl delete -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml
}

uninstall "dev-eu" "dev/eu"
uninstall "prod-eu" "prod/eu"
uninstall "prod-us" "prod/us"
