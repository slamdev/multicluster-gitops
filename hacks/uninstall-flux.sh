#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# script uninstalls flux in all clusters
PROJECT=$(gcloud projects list --format='get(projectId)' | grep multicluster-gitops-)

function uninstall() {
  local cluster=$1
  local zone=$2
  gcloud container clusters get-credentials "${cluster}" --zone="${zone}" --project="${PROJECT}"
  helm uninstall --namespace flux helm-operator
  helm uninstall --namespace flux flux
  kubectl delete namespace flux
  kubectl delete -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml
}

uninstall "dev-eu" "europe-west4-a"
uninstall "prod-eu" "europe-west4-a"
uninstall "prod-us" "europe-west3-a"
