provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0e449927258d45bc4"  # Remplacez par l'AMI appropriée pour votre région
  instance_type = "t2.micro"

  tags = {
    Name = "EraMeteoServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo service docker start
              sudo docker run -d -p 80:3000 teralti/era-meteo:latest
              EOF

  provisioner "remote-exec" {
    inline = [
      "sudo docker pull teralti/era-meteo:latest",
      "sudo docker stop era-meteo-container || true",
      "sudo docker rm era-meteo-container || true",
      "sudo docker run -d -p 80:3000 --name era-meteo-container teralti/era-meteo:latest"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = filebase64("${var.ssh_key}")
      host        = self.public_ip
    }
  }
}

variable "ssh_key" {
  description = "The SSH private key for connecting to the EC2 instance"
  type        = string
  sensitive   = true
}

output "instance_public_ip" {
  value = aws_instance.app_server.public_ip
}
