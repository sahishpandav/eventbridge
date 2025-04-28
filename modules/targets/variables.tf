# two arguments are required here
# 1. arn - The Amazon Resource Name (ARN) of the target.
# 2. rule - The name of the rule you want to add targets to.

variable "target_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) of the target."
}

variable "target_rule" {
  type        = string
  description = "The name of the rule you want to add targets to."
}

# these args are optional
variable "target_bus_name" {
  type        = string
  description = "The name or ARN of the event bus to associate with the rule. If you omit this, the default event bus is used"
  default     = "default"
}