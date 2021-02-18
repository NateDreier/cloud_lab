terraform {
  required_version = ">=0.14.0"
  backend "s3" {
    key    = "global/s3/terraform.state"
    bucket = "nates-terraform-state"
    region = "us-west-1"

    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}