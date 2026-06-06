variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
}

variable "public_subnets" {
  description = "CIDR for Public Subnet"
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "environment" {
  description = "Env for Instance"
  type        = string
}

