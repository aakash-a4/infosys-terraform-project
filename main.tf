
# Discover the default VPC

data "aws_vpc" "default" {
  default = true
}

# Discover an available subnet

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Discover the latest Amazon Linux 2023 AMI

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create a security group

resource "aws_security_group" "web_sg" {
  name        = "infosys-web-security-group"
  description = "Allow restricted SSH and HTTP traffic"
  vpc_id      = data.aws_vpc.default.id



  ingress {
    description = "HTTP traffic"
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

  tags = {
    Name        = "infosys-web-sg"
    Environment = "learning"
  }
}

# Create EC2 instance

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  subnet_id = sort(data.aws_subnets.default.ids)[0]

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name        = "infosys-terraform-ec2"
    Environment = "learning"
    Project     = "Infosys-DevOps"
  }
}
