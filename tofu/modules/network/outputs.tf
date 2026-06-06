# Output for VPC so other Module can import
output "vpc_id" {
  value = aws_vpc.main.id
}

# Output for Subnet so other Module can import
output "subnet_id" {
  value = { for k, v in aws_subnet.public : k => v.id }
}
