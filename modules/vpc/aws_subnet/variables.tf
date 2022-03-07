// module: aws_subnet

// default:   enable subnet creation.  Useful for determining if private subnet
//      should be created based on whether private subnet should be created in the first place
// this parameter should be better removed entirely
variable "enable_subnet" {
  default = "1"
}

// this is the cidr_block of the entire vpc.  Specific subnets will be created based on the subnet_offset
variable "cidr_block" {
}

variable "subnet_size" {
}

variable "vpc_id" {
}

variable "available_az" {
  type = list(any)
}

variable "environment" {
}

variable "number_of_az" {
  default = "3"
}

variable "subnet_type" {
}

variable "tag_values" {
  type    = map(string)
  default = {}
}

variable "subnet_count" {
}

variable "subnet_assignment" {
  type = list(any)
}

variable "identifier_tags" {
  type    = map(string)
  default = {}
}

variable "is_public" {
}

variable "name" {
}

