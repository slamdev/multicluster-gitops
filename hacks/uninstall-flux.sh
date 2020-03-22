#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# script uninstalls flux in all clusters
PROJECT=$(gcloud projects list --format='get(projectId)' | grep multicluster-gitops-)

function uninstall() {
  local cluster=$1
  local zone
  zone=$(gcloud container clusters list --format='get(zone)' --filter="${cluster}" --project="${PROJECT}")
  gcloud container clusters get-credentials "${cluster}" --zone="${zone}" --project="${PROJECT}"
  helm uninstall --namespace flux helm-operator
  helm uninstall --namespace flux flux
  kubectl delete namespace flux
  kubectl delete -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml
}

uninstall "dev-eu"
uninstall "prod-eu"
uninstall "prod-us"
