variable "region" {
  default = "europe-west6"
}

variable "zone" {
  default = "europe-west6-a"
}

variable "customer" {
  default = "custoomer"
}

variable "cidr" {
  default = "192.168.0.0/16"
}

variable "fwdestnets" {
  default = ["18.193.43.69/32"]
}

variable "fwdestcount" {
  default = 1
}
