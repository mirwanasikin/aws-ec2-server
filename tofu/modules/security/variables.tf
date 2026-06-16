variable "vpc_id" {
  description = "VPC for Security Group"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block for k3s"
  type        = string
}

variable "environment" {
  description = "Env for instance"
  type        = string
}
