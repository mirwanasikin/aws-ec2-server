output "instance_private_ip" {
  description = "Private IP of each k3s nodes"
  value       = { for k, v in aws_instance.main : k => v.private_ip }
}

output "instance_ids" {
  description = "Instance IDs useful for ALB target group registry"
  value       = { for k, v in aws_instance.main : k => v.id }
}
