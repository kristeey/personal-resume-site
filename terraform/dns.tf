resource "aws_route53_zone" "main" {
    name = var.hosted_dns_zone_name
}