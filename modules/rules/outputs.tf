output "rule_names" {
  description = "Names of the created EventBridge rules"
  value = {
    for k, v in aws_cloudwatch_event_rule.this : k => v.name
  }
}

output "rule_arns" {
  description = "ARNs of the created EventBridge rules"
  value = {
    for k, v in aws_cloudwatch_event_rule.this : k => v.arn
  }
}
