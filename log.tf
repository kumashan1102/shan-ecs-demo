resource "aws_cloudwatch_log_group" "shan-ecs-cluster-log-group" {
  name = "shan-ecs-cluster-log-group"
  log_group_class = "STANDARD"
  retention_in_days = 30
  tags = {
    Name = "shan-ecs-log-group"
  }
}

resource "aws_cloudwatch_log_group" "shan-ecs-taskdef-log-group" {
  name = "/ecs/fargate-node-task"
  log_group_class = "STANDARD"
  retention_in_days = 30
  tags = {
    Name = "/ecs/fargate-node-task"
  }
}