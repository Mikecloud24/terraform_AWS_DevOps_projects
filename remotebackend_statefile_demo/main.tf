provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "mikecloud24" {
  instance_type = "t2.micro"
  ami = "ami-0ebfd941bbafe70c6"
  tags = {
    name = "demo-instance"
  }
}