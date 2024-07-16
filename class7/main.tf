provider aws  {
  region = "us-east-2"
}

resource "aws_key_pair" "deployer" {
  key_name   = "bastion-kaizen"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_instance" "web" {
 ami                    = "ami-0649bea3443ede307"
 instance_type          = "t2.micro"
 key_name = aws_key_pair.deployer.key_name
 vpc_security_group_ids = [aws_security_group.allow_tls.id]

 
#   provisioner "file" {
#    source = "./apache.sh"                   # local machine
#    destination = "./apache.sh"            # remote machine
#   }


#  provisioner "remote-exec" {
#    inline = [ 
#     "sudo chmod +x apache.sh",
#     "./apache.sh"
#     ]
#  }
}


# resource "null_resource" "hello" {
#    provisioner "local-exec" {
#    command = "mkdir kaizen && touch hello"
#  }
# }
