# GitOps

ArgoCD watches this folder. Whatever is in Git gets reconciled to the cluster.

## Structure
gitops/
├── apps/
│ └── boutique/
│ └── manifests/
│ └── all.yaml
└── argocd/
└── boutique-app.yaml


## How it works

1. Commit changes to `apps/boutique/manifests/`
2. ArgoCD polls Git every 3 min (or instant via webhook)
3. ArgoCD reconciles the cluster to match Git
4. Manual `kubectl edit` → ArgoCD reverts (self-heal)

## Onboarding a new app

1. Create `apps/<name>/manifests/`
2. Add `argocd/<name>-app.yaml`
3. `kubectl apply -f gitops/argocd/<name>-app.yaml`
