# rule and arn in required for target creation. 
# if bus name is not specified then, it will get attatched to the default bus. 

resource "aws_cloudwatch_event_target" "this" {
  event_bus_name = var.target_bus_name

  rule = var.target_rule
  arn  = var.target_arn
}
