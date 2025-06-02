# rule and arn in required for target creation. 
# if bus name is not specified then, it will get attatched to the default bus. 

locals {
  target_configs = [
    for target in var.targets : merge(target, {
      TargetId       = replace(target.name, "_", "-")
      event_bus_name = try(target.event_bus_name, "default") # fallback to default bus
    })
  ]
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = {
    for target in local.target_configs : target.name => target
  }

  rule           = each.value.rule_name
  arn            = each.value.target_arn
  event_bus_name = each.value.event_bus_name
  target_id      = each.value.TargetId

  input          = try(each.value.input, null)
  role_arn       = try(each.value.role_arn, null)
}


#######################################################
# additional resources for target                     #
#######################################################
