#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# script installs flux in all clusters
PROJECT=$(gcloud projects list --format='get(projectId)' | grep multicluster-gitops-)

function install() {
  local cluster=$1
  local zone=$2
  local path=$3
  gcloud container clusters get-credentials "${cluster}" --zone="${zone}" --project="${PROJECT}"
  kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml
  kubectl create namespace flux
  kubectl create secret generic flux-github-identity --from-file=./identity -nflux
  kubectl create configmap flux-github-identity-pub --from-file=./identity.pub -nflux
  helm install --namespace flux --repo=https://charts.fluxcd.io --values=values-flux.yaml --set="git.path=${path}" flux flux
  helm install --namespace flux --repo=https://charts.fluxcd.io --values=values-helm-operator.yaml helm-operator helm-operator
}

ssh-keygen -q -N "" -f ./identity

install "dev-eu" "europe-west4-a" "dev/eu"
install "prod-eu" "europe-west4-a" "prod/eu"
install "prod-us" "europe-west3-a" "prod/us"

kubectl get cm flux-github-identity-pub -nflux -oyaml

rm ./identity*
