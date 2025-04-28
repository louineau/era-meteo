provider "aws" {
  region = "us-east-1"
}

variable "ssh_private_key" {
  description = "The SSH private key for connecting to the EC2 instance"
  type        = string
  sensitive   = true
}

variable "instance_public_ip" {
  description = "The public IP address of the existing EC2 instance"
  type        = string
}

resource "null_resource" "update_dev_container" {
  provisioner "remote-exec" {
    inline = [
      "sudo docker pull teralti/era-meteo:dev",
      "sudo docker stop era-meteo-dev-container || true",
      "sudo docker rm era-meteo-dev-container || true",
      "sudo docker run -d -p 8080:8080 --name era-meteo-dev-container teralti/era-meteo:dev"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = var.ssh_private_key
      host        = var.instance_public_ip
      timeout     = "10m"
    }
  }
}
