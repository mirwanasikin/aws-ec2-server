variable "environment" {
  description = "Environment for Instance"
  type        = string
}

variable "private_subnet_id" {
  description = "Private Subnet for EC2"
  type        = map(string)
}

variable "sg_compute_id" {
  description = "Security Group for EC2 allows trafic from ALB"
  type        = string
}

variable "sg_k3s_internal_id" {
  description = "Security Group for K3s internal communication"
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
