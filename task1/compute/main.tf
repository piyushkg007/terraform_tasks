resource "google_compute_instance" "vm" {
    boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }
  name         = "vm"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  network_interface {
    network = module.network.vpc_self_link
    access_config {}
  }

  metadata_startup_script = "sudo apt-get update && sudo apt-get install -y nginx"
}

resource "google_compute_instance_group" "mig" {
  name             = "mig"
  instances        = [google_compute_instance.vm.self_link]
  zone             = "us-central1-a"
  network          = module.network.vpc_self_link
  named_port {
    name = "http"
    port = 80
  }
}

output "vm_name" {
  value = google_compute_instance.vm.name
}
