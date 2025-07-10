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

variable "vmtype" {
  default = "e2-medium"
}

variable "vmimage" {
  default = "projects/ubuntu-os-cloud/global/images/ubuntu-2504-plucky-amd64-v20250701"
}
