provider aws {
    region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "hello-key"
  public_key = file("~/.ssh/id_rsa.pub")

  tags = {
    Name = "hello-key"
    Env = "Dev"
    Team = "DevOps"
  }
}

