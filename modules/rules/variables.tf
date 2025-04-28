# required args are event_pattern or schedule_express
# either one of them
variable "event_rule_name" {
  type        = string
  description = "Name of the rule"
  default     = "my-event-rule"
}

# this conflicts with event_rule_name
# variable "event_rule_name_prefix" {
#   type        = string
#   description = "Creates a unique beginning with the specified prefix."
#   default     = "my-prefix"
# }

variable "event_rule_description" {
  type        = string
  description = "The description of the rule"
  default     = null
}

variable "event_rule_event_bus_name" {
  type        = string
  description = "The name of ARN of the event bus to associate"
  default     = "default"
}

variable "event_rule_event_pattern" {
  type        = map(any)
  description = "The event pattern as a JSON-like object"
  default     = {}

  validation {
    condition     = var.event_rule_event_pattern == {} || can(jsonencode(var.event_rule_event_pattern))
    error_message = "Rule pattern must be in valid JSON format."
  }
}

variable "event_rule_schedule_expression" {
  description = "The scheduling expression (e.g., cron or rate). Required if event_pattern is not provided."
  type        = string
  default     = null
}


variable "event_rule_state" {
  type        = string
  description = "State of the rule"
  default     = "ENABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.event_rule_state)
    error_message = "State can be only enabled or disabled"
  }
}

variable "event_rule_tags" {
  type        = map(string)
  description = "Tags"
  default = {
    "ENV" = "DEV"
  }
}

