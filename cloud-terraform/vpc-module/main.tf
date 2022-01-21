######################VPC#######################
resource "aws_vpc" "myvpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.vpc_tag_name}"
  }
}
###########################public Subnet################
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.public_subnet_cidr_block

  tags = {
    Name = "${var.public_subnet_tag_name}"
  }
}

###########################Internet gateway################
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "igw"
  }
}

###########################Private Subnet################

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.private_subnet_cidr_block

  tags = {
    Name = "${var.private_subnet_tag_name}"
  }
}
###########################public Route Table ################

resource "aws_route_table" "mypublicrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id

  }

  tags = {
    Name = "mypublicroutetable"
  }
}

###########################Private Route Table ################

resource "aws_route_table" "myprivatert" {
  vpc_id = aws_vpc.myvpc.id

  route = null

  tags = {
    Name = "myprivateroutetable"
  }
}

###########################Private Route Table Association ################

resource "aws_route_table_association" "private_rta" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.myprivatert.id
}

###########################Public Route Table Association ################

resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.mypublicrt.id
}


###########################Security Groups ################


resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  dynamic "ingress" {
    for_each = [22,80,443]
    iterator = port
    content {
      description      = "TLS from VPC"
      from_port        = port.value
      to_port          = port.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }
  
  dynamic "egress" {
    for_each = [0]
    iterator = port
    content {
      from_port        = port.value
      to_port          = port.value
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }
    tags = {
    Name = "allow_tls_sg"
  }
}


  