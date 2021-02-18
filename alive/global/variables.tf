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
variable "webserver-port" {
  type    = number
  default = 80
}
variable "dns-name" {
  type    = string
  default = "natethegr8.net."
}
