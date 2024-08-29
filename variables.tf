variable "region" {
  type    = string
  default = "us-east-1"
}

variable "tfversion" {
  type    = string
  default = "5.61.0"
}

variable "VPC_CIDR" {
  type    = string
  default = "10.1.0.0/16"
}

variable "security_groups_rules" {
  type    = map(any)
  default = null
}