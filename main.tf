# Region1 
resource "aws_security_group" "sg_region1" {
  name        = "nginx-sg-region1"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NGINX"
    from_port   = 80
    to_port     = 80
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


# Region 2
resource "aws_security_group" "sg_region2" {
  provider    = aws.region2
  name        = "nginx-sg-region2"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

# instance Region 1
resource "aws_instance" "ec2_region1" {
  ami                         = data.aws_ami.amazon_linux_region1.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.sg_region1.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras enable nginx1
              yum install nginx -y
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Deployed from Terraform</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "nginx-region1"
  }
}

# instance Region 2
resource "aws_instance" "ec2_region2" {
  provider                    = aws.region2
  ami                         = data.aws_ami.amazon_linux_region2.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.sg_region2.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras enable nginx1
              yum install nginx -y
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Deployed from Terraform</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "nginx-region2"
  }
}

data "aws_ami" "amazon_linux_region1" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

data "aws_ami" "amazon_linux_region2" {
  provider    = aws.region2
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}
