module "eb" {
  source   = "./modules/eventbus"
  bus_name = "my-bus"
}

module "rule-event-pattern" {
  source                    = "./modules/rules"
  event_rule_name = "my-demo-rule"
  event_rule_event_bus_name = module.eb.arn
  event_rule_event_pattern = {
    source = [
      "aws.ec2", "aws.s3"
    ]
  }
  # event_rule_schedule_expression = "rate(5 minutes)"

  depends_on = [ module.eb ]
}

output "bus-arn" {
  value = module.eb.arn
}


module "target" {
  source          = "./modules/targets"
  target_bus_name = module.eb.arn
  target_rule     = module.rule-event-pattern.name
  target_arn      = aws_sns_topic.topic.arn

  depends_on = [aws_sns_topic.topic]
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