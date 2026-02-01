variable "aws_region" {
  default = "us-east-1"
}

variable "key_name" {
  description = "Your EC2 key pair name"
}

variable "ami_id" {
  default = "ami-0532be01f26a3de55"
}
