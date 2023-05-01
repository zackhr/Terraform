# Terraform
Infraestructura como Código: Terraform

<h1>1-Instalación </h1>
wget https://releases.hashicorp.com/terraform/1.4.2/terraform_1.4.2_linux_amd64.zip 

• Descomprime el contenido
unzip terraform_1.4.2_linux_amd64.zip

Comprobacion de la instalacion
terraform -version
<h1>2- Creación de los archivos de configuración </h1>
<pre>
touch main.tf
touch variables.tf
mkdir modules
cd modules
mkdir instances
cd instances
touch instances.tf
touch outputs.tf
touch variables.tf
cd ..
mkdir storage
cd storage
touch storage.tf
touch outputs.tf
touch variables.tf
cd
</pre>
<h1>(variable.tf )</h1>
<pre>
variable "region" {
 default = "us-west4"
}
variable "zone" {
 default = "us-west4-b"
}
variable "project_id" {
 default = "symbolic-idea-383200"
} </pre>
<h1>(main.tf )</h1>
<pre>
required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.53.0"
  }
  }
}
provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone }
module "instances" {
  source     = "./modules/instances"
}
module "storage" {
  source     = "./modules/storage"
}
</pre>
<h1>en CloudShell : terraform init </h1>
<h1>2- Importar infraestructura</h1>
<h2>(in modules/instances/instances.tf )</h2>
<pre>
resource "google_compute_instance" "new-terraform-instance" {
  name         = "new-terraform-instance"
  machine_type = "f1-micro"
  
  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20230425"
    }
  }

  }
  network_interface {
 network = "default"
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

    }

  network_interface {
 network = "default"
  }


  metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
  allow_stopping_for_update = true }
  </pre>

<h2>Ejecute esto en CloudShell</h2>
</pre>
terraform import module.instances.google_compute_instance. new-terraform-instance [new-terraform-instance _ID]

terraform import module.instances.google_compute_instance. new-terraform-instance2 [new-terraform-instance2_ID]

terraform plan

terraform apply 
</pre>
<h1>3- Configurar un backend remoto</h1>
<h2>in storage/storage.tf</h2>
</pre>
resource "google_storage_bucket" "storage-bucket" {
  name          = "terf-tf-bucket"
  location      = "us"
  force_destroy = true
  uniform_bucket_level_access = true
}
</pre>
<h2>Añade lo siguiente al archivo main.tf</h2>
<pre>
module "storage" {
  source     = "./modules/storage" }
  </pre>
<h2>Ejecute esto en CloudShell</h2>

terraform init

terraform apply

<h2>Actualiza el siguiente archivo main.tf</h2>
<pre>
terraform {
  backend "gcs" {
    bucket  = "terf-tf-bucket"
 prefix  = "terraform/state"
  }
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.53.0"
    }
  }
}
</pre>
<h2>Ejecute esto en CloudShell</h2>

terraform init
<h1>4- Utilizar un módulo del Registro</h1>

<h2>Pégalo en main.tf </h2>
<pre>

module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 6.0.0"

    project_id   = "symbolic-idea-383200"
    network_name = "vpc-terraform"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-east1"
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "us-east1"
            subnet_private_access = "true"
            subnet_flow_logs      = "true"
            description           = "practica terraform !"
        },
    ]
}
</pre>
<h2>Ejecute esto en CloudShell</h2>

terraform init
terraform apply
<h1>5- Configurar un firewall</h1>

<h2>Añade lo siguiente al archivo main.tf</h2>
<pre>
resource "google_compute_firewall" "tf-firewall"{
  name    = "tf-firewall"
 network = "projects/symbolic-idea-383200/global/networks/vpc-terraform"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags = ["web"]
  source_ranges = ["0.0.0.0/0"]
}
</pre>
<h2>Ejecute esto en CloudShell</h2>

terraform init
terraform apply

