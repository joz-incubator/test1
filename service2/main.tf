provider "google" {
  project = "he-prod-itinfra-incubator"
  region  = "europe-west6"
}

resource "google_compute_network" "vpc_network" {
  name                    = "service-vpc-test1"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "service-subn-test1"
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west6"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "vpc_egress" {
  name        = "service-fwout-test1"
  network     = google_compute_network.vpc_network.id
  direction   = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  priority = 899
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

resource "google_compute_firewall" "vpc_ingress" {
  name        = "service-fwin-test1"
  network     = google_compute_network.vpc_network.id
  direction   = "INGRESS"
  source_ranges = ["35.235.240.0/20"]
  priority = 900
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_instance" "compute_vm" {
  depends_on   = [google_compute_subnetwork.vpc_subnet]
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

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    enable_vtpm                 = true
  }
}
