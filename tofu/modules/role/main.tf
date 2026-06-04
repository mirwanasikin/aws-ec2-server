data "aws_iam_role" "ssm_role" {
  name = var.ssm_role
}

data "aws_s3_bucket" "ansible_ssm" {
  bucket = var.ansible_bucket_name
}

resource "aws_iam_role_policy" "ssm_s3" {
  name = "${var.environment}-ssm-ansible-access"
  role = data.aws_iam_role.ssm_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ]
      Resource = [
        data.aws_s3_bucket.ansible_ssm.arn,
        "${data.aws_s3_bucket.ansible_ssm.arn}/*"
      ]
    }]
  })
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.environment}-instance-profile"
  role = data.aws_iam_role.ssm_role.name
}
