variable "region" {
  default = "europe-west6"
}

variable "zone" {
  default = "europe-west6-a"
}

variable "customer" {
  default = "cutoomer"
}

variable "cidr" {
  default = "192.168.0.0/16"
}

variable "fwdestnets" {
  default = ["0.0.0.0/0"]
}

variable "fwdestcount" {
  default = 1
}
