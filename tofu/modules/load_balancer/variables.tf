variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "sg_alb_id" {
  description = "Security Group ID for ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "Map of public subnet IDs (ALB butuh minimal 2 AZ)"
  type        = map(string)
}

variable "instance_ids" {
  description = "Map of EC2 instance IDs to register ke target group"
  type        = map(string)
}

variable "traefik_nodeport" {
  description = "NodePort Traefik — pin ini di k3s config supaya nggak random"
  type        = number
  default     = 30080
}
