provider "google" {
  project = "he-prod-itinfra-incubator"
  region  = "europe-west6"
}

resource "google_compute_firewall" "default" {
  name    = "allow-internal"
  network = "service-vpc-test1"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.0.0/16"]
  direction     = "EGRESS"
  priority      = 899
}
