esource "google_compute_router" "router" {
  name                          = "service-cloud-router"
  project                       = var.project
  network                       = "service-vpc-test1"
  region                        = "europe-west6"

  dynamic "bgp" {
      advertise_mode     = "DEFAULT"
      advertise_groups = ["ALL_SUBNETS"]
  }

}
