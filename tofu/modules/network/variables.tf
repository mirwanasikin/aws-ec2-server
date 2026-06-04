variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR for Public Subnet"
  type        = string
}

variable "environment" {
  description = "Env for Instance"
  type        = string
}

