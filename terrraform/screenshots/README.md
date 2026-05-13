Continuous Delivery & Automated Reconciliation

This project implements a full GitOps loop using ArgoCD to manage an Amazon EKS cluster. The image above illustrates the synchronization between the "Desired State" (stored in GitHub) and the "Actual State" (running in AWS).

Key Technical Highlights:

Declarative Configuration: All Kubernetes manifests are stored in the terraform/ directory, acting as the Single Source of Truth.

Automated Sync: ArgoCD monitors the main branch (Commit 90d9cfb) and automatically reconciles any configuration drift without manual kubectl intervention.

Cluster Health Visibility: The dashboard confirms a 'Healthy' status, indicating that the EKS pods are running exactly as defined in the source code.

Deployment Hierarchy: The visualization shows the logical flow from the ArgoCD Application Controller to the ReplicaSet and finally the live Nginx Pods.

![ArgoCD Dashboard]argocd-eks-sync-dashboard.png

