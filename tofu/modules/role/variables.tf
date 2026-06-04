variable "ssm_role" {
  description = "IAM Role to use SSM"
  type        = string
}

variable "environment" {
  description = "Environment for Instance"
  type        = string
}

variable "ansible_bucket_name" {
  description = "S3 Bucket for Ansible"
  type        = string
}
