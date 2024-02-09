resource "aws_cloudwatch_metric_alarm" "cloudwatch_alarm" {
  alarm_name                = "${var.tag_name}-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 10
  threshold                 = 1
  alarm_description         = "Request error rate has exceeded 10%"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.sns_topic.arn]
  ok_actions                = [aws_sns_topic.sns_topic.arn]
  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = 120
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = var.load_balancer_arn
      }
    }
  }

}

resource "aws_sns_topic" "sns_topic" {
  name = "${var.tag_name}-sns-topic"
}

resource "aws_sns_topic_subscription" "sns_email_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "email"
  endpoint  = "abilanadar1998@gmail.com"
}
