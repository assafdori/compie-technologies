resource "aws_lb" "alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets

  tags = merge(local.tags, { Name = "${local.tags.Environment}-alb" })
}

resource "aws_lb_target_group" "ec2_target_group" {
  name     = "instances-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  tags = merge(local.tags, { Name = "${local.tags.Environment}-alb-target-group" })
}
