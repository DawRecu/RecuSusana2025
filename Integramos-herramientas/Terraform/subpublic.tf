#? Creación de la subred pública
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.mi_vpc.id
  cidr_block = "10.0.101.0/24"
  map_public_ip_on_launch = true #Mapea una ip pública al crearse

  # Poner un tag, para encontrar rápidamente cuál ha creado
  tags = {
    Name = "Public-DAW"
  }
}

#? Creación del Internet Gateway
resource "aws_internet_gateway" "ub-jenkins-gw" {
  vpc_id = aws_vpc.mi_vpc.id

  tags = {
    Name = "ub-jenkins-gw"
  }
}

#? Creación de la tabla de enrutamiento pública
resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.mi_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ub-jenkins-gw.id
  }

  tags = {
    Name = "rt-public-ub-jenkins"
  }
}

#? Asociación de la tabla de enrutamiento
resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt-public.id
}