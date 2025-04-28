locals {
  # true if schedule_expression is set
  schedule_expression_set = var.event_rule_schedule_expression != null && var.event_rule_schedule_expression != ""

  # true if event_pattern is set
  event_pattern_set = length(var.event_rule_event_pattern) > 0
}

resource "aws_cloudwatch_event_rule" "this" {
  name           = var.event_rule_name
  description    = var.event_rule_description
  event_bus_name = var.event_rule_event_bus_name
  state          = var.event_rule_state
  tags           = var.event_rule_tags

  # Out of these two are only one should be set
  event_pattern       = local.event_pattern_set ? jsonencode(var.event_rule_event_pattern) : null
  schedule_expression = local.schedule_expression_set ? var.event_rule_schedule_expression : null

  lifecycle {
    # Fail if both are set
    precondition {
      condition     = !(local.schedule_expression_set && local.event_pattern_set)
      error_message = "Both event_pattern and schedule_expression cannot be set at once."
    }

    # Fail if neither is set
    precondition {
      condition     = local.schedule_expression_set || local.event_pattern_set
      error_message = "At least one of event_pattern or schedule_expression must be set."
    }

    # if schedule_expression is choosen
    # precondition {
    #   condition     = !local.schedule_expression_set || local.event_bus_is_default
    #   error_message = "Schedule Expression is supported only on the default event bus."
    # }

  }
}
