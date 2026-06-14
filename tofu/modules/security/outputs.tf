output "sg_alb_id" {
  description = "Security Group ID for ALB"
  value       = aws_security_group.alb_sg.id
}

output "sg_compute_id" {
  description = "Security Group ID for EC2 k3s nodes"
  value       = aws_security_group.sg_compute.id
}

output "sg_k3s_internal_id" {
  description = "Security Group ID for k3s internal node communication (Flannel + metrics)"
  value       = aws_security_group.sg_k3s_internal.id
}
