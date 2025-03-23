#? Creación del grupo de seguridad
resource "aws_security_group" "ubuntu-jenkins" {
  name        = "ub-jenkins-sg"
  description = "Permitir SSH y HTTP"
  vpc_id      = aws_vpc.mi_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "allow-ssh&http"
  }
}

#? Asociaciones de subred y grupo de seguridad a la instancia
resource "aws_network_interface" "test" {
  subnet_id       = aws_subnet.public_subnet.id
  private_ips     = ["10.0.101.20"]
  security_groups = [aws_security_group.ubuntu-jenkins.id]
}