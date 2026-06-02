output "cloudfront_distribution_domain_name" {
  description = "The domain name of the CloudFront distribution for the portfolio website."
  value       = aws_cloudfront_distribution.portfolio_cdn.domain_name
}

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution for the portfolio website."
  value       = aws_cloudfront_distribution.portfolio_cdn.id
}

output "github_actions_role_arn" {
  description = "The ARN of the IAM role for GitHub Actions to deploy to S3."
  value       = aws_iam_role.github_actions_role.arn
}

output "route53_name_servers" {
  description = "The name servers for the Route 53 hosted zone."
  value       = aws_route53_zone.main.name_servers
}

output "lambda_api_url" {
  description = "The URL of the API Gateway endpoint for the visitor counter Lambda function."
  value = aws_lambda_function_url.visitor_counter_url.function_url
}