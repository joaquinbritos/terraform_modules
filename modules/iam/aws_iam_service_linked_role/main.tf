resource "aws_iam_service_linked_role" "default" {
  aws_service_name = var.aws_service_name
  description      = var.description
}