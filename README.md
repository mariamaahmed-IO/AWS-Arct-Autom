# AWS Multi-Tier Infrastructure with Terraform

This project provisions a full-stack AWS infrastructure using Terraform. It includes:

- VPC with public and private subnets
- Bastion host
- EC2 instances (App servers)
- Application Load Balancer
- Target Groups
- Auto Scaling Group with Launch Template
- IAM roles
- RDS (MySQL) database
- EFS volume
- S3 backup integration
- Route53 and ACM for HTTPS

---

## 🧾 Files Structure (Terraform Modules)

| File              | Description |
|-------------------|-------------|
| `provider.tf`      | AWS provider setup |
| `vpc.tf`           | VPC, subnets, route tables, NAT Gateways, IGW |
| `security_groups.tf` | Security groups for ALB, EC2, RDS, Bastion, etc. |
| `alb_tg.tf`        | Application Load Balancer and Target Group setup |
| `ami.tf`           | AMI creation from app server |
| `ec2.tf`           | Bastion and App EC2 instance creation |
| `EFS_AS.tf`        | EFS Mount Targets and Auto Scaling Group setup |
| `Iamrole.tf`       | IAM Role for EC2 to access S3 |
| `key.pair.tf`      | Key pair definition |
| `database.tf`      | RDS MySQL setup |
| `Route53_ACM.tf`   | Route 53 Hosted Zone and ACM certificate setup |
| `dataIp.tf`        | Public IP data fetch for Bastion SSH rule |
| `variables.tf`     | Input variables |
| `output.tf`        | Outputs like Bastion IP, ALB DNS, etc. |

---



### Clone the repository
```bash
git clone https://github.com/your-username/aws-multitier-terraform.git
cd aws-multitier-terraform
```
## Deployment Steps

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. Review the Plan**
   ```bash
   terraform plan
   ```

3. **Apply the Infrastructure**
   ```bash
   terraform apply
   ```

4. **Get Outputs**
   After deployment, Terraform will output:
   - Public and private subnet ID
   - VPC ID
   - Bastion Host Public IP
   - SSH to the bastion host

---

## Notes on Security

- `.terraform/`, `.tfstate`, `.tfvars`, `.pem`, and logs are excluded in `.gitignore`.
- No hard-coded credentials—access handled through AWS IAM roles or environment variables.

---
---

## Before pushing

- Add `.gitignore` to exclude `.terraform/`, state files, logs
- Make sure no `.pem` or sensitive files are tracked
- Initialize git repo and connect to GitHub

```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/your-username/your-repo.git
git push -u origin main
```

If `.terraform/` was accidentally committed:

```bash
git rm -r --cached .terraform/
git commit -m "Remove .terraform from repo"
git push origin main --force
```

---

## Questions?
Reach out or open an issue in this GitHub repo.


