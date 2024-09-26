resource "aws_sns_topic" "cpu_alerts" {
  name = "cpu_alerts"
  tags = merge(local.tags, { Name = "${local.tags.Environment}-sns-cpu-alerts" })
}

resource "aws_sns_topic" "scaling_alerts" {
  name = "scaling_alerts"
  tags = merge(local.tags, { Name = "${local.tags.Environment}-sns-scaling-alerts" })
}

resource "aws_sns_topic_subscription" "cpu_alerts_sms" {
  topic_arn = aws_sns_topic.cpu_alerts.arn
  protocol  = "sms"
  endpoint  = "+972549031510"
}

resource "aws_sns_topic_subscription" "scaling_alerts_sms" {
  topic_arn = aws_sns_topic.scaling_alerts.arn
  protocol  = "sms"
  endpoint  = "+972549031510"
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "high_cpu_usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_actions       = [aws_autoscaling_policy.scale_up_policy.arn, aws_sns_topic.cpu_alerts.arn]
  tags                = merge(local.tags, { Name = "${local.tags.Environment}-cloudwatch-cpu-alarm" })
}

resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ec2_asg.name
}

resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ec2_asg.name
}

resource "aws_cloudwatch_event_rule" "auto_scaling_events" {
  name        = "AutoScalingEventsRule"
  description = "Triggers on EC2 Auto Scaling actions"
  event_pattern = jsonencode({
    source      = ["aws.autoscaling"]
    detail-type = ["EC2 Instance Launch Successful", "EC2 Instance Terminate Successful", "EC2 Instance Launch Unsuccessful", "EC2 Instance Terminate Unsuccessful"]
  })
}

resource "aws_cloudwatch_event_target" "notify_auto_scaling" {
  rule      = aws_cloudwatch_event_rule.auto_scaling_events.name
  target_id = "AutoScalingNotifications"
  arn       = aws_sns_topic.scaling_alerts.arn
}

resource "aws_iam_role" "cloudwatch_events_role" {
  name = "cloudwatch_events_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "cloudwatch_events_policy" {
  name = "cloudwatch_events_policy"
  role = aws_iam_role.cloudwatch_events_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = [
          aws_sns_topic.cpu_alerts.arn,
          aws_sns_topic.scaling_alerts.arn
        ]
      }
    ]
  })
}
