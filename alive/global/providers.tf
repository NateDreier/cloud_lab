provider "aws" {
  profile = var.profile
  region  = var.region-west-primary
  alias   = "region-west-primary"
}

provider "aws" {
  profile = var.profile
  region  = var.region-east-primary
  alias   = "region-east-primary"
}
