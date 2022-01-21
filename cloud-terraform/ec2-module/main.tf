data "aws_subnet" "subnet_details" {
      filter {
    name   = "tag:Name"
    values = [var.public_subnet_tag_name]
  }
}

# data "aws_key_pair" "server" {
#   key_name = "myserver"  
# }

resource "aws_key_pair" "ec2keypair" {
  key_name   = "ec2keypair"
  public_key = file("${path.module}/id_rsa.pub")
  }


data "aws_security_groups" "ec2_sg" {
  filter {
    name   = "tag:Name"
    values = ["allow_tls_sg"]
  }
}

resource "aws_instance" "myec2instance" {
  ami           = "ami-08e4e35cccc6189f4"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id = data.aws_subnet.subnet_details.id
  key_name = aws_key_pair.ec2keypair.key_name
  vpc_security_group_ids = data.aws_security_groups.ec2_sg.ids
}


output "InstanceIP" {
  value = aws_instance.myec2instance.public_ip
  
}