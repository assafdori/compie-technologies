resource "aws_lb" "alb" {
  name               = "compie-alb"
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


  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80 
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_target_group.arn
  }
}
