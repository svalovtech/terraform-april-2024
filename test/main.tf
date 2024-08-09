terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# resource "aws_key_pair" "ansible" {
#   key_name   = "ansible-key"
#   public_key = file("~/.ssh/id_rsa.pub")
# }

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



resource "aws_instance" "web_ubuntu_virginia" {
  count                  = var.ec2_ins[0].count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ec2_ins[0].instance_type
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  availability_zone = "${var.region[0]}b"
  tags = {
    Name = var.ec2_ins[0].name
  }

  
}

output "ec2_ubuntu_virginia" {
  value = aws_instance.web_ubuntu_virginia[*].public_ip
}

resource "aws_instance" "web_ubuntu_ohio" {
  count                  = var.ec2_ins[1].count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ec2_ins[1].instance_type
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  availability_zone = "${var.region[1]}b"
  tags = {
    Name = var.ec2_ins[1].name
  }

  
}

output "ec2_ubuntu_ohio" {
  value = aws_instance.web_ubuntu_virginia[*].public_ip
}

resource "aws_instance" "web_ubuntu_california" {
  count                  = var.ec2_ins[2].count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ec2_ins[2].instance_type
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  availability_zone = "${var.region[2]}b"
  tags = {
    Name = var.ec2_ins[2].name
  }

  
}

output "ec2_ubuntu_california" {
  value = aws_instance.web_ubuntu_virginia[*].public_ip
}

resource "aws_instance" "web_ubuntu_oregon" {
  count                  = var.ec2_ins[3].count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ec2_ins[3].instance_type
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  availability_zone = "${var.region[3]}b"
  tags = {
    Name = var.ec2_ins[3].name
  }

  
}

output "ec2_ubuntu_oregon" {
  value = aws_instance.web_ubuntu_ohio[*].public_ip
}

resource "aws_security_group" "allow_tls" {
  name = "allow_tls"

    dynamic ingress {
    for_each         = var.port
    content {
    description      = "TLS from VPC"
    from_port        = ingress.value.from_port
    to_port          = ingress.value.to_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
} 

variable "ec2_ins" {
    description = "EC2 instance configurations"
    type = list(object({
      instance_type = string
      name          = string
      count         = number
    }))
  }
  
  variable "region" {
    description = "List of AWS regions"
    type = list(string)
  }

  variable port {
 type = list(object({
  from_port = number
  to_port   = number
 }))
}
