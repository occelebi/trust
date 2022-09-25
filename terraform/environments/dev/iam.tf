module "iam_role_s3_access" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4"

  create_role = true
  trusted_role_services = [
    "tasks.apprunner.amazonaws.com"
  ]
  role_requires_mfa = false
  role_name         = "apprunner-${local.name}-role"
  custom_role_policy_arns = [
    module.iam_s3_policy.arn
  ]
}

module "iam_s3_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 4"

  name        = "${local.name}-s3-policy"
  path        = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
          "s3:GetObject",
          "s3:GetObjectVersion"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::terraform-aws-app-runner-example-bucket/*"
    }
  ]
}
EOF
}
