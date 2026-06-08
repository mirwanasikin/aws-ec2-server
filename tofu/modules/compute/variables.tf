variable "environment" {
  description = "Environment for Instance"
  type        = string
}

variable "public_subnet_id" {
  description = "Public Subnet for EC2"
  type        = map(string)
}

variable "security_group_id" {
  description = "security Group for EC2"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM role for SSM"
  type        = string
}

variable "instances" {
  type = map(object({
    instance_type = string
    az            = string
    role          = string
  }))
}
