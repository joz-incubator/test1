resource "google_compute_network" "vpc_network" {
  name                    = "service-vpc-test1"
  project                 = "he-prod-itinfra-incubator"
  auto_create_subnetworks = false
  mtu                     = 1460
  enable_ula_internal_ipv6 = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "service-subn-test1"
  project       = "he-prod-itinfra-incubator"
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west6"
  network       = google_compute_network.vpc_network.id
  private_ip_google_access   = true
  private_ipv6_google_access = false
  enable_flow_logs           = false
  stack_type                 = "IPV4_ONLY"
}

resource "google_compute_instance" "compute_vm" {
  project                 = "he-prod-itinfra-incubator"
  name                    = "service-vm-test1"
  machine_type            = "e2-medium"
  zone                    = "europe-west6-c"

  boot_disk {
    initialize_params {
      image = "debian-12-bookworm-v20250610"
      size  = 10
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    enable_vtpm                 = true
  }


}
