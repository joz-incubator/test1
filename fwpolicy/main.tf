provider "google" {
  project = "he-prod-itinfra-incubator"
  region  = "europe-west6"
}

resource "google_compute_firewall_policy" "default" {
  parent      = "organizations/30668948301"
  short_name  = "fw-policy"
  description = "Resource created for Terraform acceptance testing"
}
