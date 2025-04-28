resource "aws_cloudwatch_event_bus" "this" {
  name        = var.bus_name
  description = var.bus_description
  #   event_source_name = var.event_source_name
  tags = var.common_tags
}

