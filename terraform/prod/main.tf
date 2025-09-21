# Rechercher une instance EC2 existante avec le tag "EraMeteoServer"
data "aws_instances" "existing_app" {
  filter {
    name   = "tag:Name"
    values = ["EraMeteoServer"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

# Obtenir les infos sur cette instance existante si trouvée
data "aws_instance" "existing" {
  count       = length(data.aws_instances.existing_app.ids) == 0 ? 0 : 1
  instance_id = data.aws_instances.existing_app.ids[0]
}


# Sélection dynamique de l'IP à utiliser
locals {
  instance_ip = length(data.aws_instance.existing) > 0 ? data.aws_instance.existing[0].public_ip : aws_instance.app_server[0].public_ip
}

# Provisioning distant Docker (pull/run) sur l'instance cible
resource "null_resource" "deploy_docker" {
  depends_on = [aws_instance.app_server]

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y || sudo yum install docker -y",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo docker pull teralti/era-meteo:latest",
      "sudo docker stop era-meteo || true",
      "sudo docker rm era-meteo|| true",
      "sudo docker run -d -p 80:80 --name era-meteo teralti/era-meteo:latest"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = var.ssh_private_key
      host        = local.instance_ip
      timeout     = "10m"
    }
  }
}
