resource "aws_iam_role" "state_machine_role" {
  name = "StateMachineRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "states.amazonaws.com" },
        Action    = "sts:AssumeRole"
      },
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ecs.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role" "event_rule_role" {
  name = "RuleRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "events.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

module "ecs_step_function" {
  source = "./ecs-step-function-module"

  state_machine_role_arn  = aws_iam_role.state_machine_role.arn
  event_rule_role_arn     = aws_iam_role.event_rule_role.arn
  task_execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_definition_arn     = aws_ecs_task_definition.my_task_definition.arn
  ecs_cluster_arn         = aws_ecs_cluster.my_cluster.arn
  private_subnets         = module.vpc.private_subnets
  security_group_ids      = [aws_security_group.my_security_group.id]
}
