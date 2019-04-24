provider "google" {
  credentials = "${file("key.json")}"
  project     = "agile-aleph-203917"
  region      = "us-central1"
}
#resource "google_compute_instance" "terraform" {
#  name         = "terraform"
#  machine_type = "n1-standard-1"
#  zone         = "us-central1-a"
#  boot_disk {
#    initialize_params {
#      image = "debian-cloud/debian-9"
#    }
#  }
#  network_interface {
#    network = "default"
#  }
#}
