variable "s3_portfolio_bucket" {
  description = "The name of the S3 bucket to host the portfolio website."
  type        = string
  default     = "cloud-portfolio-bucket-hd-20026"
}

variable "domain_name" {
  description = "The domain name for the portfolio website."
  type        = list(string)
  default     = ["hubert-dziedzic.pl", "www.hubert-dziedzic.pl"]
}

variable "alert_email" {
  description = "Email address to receive visitor alerts."
  type        = string
  default     = "hubert.dziedzic26@gmail.com"
}