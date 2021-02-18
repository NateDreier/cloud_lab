variable "profile" {
  type    = string
  default = "default"
}
variable "region-west-primary" {
  type    = string
  default = "us-west-1"
}
variable "region-east-primary" {
  type    = string
  default = "us-east-1"
}
variable "subnet_west_1" {
  type    = string
  description = "subnet_west_1 address"
}
variable "subnet_west_2" {
  type    = string
  description = "subnet_west_2 address"
}