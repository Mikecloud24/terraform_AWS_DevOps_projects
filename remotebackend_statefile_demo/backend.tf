terraform {
  backend "s3" {
    bucket = "mys3sleepbucket"                     # change this to your bucket name
    key = "mys3sleepbucket/terraform.tfstate"      
    region = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
