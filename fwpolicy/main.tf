provider "google" {
  project = "he-prod-itinfra-incubator"
  region  = "europe-west6"
}


resource "google_compute_firewall" "rules" {
  name        = "my-firewall-rule"
  network     = "service-vpc-test1"
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}
