resource "google_compute_network" "vpc_network" {
  name                    = "service-vpc-test1"
  project                 = "he-prod-itinfra-incubator"
  auto_create_subnetworks = false
  mtu                     = 1460
  enable_Ula_Internal_Ipv6 = false
}

resource "google_compute_subnetwork" "default" {
  name          = "service-vpc-test1"
  project       = "he-prod-itinfra-incubator"
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west6"
  network       = google_compute_network.vpc_network.id
  allow_Subnet_Cidr_Routes_Overlap = false
  enable_Flow_Logs                 = false
  private_Ip_Google_Access         = true
  stack_Type                       = "IPV4_ONLY"
}
