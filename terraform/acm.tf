resource "aws_acm_certificate" "portfolio_cert" {
  provider                  = aws.us_east_1
  domain_name               = var.domain_name[0]
  subject_alternative_names = [var.domain_name[1]]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_acm_certificate_validation" "portfolio_cert_val" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.portfolio_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}