// module: aws_iam_role

variable "role_name" {
}

variable "role_permissions_docs" {
  type    = list(any)
  default = []
}

variable "role_permissions_docs_count" {
  default = "0"
}

variable "role_policies_arns" {
  type    = list(any)
  default = []
}

variable "role_policies_arns_count" {
  default = "0"
}

variable "assumption_permissions" {
  type    = list(any)
  default = ["sts:AssumeRole"]
}

variable "service_principals" {
  type    = list(any)
  default = []
}

variable "aws_principals" {
  type    = list(any)
  default = []
}

variable "federated_principals" {
  type    = list(any)
  default = []
}

variable "enable_iam_role" {
  default = "1"
}

variable "enable_service_principals" {
  default = "0"
}

variable "enable_aws_principals" {
  default = "0"
}

variable "enable_federated_principals" {
  default = "0"
}

variable "create_instance_profile" {
  default = "0"
}

