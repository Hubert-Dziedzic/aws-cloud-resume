resource "aws_sns_topic" "visitor_alerts" {
  name = "portfolio-visitor-alerts"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.visitor_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}