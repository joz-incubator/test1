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
resource "google_compute_firewall_policy" "example_policy" {
  name     = "example-firewall-policy"
  short_name = "example-policy"
  description = "Example firewall policy"
}

resource "google_compute_firewall_policy_rule" "example_rule" {
  firewall_policy = google_compute_firewall_policy.example_policy.name
  priority        = 899
  action          = "allow"
  direction       = "EGRESS"
  match {
    src_ip_ranges = ["10.0.0.0/8"]
    layer4_configs {
      ip_protocol = "tcp"
    }
  }
  target_resources = ["589375120734031079"]
}

resource "google_compute_firewall_policy_association" "example_association" {
  name            = "example-association"
  attachment_target = "589375120734031079"
  firewall_policy = google_compute_firewall_policy.example_policy.name
}
