// module: aws_iam_role

/* NOTE:
    the Terraform docs do not show this elegant way to get the trust policies set.  Great example on
     https://github.com/hashicorp/terraform/issues/5541
*/

// I:  Trust policies

data "aws_iam_policy_document" "assume_policy_data_svc" {
  statement {
    actions = var.assumption_permissions

    principals {
      type        = "Service"
      identifiers = var.service_principals
    }

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "assume_policy_data_aws" {
  statement {
    actions = var.assumption_permissions

    principals {
      type        = "AWS"
      identifiers = var.aws_principals
    }

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "assume_policy_data_federated" {
  statement {
    actions = var.assumption_permissions

    principals {
      type        = "Federated"
      identifiers = var.federated_principals
    }

    effect = "Allow"
  }
}

// II : role

resource "aws_iam_role" "svc" {
  count              = var.enable_iam_role * var.enable_service_principals
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_policy_data_svc.json
}

resource "aws_iam_role" "aws" {
  count              = var.enable_iam_role * var.enable_aws_principals
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_policy_data_aws.json
}

resource "aws_iam_role" "federated" {
  count              = var.enable_iam_role * var.enable_federated_principals
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_policy_data_federated.json
}

// III:  new policy
resource "aws_iam_policy" "iam_policy" {
  count  = var.role_permissions_docs_count * var.enable_iam_role
  name   = "${var.role_name}-permissions"
  policy = var.role_permissions_docs[count.index]
}

resource "aws_iam_role_policy_attachment" "svc_assume_attachment_docs" {
  count      = var.role_permissions_docs_count * var.enable_service_principals
  role       = aws_iam_role.svc[0].name
  policy_arn = element(concat(aws_iam_policy.iam_policy.*.arn, [""]), 0)
}

resource "aws_iam_role_policy_attachment" "aws_assume_attachment_docs" {
  count      = var.role_permissions_docs_count * var.enable_aws_principals
  role       = aws_iam_role.aws[0].name
  policy_arn = element(concat(aws_iam_policy.iam_policy.*.arn, [""]), 0)
}

resource "aws_iam_role_policy_attachment" "federated_assume_attachment_docs" {
  count      = var.role_permissions_docs_count * var.enable_federated_principals
  role       = aws_iam_role.federated[0].name
  policy_arn = element(concat(aws_iam_policy.iam_policy.*.arn, [""]), 0)
}

// Existing policies
resource "aws_iam_role_policy_attachment" "svc_assume_attachment_policies" {
  count      = var.role_policies_arns_count * var.enable_service_principals
  role       = aws_iam_role.svc[0].name
  policy_arn = var.role_policies_arns[count.index]
}

resource "aws_iam_role_policy_attachment" "aws_assume_attachment_policies" {
  count      = var.role_policies_arns_count * var.enable_aws_principals
  role       = aws_iam_role.aws[0].name
  policy_arn = var.role_policies_arns[count.index]
}

resource "aws_iam_role_policy_attachment" "federated_assume_attachment_policies" {
  count      = var.role_policies_arns_count * var.enable_federated_principals
  role       = aws_iam_role.federated[0].name
  policy_arn = var.role_policies_arns[count.index]
}

