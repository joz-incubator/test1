resource "google_compute_router" "router" {
  name                          = "service-cloud-router"
  project                       = "he-prod-itinfra-incubator"
  network                       = "service-vpc-test1"
  region                        = "europe-west6"
}
