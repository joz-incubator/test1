variable "region" {
  default = "europe-west6"
}

variable "zone" {
  default = "europe-west6-c"
}

variable "customer" {
  default = "whatever3"
}

variable "cidr" {
  default = "10.0.0.0/24"
}

variable "fwdest" {
  default = ["0.0.0.0/0"]
}
