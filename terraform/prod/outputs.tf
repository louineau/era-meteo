output "instance_public_ip" {
  description = "Adresse IP publique de l'instance EC2"
  value       = aws_instance.app_server.public_ip
}
