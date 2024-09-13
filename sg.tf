resource "aws_security_group" "shan-ecs-alb" {
  name        = "shan-ecs-alb-sg"
  description = "Security Group to allow ALB communicate with inbound and outbound traffic"
  vpc_id      = aws_vpc.shan-ecs-demo.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "shan-ecs-alb-sg-rules" {
  for_each          = var.security_groups_rules
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks 
  security_group_id = aws_security_group.shan-ecs-alb.id
}


resource "aws_security_group" "shan-ecs-service" {
  name        = "shan-ecs-service-sg"
  description = "Security Group to allow ALB communicate with inbound and outbound traffic"
  vpc_id      = aws_vpc.shan-ecs-demo.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "shan-ecs-service-sg-rules" {
  for_each          = var.ecs_security_groups_rules
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks 
  security_group_id = aws_security_group.shan-ecs-alb.id
}