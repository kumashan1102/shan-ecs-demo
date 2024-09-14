security_groups_rules = {
    shan-alb-ingress : {
        type = "ingress"
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24","0.0.0.0/0"]
    }
    shan-alb-egress : {
        type = "egress"
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}
ecs_security_groups_rules = {
    shan-ecs-ingress-one : {
        type = "ingress"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24"]
    }
    shan-ecs-ingress-two : {
        type = "ingress"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    shan-ecs-egress : {
        type = "egress"
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}