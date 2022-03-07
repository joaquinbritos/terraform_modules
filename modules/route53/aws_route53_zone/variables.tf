variable "name" {
  description = "Name for the hosted zone"
}

variable "comment" {
  default     = "Managed by terraform"
  description = "A comment for the hosted zone. Defaults to 'Managed by Terraform'."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the zone."
}

variable "vpc_id" {
  default     = ""
  description = "The VPC to associate with a private hosted zone. Specifying vpc_id will create a private hosted zone. Conflicts w/ delegation_set_id as delegation sets can only be used for public zones."
}

variable "vpc_region" {
  default     = ""
  description = "The VPC's region. Defaults to the region of the AWS provider."
}

variable "delegation_set_id" {
  default     = ""
  description = "The ID of the reusable delegation set whose NS records you want to assign to the hosted zone. Conflicts w/ vpc_id as delegation sets can only be used for public zones."
}

variable "force_destroy" {
  default     = false
  description = "Whether to destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone."
}

variable "is_in_vpc" {
  default     = false
  description = "If you want the hosted zone to be inside a vpc"
}

variable "is_public" {
  default     = false
  description = "If you want the hosted zone to be public. Needs delegation_set_id"
}

variable "create_zone" {
  default = false
}

