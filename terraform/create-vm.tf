resource "google_compute_firewall" "sre-vm" {
    name    = "default-firewall-sre"
    network = "default"

    allow {
        protocol = "tcp"
        ports    = ["80","443", "22"] 
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["sre-vm"]  
}

resource "google_compute_address" "static-vm01" {
  name = "vm-public-address-01"
  depends_on = [ google_compute_firewall.sre-vm ]
}

resource "google_compute_address" "static-vm02" {
  name = "vm-public-address-02"
  depends_on = [ google_compute_firewall.sre-vm ]
}

resource "google_compute_address" "static-vm03" {
  name = "vm-public-address-03"
  depends_on = [ google_compute_firewall.sre-vm ]
}

resource "google_compute_address" "static-chef-server" {
  name = "vm-public-address-chef-server"
  depends_on = [ google_compute_firewall.sre-vm ]
}

resource "google_compute_instance" "vm01" {
    name            = "vm01"
    machine_type   = "e2-medium"
    zone            = "asia-southeast2-a"

    boot_disk {
        initialize_params {
            image = "centos-cloud/centos-7"
        }
    }

    metadata = {
        ssh-keys        = "indraguna:${file("~/.ssh/id_rsa.pub")}"
          }
    
    metadata_startup_script  = "${file("node_init.sh")}"
   

    network_interface {
        network = "default"

        access_config {
            nat_ip = google_compute_address.static-vm01.address
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

    metadata = {
        ssh-keys        = "indraguna:${file("~/.ssh/id_rsa.pub")}"
          }

    network_interface {
        network = "default"

        access_config {
            nat_ip = google_compute_address.static-vm02.address
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

     metadata = {
        ssh-keys        = "indraguna:${file("~/.ssh/id_rsa.pub")}"
          }
    
    metadata_startup_script  = "${file("node_init.sh")}"

    network_interface {
        network = "default"

        access_config {
            nat_ip = google_compute_address.static-vm03.address
        }
    }

    tags = ["sre-vm"]
}

resource "google_compute_instance" "chef-server" {
    name            = "chef-server"
    machine_type    = "e2-medium"
    zone            = "asia-southeast2-a"

    boot_disk {
        initialize_params {
            image = "centos-cloud/centos-7"
        }
    }

    metadata = {
        ssh-keys        = "indraguna:${file("~/.ssh/id_rsa.pub")}"
        }
    
    network_interface {
        network = "default"

        access_config {
            nat_ip = google_compute_address.static-chef-server.address
        }
    }

    metadata_startup_script  = "${file("node_init.sh")}"

    # provisioner "file" {
    #     source = "install_chef_server.sh"
    #     destination = "/home/indraguna/install_chef_server.sh"

    #     connection {
    #         host = google_compute_address.static-chef-server.address
    #         type = "ssh"
    #         user = "indraguna"
    #         private_key = "${file("~/.ssh/id_rsa")}"
    #         agent = false
    #     }
    # }

    # provisioner "remote-exec" {
    #   connection {
    #         host = google_compute_address.static-chef-server.address
    #         type = "ssh"
    #         user = "indraguna"
    #         private_key = "${file("~/.ssh/id_rsa")}"
    #         agent = false
    #   }

    #   inline = [
    #     "sudo chmod +x /home/indraguna/install_chef_server.sh",
    #     "sudo bash /home/indraguna/install_chef_server.sh"
    #   ]
    # }

    tags = ["sre-vm"]
}

