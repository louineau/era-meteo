provider "aws" {
  region = "us-east-1"
}

variable "ssh_private_key" {
  description = "The SSH private key for connecting to the EC2 instance"
  type        = string
  sensitive   = true
}

data "aws_instances" "dev_instances" {
  filter {
    name   = "tag:Name"
    values = ["EraMeteoServer"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

data "aws_instance" "dev_instance" {
  instance_id = tolist(data.aws_instances.dev_instances.ids)[0]
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
      host        = data.aws_instance.dev_instance.public_ip
      timeout     = "10m"
    }
  }
}

# (facultatif) Affiche l'IP pour debug ou logs
output "dev_instance_ip" {
  value = data.aws_instance.dev_instance.public_ip
}
