## DATA SOURCES

data "aws_vpc" "selected" {
  tags = {
    Name = "${var.name}-vpc"
  }
}

data "aws_cloudtrail_service_account" "main" {}

data "template_file" "task_definition" {
  template = file("templates/TaskDefinition.json")

  vars = merge({
    region         = var.region
    repository_url = "${var.account}.dkr.ecr.${var.region}.amazonaws.com/${var.service}"
    name_prefix    = var.name
    },
    var.task_definition_dynamic_vars
  )
}


## CLOUDWATCH LOG GROUP

resource "aws_cloudwatch_log_group" "example" {
  name              = "${var.name}-lg"
  retention_in_days = 3
}

## ECS TASK DEFINITION

resource "aws_ecs_task_definition" "example" {
  family                = "${var.name}-td"
  execution_role_arn    = "arn:aws:iam::${var.account}:role/ecsTaskExecutionRole"
  cpu                   = var.cpu
  memory                = var.memory
  container_definitions = data.template_file.task_definition.rendered
}

## ECS SERVICE

resource "aws_ecs_service" "example" {
  name                               = "${var.name}-api-srv"
  cluster                            = data.aws_vpc.selected.id
  task_definition                    = aws_ecs_task_definition.example.arn
  desired_count                      = 1
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}
