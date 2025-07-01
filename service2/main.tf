resource "google_compute_network" "vpc_network" {
  project = "he-prod-itinfra-incubator"
  name                    = "service-vpc-test1"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  project = "he-prod-itinfra-incubator"
  name          = "service-subn-test1"
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west6"
  network       = google_compute_network.vpc_network.id
}


resource "google_compute_instance" "compute_vm" {
  project = "he-prod-itinfra-incubator"
  name         = "service-vm-test1"
  tags         = ["allow-ssh"]
  zone         = "europe-west6-c"
  machine_type = "e2-micro"
  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.vpc_subnet.id
  }
  boot_disk {
    auto_delete = true
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2504-plucky-amd64-v20250624"
      size  = 10
      type  = "pd-balanced"
    }
    mode = "READ_WRITE"
  }
}
