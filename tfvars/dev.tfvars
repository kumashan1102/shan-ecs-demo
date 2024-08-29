security_groups_rules = {
    shan-ecs : {
        type = "ingress"
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24"]
    }
}