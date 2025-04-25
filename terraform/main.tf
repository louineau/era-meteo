provider "aws" {
  region = "us-east-1"
}

variable "ssh_public_key" {
  description = "The SSH public key for connecting to the EC2 instance"
  type        = string
  sensitive   = true
}

variable "ssh_private_key" {
  description = "The SSH private key for connecting to the EC2 instance"
  type        = string
  sensitive   = true
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key-${timestamp()}"
  public_key = var.ssh_public_key
}

resource "aws_security_group" "app_sg" {
  name        = "app_sg_${replace(timestamp(), ":", "-")}"
  description = "Allow SSH, HTTP and app port"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "NPM/Node.js"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "app_server" {
  ami           = "ami-0e449927258d45bc4"  # Remplacez par l'AMI appropriée pour votre région
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name = "EraMeteoServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo service docker start
              sudo docker run -d -p 80:80 teralti/era-meteo:latest
              EOF

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y || sudo yum install docker -y",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo docker pull teralti/era-meteo:latest",
      "sudo docker stop era-meteo-container || true",
      "sudo docker rm era-meteo-container || true",
      "sudo docker run -d -p 80:80 --name era-meteo-container teralti/era-meteo:latest"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = var.ssh_private_key # Remplacez par le chemin vers votre clé privée
      host        = self.public_ip
      timeout     = "10m" 
    }
  }
  
  vpc_security_group_ids = [aws_security_group.app_sg.id]

}

output "instance_public_ip" {
  value = aws_instance.app_server.public_ip
}
