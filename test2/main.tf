terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



provider "aws" {
  alias  = "ohio"
  region = "us-east-2" # Ohio
}

provider "aws" {
  alias  = "oregon"
  region = "us-west-2" # Oregon
}

provider "aws" {
  alias  = "california"
  region = "us-west-1" # California
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1" # Virginia
}

locals {
  region_providers = {
    "us-east-1" = aws.virginia
    "us-east-2" = aws.ohio
    "us-west-1" = aws.california
    "us-west-2" = aws.oregon
  }
}

resource "aws_instance" "web_ubuntu" {
  for_each              = { for idx, ins in var.ec2_ins : idx => ins }
  ami                   = data.aws_ami.ubuntu.id
  instance_type         = each.value.instance_type
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  region                = var.region[each.key]
  tags = {
    Name = each.value.name
  }

  provider = local.region_providers[var.region[each.key]]
}

output "ec2_ubuntu_ips" {
  value = aws_instance.web_ubuntu[*].public_ip
}

resource "aws_security_group" "allow_tls" {
  name_prefix = "allow_tls_"

  dynamic "ingress" {
    for_each = var.port
    content {
      description = "TLS from VPC"
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "ec2_ins" {
  description = "EC2 instance configurations"
  type = list(object({
    instance_type = string
    name          = string
  }))
}

variable "region" {
  description = "List of AWS regions"
  type = list(string)
}

variable "port" {
  type = list(object({
    from_port = number
    to_port   = number
  }))
}
