# AWS-Arct-Autom
##AWS Multi-Tier Architecture with Terraform

## Project Overview
This project provisions a highly available, secure, and scalable multi-tier architecture** on AWS using Terraform**.

It includes:
- VPC with public/private subnets across 3 AZs
- Bastion Host in public subnet
- Application Servers in private subnets behind an ALB
- RDS MySQL database in private subnet
- EFS volume mounted to App Servers
- S3 bucket for log storage
- IAM role for EC2 → S3 access
- Auto Scaling Group with Launch Template
- DNS & HTTPS using Route 53 + ACM
- CI/CD-ready infrastructure

---

## Structure

```
project/
├── modules/              # Reusable Terraform modules
├── main.tf               # Root module
├── variables.tf          # Input variables
├── outputs.tf            # Outputs like public IP, ALB DNS, etc.
├── terraform.tfvars      # Project-specific variable values
├── provider.tf           # AWS provider config
├── .gitignore            # Ignore Terraform state, logs, etc.
└── README.md             # You're here!
```

---

## 🚀 Prerequisites
AWS CLI installed and configured (`aws configure`)
- Terraform >= 1.0
- Git installed
- SSH key (e.g., `utc-key.pem`)
- A registered domain (for Route 53 & ACM)

---

## Setup Instructions

### 1. Clone the repository
```bash
git clone https://github.com/your-username/aws-multitier-terraform.git
cd aws-multitier-terraform
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Customize variables
Edit `terraform.tfvars` or create one:
```hcl
region        = "us-east-1"
key_name      = "utc-key"
domain_name   = "yourdomain.com"
```

### 4. Validate and plan the infrastructure
```bash
terraform plan
```

### 5. Apply to deploy resources
```bash
terraform apply
```

---

## Features Deployed

| Resource           | Details                                       |
|--------------------|-----------------------------------------------|
| VPC & Subnets      | 3-tier architecture with public/private split |
| Security Groups    | Granular access control                       |
| Bastion Host       | SSH access to private instances               |
| App Servers        | Auto-scaled, behind ALB                       |
| Load Balancer      | ALB with HTTP→HTTPS redirection               |
| RDS MySQL          | Private DB with IAM auth                      |
| EFS                | Shared volume mounted to App servers          |
| S3                 | Log storage with IAM access                   |
| Cron Job           | Uploads logs to S3                            |
| Launch Template    | Used in Auto Scaling Group                    |
| Route 53 & ACM     | HTTPS with custom domain                      |
| SNS Topic          | ASG event notifications                       |

---

## Outputs

- Bastion Public IP
- ALB DNS Name
- Private Subnet IDs
- RDS Endpoint

---

## Ensure 

- Don’t upload `.pem` keys, `.tfstate`, or `.terraform/` to GitHub
- Use `.gitignore` to prevent accidental commits

---

## 🧹 Clean Up

```bash
terraform destroy
```

---

## Credits

Built with:
- Terraform Modules
- AWS Free Tier Services
- GitHub for CI/CD

---

## 📧 Contact

For questions or issues, contact **yourname@example.com**
