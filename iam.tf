data "aws_iam_policy_document" "shan-ecs-task-exec-trust-policy" {
  statement {
    sid    = "shanecstaskexectrustpolicy"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "shan-ecs-task-exec-role" {
  name = "shan-ecs-task-exec-role"
  assume_role_policy = data.aws_iam_policy_document.shan-ecs-task-exec-trust-policy.json
}

data "aws_iam_policy_document" "shan-ecs-task-exec-policy" {
  statement {
    sid    = "shanecsloadbalancing"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "events:PutRule",
      "events:PutTargets"
      ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "shan-ecs-task-exec-role-policy" {
  name = "shan-ecs-demo-task-exec-role-policy"
  role = aws_iam_role.shan-ecs-task-exec-role.name
  policy = data.aws_iam_policy_document.shan-ecs-task-exec-policy.json
}


data "aws_iam_policy_document" "shan-ecs-task-iam-trust-policy" {
  statement {
    sid    = "shanecstaskiamtrustpolicy"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
    condition {
      test = "ArnLike"
      values = ["arn:aws:ecs:us-east-1:121196576469:*"] 
      variable = "aws:SourceArn"
    }
    condition {
      test = "StringEquals"
      values = ["121196576469"]
      variable = "aws:SourceAccount"
    }
  }
}

resource "aws_iam_role" "shan-ecs-task-iam-role" {
  name = "shan-ecs-task-iam-role"
  assume_role_policy = data.aws_iam_policy_document.shan-ecs-task-iam-trust-policy.json
}

data "aws_iam_policy_document" "shan-ecs-task-iam-policy" {
  statement {
    sid    = "shanecsloadbalancing"
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
      ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "shan-ecs-task-iam-role-policy" {
  name = "shan-ecs-demo-task-iam-role"
  role = aws_iam_role.shan-ecs-task-iam-role.name
  policy = data.aws_iam_policy_document.shan-ecs-task-iam-policy.json
}

data "aws_iam_policy_document" "shan-ecs-service-iam-trust-policy" {
  statement {
    sid    = "shanecsservicetrustpolicy"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
    condition {
      test = "ArnLike"
      values = ["arn:aws:ecs:us-east-1:121196576469:*"] 
      variable = "aws:SourceArn"
    }
    condition {
      test = "StringEquals"
      values = ["121196576469"]
      variable = "aws:SourceAccount"
    }
  }
}

resource "aws_iam_role" "shan-ecs-service-iam-role" {
  name = "shan-ecs-service-iam-role"
  assume_role_policy = data.aws_iam_policy_document.shan-ecs-service-iam-trust-policy.json
}

data "aws_iam_policy_document" "shan-ecs-service-iam-policy" {
  statement {
    sid    = "shanecsloadbalancing"
    effect = "Allow"
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets"
      ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "shan-ecs-service-iam-role-policy" {
  name = "shan-ecs-demo-service-iam-role"
  role = aws_iam_role.shan-ecs-service-iam-role.name
  policy = data.aws_iam_policy_document.shan-ecs-service-iam-policy.json
}
