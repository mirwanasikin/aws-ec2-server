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

variable "ansible_bucket_name" {
  description = "Ansible Bucket for SSM"
  type        = string
}

variable "ssm_role" {
  description = "IAM role for SSM"
  type        = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
