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

variable "fwdestnets" {
  default = ["18.193.43.69/32"]
}

variable "fwdestcount" {
  default = 1
}
