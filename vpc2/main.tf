resource "google_compute_network" "vpc_network" {
  name                    = "test-vpc1"
  project                 = "he-prod-itinfra-incubator"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "my-custom-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west6"
  network       = google_compute_network.vpc_network.id
}
