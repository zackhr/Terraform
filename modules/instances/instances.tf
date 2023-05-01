resource "google_compute_instance" "new-terraform-instance" {
  name         = "new-terraform-instance"
  machine_type = "f1-micro"
  

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20230425"
    }
  }

   network_interface {
    network = "vpc-terraform"
     subnetwork = "subnet-01"
  }

  metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
  allow_stopping_for_update = true
}

resource "google_compute_instance" "new-terraform-instance2" {
  name         = "new-terraform-instance2"
  machine_type = "f1-micro"


  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20230425"
    }
  }

  network_interface {
    network = "vpc-terraform"
     subnetwork = "subnet-02"
  }

  metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
  allow_stopping_for_update = true
}
