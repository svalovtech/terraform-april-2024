provider aws {
    region = var.region
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  availability_zone = var.kaizen
}

variable kaizen {}

variable ami_id {
  description = "Provide ami id"
  type = string
  default = ""
}

variable instance_type {
    description = "Provide instance type"
    type = string
    default = ""
}

variable region {
    description = "Provide region"
    type = string
    default = ""
}

# ami-08be1e3e6c338b037