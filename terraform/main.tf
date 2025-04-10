terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2" # Vous pouvez choisir une autre région si vous préférez
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0" # AMI pour Ubuntu 20.04 LTS (éligible pour le niveau gratuit)
  instance_type = "t2.micro"              # Type d'instance éligible pour le niveau gratuit

  tags = {
    Name = "EraMeteoServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io
              docker run -d -p 80:3000 teralti/era-meteo
              EOF
}

output "instance_public_ip" {
  value = aws_instance.app_server.public_ip
}
