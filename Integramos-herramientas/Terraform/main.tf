terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

#? Creación de par de claves
resource "aws_key_pair" "ubuntu-ssh" {
  key_name   = "ubuntu-ssh"
  public_key = file("../my-key-pair.pub")

  tags = {
    Name = var.name
  }
}

#? Creación de Instancia EC2 
resource "aws_instance" "ubuntu" {
  ami               = var.imagenEc2
  instance_type     = "t2.micro"

  user_data = file("./user_data.sh")

  key_name = aws_key_pair.ubuntu-ssh.key_name

  network_interface {
    network_interface_id = aws_network_interface.test.id
    device_index         = 0
  }

  tags = {
    Name = var.name
  }
}