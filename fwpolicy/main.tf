provider "google" {
  project = "he-prod-itinfra-incubator"
  region  = "europe-west6"
}


resource "google_compute_firewall" "rules" {
  name        = "my-firewall-rule"
  network     = "service-vpc-test1"
  description = "Creates firewall rule targeting tagged instances"
  direction   = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  priority = 899
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}
