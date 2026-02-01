provider "aws" {
    region = var.aws_region
}

#Security Group
resource "aws_security_group" "wb_sg"{
    name = "terraform-web-sg"

    ingress {
        from_port = 3000
        to_port   = 3000
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "terraform-web-sg"
    }
}

#EC2 Instance
resource "aws_instance" "app_server" {
    ami = var.ami_id
    instance_type = "t3.micro"
    key_name = var.key_name
    security_groups = [aws_security_group.wb_sg.name]
   
    user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nodejs git

              cat <<EOT > /home/ec2-user/server.js
              const http = require('http');
              http.createServer((req, res) => {
                res.end("Hello from Terraform EC2!");
              }).listen(3000);
              EOT

              node /home/ec2-user/server.js &
              EOF

    tags = {
        Name = "terraform-ec2-demo"
    }
    
}

output "public_ip" {
    value = aws_instance.app_server.public_ip
}