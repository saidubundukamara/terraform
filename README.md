# Terraform AWS Infrastructure Projects

A collection of Terraform infrastructure-as-code projects for provisioning AWS resources.

## Projects

### 1. [terraform-ec2](./terraform-ec2)
A foundational project that provisions a single EC2 instance with a Node.js web server.

**What it deploys:**
- Single `t3.micro` EC2 instance
- Security group for SSH and HTTP access
- Node.js server on port 3000

**Use case:** Learning Terraform basics, simple web server deployment

[View documentation →](./terraform-ec2/README.md)

### 2. [terraform-ec2-asg](./terraform-ec2-asg)
A production-ready Auto Scaling Group with Application Load Balancer for high availability.

**What it deploys:**
- Auto Scaling Group (2-4 instances)
- Application Load Balancer
- Target Group with health checks
- Security group for SSH, HTTP, and app traffic

**Use case:** Scalable, fault-tolerant web applications

[View documentation →](./terraform-ec2-asg/README.md)

## Prerequisites

All projects require:
- [Terraform](https://developer.hashicorp.com/terraform/downloads) (>= 1.0)
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- An AWS account with appropriate permissions
- EC2 key pair in your target region

## Quick Start

1. Navigate to a project directory:
```bash
cd terraform-ec2  # or terraform-ec2-asg
```

2. Create `terraform.tfvars` with your configuration:
```hcl
key_name = "your-key-pair-name"
```

3. Deploy the infrastructure:
```bash
terraform init
terraform plan
terraform apply
```

4. Clean up resources when done:
```bash
terraform destroy
```

## Project Structure

```
terraform/
├── README.md                    # This file
├── .gitignore                   # Terraform ignore patterns
├── terraform-ec2/               # Single EC2 instance project
│   ├── main.tf
│   ├── variables.tf
│   └── README.md
└── terraform-ec2-asg/           # Auto Scaling Group project
    ├── main.tf
    ├── variables.tf
    └── README.md
```

## AWS Region

Both projects default to `us-east-1`. To use a different region, set it in `terraform.tfvars`:

```hcl
aws_region = "us-west-2"
```

## Best Practices

- Always run `terraform plan` before `terraform apply`
- Use `terraform.tfvars` for sensitive/environment-specific values
- Never commit `terraform.tfvars`, `.tfstate` files, or AWS credentials
- Run `terraform destroy` to clean up resources and avoid charges
- Review the security group rules before deploying to production

## Cost Considerations

- `t3.micro` instances are eligible for AWS Free Tier (750 hours/month for 12 months)
- Application Load Balancers incur hourly charges and LCU costs
- Always destroy resources when not in use to minimize costs

## Contributing

When adding new projects:
1. Create a new directory with a descriptive name
2. Include a detailed README.md
3. Follow the existing variable naming conventions
4. Update this main README with project details
