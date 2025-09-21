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
