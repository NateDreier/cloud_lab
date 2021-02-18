data "aws_s3_bucket" "terraform_state" {
  provider = aws.region-west-primary
  bucket   = "nates-terraform-state"
}

data "aws_dynamodb_table" "terraform-locks" {
  provider = aws.region-west-primary
  name     = "terraform-locks"
}


############### BELOW RESOURCES WERE REMOVED FROM TERRAFORM STATE ###############

#resource "aws_s3_bucket" "terraform_state" {
#  bucket   = "nates-terraform-state"
#  provider = aws.region-west-primary
#  versioning {
#    enabled = true
#  }
#  server_side_encryption_configuration {
#    rule {
#      apply_server_side_encryption_by_default {
#        sse_algorithm = "AES256"
#      }
#    }
#  }
#}

#resource "aws_dynamodb_table" "terraform-locks" {
#  provider     = aws.region-west-primary
#  name         = "terraform-locks"
#  billing_mode = "PAY_PER_REQUEST"
#  hash_key     = "LockID"
#
#  attribute {
#    name = "LockID"
#    type = "S"
#  }
#}