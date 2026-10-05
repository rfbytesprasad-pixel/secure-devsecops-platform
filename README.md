# Secure DevSecOps Platform

A production-grade DevSecOps platform for Kubernetes microservices with security embedded at every stage — from `git commit` to runtime detection.

## Why this exists

Most CI/CD tutorials add security as an afterthought. This project treats security as a first-class citizen — every stage of the pipeline has automated gates, every deploy is signed and verified, every running container is observed.

## Architecture

Developer → GitHub → GitHub Actions CI (SAST + SCA + IaC scan) → Build + Sign + SBOM → Container Registry → ArgoCD → Kubernetes → Policy + Secrets + Runtime monitoring → Prometheus/Grafana/Loki

## Stack

| Layer | Tools |
|---|---|
| Source control | Git, GitHub |
| CI/CD | GitHub Actions, ArgoCD |
| Containers | Docker, BuildKit |
| Kubernetes | kind (local), EKS (cloud) |
| IaC | Terraform, Ansible |
| SAST | Semgrep |
| SCA / SBOM | Trivy, Syft, Grype |
| IaC scan | Checkov |
| Secrets scan | gitleaks |
| Image signing | Cosign |
| Policy as code | Kyverno |
| Secrets mgmt | Vault, External Secrets Operator |
| Runtime security | Falco |
| Observability | Prometheus, Grafana, Loki |

## Progress

- [x] Phase 1 — Sample app on Kubernetes
- [x] Phase 2 — Platform repo structure
- [ ] Phase 3 — CI with security gates
- [ ] Phase 4 — GitOps with ArgoCD
- [ ] Phase 5 — Secrets management
- [ ] Phase 6 — Policy-as-code
- [ ] Phase 7 — Runtime security
- [ ] Phase 8 — Observability
- [ ] Phase 9 — Supply chain security
- [ ] Phase 10 — Threat model + runbooks

## Quick start

    kind create cluster --name devsecops
    kubectl create namespace boutique
    kubectl apply -f app/release/kubernetes-manifests.yaml -n boutique
    kubectl port-forward -n boutique svc/frontend-external 8080:80

Open http://localhost:8080

## License

MIT
