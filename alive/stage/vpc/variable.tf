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
variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}
variable "runners-count" {
  type    = number
  default = 1
}
variable "instance-type" {
  type    = string
  default = "t3.micro"
}
variable "dns-name" {
  type    = string
  default = "natethegr8.net."
}
variable "subnet_west_1" {
  type    = string
  default = "10.0.1.0/24"
}
variable "subnet_west_2" {
  type    = string
  default = "10.0.2.0/24"
}
variable "subnet_east_1" {
  type    = string
  default = "192.168.1.0/24"
}
variable "subnet_east_2" {
  type    = string
  default = "192.168.2.0/24"
}