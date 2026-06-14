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

variable "private_subnets" {
  description = "Map of private subnets (EC2/k3s Nodes)"
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "nat_gateway_subnet_key" {
  description = "Key of public subnet where NAT Gateway will be placed"
  type        = string

}

variable "environment" {
  description = "Env for Instance"
  type        = string
}

