terraform {
  required_version = ">=0.14.0"
  backend "s3" {
    key    = "prod/vpc/terraform.state"
    bucket = "nates-terraform-state"
    region = "us-west-1"

    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

module "subnet-az" {
  source = "../../../modules/networking/subnets"

  subnet_west_1 = var.subnet_west_1
  subnet_west_2 = var.subnet_west_2
  subnet_east_1 = var.subnet_east_1
  subnet_east_2 = var.subnet_east_2
}
