output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.ubuntu.id
}

output "instance_public_ip" {
  description = "IP pública de la instancia EC2"
  value       = aws_instance.ubuntu.public_ip
}