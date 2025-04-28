variable "ssh_private_key" {
  description = "Clé SSH privée pour accéder à l'instance EC2 existante"
  type        = string
}

variable "instance_public_ip" {
  description = "IP publique de l'instance EC2 existante"
  type        = string
}
