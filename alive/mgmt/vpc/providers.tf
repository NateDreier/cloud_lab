provider "aws" {
  profile = var.profile
  region  = var.region_west_primary
  alias   = "region_west_primary"
}

provider "aws" {
  profile = var.profile
  region  = var.region_east_primary
  alias   = "region_east_primary"
}


