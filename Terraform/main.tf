resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "route_table_association1" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association2" {
  subnet_id = aws_subnet.subnet2.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "security_group" {
  name_prefix = "web-sg"
  vpc_id = aws_vpc.myvpc.id

  ingress = {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    egress = {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "web-sg"
  }
  }

  resource "aws_s3_bucket" "s3_bucket" {
    bucket = "hd489h84hdjs-terrform_example-bucket"
    
  }
  
resource "aws_instance" "web_server1" {
  ami = "ami-0ecb62995f68bb549"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id = aws_subnet.subnet1.id
  user_data = base64encode(file("userData.sh"))
}

resource "aws_instance" "web_server2" {
  ami = "ami-0ecb62995f68bb549"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id = aws_subnet.subnet2.id
  user_data = base64encode(file("userData.sh"))
}