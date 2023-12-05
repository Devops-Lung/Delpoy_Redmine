
#Khai bao Terraform noi chuyen voi nen tang nao o day la AWS
provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
}

#Tao mot resource group redmine_vpc, neu khong co thi tao moi.
resource "aws_vpc" "redmine_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Redmine VPC"
  }
}
#Tao mot Subnet dung de ra interet cho Redmine
resource "aws_subnet" "redmine_public_subnet" {
  vpc_id            = aws_vpc.redmine_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "Redmine Public Subnet"
  }
}
#De ra Internet VPC can mot Internet Gateway 
resource "aws_internet_gateway" "redmine_ig" {
  vpc_id = aws_vpc.redmine_vpc.id

  tags = {
    Name = "Some Internet Gateway"
  }
}
# VPC nhu Router thi phai co Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.redmine_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.redmine_ig
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.redmine_ig
  }

  tags = {
    Name = "Public Route Table"
  }
}
# Dua Subnet public vao route table 
resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.redmine_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
#Tao mot security group chi mo dich vu HTTP va SSH
resource "aws_security_group" "web_sg" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.redmine_vpc.id
  //Allows
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  //Perrmit
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Tao Instance Linux Server su dung free tier cua AWS
#Instance su dung Key de SHH duoc khai bao trong Keypem tren AWS Console
#Su dung key nay de SSH len Server
#Yeu cau may co RAM toi thieu 4Gb nen su dung T2. Medium gia thue: 0.056 usd/Hr
resource "aws_instance" "web_instance" {
  ami           = "ami-078c1149d8ad719a7"
  instance_type = "t2.medium"
  key_name      = "EC2-Public"

  subnet_id                   = aws_subnet.redmine_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  tags = {
    "Name" : "Redmine Server"
  }
}