resource "aws_sfn_state_machine" "ecs_state_machine" {
  name     = var.name
  role_arn = var.role_arn
  definition = jsonencode({
    Comment        = "Run ECS/Fargate tasks",
    StartAt        = "RunTask",
    TimeoutSeconds = var.timeout_seconds,
    States = {
      RunTask = {
        Type     = "Task",
        Resource = "arn:aws:states:::ecs:runTask.sync",
        Parameters = {
          LaunchType     = "FARGATE",
          Cluster        = var.ecs_cluster_arn,
          TaskDefinition = aws_ecs_task_definition.this.arn,
          NetworkConfiguration = {
            AwsvpcConfiguration = {
              Subnets        = var.subnet_ids,
              AssignPublicIp = "ENABLED",
              SecurityGroups = var.security_group_ids
            }
          }
        },
        Retry = [{
          ErrorEquals     = ["States.TaskFailed"],
          IntervalSeconds = var.retry_interval_seconds,
          MaxAttempts     = var.retry_attempts,
          BackoffRate     = var.retry_backoff_rate
        }],
        End = true
      }
    }
  })
}

resource "aws_cloudwatch_event_rule" "schedule_rule" {
  name                = "${var.name}-schedule-rule"
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "state_machine_target" {
  rule     = aws_cloudwatch_event_rule.schedule_rule.name
  arn      = aws_sfn_state_machine.ecs_state_machine.arn
  role_arn = var.role_arn
}
