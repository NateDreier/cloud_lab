variable "profile" {
  type    = string
  default = "default"
}
variable "region_west_primary" {
  type    = string
  default = "us-west-1"
}
variable "region_east_primary" {
  type    = string
  default = "us-east-1"
}
variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "dns-name" {
  type    = string
  default = "natethegr8.net."
}