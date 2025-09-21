# Créer le groupe de sécurité
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
    description = "App Port"
    from_port   = 8080
    to_port     = 8080
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

# Générer la clé SSH
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key-${timestamp()}"
  public_key = var.ssh_public_key
}

# Créer une nouvelle instance SEULEMENT si aucune n’existe
resource "aws_instance" "app_server" {
  count         = length(data.aws_instances.existing_app.ids) == 0 ? 1 : 0
  ami           = "ami-0e449927258d45bc4"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "EraMeteoServerProd"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo service docker start
              sudo docker run -d -p 80:80 teralti/era-meteo:latest
              EOF
}

