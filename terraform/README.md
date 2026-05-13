EKS GitOps Framework
This repository contains a professional-grade Infrastructure as Code (IaC) framework for deploying and managing an AWS EKS cluster using a GitOps methodology. The architecture prioritizes automated governance, identity isolation, and shift-left security practices to ensure a production-ready cloud environment.

Architecture and Tech Stack
Infrastructure: Modularized HashiCorp Terraform for multi-region cloud provisioning.

Orchestration: Amazon EKS (Elastic Kubernetes Service).

GitOps: ArgoCD for continuous delivery and automated synchronization.

Security: Integration of IAM OIDC providers, identity isolation, and automated guardrails.

Deployment Status
The following visualization confirms the live synchronization state of the EKS cluster. This demonstrates that the live environment successfully matches the declarative state defined within this repository.

![ArgoCD Sync Status](https://raw.githubusercontent.com/Fisayo24/eks-gitops-framework/main/terraform/argocd-sync-status.png)

## Security & Governance

This framework implements **Shift-Left Security** and **Automated Governance** principles to ensure a hardened production environment:

*   **Identity Isolation**: Leverages AWS IAM Roles for Service Accounts (IRSA) to provide fine-grained, least-privilege permissions to Kubernetes pods.
*   **Infrastructure Scanning**: Integration readiness for **tfsec** to perform static analysis on Terraform code before deployment, catching misconfigurations early.
*   **GitOps Security**: ArgoCD ensures that the live cluster state remains in sync with the version-controlled manifests, preventing "configuration drift" and unauthorized manual changes.
*   **Network Hardening**: Provisioned within a custom VPC with isolated private subnets for EKS worker nodes to minimize the public attack surface.

### Cluster Health & GitOps Sync (CLI)
![ArgoCD Components Validation](https://raw.githubusercontent.com/Fisayo24/eks-gitops-framework/main/terraform/argocd-validation.png)
