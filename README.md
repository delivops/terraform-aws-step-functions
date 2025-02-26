![image info](logo.jpeg)

# Terraform Step Functions

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

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_target.state_machine_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.event_rule_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.state_machine_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.event_rule_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.state_machine_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_sfn_state_machine.ecs_state_machine](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_state_machine) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ecs_cluster_arn"></a> [ecs\_cluster\_arn](#input\_ecs\_cluster\_arn) | The ARN of the ECS cluster | `string` | n/a | yes |
| <a name="input_event_rule_policy_name"></a> [event\_rule\_policy\_name](#input\_event\_rule\_policy\_name) | The name of the IAM policy for the CloudWatch Event Rule | `string` | `"EventRulePolicy"` | no |
| <a name="input_event_rule_role_arn"></a> [event\_rule\_role\_arn](#input\_event\_rule\_role\_arn) | The ARN of the IAM role for the CloudWatch Event Rule | `string` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnets | `list(string)` | n/a | yes |
| <a name="input_retry_attempts"></a> [retry\_attempts](#input\_retry\_attempts) | The number of attempts to retry the task | `number` | `3` | no |
| <a name="input_retry_backoff_rate"></a> [retry\_backoff\_rate](#input\_retry\_backoff\_rate) | The rate at which the interval increases | `number` | `2` | no |
| <a name="input_retry_interval"></a> [retry\_interval](#input\_retry\_interval) | The interval between retries in seconds | `number` | `10` | no |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | The schedule expression for the CloudWatch Event Rule | `string` | `"rate(1 day)"` | no |
| <a name="input_schedule_rule_name"></a> [schedule\_rule\_name](#input\_schedule\_rule\_name) | The name of the CloudWatch Event Rule | `string` | `"StateMachineScheduleRule"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs for the ECS tasks | `list(string)` | n/a | yes |
| <a name="input_state_machine_name"></a> [state\_machine\_name](#input\_state\_machine\_name) | The name of the Step Functions state machine | `string` | `"EcsFargateStateMachine"` | no |
| <a name="input_state_machine_policy_name"></a> [state\_machine\_policy\_name](#input\_state\_machine\_policy\_name) | The name of the IAM policy for the state machine | `string` | `"StateMachinePolicy"` | no |
| <a name="input_state_machine_role_arn"></a> [state\_machine\_role\_arn](#input\_state\_machine\_role\_arn) | The ARN of the IAM role for the state machine | `string` | n/a | yes |
| <a name="input_task_definition_arn"></a> [task\_definition\_arn](#input\_task\_definition\_arn) | The ARN of the ECS task definition | `string` | n/a | yes |
| <a name="input_task_execution_role_arn"></a> [task\_execution\_role\_arn](#input\_task\_execution\_role\_arn) | The ARN of the ECS task execution role | `string` | n/a | yes |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | The ARN of the ECS task role | `string` | n/a | yes |
| <a name="input_time_out"></a> [time\_out](#input\_time\_out) | The time out for the state machine | `number` | `600` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rule_arn"></a> [rule\_arn](#output\_rule\_arn) | The ARN of the CloudWatch Event rule |
| <a name="output_state_machine_arn"></a> [state\_machine\_arn](#output\_state\_machine\_arn) | The ARN of the created state machine |
<!-- END_TF_DOCS -->