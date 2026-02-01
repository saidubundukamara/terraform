#!/bin/bash
yum update -y
yum install -y nodejs git

HOSTNAME=$(hostname -f)

cat <<EOT > /home/ec2-user/server.js
const http = require('http');
const hostname = "$HOSTNAME";
http.createServer((req, res) => {
  res.end("Hello from Terraform EC2 ASG! Hostname: " + hostname);
}).listen(3000);
EOT

node /home/ec2-user/server.js &
