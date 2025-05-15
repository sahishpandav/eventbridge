locals {
  eventbridge_rules = [
    for rule in var.rules :
    merge(rule, {
      name = rule.name
      Name = var.append_rule_postfix ? "${replace(rule.name, "_", "-")}-rule" : rule.name
    })
  ]
}

resource "aws_cloudwatch_event_rule" "this" {
  for_each = { for rule in local.eventbridge_rules : rule.name => rule }

  name           = each.value.Name
  description    = try(each.value.description, null)
  event_bus_name = each.value.event_bus_name
  state          = try(each.value.state, "ENABLED")
  tags           = try(each.value.tags, {})

  event_pattern       = try(length(each.value.event_pattern) > 0 ? jsonencode(each.value.event_pattern) : null, null)
  schedule_expression = try(each.value.schedule_expression != "" ? each.value.schedule_expression : null, null)

  lifecycle {
    precondition {
      condition = !(
        try(each.value.schedule_expression != null && each.value.schedule_expression != "", false)
        &&
        try(each.value.event_pattern != null && length(keys(each.value.event_pattern)) > 0, false)
      )
      error_message = "Cannot define both schedule_expression and event_pattern."
    }

    precondition {
      condition = (
        try(each.value.schedule_expression != null && each.value.schedule_expression != "", false)
        ||
        try(each.value.event_pattern != null && length(keys(each.value.event_pattern)) > 0, false)
      )
      error_message = "Must define either schedule_expression or event_pattern."
    }
  }

}
