resource "aws_acm_certificate" "gitlab-lb-https" {
  provider          = aws.region-master
  domain_name       = join(".", ["gitlab", data.aws_route53_zone.dns.name])
  validation_method = "DNS"
  tags = {
    Name = "Gitlab-ACM"
  }
}

data "aws_route53_zone" "dns" {
  provider = aws.region-master
  name     = var.dns-name
  private_zone = false
}

resource "aws_route53_record" "gitlab" {
  provider = aws.region-master
  zone_id  = data.aws_route53_zone.dns.zone_id
  name     = join(".", ["gitlab", data.aws_route53_zone.dns.name])
  type     = "A"
  alias {
    name                   = aws_lb.application-lb.dns_name
    zone_id                = aws_lb.application-lb.zone_id
    evaluate_target_health = true
  }
}