provider "aws" {
  region = "us-east-1"   # set your desired AWS region
}

resource "aws_instance" "demo2107-instance" {
  ami                     = "ami-0ebfd941bbafe70c6"         # specified an appropriate AMI ID
  instance_type           = "t2.micro"                      # specified your instance type
  
}