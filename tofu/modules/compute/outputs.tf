output "instance_public_ip" {
  value = { for k, v in aws_instance.main : k => v.public_ip }
}
