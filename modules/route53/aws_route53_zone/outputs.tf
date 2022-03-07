output "zone_id" {
  description = "The id of the zone created"
  value       = var.is_in_vpc == true ? element(concat(aws_route53_zone.main_in_vpc.*.zone_id, [""]), 0) : var.is_public == true ? element(concat(aws_route53_zone.main_public.*.zone_id, [""]), 0) : element(concat(aws_route53_zone.main.*.zone_id, [""]), 0)
}

output "nameservers" {
  value = aws_route53_zone.main_public.*.name_servers
}

//
//output "name_servers" {
//  description = "A list of name servers in associated (or default) delegation set. Find more about delegation sets in AWS docs."
//  value       = "${var.is_in_vpc == true ? element(concat(aws_route53_zone.main_in_vpc.*.name_servers, list("")), 0) : var.is_public == true ? element(concat(aws_route53_zone.main_public.*.name_servers, list("")), 0) : element(concat(aws_route53_zone.main.*.name_servers, list("")), 0)}"
//}
//
