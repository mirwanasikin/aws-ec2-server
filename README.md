# AWS EC2 Configuration with OpenTofu and Ansible

Automated EC2 provisioning and configuration using OpenTofu (Terraform-compatible) and Ansible — with **no open SSH port**. All remote access is handled through AWS Systems Manager (SSM).

---

## Purpose

This repository automates the full lifecycle of an EC2 server setup without any manual work through the AWS Console. Infrastructure is provisioned with OpenTofu and configured with Ansible, connected securely via SSM instead of traditional SSH.

I chose `opentofu` over `terraform` due to its open-source license — and honestly, it's been a pleasure to work with.

---

## Features

- **No SSH (port 22)** — all Ansible communication routes through AWS SSM via S3, keeping the attack surface minimal
- **Modular IaC** — OpenTofu uses a root/child module pattern (`compute`, `network`, `role`, `security`)
- **Dynamic AMI** — data source pulls the latest Amazon Linux image automatically
- **Remote state** — S3 bucket as OpenTofu backend with state locking
- **Dynamic inventory** — Ansible uses the `amazon.aws.aws_ec2` plugin to discover instances at runtime instead of hardcoded IPs
- **Reproducible dev environment** — Nix flake included for a consistent Ansible shell

---

## Prerequisites

Before using this setup, make sure you have the following ready:

- AWS account with appropriate IAM permissions
- An EC2 instance profile with `AmazonSSMManagedInstanceCore` policy attached
- Two S3 buckets:
  - One for OpenTofu remote state (`backend.tf`)
  - One for Ansible SSM file transfer
- AWS CLI configured locally (`aws configure`)
- OpenTofu installed (`tofu` CLI)
- Ansible with `amazon.aws` collection installed, **or** use the provided Nix flake shell

---

## Repository Structure

```
.
├── ansible
│   ├── ansible.cfg
│   ├── flake.lock
│   ├── flake.nix                    # Nix dev shell for reproducible Ansible env
│   ├── inventory
│   │   ├── group_vars
│   │   │   └── all.yml
│   │   └── server.aws_ec2.yaml      # Dynamic inventory via aws_ec2 plugin
│   ├── roles
│   │   └── base_setup
│   │       ├── defaults
│   │       │   └── main.yml
│   │       └── tasks
│   │           └── main.yml
│   └── server-playbook.yml
├── LICENSE
├── README.md
└── tofu
    ├── environment
    │   └── server
    │       ├── backend.tf
    │       ├── main.tf
    │       ├── providers.tf
    │       ├── terraform.tfvars
    │       └── variables.tf
    └── modules
        ├── compute
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── variables.tf
        ├── network
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── variables.tf
        ├── role
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── variables.tf
        └── security
            ├── main.tf
            ├── outputs.tf
            └── variables.tf
```

> [!NOTE]
> This repository is still a work in progress. Several features are planned but not yet implemented.

---

## How to Run

### 1. Provision Infrastructure with OpenTofu

```bash
cd tofu/environment/server

# Initialize backend
tofu init

# Preview changes
tofu plan

# Apply
tofu apply
```

### 2. Configure EC2 with Ansible

> Make sure your EC2 instance is running and SSM agent is active before proceeding.

If you're using the Nix flake:

```bash
cd ansible
nix develop
```

Run the playbook:

```bash
ansible-playbook -i inventory/server.aws_ec2.yaml server-playbook.yml
```

---

## How Ansible Communicates (SSM Route)

Since port 22 is intentionally closed, Ansible does not connect via SSH directly. Instead, it routes through S3 and AWS SSM:

```
Ansible → S3 Bucket → SSM Agent → EC2
```

This is handled by the `amazon.aws` community collection with a dynamic inventory plugin that discovers instances at runtime based on EC2 tags.

> [!IMPORTANT]
> Before using this setup, make sure your S3 buckets exist and your instance profile has the correct SSM permissions. Update the bucket names in `ansible.cfg` and `backend.tf` to match your own.

---

## Todo

- [x] Multiple instances using `for_each` in OpenTofu modules
- [x] k3s installation on EC2
- [ ] Cloudflare integration for SSL
- [ ] Monitoring stack (Prometheus, Grafana, Node Exporter)
- [ ] Application deployment (Nextcloud or Flask demo app)

---
