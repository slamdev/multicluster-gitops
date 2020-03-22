#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# scripts create a project and small clusters in GCP via gcloud cli
PROJECT="multicluster-gitops-$(openssl rand -hex 3)"
BILLING_ACCOUNT_ID=$(gcloud beta billing accounts list --format='get(name)' | grep -oE '[^/]+$')
CLUSTERS="dev-eu prod-eu prod-us"

gcloud projects create "${PROJECT}"
gcloud beta billing projects link "${PROJECT}" --billing-account "${BILLING_ACCOUNT_ID}"
gcloud services enable container.googleapis.com --project=${PROJECT}

for c in ${CLUSTERS}; do
  gcloud container clusters create "${c}" --zone="europe-west4-a" --machine-type="g1-small" --num-nodes=2 --preemptible --project=${PROJECT}
done
