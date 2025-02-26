resource "aws_iam_policy" "state_machine_policy" {
  name = var.state_machine_policy_name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = [var.task_execution_role_arn, var.task_role_arn]
      },
      {
        Effect   = "Allow"
        Action   = "ecs:RunTask"
        Resource = var.task_definition_arn
      },
      {
        Effect   = "Allow"
        Action   = ["ecs:StopTask", "ecs:DescribeTasks"]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["events:PutTargets", "events:PutRule", "events:DescribeRule"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "state_machine_attachment" {
  role       = var.state_machine_role_arn
  policy_arn = aws_iam_policy.state_machine_policy.arn
}

resource "aws_sfn_state_machine" "ecs_state_machine" {
  name     = var.state_machine_name
  role_arn = var.state_machine_role_arn
  definition = jsonencode({
    Comment        = "Run ECS/Fargate tasks",
    StartAt        = "RunTask",
    TimeoutSeconds = var.time_out,
    States = {
      RunTask = {
        Type     = "Task",
        Resource = "arn:aws:states:::ecs:runTask.sync",
        Parameters = {
          LaunchType     = "FARGATE",
          Cluster        = var.ecs_cluster_arn,
          TaskDefinition = var.task_definition_arn,
          NetworkConfiguration = {
            AwsvpcConfiguration = {
              Subnets        = var.private_subnets
              AssignPublicIp = "ENABLED"
              SecurityGroups = var.security_group_ids
            }
          }
        },
        Retry = [{
          ErrorEquals     = ["States.TaskFailed"]
          IntervalSeconds = var.retry_interval
          MaxAttempts     = var.retry_attempts
          BackoffRate     = var.retry_backoff_rate
        }],
        End = true
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "state_machine_target" {
  rule     = aws_cloudwatch_event_rule.schedule_rule.name
  arn      = aws_sfn_state_machine.ecs_state_machine.arn
  role_arn = var.event_rule_role_arn
}

resource "aws_iam_policy" "event_rule_policy" {
  name = var.event_rule_policy_name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "states:StartExecution",
      Resource = aws_sfn_state_machine.ecs_state_machine.arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "event_rule_attachment" {
  role       = var.event_rule_role_arn
  policy_arn = aws_iam_policy.event_rule_policy.arn
}
