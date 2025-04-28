variable "bus_name" {
  type        = string
  description = "A unique bus name for your EventBridge Bus. Bus name and event source name must match."

  validation {
    condition     = !can(regex("/", var.bus_name))
    error_message = "The name of the custom event bus can't contain '/' character."
  }
}

variable "bus_description" {
  type        = string
  description = "Event Bus Description"
  default     = null
}

variable "event_source_name" {
  type        = string
  description = "Partner event source that the new event bus will be matched with."
  default     = null
}

variable "common_tags" {
  type = map(string)
  default = {
    "ENV" = "DEV"
  }
}
