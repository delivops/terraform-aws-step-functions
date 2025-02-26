# terraform-aws-step-functions

This Terraform module creates an AWS Step Functions state machine that runs ECS tasks on Fargate. It also sets up the necessary IAM roles, policies, and CloudWatch event rules for scheduling execution.

# Features

- Creates an AWS Step Functions state machine to run ECS tasks.
- Attaches necessary IAM policies for PassRole, RunTask, and event rule execution.
- Defines retry logic for handling task failures.
- Uses AWS CloudWatch Events to trigger the state machine on a schedule.

# Resources Created

- Step Functions State Machine: Executes ECS tasks on Fargate.
- IAM Policies and Roles: Grants permissions for Step Functions and CloudWatch Event Rules.
- CloudWatch Event Rule: Triggers Step Functions execution on a schedule.
- CloudWatch Event Target: Connects the event rule to the Step Functions state machine.

# Usage

```python

################################################################################
# AWS STEP-FUNCTIONS
################################################################################

module "ecs_step_function" {
source = "./modules/step-function-ecs"
task_execution_role_arn = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
task_role_arn = "arn:aws:iam::123456789012:role/ecsTaskRole"
task_definition_arn = "arn:aws:ecs:us-east-1:123456789012:task-definition/my-task"
ecs_cluster_arn = "arn:aws:ecs:us-east-1:123456789012:cluster/my-cluster"
private_subnets = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]
security_group_ids = ["sg-xxxxxxxx"]
event_rule_role_arn = "arn:aws:iam::123456789012:role/eventRuleRole"
retry_interval = 10
retry_attempts = 3
retry_backoff_rate = 2
}
```

# License

This project is licensed under the MIT License.

```

```
