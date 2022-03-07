// module:  aws_iam_policy

output "policy_arn" {
  value = aws_iam_policy.permissions[0].arn
}

output "policy_id" {
  value = aws_iam_policy.permissions[0].id
}

