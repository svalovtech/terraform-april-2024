 


resource "null_resource" "hello" {

    triggers = {
   always_run = "${timestamp()}"
}

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host = aws_instance.web.public_ip
  }

  provisioner "remote-exec" {
    inline = ["sudo yum install httpd -y",
    "sudo yum install git -y"
 ]
  }
}