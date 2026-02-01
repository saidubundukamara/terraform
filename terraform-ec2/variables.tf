variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI"
  default     = "ami-0532be01f26a3de55"
}

variable "key_name" {
  description = "Your EC2 key pair name"
}
