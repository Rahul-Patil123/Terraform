# Terraform Infrastructure

This repository holds my Terraform learning and infrastructure code for provisioning VPCs and EKS clusters on AWS using modular, reusable configurations.

## Table of Contents
- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Requirements](#requirements)
- [Usage](#usage)
- [Terraform Commands](#terraform-commands)
- [Module Documentation](#module-documentation)
- [Author](#author)

## Overview
This repo provides Terraform configurations to provision infrastructure on AWS, particularly focusing on network architecture (VPC) and managed Kubernetes clusters (EKS). It demonstrates modular designs and automation scripts for streamlined deployments.

## Repository Structure
```
.
├── modules/               # Reusable modules (e.g., VPC, EKS)
├── vpc.tf                 # Root VPC configuration
├── eks-cluster.tf         # Root EKS cluster configuration
├── variables.tf           # Root-level input variables
├── terraform.tfvars       # Example variable values
├── entry-script.sh        # Optional bootstrap or operational script
└── README.md              # You're reading it!
```

## Requirements
- Terraform v1.x+
- AWS CLI configured with proper IAM permissions
- AWS credentials (e.g., via environment or `~/.aws/credentials`)

## Usage
```bash
git clone https://github.com/Rahul-Patil123/Terraform.git
cd Terraform

# Optional: Edit terraform.tfvars to configure your environment

terraform init
terraform plan
terraform apply
```

## Terraform Commands
```bash
terraform fmt         # Format files
terraform validate    # Validate configs
terraform plan        # Plan deployment
terraform apply       # Deploy to AWS
terraform destroy     # Tear down infrastructure
```

## Module Documentation
### modules/vpc
- **Inputs**: `vpc_cidr`, `public_subnets`, `private_subnets`
- **Outputs**: `vpc_id`, `subnet_ids`
- **Description**: Creates a VPC with public and private subnets, suitable for hosting EKS or EC2 instances.

### modules/eks
- **Inputs**: `cluster_name`, `node_groups`, `vpc_id`, `subnet_ids`
- **Outputs**: `eks_cluster_id`, `kubeconfig`
- **Description**: Provisions an Amazon EKS cluster with node groups connected to the specified VPC and subnets.
