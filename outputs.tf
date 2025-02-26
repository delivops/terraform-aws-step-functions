output "state_machine_arn" {
  description = "The ARN of the created state machine"
  value       = aws_sfn_state_machine.ecs_state_machine.arn
}

output "rule_arn" {
  description = "The ARN of the CloudWatch Event rule"
  value       = aws_cloudwatch_event_rule.schedule_rule.arn
}
