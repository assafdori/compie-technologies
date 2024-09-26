resource "aws_autoscaling_group" "ec2_asg" {
  vpc_zone_identifier         = module.vpc.private_subnets
  launch_template {
    id      = aws_launch_template.ec2_template.id
    version = "$Latest"
  }

  min_size                    = 1
  max_size                    = 4
  desired_capacity            = 2
  
  target_group_arns           = [aws_lb_target_group.ec2_target_group.arn]

  tag {
    key                 = "Name"
    value               = "${local.tags.Environment}-ec2-instance"
    propagate_at_launch = true
  }
}



resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale_up_policy"
  scaling_adjustment      = 1
  adjustment_type         = "ChangeInCapacity"
  autoscaling_group_name  = aws_autoscaling_group.ec2_asg.name
}
