resource "aws_apprunner_service" "this" {
  count = var.create ? 1 : 0

  service_name = var.service_name

  auto_scaling_configuration_arn = var.auto_scaling_configuration_arn

  tags = var.tags

  dynamic "source_configuration" {
    for_each = var.service_source_type == "image" ? [1] : []
    content {
      auto_deployments_enabled = var.auto_deployments_enabled

      ## access_role_arn required for only ECR image repository type (Private ECR)
      dynamic "authentication_configuration" {
        for_each = var.image_repository_type == "ECR" ? [1] : []
        content {
          access_role_arn = var.image_access_role_arn
        }
      }

      image_repository {
        image_identifier      = var.image_identifier
        image_repository_type = var.image_repository_type
        dynamic "image_configuration" {
          for_each = var.image_configuration != null ? [var.image_configuration] : []
          content {
            port                          = lookup(image_configuration.value, "port", null)
            runtime_environment_variables = lookup(image_configuration.value, "runtime_environment_variables", null)
            start_command                 = lookup(image_configuration.value, "start_command", null)
          }
        }
      }
    }
  }

  dynamic "health_check_configuration" {
    for_each = var.health_check_configuration != null ? [var.health_check_configuration] : []
    content {
      healthy_threshold   = lookup(health_check_configuration.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check_configuration.value, "unhealthy_threshold", null)
      interval            = lookup(health_check_configuration.value, "interval", null)
      path                = lookup(health_check_configuration.value, "path", null)
      protocol            = lookup(health_check_configuration.value, "protocol", null)
      timeout             = lookup(health_check_configuration.value, "timeout", null)
    }
  }

  dynamic "instance_configuration" {
    for_each = var.instance_configuration != null ? [var.instance_configuration] : []
    content {
      instance_role_arn = lookup(instance_configuration.value, "instance_role_arn", null)
      cpu               = lookup(instance_configuration.value, "cpu", null)
      memory            = lookup(instance_configuration.value, "memory", null)
    }
  }

  encryption_configuration {
    kms_key = var.kms_key_arn
  }
}
