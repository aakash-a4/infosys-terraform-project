output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web_server.id
}

output "ec2_public_ip" {
  description = "EC2 public IP address"
  value       = aws_instance.web_server.public_ip
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.web_sg.id
}