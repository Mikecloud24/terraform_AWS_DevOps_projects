terraform {
  backend "s3" {
    bucket = "mys3sleepbucket"
    key = "mys3sleepbucket/terraform.tfstate"
    region = "eu-central-1"
  }
}