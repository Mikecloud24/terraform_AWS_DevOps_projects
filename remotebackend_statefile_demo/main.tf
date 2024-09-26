provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "mikecloud24" {
  instance_type = "t2.micro"
  ami = "ami-0ebfd941bbafe70c6"    # change this to your specific ami
  tags = {
    name = "demo-instance"
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"                  # you can name it depending on your choice.
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
