provider "google" {
  project = "he-prod-itinfra-incubator"
  region  = "europe-west6"
}

resource "google_compute_network" "vpc_network" {
  name = "custom-network"
  auto_create_subnetworks = false
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
  priority = 899
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
  priority = 900
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_instance" "vm_instance" {
  name         = "ubuntu-vm"
  zone         = "europe-west6-c"
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
