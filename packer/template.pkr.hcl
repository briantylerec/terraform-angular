packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.3"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu-node" {
  ami_name      = "ami-node"
  instance_type = "t2.micro"
  region        = "us-west-2"
  associate_public_ip_address = true
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  tags = {
    "Name"        = "unir-packer-task-node"
    "Environment" = "Production"
    "OS_Version"  = "Ubuntu 22.04"
    "Release"     = "Latest"
    "Created-by"  = "B. Tyler Mora"
  }
}

source "amazon-ebs" "ubuntu-mongo" {
  ami_name      = "ami-mongo"
  instance_type = "t2.micro"
  region        = "us-west-2"
  associate_public_ip_address = true
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  tags = {
    "Name"        = "unir-packer-task-mongo"
    "Environment" = "Production"
    "OS_Version"  = "Ubuntu 22.04"
    "Release"     = "Latest"
    "Created-by"  = "B. Tyler Mora"
  }
}

build {
  name    = "node-nginx-app"
  sources = ["source.amazon-ebs.ubuntu-node"]

  // Create a directory for files
  provisioner "shell" {
    inline = [
      "sudo mkdir -p /home/ubuntu/files/",
      "sudo chown ubuntu:ubuntu /home/ubuntu/files/",
    ]
  }

  // Copy files for both AWS
  provisioner "file" {
    source      = "files/"
    destination = "/home/ubuntu/files/"
  }

  provisioner "shell" {
    script = "files/script.sh"
  }

  // To create a manifest file with AMI ID
  post-processor "manifest" {
    output = "packer-node-manifest.json"
  }

  post-processor "shell-local" {
    script  = "files/script.sh"
  }
}

build {
  name    = "mongodb-instance"
  sources = ["source.amazon-ebs.ubuntu-mongo"]

  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y gnupg wget",  // Instalar dependencias necesarias para MongoDB
      "wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -",  // Agregar clave PGP de MongoDB
      "echo \"deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list",  // Agregar repositorio de MongoDB
      "sudo apt update",  // Actualizar los repositorios con MongoDB
      "sudo apt install -y mongodb-org",  // Instalar MongoDB
      "sudo systemctl enable mongod",  // Habilitar MongoDB para que inicie con el sistema
      "sudo systemctl start mongod",  // Iniciar MongoDB
    ]
  }

  // Create a directory for files
  provisioner "shell" {
    inline = [
      "sudo mkdir -p /home/ubuntu/mongo/",
      "sudo chown ubuntu:ubuntu /home/ubuntu/mongo/",
    ]
  }

  // Copy files for both AWS
  provisioner "file" {
    source      = "mongo/"
    destination = "/home/ubuntu/mongo/"
  }

  post-processor "manifest" {
    output = "packer-mongo-manifest.json"
  }

  post-processor "shell-local" {
    script  = "mongo/script.sh"
  }
}
