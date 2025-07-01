provider "google" {
  project = "he-prod-itinfra-incubator"
  region  = var.region
}

resource "google_compute_network" "vpc_network" {
  name = "network-${var.customer}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-${var.customer}"
  ip_cidr_range = var.cidr
  region  = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "egress_https" {
  name    = "egress-${var.customer}"
  network = google_compute_network.vpc_network.name
  priority = 900
  direction = "EGRESS"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  destination_ranges = slice(var.fwdestnets, 0, var.fwdestcount)
}

resource "google_compute_firewall" "egress_deny" {
  name    = "denyout-${var.customer}"
  network = google_compute_network.vpc_network.name
  priority = 1000
  direction = "EGRESS"
  deny {
    protocol = "all"
  }
  destination_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "ingress_ssh" {
  name    = "ingress-${var.customer}"
  network = google_compute_network.vpc_network.name
  priority = 901
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_firewall" "ingress_deny" {
  name    = "denyin-${var.customer}"
  network = google_compute_network.vpc_network.name
  priority = 1001
  direction = "INGRESS"
  deny {
    protocol = "all"
  }
  destination_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "vm_instance" {
  name         = "vm-${var.customer}"
  zone         = var.zone
  depends_on   = [google_compute_subnetwork.subnet]
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2504-plucky-amd64-v20250624"
      size  = 10
      type  = "pd-balanced"
      }
    }

    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot          = true
      enable_vtpm                 = true
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id
  }
}

resource "google_compute_router" "router" {
  name    = "router-${var.customer}"
  network = google_compute_network.vpc_network.name
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  name                               = "natgw-${var.customer}"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
