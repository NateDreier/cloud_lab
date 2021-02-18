terraform {
  required_version = ">=0.14.0"
  backend "s3" {
    key    = "mgmt/vpc/terraform.state"
    bucket = "nates-terraform-state"
    region = "us-west-1"

    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

module "subnet_west" {
  source = "../../../modules/networking/subnets_west"

  subnet_west_1 = var.subnet_west_1
  subnet_west_2 = var.subnet_west_2
}