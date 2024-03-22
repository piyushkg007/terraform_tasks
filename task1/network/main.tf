resource "google_compute_network" "vpc" {
  name = "vpc"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "subnet"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.vpc.self_link
  region        = "us-central1"
}

resource "google_compute_firewall" "allow_iap" {
  name    = "allow-iap"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_firewall" "internal_communication" {
  name    = "allow-internal-communication"
  network = google_compute_network.vpc.name

  allow {
    protocol = "all"
  }

  source_tags = ["internal"]
  target_tags = ["internal"]
}

resource "google_compute_firewall" "health_checks" {
  name    = "allow-health-checks"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["130.211.0.0/22"]
}
