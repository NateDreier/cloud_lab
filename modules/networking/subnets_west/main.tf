data "terraform_remote_state" "global-outputs" {
    backend = "s3"
    config = {
        bucket = "nates-terraform-state"
        key = "global/s3/terraform.state"
        region = "us-west-1"
    }
}

data "aws_availability_zones" "az-west-1" {
  provider = aws.region-west-primary
  state    = "available"
}

resource "aws_subnet" "subnet_west_1" {
  provider          = aws.region-west-primary
  vpc_id            = data.terraform_remote_state.global-outputs.outputs.vpc-west-primary-id
  availability_zone = element(data.aws_availability_zones.az-west-1.names, 0)
  cidr_block        = var.subnet_west_1
}

resource "aws_subnet" "subnet_west_2" {
  provider          = aws.region-west-primary
  vpc_id            = data.terraform_remote_state.global-outputs.outputs.vpc-west-primary-id
  availability_zone = element(data.aws_availability_zones.az-west-1.names, 1)
  cidr_block        = var.subnet_west_2
}