#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# script installs flux in all clusters
PROJECT=$(gcloud projects list --format='get(projectId)' | grep multicluster-gitops-)

function install() {
  local cluster=$1
  local path=$2
  local zone
  zone=$(gcloud container clusters list --format='get(zone)' --filter="${cluster}" --project="${PROJECT}")
  gcloud container clusters get-credentials "${cluster}" --zone="${zone}" --project="${PROJECT}"
  kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml
  kustomize build "../clusters/${path}" | kubectl apply -f -
  hv=$(yq r ../ops-apps/helm-operator/helm.yaml spec.chart.version)
  helm install --namespace flux --repo=https://charts.fluxcd.io --values=../ops-apps/helm-operator/values.yaml --version "${hv}" helm-operator helm-operator
  kubectl create secret generic flux-github-identity --from-file=./identity -nflux
  kubectl create configmap flux-github-identity-pub --from-file=./identity.pub -nflux
}

ssh-keygen -q -N "" -f ./identity

install "dev-eu" "dev/eu"
install "prod-eu" "prod/eu"
install "prod-us" "prod/us"

kubectl get cm flux-github-identity-pub -nflux -oyaml

rm ./identity*
