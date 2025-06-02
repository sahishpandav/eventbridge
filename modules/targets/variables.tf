variable "targets" {
  description = "List of eventbridge targets, can be maximum 5 at a time"
  type = list(object({
    name           = string           # Logical name (used as key in for_each)
    rule_name      = string           # EventBridge rule name to attach to
    event_bus_name = string           # The name or ARN of the event bu
    target_arn     = string           # Target ARN (SNS, Lambda, Step Function, etc.)
    input          = optional(string) # Optional input (e.g., custom JSON payload)
    role_arn       = optional(string) # IAM role if needed
  }))
}
