provider "google" {
  project = "he-prod-itinfra-incubator"
  region  = "europe-west6"
}

resource "google_compute_network" "vpc_network" {
  name = "custom-network"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "custom-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = "europe-west6"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "egress_https" {
  name    = "egress-https"
  network = google_compute_network.vpc_network.name

  direction = "EGRESS"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  destination_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "ingress_ssh" {
  name    = "ingress-ssh"
  network = google_compute_network.vpc_network.name

  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_instance" "vm_instance" {
  name         = "ubuntu-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {
      // No public IP will be assigned
      nat_ip = null
    }
  }

  tags = ["vm"]
}

resource "google_compute_router" "router" {
  name    = "nat-router"
  network = google_compute_network.vpc_network.name
  region  = "europe-west6"
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat-config"
  router                             = google_compute_router.router.name
  region                             = "europe-west6"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
