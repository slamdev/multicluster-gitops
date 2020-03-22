#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# scripts deletes a projects in GCP (clusters will be deleted as well)
PROJECT=$(gcloud projects list --format='get(projectId)' | grep multicluster-gitops-)

gcloud projects delete "${PROJECT}" --quiet
