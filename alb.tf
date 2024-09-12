resource "aws_lb" "shan-ecs-alb" {
  name               = "shan-ecs-alb"
  load_balancer_type = "application"
  subnets            = [for subnet in aws_subnet.shan-ecs-public : subnet.id]
  internal           = false
  idle_timeout       = 100
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.shan-ecs-alb.id]
}

resource "aws_lb_target_group" "shan-ecs-alb-tg" {
  name = "shan-ecs-alb-tg"
  port = "80"
  protocol = "HTTP"
  deregistration_delay = 10
  load_balancing_cross_zone_enabled = true
  target_type = "ip"
  vpc_id = aws_vpc.shan-ecs-demo.id

  health_check {
    enabled = true
    path = "/healthcheck"
    interval = 15
    port = 80
    protocol = "HTTP"
    timeout = 10
    unhealthy_threshold = 3
    matcher = "200"
    healthy_threshold = 3
  }
}

resource "aws_lb_listener" "shan-ecs-alb-listner" {
  load_balancer_arn = aws_lb.shan-ecs-alb.arn
  port = 3000
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.shan-ecs-alb-tg.arn
  }
}