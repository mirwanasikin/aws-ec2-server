variable "environment" {
  description = "Environment for Instance"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR for Public Subnet"
  type        = string
}

variable "availability_zone" {
  description = "Zone for Subnet"
  type        = string
}

variable "ansible_bucket_name" {
  description = "Ansible Bucket for SSM"
  type        = string
}

variable "ssm_role" {
  description = "IAM role for SSM"
  type        = string
}

variable "instances" {
  description = "Instance Type"
  type = map(object({
    instance_type = string
  }))
}
