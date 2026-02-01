provider "aws" {
  region = var.aws_region
}

# VPC and Subnet (use default VPC/subnet in your account for simplicity)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_vpc" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Then, to get the IDs for ASG:
locals {
  subnet_ids = [for s in data.aws_subnets.default_vpc.ids : s]
}

# Security group for EC2
resource "aws_security_group" "web_sg" {
  name        = "terraform-web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch template for ASG
resource "aws_launch_template" "web_lt" {
  name_prefix          = "web-"
  image_id             = var.ami_id
  instance_type        = "t3.micro"
  key_name             = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]


  user_data = base64encode(file("${path.module}/user_data.sh"))
  tags = {
    Name = "terraform-web-lt"
  }
}

# Target Group for ASG
resource "aws_lb_target_group" "web_tg" {
  name     = "web-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# ALB
resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = local.subnet_ids

  tags = {
    Name = "terraform-web-alb"
  }
}


# Listener
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  vpc_zone_identifier = local.subnet_ids
  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.web_tg.arn]

  tag {
    key                 = "Name"
    value               = "Terraform-ASG-EC2"
    propagate_at_launch = true
  }

  health_check_type         = "ELB"
  health_check_grace_period = 60

}

# Outputs
output "alb_dns" {
  value = aws_lb.web_alb.dns_name
}

output "target_group" {
  value = aws_lb_target_group.web_tg.arn
}
