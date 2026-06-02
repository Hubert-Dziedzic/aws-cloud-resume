resource "aws_dynamodb_table" "visit_counter" {
  name           = "portfolio-visitor-counter"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
  
}