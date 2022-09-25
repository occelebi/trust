module "kata" {
  source = "../../modules/apprunner"

  create       = true
  service_name = "sre-kata"

  tags = {
    Name = "sre-kata"
  }

  service_source_type      = "image"
  image_repository_type    = "ECR_PUBLIC"
  image_identifier         = "public.ecr.aws/l1y5t2n8/kata:latest"
  auto_deployments_enabled = false

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.main.arn

  health_check_configuration = {
    healthy_threshold   = "1"
    unhealthy_threshold = "3"
    interval            = "3"
    path                = "/"
    protocol            = "TCP"
    timeout             = "2"
  }
  instance_configuration = {
    instance_role_arn = module.iam_role_s3_access.iam_role_arn
    cpu               = "1024"
    memory            = "2048"
  }
}

resource "aws_apprunner_connection" "github_connection" {
  connection_name = "github_connection"
  provider_type   = "GITHUB"
}


resource "aws_apprunner_auto_scaling_configuration_version" "main" {
  auto_scaling_configuration_name = "${local.name}-as"
  max_concurrency                 = 50
  max_size                        = 10
  min_size                        = 2

  tags = local.tags
}
