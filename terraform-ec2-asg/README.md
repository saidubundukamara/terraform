# Terraform EC2 Auto Scaling Group with ALB

A Terraform project that provisions a highly available Auto Scaling Group with an Application Load Balancer on AWS.

## What It Creates

- **VPC Data Source** - Uses the default VPC in your AWS account
- **Security Group** (`terraform-web-sg`) - Allows inbound traffic on ports 22 (SSH), 80 (HTTP), and 3000 (app)
- **Launch Template** - Defines EC2 instance configuration with user data script
- **Auto Scaling Group** - Manages 2-4 `t3.micro` instances across multiple availability zones
- **Application Load Balancer** - Distributes traffic across healthy instances
- **Target Group** - Routes traffic to port 3000 with health checks
- **ALB Listener** - Listens on port 80 and forwards to the target group

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed
- AWS CLI configured with credentials
- An existing EC2 key pair in the target region
- Default VPC with at least 2 subnets in different availability zones

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region to deploy to | `us-east-1` |
| `ami_id` | Amazon Linux 2023 AMI ID | `ami-0532be01f26a3de55` |
| `key_name` | Your EC2 key pair name | *required* |

Set your key pair in `terraform.tfvars`:

```hcl
key_name = "your-key-pair-name"
```

## Usage

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan -out=tfplan

# Deploy infrastructure
terraform apply

# Get the ALB DNS name
terraform output alb_dns
```

Access your application at `http://<alb_dns>`

## Auto Scaling Configuration

- **Desired Capacity**: 2 instances
- **Minimum Size**: 2 instances
- **Maximum Size**: 4 instances
- **Health Check**: ELB health checks with 60-second grace period
- **Health Check Settings**: 30-second interval, 2 healthy/unhealthy thresholds

## Cleanup

```bash
terraform destroy
```

## Outputs

| Name | Description |
|------|-------------|
| `alb_dns` | DNS name of the Application Load Balancer |
| `target_group` | ARN of the target group |
