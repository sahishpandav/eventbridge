variable "append_rule_postfix" {
  description = "Controls whether to append '-rule' to the name of the rule"
  type        = bool
  default     = true
}

variable "rules" {
  description = "List of EventBridge rule definitions"
  type = list(object({
    name                = string
    description         = optional(string)
    event_bus_name      = string
    event_pattern       = optional(map(any))
    schedule_expression = optional(string)
    state               = optional(string, "ENABLED")
    tags                = optional(map(string))
  }))
}
