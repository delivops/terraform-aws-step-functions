locals {
  step_function_policy_arn = aws_iam_policy.step_function_policy.arn
  step_fucnction_role_arn  = aws_iam_role.step_function_role.arn
  ecs_cluster_arn          = aws_ecs_cluster.production_ecs_cluster.arn
  subnet_ids               = module.vpc.private_subnets
  security_group_ids       = [aws_security_group.gatus_sg.id]
  vpc_id                   = module.vpc.vpc_id
  name                     = "argo-workflow-1"
}
resource "aws_iam_role" "step_function_role" {
  name = "StepFunctionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "states.amazonaws.com" }
      Action    = "sts:AssumeRole"
      },
      {
        Effect    = "Allow",
        Principal = { Service = "events.amazonaws.com" },
        Action    = "sts:AssumeRole"
      },
      {
        Effect    = "Allow",
        Principal = { Service = "ecs.amazonaws.com" }
        Action    = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_policy" "step_function_policy" {
  name = "StepFunctionPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "ecs:RunTask",
        "ecs:DescribeTasks",
        "iam:PassRole",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ecs:StopTask",
        "events:PutTargets",
        "events:PutRule",
        "events:DescribeRule",
        "states:StartExecution"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "state_machine_attachment" {
  role       = aws_iam_role.step_function_role.name
  policy_arn = aws_iam_policy.step_function_policy.arn
}


module "step_function" {
  version = "xxx"

  //step function
  step_function_name       = local.name
  step_function_role_arn   = local.step_fucnction_role_arn
  step_function_policy_arn = local.step_function_policy_arn
  schedule_expression      = "rate(1 hour)"

  //network
  ecs_cluster_arn    = local.ecs_cluster_arn
  subnet_ids         = local.subnet_ids
  security_group_ids = local.security_group_ids

  //task
  execution_role_arn = local.task_execution_role_arn
  task_role_arn      = local.task_role_arn
  container_image    = "123123123.dkr.ecr.eu-west-1.amazonaws.com/python123"
  container_port     = 8080
  container_name     = "python-slack"
  environment_variables = [
    {
      "name" : "SLACK_MESSAGE",
      "value" : "hello from Step functions"
    },
    {
      "name" : "SLACK_WEBHOOK_URL",
      "value" : "https://hooks.slack.com/services/xxx"
    }
  ]
}