resource "aws_ecr_repository" "shan-ecs-ecr-repo" {
  name = "shan-ecs-ecr-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecs_cluster" "shan-ecs-cluster" {
  name = "shan-ecs-cluster"
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name = aws_cloudwatch_log_group.shan-ecs-cluster-log-group.name
      }
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "shan-ecs-cluster-capacity" {
  cluster_name = aws_ecs_cluster.shan-ecs-cluster.name
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
    base = 1
    weight = 100
    capacity_provider = "FARGATE"
  }
}