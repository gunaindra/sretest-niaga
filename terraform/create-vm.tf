resource "google_compute_instance" "vm01" {
    name            = "vm01"
    machine_type   = "e2-medium"
    zone            = "asia-southeast2-a"

    boot_disk {
        initialize_params {
            image = "centos-cloud/centos-7"
        }
    }

    network_interface {
        network = "default"

        access_config {

        }
    }

    tags = ["sre-vm"]
}

resource "google_compute_instance" "vm02" {
    name            = "vm02"
    machine_type   = "e2-medium"
    zone            = "asia-southeast2-a"

    boot_disk {
        initialize_params {
            image = "centos-cloud/centos-7"
        }
    }

    network_interface {
        network = "default"

        access_config {

        }
    }

    tags = ["sre-vm"]
}

resource "google_compute_instance" "vm03" {
    name            = "vm03"
    machine_type   = "e2-medium"
    zone            = "asia-southeast2-a"

    boot_disk {
        initialize_params {
            image = "centos-cloud/centos-7"
        }
    }

    network_interface {
        network = "default"

        access_config {

        }
    }

    tags = ["sre-vm"]
}

resource "google_compute_firewall" "sre-vm" {
    name    = "default-allow-http"
    network = "default"

    allow {
        protocol = "tcp"
        ports    = ["80","443"] 
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["sre-vm"]  
}