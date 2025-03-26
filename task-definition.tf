

resource "aws_ecs_task_definition" "this" {
  family                   = var.step_function_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = var.network_mode
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = coalesce(var.task_role_arn, var.execution_role_arn)

  dynamic "runtime_platform" {
    for_each = var.runtime_platform != null ? [var.runtime_platform] : []
    content {
      cpu_architecture        = runtime_platform.value.cpu_architecture
      operating_system_family = runtime_platform.value.operating_system_family
    }
  }

  dynamic "volume" {
    for_each = var.volumes
    content {
      name = volume.value.name

      dynamic "efs_volume_configuration" {
        for_each = volume.value.efs_volume_configuration != null ? [volume.value.efs_volume_configuration] : []
        content {
          file_system_id     = efs_volume_configuration.value.file_system_id
          root_directory     = efs_volume_configuration.value.root_directory
          transit_encryption = efs_volume_configuration.value.transit_encryption
        }
      }

      host_path = volume.value.host_path
    }
  }

  container_definitions = jsonencode([{
    name  = var.container_name
    image = var.container_image
    cpu   = 0

    portMappings = [{
      name          = var.container_name
      containerPort = var.container_port
      hostPort      = var.container_port
      protocol      = "tcp"
      appProtocol   = "http"
    }]

    essential = true

    environment = var.environment_variables

    secrets = var.secrets

    mountPoints = var.mount_points

    logConfiguration = var.logs_enabled ? {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${var.step_function_name}"
        "awslogs-region"        = var.aws_region
        "mode"                  = "non-blocking"
        "awslogs-create-group"  = "true"
        "max-buffer-size"       = "25m"
        "awslogs-stream-prefix" = "ecs"
      }
    } : null


    dependsOn = var.container_dependencies
  }])

  tags = {
    Name = var.step_function_name
  }
}

# Option 1: Using AWS Secrets Manager
# resource "aws_secretsmanager_secret" "slack_webhook" {
#   name = "slack-webhook-url"
# }

# resource "aws_secretsmanager_secret_version" "slack_webhook" {
#   secret_id = aws_secretsmanager_secret.slack_webhook.id
#   secret_string = jsonencode({
#     SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/your-webhook-url"
#   })
# }

# # Option 2: Using AWS Systems Manager Parameter Store
# resource "aws_ssm_parameter" "slack_webhook" {
#   name  = "/myapp/slack/webhook-url"
#   type  = "SecureString"
#   value = "https://hooks.slack.com/services/your-webhook-url"
# }

# # Updated module usage with secrets
# module "python_task_definition_with_secrets" {
#   source = "./modules/ecs_task_definition"

#   # ... other configurations ...

#   secrets = [
#     # Secrets Manager example
#     {
#       name      = "SLACK_WEBHOOK_URL"
#       valueFrom = "${aws_secretsmanager_secret.slack_webhook.arn}:SLACK_WEBHOOK_URL::"
#     },
#     # SSM Parameter Store example
#     {
#       name      = "SLACK_WEBHOOK_URL_SSM"
#       valueFrom = aws_ssm_parameter.slack_webhook.arn
#     }
#   ]
# }
