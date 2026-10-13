#!/usr/bin/env bash
# Bootstrap the Secure DevSecOps Platform from scratch.
#
# Prereqs: Docker, kind, kubectl, helm installed in WSL.
# Run after a cluster wipe to restore the whole platform from Git.

set -e

GITHUB_REPO="https://github.com/rfbytesprasad-pixel/secure-devsecops-platform.git"
CLUSTER_NAME="devsecops"

echo ">>> [1/7] Creating kind cluster..."
kind create cluster --name "$CLUSTER_NAME" || echo "Cluster already exists, continuing."

echo ">>> [2/7] Adding Helm repos..."
helm repo add hashicorp https://helm.releases.hashicorp.com 2>/dev/null || true
helm repo add external-secrets https://charts.external-secrets.io 2>/dev/null || true
helm repo add kyverno https://kyverno.github.io/kyverno/ 2>/dev/null || true
helm repo update

echo ">>> [3/7] Installing ArgoCD..."
kubectl create namespace argocd 2>/dev/null || true
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

echo ">>> [4/7] Installing Vault (dev mode)..."
helm upgrade --install vault hashicorp/vault \
  --namespace vault --create-namespace \
  --set "server.dev.enabled=true" \
  --set "server.dev.devRootToken=root" \
  --set "injector.enabled=false"
kubectl wait --for=condition=ready pod/vault-0 -n vault --timeout=180s

echo ">>> [5/7] Installing External Secrets Operator..."
helm upgrade --install external-secrets external-secrets/external-secrets \
  --namespace external-secrets --create-namespace
kubectl wait --for=condition=ready pod --all -n external-secrets --timeout=180s

echo ">>> [6/7] Installing Kyverno..."
helm upgrade --install kyverno kyverno/kyverno \
  --namespace kyverno --create-namespace \
  --set admissionController.replicas=1 \
  --set backgroundController.replicas=1 \
  --set cleanupController.replicas=1 \
  --set reportsController.replicas=1

echo ">>> [7/7] Bootstrap secrets + Vault values + ArgoCD apps..."
kubectl create namespace boutique 2>/dev/null || true
kubectl create secret generic vault-token -n boutique --from-literal=token=root 2>/dev/null || true

kubectl exec -n vault vault-0 -- vault kv put secret/boutique/db \
  username=admin \
  password='RotatedPassword456!' \
  host=postgres.boutique.svc \
  port=5432

kubectl apply -f gitops/argocd/boutique-app.yaml
kubectl apply -f gitops/argocd/policies-app.yaml

echo ""
echo ">>> Bootstrap complete."
echo "ArgoCD will now reconcile the app and policies from Git."
echo "Check progress with:"
echo "  kubectl get applications -n argocd"
echo "  kubectl get pods -n boutique"
echo ""
echo "ArgoCD UI password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo
