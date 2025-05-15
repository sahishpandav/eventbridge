variable "target_bus_name" {
  description = "The name or ARN of the event bus"
  type        = string
}

variable "target_rule" {
  description = "The name of the event rule"
  type        = string
}

variable "target_arn" {
  description = "The ARN of the target resource (e.g., Lambda or SNS)"
  type        = string
}
