variable "step_function_name" {
  description = "The name of the workflow"
  type        = string
  default     = "EcsFargateStateMachine"
}
variable "step_function_role_arn" {
  description = "The ARN of the IAM role for the Step Functions state machine"
  type        = string

}
variable "step_function_policy_arn" {
  description = "The ARN of the IAM policy for the Step Functions state machine"
  type        = string

}

##########ECS#####################

variable "container_name" {
  description = "Name of the container"
  type        = string
  default = "app"
}

variable "container_image" {
  description = "Docker image for the container"
  type        = string
  default = "nginx:latest"
}

variable "container_port" {
  description = "Container port to expose"
  type        = number
  default     = 80
}

variable "cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory for the task in MiB"
  type        = number
  default     = 512
}

variable "execution_role_arn" {
  description = "ARN of the execution role"
  type        = string

}

variable "task_role_arn" {
  description = "ARN of the task role"
  type        = string
  default     = null
}

variable "network_mode" {
  description = "Docker network mode for the container"
  type        = string
  default     = "awsvpc"
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "secrets" {
  description = "Secrets to pass to the container"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}


variable "mount_points" {
  description = "Mount points for the container"
  type = list(object({
    sourceVolume  = string
    containerPath = string
    readOnly      = optional(bool, false)
  }))
  default = []
}

variable "volumes" {
  description = "Volumes to be used in the task definition"
  type = list(object({
    name = string
    host_path = optional(string)
    efs_volume_configuration = optional(object({
      file_system_id     = string
      root_directory     = optional(string, "/")
      transit_encryption = optional(string, "DISABLED")
    }))
  }))
  default = []
}

variable "runtime_platform" {
  description = "Runtime platform configuration"
  type = object({
    cpu_architecture       = optional(string, "ARM64")
    operating_system_family = optional(string, "LINUX")
  })
  default = {}
}

variable "container_dependencies" {
  description = "Container dependencies"
  type = list(object({
    containerName = string
    condition     = string
  }))
  default = []
}

variable "logs_enabled" {
  description = "Whether to enable logging for the container"
  type        = bool
  default     = true
  
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}


#########################################

variable "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the ECS task will run"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the ECS task"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP to the task"
  type        = bool
  default     = false
}


####CONFIGURATION###########

variable "schedule_expression" {
  description = "The schedule expression for the CloudWatch Event Rule"
  type        = string
  default     = "rate(1 minute)"
}
variable "retry_attempts" {
  description = "The number of attempts to retry the task"
  type        = number
  default     = 3

}
variable "retry_interval_seconds" {
  description = "The interval between retries in seconds"
  type        = number
  default     = 10

}
variable "retry_backoff_rate" {
  description = "The rate at which the interval increases"
  type        = number
  default     = 2

}
variable "timeout_seconds" {
  description = "The time out for the state machine"
  type        = number
  default     = 600

}
