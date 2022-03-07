// module: aws_route_table

resource "aws_route_table" "main" {
  count            = var.route_table_count
  vpc_id           = var.vpc_id
  propagating_vgws = var.propagating_vgws
  tags = merge(
    {
      "Name" = "${var.cluster_name} - ${var.purpose} - ${element(var.available_az, count.index)}"
    },
    var.identifier_tags,
  )
}

resource "aws_vpc_endpoint_route_table_association" "s3_vpc_endpoint_association" {
  count           = var.enable_s3_vpc_endpoint ? var.route_table_count : 0
  vpc_endpoint_id = var.s3_vpc_endpoint_id
  route_table_id  = element(aws_route_table.main.*.id, count.index)
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb_vpc_endpoint_association" {
  count           = var.enable_dynamodb_vpc_endpoint * var.route_table_count
  vpc_endpoint_id = var.dynamodb_vpc_endpoint_id
  route_table_id  = element(aws_route_table.main.*.id, count.index)
}

