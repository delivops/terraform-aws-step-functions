![image info](logo.jpeg)

# Terraform Step Functions

This Terraform module creates an AWS Step Functions state machine that runs ECS tasks on Fargate. It also sets up the necessary IAM roles, policies.

# Features

- Creates a task definition from an image name.
- Creates an AWS Step Functions state machine to run ECS tasks.
- Attaches necessary IAM policies for PassRole, RunTask, and event rule execution.
- Defines retry logic for handling task failures.

# Resources Created

- Task definition: Creates a task definition from an image name.
- Step Functions State Machine: Executes ECS tasks on Fargate.
- IAM Policies and Roles: Grants permissions for Step Functions and CloudWatch Event Rules.
- CloudWatch Event Rule: Triggers Step Functions execution on a schedule.

# Usage

```python

################################################################################
# AWS STEP-FUNCTIONS
################################################################################

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
| [aws_cloudwatch_event_rule.schedule_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.state_machine_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_sfn_state_machine.ecs_state_machine](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_state_machine) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Whether to assign a public IP to the task | `bool` | `false` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_container_dependencies"></a> [container\_dependencies](#input\_container\_dependencies) | Container dependencies | <pre>list(object({<br/>    containerName = string<br/>    condition     = string<br/>  }))</pre> | `[]` | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | Docker image for the container | `string` | `"nginx:latest"` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Name of the container | `string` | `"app"` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Container port to expose | `number` | `80` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU units for the task | `number` | `256` | no |
| <a name="input_ecs_cluster_arn"></a> [ecs\_cluster\_arn](#input\_ecs\_cluster\_arn) | The ARN of the ECS cluster | `string` | n/a | yes |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Environment variables for the container | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | ARN of the execution role | `string` | n/a | yes |
| <a name="input_logs_enabled"></a> [logs\_enabled](#input\_logs\_enabled) | Whether to enable logging for the container | `bool` | `true` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory for the task in MiB | `number` | `512` | no |
| <a name="input_mount_points"></a> [mount\_points](#input\_mount\_points) | Mount points for the container | <pre>list(object({<br/>    sourceVolume  = string<br/>    containerPath = string<br/>    readOnly      = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | Docker network mode for the container | `string` | `"awsvpc"` | no |
| <a name="input_retry_attempts"></a> [retry\_attempts](#input\_retry\_attempts) | The number of attempts to retry the task | `number` | `3` | no |
| <a name="input_retry_backoff_rate"></a> [retry\_backoff\_rate](#input\_retry\_backoff\_rate) | The rate at which the interval increases | `number` | `2` | no |
| <a name="input_retry_interval_seconds"></a> [retry\_interval\_seconds](#input\_retry\_interval\_seconds) | The interval between retries in seconds | `number` | `10` | no |
| <a name="input_runtime_platform"></a> [runtime\_platform](#input\_runtime\_platform) | Runtime platform configuration | <pre>object({<br/>    cpu_architecture       = optional(string, "ARM64")<br/>    operating_system_family = optional(string, "LINUX")<br/>  })</pre> | `{}` | no |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | The schedule expression for the CloudWatch Event Rule | `string` | `"rate(1 minute)"` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Secrets to pass to the container | <pre>list(object({<br/>    name      = string<br/>    valueFrom = string<br/>  }))</pre> | `[]` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs for the ECS task | `list(string)` | n/a | yes |
| <a name="input_step_function_name"></a> [step\_function\_name](#input\_step\_function\_name) | The name of the workflow | `string` | `"EcsFargateStateMachine"` | no |
| <a name="input_step_function_policy_arn"></a> [step\_function\_policy\_arn](#input\_step\_function\_policy\_arn) | The ARN of the IAM policy for the Step Functions state machine | `string` | n/a | yes |
| <a name="input_step_function_role_arn"></a> [step\_function\_role\_arn](#input\_step\_function\_role\_arn) | The ARN of the IAM role for the Step Functions state machine | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs where the ECS task will run | `list(string)` | n/a | yes |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | ARN of the task role | `string` | `null` | no |
| <a name="input_timeout_seconds"></a> [timeout\_seconds](#input\_timeout\_seconds) | The time out for the state machine | `number` | `600` | no |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | Volumes to be used in the task definition | <pre>list(object({<br/>    name = string<br/>    host_path = optional(string)<br/>    efs_volume_configuration = optional(object({<br/>      file_system_id     = string<br/>      root_directory     = optional(string, "/")<br/>      transit_encryption = optional(string, "DISABLED")<br/>    }))<br/>  }))</pre> | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
