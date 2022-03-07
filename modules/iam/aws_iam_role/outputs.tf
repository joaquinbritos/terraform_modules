// module: aws_iam_role

output "role_svc_arn" {
  value = var.enable_service_principals == "1" ? element(concat(aws_iam_role.svc.*.arn, [""]), 0) : ""
}

output "role_aws_arn" {
  value = var.enable_aws_principals == "1" ? element(concat(aws_iam_role.aws.*.arn, [""]), 0) : ""
}

output "role_federated_arn" {
  value = var.enable_federated_principals == "1" ? element(concat(aws_iam_role.federated.*.arn, [""]), 0) : ""
}

output "role_svc_name" {
  value = var.enable_service_principals == "1" ? element(concat(aws_iam_role.svc.*.name, [""]), 0) : ""
}

output "role_aws_name" {
  value = var.enable_aws_principals == "1" ? element(concat(aws_iam_role.aws.*.name, [""]), 0) : ""
}

output "role_federated_name" {
  value = var.enable_federated_principals == "1" ? element(concat(aws_iam_role.federated.*.name, [""]), 0) : ""
}

