resource "aws_sns_topic" "scaling_alerts" {
  name = "scaling_alerts"

  tags = merge(local.tags, { Name = "${local.tags.Environment}-sns-scaling-alerts" })
}

resource "aws_sns_topic_subscription" "sms_subscription" {
  topic_arn = aws_sns_topic.scaling_alerts.arn
  protocol  = "sms"
  endpoint  = "+972549031510"  # This is my personal phone number feel free to replace with yours
}

# CloudWatch Alarms for Auto Scaling and Stress Notifications
resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "high_cpu_usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  alarm_actions       = [aws_autoscaling_policy.scale_up_policy.arn, aws_sns_topic.scaling_alerts.arn]

  tags = merge(local.tags, { Name = "${local.tags.Environment}-cloudwatch-cpu-alarm" })
}
