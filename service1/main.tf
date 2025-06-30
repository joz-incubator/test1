resource "google_compute_network" "vpc_network" {
  name                    = "service-vpc-test1"
  project                 = "he-prod-itinfra-incubator"
  auto_create_subnetworks = false
  mtu                     = 1460
  enable_ula_internal_ipv6 = false
}

resource "google_compute_subnetwork" "default" {
  name          = "service-vpc-test1"
  project       = "he-prod-itinfra-incubator"
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west6"
  network       = google_compute_network.vpc_network.id
  allow_subnet_cidr_routes_overlap = false
  enable_flow_logs                 = false
  private_ip_google_access         = true
  stack_type                       = "IPV4_ONLY"
}
