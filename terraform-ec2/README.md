# Terraform EC2 Demo

A simple Terraform project that provisions an EC2 instance running a Node.js web server on AWS.

## What It Creates

- **Security Group** (`terraform-web-sg`) - Allows inbound traffic on ports 22 (SSH) and 3000 (app)
- **EC2 Instance** (`t3.micro`) - Amazon Linux 2023 with a Node.js server responding "Hello from Terraform EC2!"

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed
- AWS CLI configured with credentials
- An existing EC2 key pair in the target region

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

# Get the public IP
terraform output public_ip
```

Access your app at `http://<public_ip>:3000`

## Cleanup

```bash
terraform destroy
```

## Output

| Name | Description |
|------|-------------|
| `public_ip` | Public IP address of the EC2 instance |
