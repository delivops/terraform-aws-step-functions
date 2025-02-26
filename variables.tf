variable "state_machine_role_arn" {
  description = "The ARN of the IAM role for the state machine"
  type        = string
}

variable "state_machine_policy_name" {
  description = "The name of the IAM policy for the state machine"
  type        = string
  default     = "StateMachinePolicy"
}

variable "task_execution_role_arn" {
  description = "The ARN of the ECS task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "The ARN of the ECS task role"
  type        = string
}

variable "task_definition_arn" {
  description = "The ARN of the ECS task definition"
  type        = string
}

variable "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the ECS tasks"
  type        = list(string)
}

variable "state_machine_name" {
  description = "The name of the Step Functions state machine"
  type        = string
  default     = "EcsFargateStateMachine"
}

variable "schedule_rule_name" {
  description = "The name of the CloudWatch Event Rule"
  type        = string
  default     = "StateMachineScheduleRule"
}

variable "schedule_expression" {
  description = "The schedule expression for the CloudWatch Event Rule"
  type        = string
  default     = "rate(1 day)"
}

variable "event_rule_role_arn" {
  description = "The ARN of the IAM role for the CloudWatch Event Rule"
  type        = string
}

variable "event_rule_policy_name" {
  description = "The name of the IAM policy for the CloudWatch Event Rule"
  type        = string
  default     = "EventRulePolicy"
}

variable "retry_attempts" {
  description = "The number of attempts to retry the task"
  type        = number
  default     = 3
  
}
variable "retry_interval" {
  description = "The interval between retries in seconds"
  type        = number
  default     = 10
  
}
variable "retry_backoff_rate" {
  description = "The rate at which the interval increases"
  type        = number
  default     = 2
  
}
variable "time_out" {
  description = "The time out for the state machine"
  type        = number
  default     = 600
  
}
