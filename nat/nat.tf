resource "google_compute_project_default_network_tier" "project-tier" {
  project                             = "he-prod-itinfra-incubator"
  network_tier                        = "STANDARD"
}

resource "google_compute_router_nat" "nat" {
  name                                = "service-nat-test1"
  project                             = "he-prod-itinfra-incubator"
  router                              = "service-cloud-router"
  region                              = "europe-west6"
  nat_ip_allocate_option              = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
