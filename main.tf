module "eb" {
  source   = "./modules/eventbus"
  bus_name = "my-bus"
}

module "rule_event_pattern" {
  source = "./modules/rules"

  rules = [
    {
      name                = "my-demo-rule"
      description         = "Trigger for EC2 and S3 events"
      event_bus_name      = module.eb.arn
      event_pattern       = {
        source = ["aws.ec2", "aws.s3"]
      }
      schedule_expression = null
      state               = "ENABLED"
      tags = {
        Environment = "dev"
      }
    }
  ]

  append_rule_postfix = true

  depends_on = [module.eb]
}

resource "aws_sns_topic" "topic" {
  name = "MyServerMonitor"
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    resources = [aws_sns_topic.topic.arn]
  }
}

module "target" {
  source          = "./modules/targets"

  target_bus_name = module.eb.arn
  target_rule     = module.rule_event_pattern.rule_names["my-demo-rule"]
  target_arn      = aws_sns_topic.topic.arn

  depends_on = [aws_sns_topic.topic]
}

output "bus-arn" {
  value = module.eb.arn
}

output "rule_names" {
  value = module.rule_event_pattern.rule_names
}
