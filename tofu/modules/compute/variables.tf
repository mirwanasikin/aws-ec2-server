variable "environment" {
  description = "Environment for Instance"
  type        = string
}

variable "instance_type" {
  description = "Instance Type for EC2"
  type        = string
}

variable "public_subnet_id" {
  description = "Public Subnet for EC2"
  type        = string
}

variable "security_group_id" {
  description = "security Group for EC2"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM role for SSM"
  type        = string
}
