# multicluster-gitops

## Requirements

### Clusters

- **dev-eu** hosts all business applications
- **prod-eu** hosts all business applications
- **prod-us** hosts only a subset of business applications

### Apps

- **frontend** static web app deployed to **dev-eu**, **prod-eu** and **prod-us** clusters
- **backend** service deployed to **dev-eu** and **prod-eu** clusters

## Tooling

- **kustomize** to remove duplication in kube manifests
- **flux** to handle gitops way of deployment
