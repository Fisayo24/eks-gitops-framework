EKS GitOps Framework
This repository contains a professional-grade Infrastructure as Code (IaC) framework for deploying and managing an AWS EKS cluster using a GitOps methodology. The architecture prioritizes automated governance, identity isolation, and shift-left security practices to ensure a production-ready cloud environment.

Architecture and Tech Stack
Infrastructure: Modularized HashiCorp Terraform for multi-region cloud provisioning.

Orchestration: Amazon EKS (Elastic Kubernetes Service).

GitOps: ArgoCD for continuous delivery and automated synchronization.

Security: Integration of IAM OIDC providers, identity isolation, and automated guardrails.

Deployment Status
The following visualization confirms the live synchronization state of the EKS cluster. This demonstrates that the live environment successfully matches the declarative state defined within this repository.

![ArgoCD Sync Status](terraform/terraform/screenshots/argocd-sync-status.png)
