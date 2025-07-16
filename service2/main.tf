
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

resource "google_compute_firewall" "egress_internet" {
  name    = "egress-internet"
  network = google_compute_network.vpc_network.name
  priority = 700
  direction = "EGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  destination_ranges = ["0.0.0.0/0"]
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
    ports    = ["22", "3389"]
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
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "vm_instance" {
  name         = "vm-${var.customer}"
  zone         = var.zone
  depends_on   = [google_compute_subnetwork.subnet]
  machine_type = var.vmtype

  boot_disk {
    initialize_params {
      image = var.vmimage
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

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt update
    apt upgrade
    apt install xrdp -y
    systemctl enable xrdp
    systemctl start xrdp
    ufw allow 3389/tcp
    apt install xfce4
    touch /var/log/startup-script-done
  EOT
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
