resource "google_compute_network" "vpc_network" {
  name                    = "service-vpc-test1"
  project                 = "he-prod-itinfra-incubator"
  auto_create_subnetworks = false
  mtu                     = 1460
  enable_ula_internal_ipv6 = false
  depends_on               = [google_compute_subnetwork.vpc_subnet]
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "service-vpc-test1"
  project       = "he-prod-itinfra-incubator"
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west6"
  network       = google_compute_network.vpc_network.id
  private_ip_google_access   = true
  private_ipv6_google_access = false
  enable_flow_logs           = false
  stack_type                 = "IPV4_ONLY"
}

resource "google_compute_router" "router" {
  name                          = "service-cloud-router"
  project                       = "he-prod-itinfra-incubator"
  network                       = "service-vpc-test1"
  region                        = "europe-west6"
  depends_on                    = [google_compute_network.vpc_network]
}

resource "google_compute_router_nat" "nat" {
  name                                = "service-nat-test1"
  project                             = "he-prod-itinfra-incubator"
  router                              = "service-cloud-router"
  region                              = "europe-west6"
  nat_ip_allocate_option              = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on                          = [google_compute_router.router]
}
